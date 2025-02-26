<?php

/**
 * ClouDNS DNS Manager v1.8
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

function cloudns_MetaData() {
    return array(
        'DisplayName' => 'ClouDNS DNS Manager',
        'APIVersion' => '1.1',
        'RequiresServer' => false,
    );
}

require_once dirname(__FILE__) . "/cloudns_core/core.php";

function cloudns_ConfigOptions($params) {
	$cloudns = Cloudns_Core::inst($params);
	$servers = $cloudns->Servers->getAvailableServers();
	$serverString = $databaseTable = '';
	$tblparams = array(
		'id' => $_POST['id'],
		);
	$product = $cloudns->Database->select('tblproducts', $tblparams);
	if ($product[0]['registeredDomains'] != 'on') {
		$foColumn = $cloudns->Database->columnCheck('mod_cloudns_zones', 'fo_checks');
		$databaseTable = 'mod_cloudns_zones';
	} else {
		$foColumn = $cloudns->Database->columnCheck('tbldomains', 'fo_checks');
		$databaseTable = 'tbldomains';
	}
	$foDescription = '';

	if ($foColumn == 1) {
		$foDescription = array(
			'Type' => 'text',
			'Size' => '25',
			'Default' => '1',
			'Description' => '<br />How many DNS Failover checks are supported by this plan/product.',
		);
	} else {
		$foDescription = array(
			'Description' => '<div style="color: red;">No "fo_checks" column! The "fo_checks" column needs to be added to "'.$databaseTable.'" table in your database, in order for this option to be available.</div>',
		);
	}

	foreach ($servers as $name) {
		$serverString .= $name . "<br />";
	}
	return array(
		'Zones' => array(
			'Type' => 'text',
			'Size' => '25',
			'Default' => '0',
			'Description' => '<br />How many zones are supported by this plan/product.',
		),
		'Servers' => array(
			'Type' => 'textarea',
			'Rows' => 10,
			'Cols' => 50,
			'Description' => "<br />List of DNS server for the customers to use. One server per row. Server names only. <br />Here is an example, with the default ones:<br /><br />" . $serverString . "<br /> If the list is empty and you didn't specify global servers the default servers of your ClouDNS account will be shown",
			'Default' => '',
		),
		'Registered domains' => array(
			'Type' => 'yesno',
			'Description' => "Check this box if you only want to use this product for the registered domains of the customer. The above zones limit will be ignored and the new limit will be the number of registered domains the customer has. No zones can be added or deleted. Zones for the Registered domains of the customer will be added automatically.",
		),
		'Template zone' => array(
			'Type' => 'text',
			'Size' => '25',
			'Default' => '',
			'Description' => '<br />Zone to be used as records template for new zones.',
		),
		'DNS Failover checks' => $foDescription,
		'Records' => array(
			'Type' => 'text',
			'Size' => '25',
			'Default' => '-1',
			'Description' => '<br />How many records are supported for a DNS zone. Use -1 for unlimited'
		),
	);
}

function cloudns_AdminServicesTabFields($params) {
	$cloudns = Cloudns_Core::inst($params);
	
	$data = $cloudns->Database->select('mod_cloudns_zones', array("serviceid" => $params['serviceid'],));

	$zones = '';
	if (empty($data)) {
		$fieldsarray = array(
			'Connected DNS Zones' => 'There are no DNS zones added to this service.',
		);
	} else {
		foreach ($data as $zone) {
			$zones .= '<option>'.$zone['name'].'</option>';
		}
		$fieldsarray = array(
			'Connected DNS Zones' => '<select name="modulefields[1]">'.$zones.'</select>',
		);
	}
	return $fieldsarray;

}


function cloudns_CreateAccount ($params) {
	$cloudns = Cloudns_Core::inst($params);
	
	try {
		
	} catch (Exception $e) {
		// Record the error in WHMCS's module log.
		logModuleCall(
			'cloudns',
			__FUNCTION__,
			$params,
			$e->getMessage(),
			$e->getTraceAsString()
		);
		return $e->getMessage();
	}
	
	return 'success';
}


function cloudns_SuspendAccount ($params) {
	$cloudns = Cloudns_Core::inst($params);
	
	try {
		// make the zones inactive
		$result = $cloudns->Actions->suspendZones();
	} catch (Exception $e) {
		// Record the error in WHMCS's module log.
		logModuleCall(
			'cloudns',
			__FUNCTION__,
			$params,
			$e->getMessage(),
			$e->getTraceAsString()
		);
		return $e->getMessage();
	}
	
	return $result;
}


function cloudns_UnsuspendAccount ($params) {
	$cloudns = Cloudns_Core::inst($params);
	try {
		// make the zones active again
		$result = $cloudns->Actions->unSuspendZones();
	} catch (Exception $e) {
		// Record the error in WHMCS's module log.
		logModuleCall(
			'cloudns',
			__FUNCTION__,
			$params,
			$e->getMessage(),
			$e->getTraceAsString()
		);
		return $e->getMessage();
	}
	return $result;
}


function cloudns_TerminateAccount ($params) {
	$cloudns = Cloudns_Core::inst($params);
	try {
		// delete the zones
		$result = $cloudns->Actions->terminateAccount();
	} catch (Exception $e) {
		// Record the error in WHMCS's module log.
		logModuleCall(
			'cloudns',
			__FUNCTION__,
			$params,
			$e->getMessage(),
			$e->getTraceAsString()
		);
		return $e->getMessage();
	}
	return $result;
}
function cloudns_ChangePackage ($params) {
	$cloudns = Cloudns_Core::inst($params);
	
	try {
		
	} catch (Exception $e) {
		// Record the error in WHMCS's module log.
		logModuleCall(
			'cloudns',
			__FUNCTION__,
			$params,
			$e->getMessage(),
			$e->getTraceAsString()
		);
		return $e->getMessage();
	}
	
	return 'success';
}


function cloudns_ClientArea ($params) {
	$cloudns = Cloudns_Core::inst($params);
	$requestedAction = isset($_REQUEST['customAction']) ? $_REQUEST['customAction'] : 'zones';
	
	try {
		if (isset($params['status']) && $params['status'] != 'Active') {
			// returning template, which is forbiding us from
			// using not active Service
			return array(
				'tabOverviewReplacementTemplate' => 'templates/notActive.tpl',
			);
		}
		$zone = $cloudns->Helper->getRequest('zone');
		$response = $zoneInfo = $recordTypes = array();
		
		if (!empty($zone)) {
			$zoneExists = $cloudns->Controller->zoneExists($zone);
			
			if (isset($zoneExists['status']) && ($requestedAction != 'add-existing-zone' && $requestedAction != 'add-zone')) {
				// the zone doesn't exist in ClouDNS
				if ($zoneExists['status'] == 'error' || $zoneExists['status'] == 'info') {
						
					$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}&customAction=add-existing-zone&zone={$zone}");
				// the zone doesn't exist here
				} elseif ($zoneExists['status'] == 'info' && $params['configoption3'] != 'on') {

					$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
				}
			}
		}
		
		$zoneInfo = isset($zoneExists['zoneInfo']) ? $zoneExists['zoneInfo'] : array('name'=>'');
		
		$zoneOwnership = $cloudns->Controller->getZoneByName($zoneInfo['name']);
		if (!empty($zone) && (isset($zoneOwnership[0]['serviceid']) && $zoneOwnership[0]['serviceid'] != $params['serviceid']) && $params['configoption3'] != 'on') {
			$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
		} elseif (!empty($zone) && (!isset($zoneOwnership[0]['serviceid']) || (isset($zoneOwnership[0]['serviceid']) && $zoneOwnership[0]['serviceid'] != $params['serviceid']))) {
			
			if ($params['configoption3'] == 'on') {
				$domain = $cloudns->Controller->getRegisteredDomainByName($zoneInfo['name']);
				if (empty($domain) && ($requestedAction != 'add-existing-zone' && $requestedAction != 'add-zone')) {
					$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
				}
				$service = array();
				if (!empty($domain)) {
					$command = 'GetClientsProducts';
					$postData = array(
						'clientid' => $domain[0]['userid'],
						'serviceid' => $zoneOwnership[0]['serviceid'],
						'status' => true,
					);
					$adminUsername = $cloudns->Configuration->getAdminUser();
					$service = localAPI($command, $postData, $adminUsername);
				}
				
				if ((empty($service) || $service['totalresults'] == 0 || empty($service['products']))  && ($requestedAction != 'add-existing-zone' && $requestedAction != 'add-zone')) {
					$templateFile = 'templates/registered-domain-zone-not-own.tpl';
					
					// adding the below keys, because they are used everywhere and there is no need to add them in each action
					$version = explode('.', $params['whmcsVersion']);
					$templateVariables['serviceid'] = $params['serviceid'];
					$templateVariables['zone'] = $zone;
					$templateVariables['version']=$version[0];
					$templateVariables['theme'] = $params['clientareatemplate'];
					$templateVariables['registeredDomains'] = $params['configoption3'];

					// returning the error template
					return array(
						'tabOverviewReplacementTemplate' => $templateFile,
						'vars' => $templateVariables,
						'cloudAction' => $requestedAction,
					);
				}
			}
		}
		
		if ($requestedAction == 'add-zone') {
			$zoneType = $cloudns->Helper->getPost('zoneType');
			
			$servers = $cloudns->Helper->getPost('masterDNSServer', array());
			if ($cloudns->Controller->defaultZone()) {
				$option = 3;
			} else {
				$option = $cloudns->Helper->getPost('newZoneOptions', 1);
			}
			
				
			$sufix = $cloudns->Helper->getPost('zoneSufix');
			$masterIP = $cloudns->Helper->getPost('slaveMasterIp');
			
			if (!empty($sufix)) {
				$zone = $zone.'.'.$sufix;
			}
			
			$response = $cloudns->Controller->addNewZone($zone, $zoneType, $option, $servers, $masterIP, $zoneExists);
			if ($response['status'] == 'success') {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}&customAction=zone-settings&zone={$response['zone']}");
			} else {
				$version = explode('.', $params['whmcsVersion']);
				$templateVariables = array(
					'response' => $response,
					'serversList' => $cloudns->Servers->getAvailableServers(),
					'version'=>$version[0],
					'theme' => $params['clientareatemplate'],
				);
			}
			
			$templateFile = 'templates/add-new-zone.tpl';
			
		} elseif ($requestedAction == 'add-existing-zone') {
			if ($cloudns->Controller->defaultZone()) {
				$option = 3;
			} else {
				$option = $cloudns->Helper->getPost('newZoneOptions', 1);
			}
			$response = $cloudns->Controller->addNewExistingZone($zone, $option);
			if ($response['status'] == 'success') {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}&customAction=zone-settings&zone={$response['zone']}");
			} else {
				$version = explode('.', $params['whmcsVersion']);
				$templateVariables = array(
					'response' => $response,
					'cloudAction' => 'add-new-zone',
					'version'=>$version[0],
					'theme' => $params['clientareatemplate'],
				);
			}
			$templateFile = 'templates/add-new-zone.tpl';
			
		} elseif ($requestedAction == 'zone-settings') {
			$recordTypes = $cloudns->Controller->getRecordTypes($zoneInfo['zone']);
			$failoverChecks = $params['configoption5'];
			$productid = $params['pid'];
			$type = 'all';
			$recordsCount = $cloudns->Controller->getRecordsCount($zone);
			$recordsLimit = $params['configoption6'];
			$error = $cloudns->Helper->getGet('error');
			
			if (in_array($cloudns->Helper->getPost('recordsType'), $recordTypes)) {
				$type = $cloudns->Helper->getPost('recordsType');
			} elseif (in_array($cloudns->Helper->getGet('type'), $recordTypes)) {
				$type = $cloudns->Helper->getGet('type');
			}
			
			if ($zoneInfo['type'] == 'slave') {
				$templateFile = 'templates/slave/master-servers.tpl';
			} else {
				$templateFile = 'templates/records.tpl';
			}
			
			$templateVariables = $cloudns->Actions->getSettings($zoneInfo, $type, $recordTypes, $failoverChecks, $productid);
			$templateVariables['recordsCount'] = $recordsCount;
			$templateVariables['recordsLimit'] = $recordsLimit;
			$templateVariables['error'] = $error;
			
			if (isset($templateVariables['response']) && isset($templateVariables['response']['status']) && ($templateVariables['response']['status'] == 'error' || $templateVariables['response']['status'] == '0')) {
				$templateFile = 'templates/zone-error.tpl';
			}
			
		} elseif ($requestedAction == 'delete-record') {
			$record_id = $cloudns->Helper->getGet('record');
			$templateVariables = $cloudns->Actions->deleteRecord($zoneInfo, $record_id);
			$templateFile = 'templates/records.tpl';
			
		} elseif ($requestedAction == 'delete-zone') {
			$templateVariables = $cloudns->Actions->deleteZone($zone);
			$templateFile = 'templates/zones.tpl';
			
		} elseif ($requestedAction == 'bind-settings') {
			$templateVariables = $cloudns->Actions->getBINDSettings($zoneInfo);
			$templateFile = 'templates/slave/slave-bind-settings.tpl';
			
		} elseif ($requestedAction == 'delete-master-servers') {
			$master = $cloudns->Helper->getGet('master_server_id');
			$templateVariables = $cloudns->Actions->deleteMasterServer($zone, $master);
			$templateFile = 'templates/slave/master-servers.tpl';
			
		} elseif ($requestedAction == 'add-master-servers') {
			$master = $cloudns->Helper->getPost('masterIP');
			$templateVariables = $cloudns->Actions->addMasterServer($zone, $master);
			$templateFile = 'templates/slave/master-servers.tpl';
		
		} elseif ($requestedAction == 'add-new-record') {
			$templateVariables = $cloudns->Actions->addNewRecord($zoneInfo, $cloudns->Helper->getRequest('type'));
			
			if ($templateVariables['status'] == 'error') {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}&customAction=zone-settings&zone={$zoneInfo['name']}&error=1");
			} else {
				$templateFile = 'templates/add-new-record.tpl';
			}
		} elseif ($requestedAction == 'add-record') {
			$recordType = $cloudns->Helper->getRequest('addRecordType');
			$settings = array();
			$settings['host'] = $cloudns->Helper->getPost('addRecordHost');
			$settings['record'] = html_entity_decode($cloudns->Helper->getPost('addRecordRecord'));
			$settings['ttl'] = $cloudns->Helper->getPost('addRecordTtl');
			$status = 1;
			
			if ($recordType == 'SRV') {
				$settings['priority'] = $cloudns->Helper->getPost('addRecordSRVPriority');
				$settings['weight'] = $cloudns->Helper->getPost('addRecordWeight');
				$settings['port'] = $cloudns->Helper->getPost('addRecordPort');
			} else if ($recordType == 'MX') {
				$settings['priority'] = $cloudns->Helper->getPost('addRecordMXPriority');
			} else if ($recordType == 'WR') {
				$settings['frame'] = $cloudns->Helper->getPost('addRecordWRFrame');
				$settings['frame-title'] = $cloudns->Helper->getPost('addRecordWRFrameTitle');
				$settings['frame-description'] = $cloudns->Helper->getPost('addRecordWRFrameDescription');
				$settings['frame-keywords'] = $cloudns->Helper->getPost('addRecordWRFrameKeywords');
				$settings['save-path'] = $cloudns->Helper->getPost('addRecordWRSavePath');
				$settings['mobile-meta'] = $cloudns->Helper->getPost('addRecordWRMobileMeta');
				$settings['redirect-type'] = $cloudns->Helper->getPost('wr_type');
			} else if ($recordType == 'RP') {
				$settings['mail'] = $cloudns->Helper->getPost('addRecordMail');
				$settings['txt'] = $cloudns->Helper->getPost('addRecordTxt');
			} else if ($recordType == 'SSHFP') {
				$settings['algorithm'] = $cloudns->Helper->getPost('algorithm');
				$settings['fptype'] = $cloudns->Helper->getPost('fp_type');
			} else if ($recordType == 'NAPTR') {
				$settings['order'] = $cloudns->Helper->getPost('addRecordOrder');
				$settings['pref'] = $cloudns->Helper->getPost('addRecordPref');
				$settings['flag'] = $cloudns->Helper->getPost('flag');
				$settings['params'] = $cloudns->Helper->getPost('addRecordParams');
				$settings['regexp'] = $cloudns->Helper->getPost('addRecordRegexp');
				$settings['replace'] = $cloudns->Helper->getPost('addRecordReplace');
			} else if ($recordType == 'CAA') {
				$settings['caa_flag'] = $cloudns->Helper->getPost('addRecordCAAflag');
				$settings['caa_type'] = $cloudns->Helper->getPost('addRecordCAAtype');
				$settings['caa_value'] = $cloudns->Helper->getPost('addRecordCAAvalue');
			} else if ($recordType == 'TLSA') {
				$settings['tlsa_usage'] = $cloudns->Helper->getPost('addRecordUsage');
				$settings['tlsa_selector'] = $cloudns->Helper->getPost('addRecordSelector');
				$settings['tlsa_matching_type'] = $cloudns->Helper->getPost('addRecordMatchingType');
			} else if ($recordType == 'DS') {
				$settings['key-tag'] = $cloudns->Helper->getPost('addRecordKeyTag');
				$settings['algorithm'] = $cloudns->Helper->getPost('addRecordDsAlgorithm');
				$settings['digest-type'] = $cloudns->Helper->getPost('addRecordDigestType');
			} else if ($recordType == 'CERT') {
				$settings['cert-type'] = $cloudns->Helper->getPost('addRecordCertType');
				$settings['cert-key-tag'] = $cloudns->Helper->getPost('addRecordCertKeyTag');
				$settings['cert-algorithm'] = $cloudns->Helper->getPost('addRecordCertAlgorithm');
			} else if ($recordType == 'HINFO') {
				$settings['cpu'] = $cloudns->Helper->getPost('addRecordCPU');
				$settings['os'] = $cloudns->Helper->getPost('addRecordOS');
			} else if ($recordType == 'LOC') {
				$settings['lat-deg'] = $cloudns->Helper->getPost('addRecordLatDeg');
				$settings['lat-min'] = $cloudns->Helper->getPost('addRecordLatMin');
				$settings['lat-sec'] = $cloudns->Helper->getPost('addRecordLatSec');
				$settings['lat-dir'] = $cloudns->Helper->getPost('addRecordLatDir');
				$settings['long-deg'] = $cloudns->Helper->getPost('addRecordLongDeg');
				$settings['long-min'] = $cloudns->Helper->getPost('addRecordLongMin');
				$settings['long-sec'] = $cloudns->Helper->getPost('addRecordLongSec');
				$settings['long-dir'] = $cloudns->Helper->getPost('addRecordLongDir');
				$settings['altitude'] = $cloudns->Helper->getPost('addRecordAltitude');
				$settings['size'] = $cloudns->Helper->getPost('addRecordSize');
				$settings['h-precision'] = $cloudns->Helper->getPost('addRecordHPrecision');
				$settings['v-precision'] = $cloudns->Helper->getPost('addRecordVPrecision');
			} else if ($recordType == 'SMIMEA') {
				$settings['smimea-usage'] = $cloudns->Helper->getPost('addRecordSmimeaUsage');
				$settings['smimea-selector'] = $cloudns->Helper->getPost('addRecordSmimeaSelector');
				$settings['smimea-matching-type'] = $cloudns->Helper->getPost('addRecordSmimeaMatchingType');
			}
			
			$templateVariables = $cloudns->Actions->doAddNewRecord($zoneInfo, $recordType, $settings);
			$templateFile = 'templates/add-new-record.tpl';
			
		} elseif ($requestedAction == 'get-failover-settings') {
			$productid = $params['pid'];
			$freeProductId = $cloudns->Configuration->getFreeProductId();
			if ($productid != $freeProductId) {
				$foColumn = $cloudns->Database->columnCheck('mod_cloudns_zones', 'fo_checks');
			} else {
				$foColumn = $cloudns->Database->columnCheck('tbldomains', 'fo_checks');
			}
			if ($foColumn == 1) {
				$record_id = $cloudns->Helper->getGet('dns_record_id');
				$templateVariables = $cloudns->Actions->getFailoverSettings($zoneInfo, $record_id);
				if (isset($templateVariables['failover']) && isset($templateVariables['failover']['status']) && $templateVariables['failover']['status'] != 'error') {
					$templateFile = 'templates/failover-view.tpl';
				} else {
					$templateFile = 'templates/failover-new.tpl';
				}
			}
			else {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
		} elseif ($requestedAction == 'failover-activate') {
			$productid = $params['pid'];
			$freeProductId = $cloudns->Configuration->getFreeProductId();
			if ($productid != $freeProductId) {
				$foColumn = $cloudns->Database->columnCheck('mod_cloudns_zones', 'fo_checks');
			} else {
				$foColumn = $cloudns->Database->columnCheck('tbldomains', 'fo_checks');
			}
			if ($foColumn == 1) {
				$record_id = $cloudns->Helper->getGet('dns_record_id');
				$settings = array();
				$settings['check_type'] = $cloudns->Helper->getPost('fo_check_type');
				$settings['down_event_handler'] = $cloudns->Helper->getPost('fo_down_event_handler');
				$settings['up_event_handler'] = $cloudns->Helper->getPost('fo_up_event_handler');
				$settings['main_ip'] = $cloudns->Helper->getPost('fo_main_ip');
				$settings['backup_ip_1'] = $cloudns->Helper->getPost('fo_backup_ip_1');
				$settings['backup_ip_2'] = $cloudns->Helper->getPost('fo_backup_ip_2');
				$settings['backup_ip_3'] = $cloudns->Helper->getPost('fo_backup_ip_3');
				$settings['backup_ip_4'] = $cloudns->Helper->getPost('fo_backup_ip_4');
				$settings['backup_ip_5'] = $cloudns->Helper->getPost('fo_backup_ip_5');
				$settings['ping_threshold'] = $cloudns->Helper->getPost('fo_ping_threshold');
				$settings['monitoring_region'] = $cloudns->Helper->getPost('fo_monitoring_region');
				if ($settings['check_type'] === '18') {
					$settings['host'] = $cloudns->Helper->getPost('fo_http_host');
					$settings['port'] = $cloudns->Helper->getPost('fo_http_port');
				} else {
					$settings['host'] = $cloudns->Helper->getPost('fo_dns_host');
					$settings['port'] = $cloudns->Helper->getPost('fo_port');
				}
				$settings['path'] = $cloudns->Helper->getPost('fo_http_path');
				$settings['query_type'] = $cloudns->Helper->getPost('fo_dns_type');
				$settings['query_response'] = $cloudns->Helper->getPost('fo_dns_response');
				$settings['notification_type'] = $cloudns->Helper->getPost('fo_notification_type');
				$settings['notification_value'] = $cloudns->Helper->getPost('fo_notification_value');
				
				if ($settings['check_type'] === '18') {
					if ($cloudns->Helper->getPost('web_custom_string') == '1') {
						$settings['content'] = htmlspecialchars($cloudns->Helper->getPost('fo_http_content'));
					}
					$settings['http_protocol'] = $cloudns->Helper->getPost('web_protocol');
				}

				$templateVariables = $cloudns->Actions->activateFailover($zoneInfo, $record_id, $settings);
				$templateFile = 'templates/failover-new.tpl';
			}
			else {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
		} elseif ($requestedAction == 'failover-deactivate') {
			$record_id = $cloudns->Helper->getGet('dns_record_id');
			
			$templateVariables = $cloudns->Actions->deactivateFailover($zoneInfo, $record_id);
			$templateFile = 'templates/records.tpl';
			
		} elseif ($requestedAction == 'failover-edit') {
			$productid = $params['pid'];
			$freeProductId = $cloudns->Configuration->getFreeProductId();
			if ($productid != $freeProductId) {
				$foColumn = $cloudns->Database->columnCheck('mod_cloudns_zones', 'fo_checks');
			} else {
				$foColumn = $cloudns->Database->columnCheck('tbldomains', 'fo_checks');
			}
			if ($foColumn == 1) {
				$record_id = $cloudns->Helper->getGet('dns_record_id');
				$settings = array();
				$settings['check_type'] = $cloudns->Helper->getPost('fo_check_type');
				$settings['down_event_handler'] = $cloudns->Helper->getPost('fo_down_event_handler');
				$settings['up_event_handler'] = $cloudns->Helper->getPost('fo_up_event_handler');
				$settings['main_ip'] = $cloudns->Helper->getPost('fo_main_ip');
				$settings['backup_ip_1'] = $cloudns->Helper->getPost('fo_backup_ip_1');
				$settings['backup_ip_2'] = $cloudns->Helper->getPost('fo_backup_ip_2');
				$settings['backup_ip_3'] = $cloudns->Helper->getPost('fo_backup_ip_3');
				$settings['backup_ip_4'] = $cloudns->Helper->getPost('fo_backup_ip_4');
				$settings['backup_ip_5'] = $cloudns->Helper->getPost('fo_backup_ip_5');
				$settings['ping_threshold'] = $cloudns->Helper->getPost('fo_ping_threshold');
				$settings['monitoring_region'] = $cloudns->Helper->getPost('fo_monitoring_region');
				if ($settings['check_type'] === '18') {
					$settings['host'] = $cloudns->Helper->getPost('fo_http_host');
					$settings['port'] = $cloudns->Helper->getPost('fo_http_port');
				} else {
					$settings['host'] = $cloudns->Helper->getPost('fo_dns_host');
					$settings['port'] = $cloudns->Helper->getPost('fo_port');
				}
				
				if ($settings['check_type'] === '18') {
					if ($cloudns->Helper->getPost('web_custom_string') == '1') {
						$settings['content'] = $cloudns->Helper->getPost('fo_http_content');
					}
					$settings['http_protocol'] = $cloudns->Helper->getPost('web_protocol');
				}
				
				$settings['path'] = $cloudns->Helper->getPost('fo_http_path');
				$settings['query_type'] = $cloudns->Helper->getPost('fo_dns_type');
				$settings['query_response'] = $cloudns->Helper->getPost('fo_dns_response');

				$templateVariables = $cloudns->Actions->editFailover($zoneInfo, $record_id, $settings);
				$templateFile = 'templates/failover-view.tpl';					
			} else {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
		} elseif ($requestedAction == 'failover-action-log') {
			$productid = $params['pid'];
			$freeProductId = $cloudns->Configuration->getFreeProductId();
			if ($productid != $freeProductId) {
				$foColumn = $cloudns->Database->columnCheck('mod_cloudns_zones', 'fo_checks');
			} else {
				$foColumn = $cloudns->Database->columnCheck('tbldomains', 'fo_checks');
			}
			if ($foColumn == 1) {
				$record_id = $cloudns->Helper->getGet('dns_record_id');
				$page = abs($cloudns->Helper->getGet('page', 1));

				$templateVariables = $cloudns->Actions->failoverActionLog($zoneInfo, $record_id, $page);
				$templateFile = 'templates/failover-action-log.tpl';
			} else {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
		} elseif ($requestedAction == 'failover-monitoring-log') {
			$productid = $params['pid'];
			$freeProductId = $cloudns->Configuration->getFreeProductId();
			if ($productid != $freeProductId) {
				$foColumn = $cloudns->Database->columnCheck('mod_cloudns_zones', 'fo_checks');
			} else {
				$foColumn = $cloudns->Database->columnCheck('tbldomains', 'fo_checks');
			}
			if ($foColumn == 1) {
				$record_id = $cloudns->Helper->getGet('dns_record_id');
				$page = abs($cloudns->Helper->getGet('page', 1));

				$templateVariables = $cloudns->Actions->failoverMonitoringLog($zoneInfo, $record_id, $page);
				$templateFile = 'templates/failover-monitoring-log.tpl';
			} else {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
			
		} elseif ($requestedAction == 'failover-monitoring-notifications') {
			$productid = $params['pid'];
			$freeProductId = $cloudns->Configuration->getFreeProductId();
			
			if ($productid != $freeProductId) {
				$foColumn = $cloudns->Database->columnCheck('mod_cloudns_zones', 'fo_checks');
			} else {
				$foColumn = $cloudns->Database->columnCheck('tbldomains', 'fo_checks');
			}
			
			if ($foColumn == 1) {
				$record_id = $cloudns->Helper->getGet('dns_record_id');
				$page = abs($cloudns->Helper->getGet('page', 1));

				$templateVariables = $cloudns->Actions->failoverMonitoringNotifications($zoneInfo, $record_id, $page);
				$templateFile = 'templates/failover-monitoring-notifications.tpl';
			} else {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
			
		} elseif ($requestedAction == 'failover-add-notification') {
			$productid = $params['pid'];
			$freeProductId = $cloudns->Configuration->getFreeProductId();
			if ($productid != $freeProductId) {
				$foColumn = $cloudns->Database->columnCheck('mod_cloudns_zones', 'fo_checks');
			} else {
				$foColumn = $cloudns->Database->columnCheck('tbldomains', 'fo_checks');
			}
			if ($foColumn == 1) {
				$record_id = $cloudns->Helper->getGet('dns_record_id');
				$page = abs($cloudns->Helper->getGet('page', 1));
				$settings = array();
				$settings['notification_type'] = $cloudns->Helper->getPost('fo_notification_type');
				$settings['notification_value'] = $cloudns->Helper->getPost('fo_notification_value');

				$templateVariables = $cloudns->Actions->addFailoverNotification($zoneInfo, $record_id, $settings, $page);
				$templateFile = 'templates/failover-monitoring-notifications.tpl';
			}
			else {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
		} elseif ($requestedAction == 'failover-delete-notification') {
			$productid = $params['pid'];
			$freeProductId = $cloudns->Configuration->getFreeProductId();
			if ($productid != $freeProductId) {
				$foColumn = $cloudns->Database->columnCheck('mod_cloudns_zones', 'fo_checks');
			} else {
				$foColumn = $cloudns->Database->columnCheck('tbldomains', 'fo_checks');
			}
			if ($foColumn == 1) {
				$record_id = $cloudns->Helper->getGet('dns_record_id');
				$page = abs($cloudns->Helper->getGet('page', 1));;
				$notification_id = $cloudns->Helper->getGet('notification_id');

				$templateVariables = $cloudns->Actions->deleteFailoverNotification($zoneInfo, $record_id, $notification_id, $page);
				$templateFile = 'templates/failover-monitoring-notifications.tpl';
			}
			else {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
		} elseif ($requestedAction == 'dnssec'){
			
			if ($zoneInfo['type'] != 'master') {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
			
			$waitDSrecords = $cloudns->Helper->getGet('waitDS');
			$templateVariables = $cloudns->Actions->dnssec($zoneInfo, $waitDSrecords);
			if (isset($templateVariables['dnssec']) && isset($templateVariables['dnssec']['status']) && $templateVariables['dnssec']['status'] == '1') {
				$templateFile = 'templates/dnssec-settings.tpl';
			}
			elseif ($templateVariables['dnssec']['status'] == 'error' && $waitDSrecords == 1) {
				$templateFile = 'templates/dnssec-waiting.tpl';
			}
			else {
				$templateFile = 'templates/dnssec-show.tpl';
			}
			
		} elseif ($requestedAction == 'dnssec-show'){
			
			if ($zoneInfo['type'] != 'master') {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
			
			$templateVariables = $cloudns->Actions->dnssecShow($zoneInfo);
			$templateFile = 'templates/dnssec-show.tpl';
			
		} elseif ($requestedAction == 'dnssec-settings'){
			
			if ($zoneInfo['type'] != 'master') {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
			
			$templateVariables = $cloudns->Actions->dnssecSettings($zoneInfo);
			$templateFile = 'templates/dnssec-settings.tpl';
			
		} elseif ($requestedAction == 'dnssec-activate'){
			
			if ($zoneInfo['type'] != 'master') {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
			
			$waitDSrecords = $cloudns->Helper->getGet('waitds', 0);
			
			$templateVariables = $cloudns->Actions->dnssecActivate($zoneInfo);
			$templateFile = 'templates/dnssec-settings.tpl';
			
		} elseif ($requestedAction == 'dnssec-deactivate'){
			
			if ($zoneInfo['type'] != 'master') {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
			
			$templateVariables = $cloudns->Actions->dnssecDeactivate($zoneInfo);
			$templateFile = 'templates/dnssec-show.tpl';
			
		} elseif ($requestedAction == 'dnssec-waiting'){
			
			if ($zoneInfo['type'] != 'master') {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
			
			$templateVariables = $cloudns->Actions->dnssecWaiting($zoneInfo);
			$templateFile = 'templates/dnssec-waiting.tpl';
			
		} elseif ($requestedAction == 'edit-record') {
			$record_id = $cloudns->Helper->getGet('dns_record_id');
			$templateVariables = $cloudns->Actions->editRecord($zoneInfo, $record_id);
			$templateFile = 'templates/edit-record.tpl';
			
		} elseif ($requestedAction == 'do-edit-record') {
			$record_id = $cloudns->Helper->getGet('dns_record_id');
			$recordType = $cloudns->Helper->getPost('recordType');
			
			$settings = array();
			$settings['host'] = $cloudns->Helper->getPost('editRecordHost');
			$settings['record'] = html_entity_decode($cloudns->Helper->getPost('editRecordRecord'));
			$settings['ttl'] = $cloudns->Helper->getPost('editRecordTtl');
			$status = 1;
			
			if ($recordType == 'SRV') {
				$settings['priority'] = $cloudns->Helper->getPost('editRecordPriority');
				$settings['weight'] = $cloudns->Helper->getPost('editRecordWeight');
				$settings['port'] = $cloudns->Helper->getPost('editRecordPort');
			} else if ($recordType == 'MX') {
				$settings['priority'] = $cloudns->Helper->getPost('editRecordPriority');
			} else if ($recordType == 'WR') {
				$settings['frame'] = $cloudns->Helper->getPost('editRecordWRFrame');
				$settings['frame-title'] = $cloudns->Helper->getPost('editRecordWRFrameTitle');
				$settings['frame-description'] = $cloudns->Helper->getPost('editRecordWRFrameDescription');
				$settings['frame-keywords'] = $cloudns->Helper->getPost('editRecordWRFrameKeywords');
				$settings['save-path'] = $cloudns->Helper->getPost('editRecordWRSavePath');
				$settings['mobile-meta'] = $cloudns->Helper->getPost('editRecordWRMobileMeta');
				$settings['redirect-type'] = $cloudns->Helper->getPost('wr_type');
			} else if ($recordType == 'RP') {
				$settings['mail'] = $cloudns->Helper->getPost('editRecordMail');
				$settings['txt'] = $cloudns->Helper->getPost('editRecordTxt');
			} else if ($recordType == 'SSHFP') {
				$settings['algorithm'] = $cloudns->Helper->getPost('algorithm');
				$settings['fptype'] = $cloudns->Helper->getPost('fp_type');
			} else if ($recordType == 'NAPTR') {
				$settings['order'] = $cloudns->Helper->getPost('editRecordOrder');
				$settings['pref'] = $cloudns->Helper->getPost('editRecordPref');
				$settings['flag'] = $cloudns->Helper->getPost('flag');
				$settings['params'] = $cloudns->Helper->getPost('editRecordParams');
				$settings['regexp'] = $cloudns->Helper->getPost('editRecordRegexp');
				$settings['replace'] = $cloudns->Helper->getPost('editRecordReplace');
			} else if ($recordType == 'CAA') {
				$settings['caa_flag'] = $cloudns->Helper->getPost('editRecordCAAflag');
				$settings['caa_type'] = $cloudns->Helper->getPost('editRecordCAAtype');
				$settings['caa_value'] = $cloudns->Helper->getPost('editRecordCAAvalue');
			} else if ($recordType == 'TLSA') {
				$settings['tlsa_usage'] = $cloudns->Helper->getPost('editRecordUsage');
				$settings['tlsa_selector'] = $cloudns->Helper->getPost('editRecordSelector');
				$settings['tlsa_matching_type'] = $cloudns->Helper->getPost('editRecordMatchingType');
			} else if ($recordType == 'DS') {
				$settings['key-tag'] = $cloudns->Helper->getPost('editRecordKeyTag');
				$settings['algorithm'] = $cloudns->Helper->getPost('editRecordDsAlgorithm');
				$settings['digest-type'] = $cloudns->Helper->getPost('editRecordDigestType');
			} else if ($recordType == 'CERT') {
				$settings['cert-type'] = $cloudns->Helper->getPost('editRecordCertType');
				$settings['cert-key-tag'] = $cloudns->Helper->getPost('editRecordCertKeyTag');
				$settings['cert-algorithm'] = $cloudns->Helper->getPost('editRecordCertAlgorithm');
			} else if ($recordType == 'HINFO') {
				$settings['cpu'] = $cloudns->Helper->getPost('editRecordCPU');
				$settings['os'] = $cloudns->Helper->getPost('editRecordOS');
			} else if ($recordType == 'LOC') {
				$settings['lat-deg'] = $cloudns->Helper->getPost('editRecordLatDeg');
				$settings['lat-min'] = $cloudns->Helper->getPost('editRecordLatMin');
				$settings['lat-sec'] = $cloudns->Helper->getPost('editRecordLatSec');
				$settings['lat-dir'] = $cloudns->Helper->getPost('editRecordLatDir');
				$settings['long-deg'] = $cloudns->Helper->getPost('editRecordLongDeg');
				$settings['long-min'] = $cloudns->Helper->getPost('editRecordLongMin');
				$settings['long-sec'] = $cloudns->Helper->getPost('editRecordLongSec');
				$settings['long-dir'] = $cloudns->Helper->getPost('editRecordLongDir');
				$settings['altitude'] = $cloudns->Helper->getPost('editRecordAltitude');
				$settings['size'] = $cloudns->Helper->getPost('editRecordSize');
				$settings['h-precision'] = $cloudns->Helper->getPost('editRecordHPrecision');
				$settings['v-precision'] = $cloudns->Helper->getPost('editRecordVPrecision');
			} else if ($recordType == 'SMIMEA') {
				$settings['smimea-usage'] = $cloudns->Helper->getPost('editRecordSmimeaUsage');
				$settings['smimea-selector'] = $cloudns->Helper->getPost('editRecordSmimeaSelector');
				$settings['smimea-matching-type'] = $cloudns->Helper->getPost('editRecordSmimeaMatchingType');
			}
			
			$templateVariables = $cloudns->Actions->doEditRecord($zoneInfo, $record_id, $settings, $status, $recordType);

			$templateFile = 'templates/edit-record.tpl';
	
		} elseif ($requestedAction == 'add-new-zone') {
			if ($params['configoption3'] == 'on') {
				$cloudns->Helper->redirect("clientarea.php?action=productdetails&id={$params['serviceid']}");
			}
			$version = explode('.', $params['whmcsVersion']);
			$templateVariables = array(
				'serversList' => $cloudns->Servers->getAvailableServers(),
				'cloudAction' => 'add-new-zone',
				'version'=>$version[0],
				'theme' => $params['clientareatemplate'],
				'templateZone' => $cloudns->Controller->defaultZone(),
			);
			
			$templateFile = 'templates/add-new-zone.tpl';
			
		} elseif ($requestedAction == 'soa-settings') {
			$templateVariables = $cloudns->Actions->getSOASettings($zoneInfo);
			$templateFile = 'templates/soa.tpl';
			
		} elseif ($requestedAction == 'edit-soa-settings') {
			$soa = array();
			$soa['primaryNS'] = $cloudns->Helper->getPost('primaryNS');
			$soa['adminMail'] = $cloudns->Helper->getPost('adminMail');
			$soa['refresh'] = $cloudns->Helper->getPost('refresh');
			$soa['retry'] = $cloudns->Helper->getPost('retry');
			$soa['expire'] = $cloudns->Helper->getPost('expire');
			$soa['defaultTTL'] = $cloudns->Helper->getPost('defaultTTL');
			$soaAction = 'do_save';
			if (isset($_POST['do_reset'])) {
				$soaAction = 'do_reset';
			}
			$templateVariables = $cloudns->Actions->editSOA($zoneInfo, $soa, $soaAction);
			$templateFile = 'templates/soa.tpl';
			
		} elseif ($requestedAction == 'update-status') {
			$templateVariables = $cloudns->Actions->getUpdateStatus($zoneInfo);
			$templateFile = 'templates/update-status.tpl';
			
		} elseif ($requestedAction == 'update') {
			$templateFile = 'templates/update-status.tpl';
			$templateVariables = $cloudns->Actions->updateZone($zoneInfo);
			
		} elseif ($requestedAction == 'import') {
			$templateFile = 'templates/import.tpl';
			$version = explode('.', $params['whmcsVersion']);
			$response = '';
			$templateVariables = array(
				'pagetitle' => 'Import records to '.$zone,
				'response' => $response,
				'cloudAction' => 'import',
				'version'=>$version[0],
				'theme' => $params['clientareatemplate'],
			);
			
		} elseif ($requestedAction == 'import-records') {
			$fileType = $cloudns->Helper->getPost('type');
			if (!in_array($fileType, array('bind', 'tinydns'))) {
				$templateVariables = array(
					'pagetitle' => 'Import records to '.$zone,
					'response' => 'Invalid DNS zone file type',
					'cloudAction' => 'import',
				);
			} else {
				$delete = $cloudns->Helper->getPost('delete');
				if (!in_array($delete, array(0, 1))) {
					$templateVariables = array(
						'pagetitle' => 'Import records to '.$zone,
						'response' => 'Invalid delete parameter',
						'cloudAction' => 'import',
					);
				}
				$format = $cloudns->Helper->getPost('format');
				$records = html_entity_decode($cloudns->Helper->getPost('recordsList'));
				
				$templateVariables = $cloudns->Actions->importRecords($zone, $records, $delete, $format);
			}
			$templateFile = 'templates/import.tpl';
			
		} elseif ($requestedAction == 'statistics') {
			$templateVariables = $cloudns->Actions->getStats($zoneInfo, $cloudns->Helper->getGet('date', ''));
			$templateFile = 'templates/statistics.tpl';
			
		} else {
			$_SESSION['zoneInfo'] = array();
			$templateFile = 'templates/zones.tpl';
			$templateVariables = $cloudns->Actions->getZones();
		}
		
		// adding the below keys, because they are used everywhere and there is no need to add them in each action
		$version = explode('.', $params['whmcsVersion']);
		$templateVariables['serviceid'] = $params['serviceid'];
		$templateVariables['zone'] = $zone;
		$templateVariables['version']=$version[0];
		$templateVariables['theme'] = $params['clientareatemplate'];
		$templateVariables['registeredDomains'] = $params['configoption3'];
				
		// returning the template
		return array(
			'tabOverviewReplacementTemplate' => $templateFile,
			'vars' => $templateVariables,
			'cloudAction' => $requestedAction,
		);
		
	} catch (Exception $e) {
		// Record the error in WHMCS's module log.
		logModuleCall(
			'cloudns',
			__FUNCTION__,
			$params,
			$e->getMessage(),
			$e->getTraceAsString()
		);
		$version = explode('.', $params['whmcsVersion']);
		// In an error condition, display an error page.
		return array(
			'tabOverviewReplacementTemplate' => 'zone-error.tpl',
			'templateVariables' => array(
				'zone' => $zone,
				'response' => array('status'=>'error', 'description'=>$e->getMessage()),
				'usefulErrorHelper' => $e->getMessage(),
				'version'=>$version[0],
				'theme' => $params['clientareatemplate'],
				'registeredDomains' => $params['registeredDomains'],
				'cloudAction' => 'error',
			),
		);
	}
}

