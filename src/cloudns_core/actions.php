<?php

class Cloudns_Actions {
	/**
	 * @var core 
	 */
	protected $core;
	protected $params;

	public function __construct($params) {
		$this->core = Cloudns_Core::inst($params);
		$this->params = $params;
	}

	/**
	 * Gets the zones from the module's table
	 * @return array
	 */
	public function getZones() {

		if ($this->params['registeredDomains'] == 'on') {

			$zones = $this->core->Controller->getRegisteredDomains();
			foreach ($zones as &$zone) {
				$zone['ascii'] = $this->core->Helper->getUnicodeName($zone['name']);
			}

			$response = $zones;
		} else {
			$response = $this->core->Controller->getZones();
		}
		return array(
			'response' => $response,
			'zones' => $response,
			'cloudAction' => 'zones',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	/**
	 * Gets the info needed to display the Add new record page
	 * @param array $zoneInfo
	 * @param string $recordType
	 * @return array
	 */
	public function addNewRecord($zoneInfo, $recordType) {
		
		// check records limit before creation
		$recordsCount = $this->core->Controller->getRecordsCount($zoneInfo['name']);

		if ($this->params['recordsLimit'] != '' && $this->params['recordsLimit'] != -1 && $recordsCount >= $this->params['recordsLimit']) {
			return array('status' => 'error');
		}
		
		if ($zoneInfo['zone'] == 'ipv4' || $zoneInfo['zone'] == 'ipv6') {
			$zone_type = 'reverse';
		} else {
			$zone_type = $zoneInfo['zone'];
		}

		$recordTypes = $this->core->Controller->getRecordTypes($zone_type);
		$ttl = $this->core->Controller->getAvailableTTL();
		$type = 'A';
		if (in_array($recordType, $recordTypes)) {
			$type = $recordType;
		}

		$shortName = $this->core->Helper->shortenLongName($zoneInfo['name'], 34);

		return array(
			'pagetitle' => 'Add new record for ' . $zoneInfo['name'],
			'recordTypes' => $recordTypes,
			'defaultType' => $type,
			'shortName' => $shortName,
			'ttls' => $ttl,
			'settings' => array(),
			'cloudAction' => 'add-new-record',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	/**
	 * Adds new record
	 * @param array $zoneInfo
	 * @param string $recordType The type of the new record
	 * @param array $settings The record's settings submited by the customer
	 * @return array
	 */
	// todo
	public function doAddNewRecord($zoneInfo, $recordType, $settings) {
		$zone = $zoneInfo['name'];
		
		$recordTypes = $this->core->Controller->getRecordTypes($zoneInfo['zone']);
		$ttl = $this->core->Controller->getAvailableTTL();

		$response = $this->core->Records->recordAdd($zone, $recordType, $settings);

		if ($response['status'] == 'success') {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=zone-settings&zone={$zone}");
		}
		$shortName = $this->core->Helper->shortenLongName($zone, 34);

		return array(
			'pagetitle' => 'Add new record for ' . $zone,
			'response' => $response,
			'recordTypes' => $recordTypes,
			'defaultType' => $recordType,
			'settings' => $settings,
			'zone' => $zone,
			'ttls' => $ttl,
			'shortName' => $shortName,
			'cloudAction' => 'add-record',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	/**
	 * Gets the information needed to display the Edit record page
	 * @param array $zoneInfo
	 * @param int $record_id ID of the record in the ClouDNS system
	 * @return array
	 */
	public function editRecord($zoneInfo, $record_id) {
		$record = $this->core->Controller->getRecordById($zoneInfo['name'], $record_id);

		if (empty($record)) {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=zone-settings&zone={$zoneInfo['name']}");
		}

		$record['full_host'] = $this->core->Helper->getUnicodeName($record['host'] . (mb_strlen($record['host']) > 0 ? '.' : '') . $zoneInfo['name']);
		$shortName = $this->core->Helper->shortenLongName($zoneInfo['name'], 34);
		$uniHost = $this->core->Helper->getUnicodeName($record['host']);

		$ttl = $this->core->Controller->getAvailableTTL();

		return array(
			'pagetitle' => 'Edit record',
			'shortName' => $shortName,
			'record' => $record,
			'uniHost' => $uniHost,
			'zone' => $zoneInfo['name'],
			'ttls' => $ttl,
			'cloudAction' => 'edit-record',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	/**
	 * 
	 * @param array $zoneInfo
	 * @param int $record_id
	 * @param array $settings
	 * @param int $status
	 * @param string $recordType
	 * @return array
	 */
	public function doEditRecord($zoneInfo, $record_id, $settings, $status, $recordType) {
		$record = $this->core->Controller->getRecordById($zoneInfo['name'], $record_id);
		$uniHost = $this->core->Helper->getUnicodeName($record['host']);
		$shortName = $this->core->Helper->shortenLongName($zoneInfo['name'], 34);

		$response = $this->core->Records->recordEdit($zoneInfo['name'], $record_id, $settings, $status);

		// merging the arrays so the new values can be used to fill
		// the form, if there is an error with the record saving 
		$settings['fp_type'] = $this->core->Helper->getPost('fp_type');
		$record = array_merge($record, $settings);
		$ttl = $this->core->Controller->getAvailableTTL();
		
		if ($response['status'] == 'success') {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=zone-settings&zone={$zoneInfo['name']}");
		}
		
		return array(
			'pagetitle' => 'Edit record',
			'response' => $response,
			'shortName' => $shortName,
			'record' => $record,
			'uniHost' => $uniHost,
			'settings' => $settings,
			'zone' => $zoneInfo['name'],
			'ttls' => $ttl,
			'cloudAction' => 'do-edit-record',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	/**
	 * Gets the SOA settings
	 * @param array $zoneInfo
	 * @return array
	 */
	public function getSOASettings($zoneInfo) {
		if (!empty($zoneInfo)) {
			$soa = $this->core->SOA->getSOA($zoneInfo['name']);

			if (empty($soa)) {
				$response = array('status' => 'error', 'description' => 'It looks like there is no such zone');
			}

			$unicodePrymaryNS = $this->core->Helper->getUnicodeName($soa['primaryNS']);

			return array(
				'pagetitle' => 'SOA settings of ' . $zoneInfo['name'],
				'response' => $response,
				'soa' => $soa,
				'primaryNS' => $unicodePrymaryNS,
				'cloudAction' => 'soa-settings',
				'version' => $this->params['shortVersion'],
				'theme' => $this->params['theme'],
			);
		} else {
			return array('response' => 'An error occured');
		}
	}

	/**
	 * 
	 * @param array $zoneInfo
	 * @param array $soa
	 * @param string $soaAction
	 * @return array
	 */
	public function editSOA($zoneInfo, $soa, $soaAction) {
		$zone = $zoneInfo['name'];

		if ($soaAction == 'do_save') {
			$response = $this->core->SOA->editSOA($zone, $soa['primaryNS'], $soa['adminMail'], $soa['refresh'], $soa['retry'], $soa['expire'], $soa['defaultTTL']);
		} elseif ($soaAction == 'do_reset') {
			$response = $this->core->SOA->resetSOA($zone);
		} else {
			$response = array('status' => 'error', 'description' => 'An error occurred while saving the changes!');
		}

		if (isset($response['status']) && $response['status'] == 'error') {
			$soaSettings = $this->core->SOA->getSOA($zone);
			$soa = array_merge($soaSettings, $soa);
		} else {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=soa-settings&zone={$zone}");
		}

		return array(
			'pagetitle' => 'SOA settings edit of ' . $zone,
			'response' => $response,
			'zoneInfo' => $zoneInfo,
			'soa' => $soa,
			'cloudAction' => 'edit-soa-settings',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	/**
	 * Calls a method depending on the zone type (slave or master)
	 * @param array 
	 * $zoneInfo
	 * @param string $type Record type to return only these records for master zones
	 * @return array
	 */
	public function getSettings($zoneInfo, $type, $recordTypes, $failoverChecks, $productid) {
		if (!empty($zoneInfo)) {
			
			if (isset($zoneInfo['status']) && $zoneInfo['status'] == '0') {
				return array('response' => array('status' => $zoneInfo['status'], 'description' => 'The DNS zone ('.$zoneInfo['name'].') is currently unavailable, please contact Technical Support for assistance.'));
			}
			
			if ($zoneInfo['type'] == 'master') {
				return $this->getRecords($zoneInfo, $type, $recordTypes, $failoverChecks, $productid);
			} else {
				return $this->getMasterServers($zoneInfo);
			}
		} else {
			return array('response' => 'There is no such DNS zone');
		}
	}

	/**
	 * 
	 * @param array $zoneInfo
	 * @param string $type
	 * @param array
	 * @return array
	 */
	public function getRecords($zoneInfo, $type, $recordTypes, $failoverChecks, $productid, $response = array()) {
		$records = $this->core->Controller->getRecords($zoneInfo['name'], $type);
		$freeProductId = $this->core->Configuration->getFreeProductId();
		if ($productid != $freeProductId) {
			$foColumn = $this->core->Database->columnCheck('mod_cloudns_zones', 'fo_checks');
		} else {
			$foColumn = $this->core->Database->columnCheck('tbldomains', 'fo_checks');
		}

		foreach ($records as &$row) {
			$row['full_host'] = $this->core->Helper->getUnicodeName($row['host'] . (mb_strlen($row['host']) > 0 ? '.' : '') . $zoneInfo['name']);
			$row['shortHost'] = $this->core->Helper->shortenLongName($row['host'] . (mb_strlen($row['host']) > 0 ? '.' : '') . $zoneInfo['name'], 24);
						
			if ($row['type'] == 'MX') {
				$row['priority'] = $row['priority'] . ' ';
			}
			if ($row['type'] == 'SRV') {
				$row['priority'] = $row['priority'] . ' ' . $row['weight'] . ' ' . $row['port'] . ' ';
			}
			if (in_array($row['type'], array('SSHFP', 'TXT', 'SPF', 'MX', 'SRV'))) {
				$row['shortRecord'] = $this->core->Helper->shortenLongString($row['priority'] . $row['record'], 24);
			} elseif ($row['type'] == 'RP') {
				$row['shortRecord'] = $this->core->Helper->shortenLongName($row['mail'], 24);
			} elseif ($row['type'] == 'NAPTR') {
				$row['shortRecord'] = $this->core->Helper->shortenLongName($row['order'] . ' ' . $row['pref'] . ' "' . $row['flag'] . '" "' . $row['params'] . '" ' . (!empty($row['regexp']) ? '"' . $row['regexp'] . '"' : '""') . ' ' . (!empty($row['replace']) ? $row['replace'] : '.'), 30);
			} elseif ($row['type'] == 'CAA') {
				$row['shortRecord'] = $this->core->Helper->shortenLongName($row['caa_flag'] . ' ' . $row['caa_type'] . ' "' . $row['caa_value'] . '"', 30);
			} elseif ($row['type'] == 'TLSA') {
				$row['shortRecord'] = $this->core->Helper->shortenLongName($row['tlsa_usage'].' '.$row['tlsa_selector'].' '.$row['tlsa_matching_type']. ' '.$row['record'], 30);
			} elseif ($row['type'] == 'DS') {
				$row['shortRecord'] = $this->core->Helper->shortenLongName($row['key_tag'].' '.$row['algorithm'].' '.$row['digest_type']. ' '.$row['record'], 30);
			} elseif ($row['type'] == 'CERT') {
				$row['shortRecord'] = $this->core->Helper->shortenLongString($row['cert_type'].' '.$row['key_tag'].' '.$row['algorithm']. ' '.$row['record'], 24);
			} elseif ($row['type'] == 'HINFO') {
				$row['shortRecord'] = $this->core->Helper->shortenLongName($row['cpu'].' '.$row['os'], 30);
			} elseif ($row['type'] == 'LOC') {
				$row['shortRecord'] = $this->core->Helper->shortenLongName($row['lat_deg'].' '.$row['lat_min'].' '.$row['lat_sec'].' '.strtoupper($row['lat_dir']).' '.$row['long_deg'].' '.$row['long_min'].' '.$row['long_sec'].' '.strtoupper($row['long_dir']).' '.$row['altitude'].' '.$row['size'].' '.$row['h_precision'].' '.$row['v_precision'], 30);
			} elseif ($row['type'] == 'SMIMEA') {
				$row['shortRecord'] = $this->core->Helper->shortenLongString($row['smimea_usage'].' '.$row['smimea_selector'].' '.$row['smimea_matching_type']. ' '.$row['record'], 30);
			} else {
				$row['shortRecord'] = $this->core->Helper->shortenLongName($row['record'], 24);
			}
			
			$row['ttl_seconds'] = $this->core->Helper->convertSeconds($row['ttl']);
		}

		return array(
			'pagetitle' => 'DNS records of ' . $zoneInfo['name'],
			'zoneInfo' => $zoneInfo,
			'recordTypes' => $recordTypes,
			'defaultType' => $type,
			'foColumn' => $foColumn,
			'records' => $records,
			'cloudAction' => 'zone-settings',
			'failover' => $failover,
			'failoverChecks' => $failoverChecks,
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
			'response' => $response,
		);
	}

	/**
	 * Deletes a record
	 * @param array $zoneInfo
	 * @param int $record_id
	 * @return type
	 */
	public function deleteRecord($zoneInfo, $record_id) {
		$response = $this->core->Controller->deleteRecord($zoneInfo['name'], $record_id);
		if ($response['status'] == 'success') {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=zone-settings&zone={$zoneInfo['name']}");
		}
		
		$recordTypes = $this->core->Controller->getRecordTypes($zoneInfo['zone']);
		
		return $this->getRecords($zoneInfo, 'all', $recordTypes, $this->params['failoverChecks'], $this->params['productid'], $response);
	}

	/**
	 * Deletes a zone
	 * @param array $zoneInfo
	 * @return array
	 */
	public function deleteZone($zone) {
		$response = $this->core->Controller->deleteZone($zone);

		if ($response['status'] == 'success') {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=zones");
		}
		$toReturn = $this->getZones();
		$toReturn['response'] = $response['description'];

		return $toReturn;
	}

	/**
	 * Gets the slave servers for slave zones
	 * @param array $zoneInfo
	 * @return array
	 */
	public function getBINDSettings($zoneInfo) {
		$ipv4 = '';
		$ipv6 = '';
		foreach ($this->core->Servers->getMasterServers() as $server) {
			$ipv4 .= "		{$server['ip4']};\n";
			if (!is_null($server['ip6'])) {
				$ipv6 .= "		{$server['ip6']};\n";
			}
		}

		return array(
			'pagetitle' => 'Example Bind settings of ' . $zoneInfo['name'],
			'zoneInfo' => $zoneInfo,
			'ipv4' => $ipv4,
			'ipv6' => $ipv6,
			'cloudAction' => 'bind-settings',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	/**
	 * Gets the master servers of a slave zone, added by the client
	 * @param array $zoneInfo
	 * @return array
	 */
	public function getMasterServers($zoneInfo) {
		$masterServers = $this->core->Slave->getMasterServers($zoneInfo['name']);
		$response = '';
		return array(
			'pagetitle' => 'Master servers of ' . $zoneInfo['name'],
			'zoneInfo' => $zoneInfo,
			'response' => $response,
			'masterServers' => $masterServers,
			'cloudAction' => 'zone-settings',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	/**
	 * Deletes a master server
	 * @param string $zone
	 * @param string $master
	 * @return array
	 */
	public function deleteMasterServer($zone, $master) {
		$response = $this->core->Slave->deleteMasterServer($zone, $master);
		if ($response['status'] == 'success') {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=zone-settings&zone={$zone}");
		}
		$masterServers = $this->core->Slave->getMasterServers($zone);
		return array(
			'pagetitle' => 'Master servers of ' . $zone,
			'response' => $response,
			'masterServers' => $masterServers,
			'cloudAction' => 'delete-master-server',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	/**
	 * 
	 * @param string $zone
	 * @param string $master
	 * @return array
	 */
	public function addMasterServer($zone, $master) {
		$response = $this->core->Slave->addMasterServer($zone, $master);
		if ($response['status'] == 'success') {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=zone-settings&zone={$zone}");
		}
		$masterServers = $this->core->Slave->getMasterServers($zone);

		return array(
			'pagetitle' => 'Master servers of ' . $zone,
			'response' => $response,
			'masterServers' => $masterServers,
			'cloudAction' => 'add-master-server',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	/**
	 * Gets the update status of a zone
	 * @param array $zoneInfo
	 * @return array
	 */
	public function getUpdateStatus($zoneInfo) {
		$updated = $this->core->Zones->getUpdateStatus($zoneInfo['name']);
		return array(
			'pagetitle' => 'Update status of ' . $zoneInfo['name'],
			'response' => '',
			'updated' => $updated,
			'zoneInfo' => $zoneInfo,
			'cloudAction' => 'update-status',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	/**
	 * Updates the zone at the DNS servers
	 * @param array $zoneInfo
	 * @return array
	 */
	public function updateZone($zoneInfo) {
		$response = $this->core->Zones->updateZone($zoneInfo['name']);
		if ($response['status'] == 'success') {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=update-status&zone={$zoneInfo['name']}");
		} else {
			$updated = $this->core->Zones->getUpdateStatus($zoneInfo['name']);
			return array(
				'pagetitle' => 'Update status of ' . $zoneInfo['name'],
				'response' => $response,
				'updated' => $updated,
				'zoneInfo' => $zoneInfo,
				'cloudAction' => 'update',
				'version' => $this->params['shortVersion'],
				'theme' => $this->params['theme'],
			);
		}
	}

	/**
	 * Imports records from a text area in BIND or TinyDNS format
	 * @param string $zone
	 * @param string $records A list with all the records submited by the client
	 * @param int $delete 1 or 0
	 * @param string $format BIND or TinyDNS
	 * @return array
	 */
	public function importRecords($zone, $records, $delete, $format) {
		$response = $this->core->Records->import($zone, $records, $format, $delete);

		if ($response['status'] == 'success') {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=zone-settings&zone={$zone}");
		}
		return array(
			'pagetitle' => 'Import records to ' . $zone,
			'response' => $response,
			'cloudAction' => 'import',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	/**
	 * Returns the data needed to display the statistics
	 * @param array $zoneInfo
	 * @param string $date
	 * @return array
	 */
	public function getStats($zoneInfo, $date) {
		$zone = $zoneInfo['name'];
		$stats = $this->core->Statistics->getZoneStats($zone, $date);

		$requests = array_sum($stats);
		$statsTable = '';
		foreach ($stats as $key => $value) {
			$showLink = true;

			if ($date == 'last-30-days') {
				$unixtime = strtotime($key);
				$timeHTML = date('l, F d, Y', $unixtime);
				$timeLink = date('Ymd', $unixtime);
				$hover = date('Y-m-d', $unixtime);

				if (strtotime($hover) < strtotime('-1 month')) {
					$showLink = false;
				}
			} else if (strlen($date) == 8) {
				$currhour = $key;
				$nexthour = $currhour + 1;

				if ($nexthour < 10) {
					$nexthour = "0{$nexthour}";
				}

				$timeLink = 0;

				$timeHTML = "{$currhour}:00 - {$nexthour}:00 , " . date('F d , Y', strtotime($date));
				$hover = date('Y-m-d', strtotime($date)) . " $currhour:00 - $nexthour:00";
				$showLink = false;
			} elseif (strlen($date) == 6) {
				$timeHTML = date('l, F d, Y', strtotime($date . $key));
				$timeLink = $date . $key;
				$hover = date('Y-m-d', strtotime($date . $key));
				if (strtotime($hover) < strtotime('-1 month')) {
					$showLink = false;
				}
				$noLinkDate = date('Ymd', strtotime('-1 month'));
			} elseif (strlen($date) == 4) {
				$timeHTML = date('F, Y', strtotime($date . $key . '01'));
				$timeLink = $date . $key;
				$hover = date('Y-m', strtotime($date . $key . '01'));
			} else {
				$hover = $timeHTML = $timeLink = $key;
			}

			// html
			if ($requests == 0) {
				$percent = 0;
			} else {
				$percent = ($value / $requests) * 100;
			}

			$tdWidth = strlen($date) * 42;
			if (strlen($date) == 12) {
				$tdWidth = 270;
			} elseif (strlen($date) == 0) {
				$tdWidth = 100;
			}

			$statsTable .= '<tr ' . (($showLink == true || strlen($date) < 6) ? 'class="pointer" onClick="javascript: location.href=\'clientarea.php?action=productdetails&id=' . $this->params['serviceid'] . '&customAction=statistics&zone=' . $zone . '&date=' . $timeLink . '\'"' : '') . '>
				<td class="text-right" style="width:' . $tdWidth . 'px;">' . $timeHTML . '</td>
				<td>
					<div style="height:10px; width:' . round((450 * $percent) / 100) . 'px; background-color:#ffa900; margin:3px 5px 0 5px;" class="pull-left">&nbsp</div> ' . number_format($percent, 2) . '% (' . number_format($value) . ' Requests)
				</td>
			</tr>';
		}

		$statLinks = '';
		if (strlen($date) == 8) {
			$statLinks = ' » <a href="clientarea.php?action=productdetails&id=' . $this->params['serviceid'] . '&customAction=statistics&zone=' . $zone . '&date=' . substr($date, 0, 4) . '">' . substr($date, 0, 4) . '</a> » <a href="clientarea.php?action=productdetails&id=' . $this->params['serviceid'] . '&customAction=statistics&zone=' . $zone . '&date=' . substr($date, 0, 6) . '">' . date('F', strtotime($date)) . '</a> » ' . date('l d', strtotime(substr($date, 0, 8)));
		} elseif (strlen($date) == 6) {
			$statLinks = ' » <a href="clientarea.php?action=productdetails&id=' . $this->params['serviceid'] . '&customAction=statistics&zone=' . $zone . '&date=' . substr($date, 0, 4) . '">' . substr($date, 0, 4) . '</a> » ' . date('F', strtotime($date . '01'));
		} elseif (strlen($date) == 4) {
			$statLinks = ' » ' . substr($date, 0, 4);
		}

		$response = '';
		return array(
			'pagetitle' => 'Statistics of ' . $zone,
			'response' => $response,
			'statsTable' => $statsTable,
			'statLinks' => $statLinks,
			'requests' => $requests,
			'date' => $date,
			'zoneInfo' => $zoneInfo,
			'cloudAction' => 'statistics',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	public function suspendZones() {
		$zones = $this->core->Controller->getZones();

		if (!isset($zones['status'])) {
			$message = array();
			foreach ($zones as $zone) {
				$response = $this->core->Zones->suspend($zone['name']);
				if (isset($response['status']) && $response['status'] == 'error') {
					$message[] = $response['description'];
				}
			}

			if (!empty($message)) {
				return implode(', ', $message);
			}
		}

		return 'success';
	}

	public function unSuspendZones() {
		$zones = $this->core->Controller->getZones();

		if (!isset($zones['status'])) {
			$message = array();
			foreach ($zones as $zone) {
				$response = $this->core->Zones->unSuspend($zone['name']);
				if (isset($response['status']) && $response['status'] == 'error') {
					$message[] = $response['description'];
				}
			}
			if (!empty($message)) {
				return implode(', ', $message);
			}
		}

		return 'success';
	}

	public function terminateAccount() {
		$zones = $this->core->Controller->getZones();
		if (!isset($zones['status'])) {
			$message = array();
			foreach ($zones as $zone) {
				$this->core->Controller->deleteZone($zone['name']);
			}
		}

		return 'success';
	}

	public function getFailoverSettings($zoneInfo, $record_id) {
		$zone = $zoneInfo['name'];
		$response = $this->core->Failover->failoverSettings($zone, $record_id);

		if ($response['status'] == '-1') {
			return $this->failoverView($zoneInfo, $record_id);
		} else {
			return $this->failoverSettings($zoneInfo, $record_id);
		}
	}

	public function failoverSettings($zoneInfo, $record_id) {
		$zone = $zoneInfo['name'];

		$record = $this->core->Controller->getRecordById($zone, $record_id);
		$failover = $this->core->Failover->failoverSettings($zone, $record_id);
		$checkTypes = $this->core->Failover->getCheckTypes();

		$record['full_host'] = $this->core->Helper->getUnicodeName($record['host'] . (mb_strlen($record['host']) > 0 ? '.' : '') . $zoneInfo['name']);
		$shortName = $this->core->Helper->shortenLongName($zone, 34);
		$uniHost = $this->core->Helper->getUnicodeName($record['host']);

		return array(
			'pagetitle' => 'DNS Failover & Monitoring',
			'shortName' => $shortName,
			'record' => $record,
			'failover' => $failover,
			'fullHost' => $record['full_host'],
			'uniHost' => $uniHost,
			'zone' => $zone,
			'settings' => array(),
			'checkTypes' => $checkTypes,
			'cloudAction' => 'failover-new',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	public function activateFailover($zoneInfo, $record_id, $settings) {
		$zone = $zoneInfo['name'];
		
		$checkTypes = $this->core->Failover->getCheckTypes();
		$record = $this->core->Controller->getRecordById($zone, $record_id);
		$record['full_host'] = $this->core->Helper->getUnicodeName($record['host'] . (mb_strlen($record['host']) > 0 ? '.' : '') . $zoneInfo['name']);
		$shortName = $this->core->Helper->shortenLongName($zone, 34);
		$uniHost = $this->core->Helper->getUnicodeName($record['host']);
		$response['status'] = 'success';
		
		if ($settings['notification_type'] == Cloudns_Failover::NOTIFICATION_TYPE_EMAIL) {
			$notification_value = $this->core->Helper->getUnicodeName($settings['notification_value']);
			if (!$this->core->Valid->mail($notification_value)) {
				$response['status'] = 'error';
				$response['description'] = 'Invalid monitoring notification mail';
			}
		} else {
			$notification_value = $this->core->Helper->convertWRtoAscii($settings['notification_value']);
			$url = parse_url($notification_value);
			$valid = false;
			
			if (isset($url['host'])) {
				$valid = $this->core->Valid->host($url['host']);
			}
			
			if (!isset($url['host']) || (isset($url['host']) && !$valid['status'])) {
				$response['status'] = 'error';
				$response['description'] = 'Invalid monitoring notification URL';
			}
			
			if (!isset($url['scheme']) || (isset($url['scheme']) && !in_array($url['scheme'], array('http', 'https', 'ftp')))) {
				$response['status'] = 'error';
				$response['description'] = 'Invalid monitoring notification URL';
			}
		}
		
		if ($response['status'] != "success") {
			return array(
				'pagetitle' => 'DNS Failover & Monitoring',
				'shortName' => $shortName,
				'record' => $record,
				'response' => $response,
				'fullHost' => $record['full_host'],
				'uniHost' => $uniHost,
				'zone' => $zone,
				'settings' => array(),
				'checkTypes' => $checkTypes,
				'cloudAction' => 'failover-new',
				'version' => $this->params['shortVersion'],
				'theme' => $this->params['theme'],
			);
		}
		
		if ($settings['notification_type']  == Cloudns_Failover::NOTIFICATION_TYPE_WEBHOOK_UP || $settings['notification_type'] == Cloudns_Failover::NOTIFICATION_TYPE_WEBHOOK_DOWN) {
			
			$response = $this->core->Failover->failoverActivate($zone, $record_id, $settings);

			//add the webhook notification
			if ($response['status'] == "success") {
				$webhookResponse = $this->core->Failover->createNotification($zone, $record_id, $settings['notification_type'], $settings['notification_value']);
			}
		} else {
			$settings['notification_mail'] = $settings['notification_value'];
			$response = $this->core->Failover->failoverActivate($zone, $record_id, $settings);
		}
		
		if ($response['status'] == "success") {

			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=zone-settings&zone={$zoneInfo['name']}");

			return array(
				'pagetitle' => 'DNS Failover & Monitoring',
				'shortName' => $shortName,
				'response' => $response,
				'record' => $record,
				'fullHost' => $record['full_host'],
				'uniHost' => $uniHost,
				'settings' => $settings,
				'zone' => $zone,
				'cloudAction' => 'failover-activate',
				'version' => $this->params['shortVersion'],
				'theme' => $this->params['theme'],
			);
		} else {
			return array(
				'pagetitle' => 'DNS Failover & Monitoring',
				'shortName' => $shortName,
				'record' => $record,
				'response' => $response,
				'fullHost' => $record['full_host'],
				'uniHost' => $uniHost,
				'zone' => $zone,
				'settings' => array(),
				'checkTypes' => $checkTypes,
				'cloudAction' => 'failover-new',
				'version' => $this->params['shortVersion'],
				'theme' => $this->params['theme'],
			);
		}
	}

	public function deactivateFailover($zoneInfo, $record_id) {
		$zone = $zoneInfo['name'];

		$response = $this->core->Failover->failoverDeactivate($zone, $record_id, $settings);
		if ($response['status'] == "success") {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=zone-settings&zone={$zoneInfo['name']}");
		}
		return $this->getRecords($zoneInfo, 'all', $response);
	}

	public function editFailover($zoneInfo, $record_id, $settings) {
		$zone = $zoneInfo['name'];

		$record = $this->core->Controller->getRecordById($zone, $record_id);
		$checkTypes = $this->core->Failover->getCheckTypes();
		$response = $this->core->Failover->failoverEdit($zone, $record_id, $settings);
		
		$record['full_host'] = $this->core->Helper->getUnicodeName($record['host'] . (mb_strlen($record['host']) > 0 ? '.' : '') . $zoneInfo['name']);
		$shortName = $this->core->Helper->shortenLongName($zone, 34);
		$uniHost = $this->core->Helper->getUnicodeName($record['host']);
		
		if ($response['status'] == "success") {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=zone-settings&zone={$zoneInfo['name']}");
		
			return array(
				'pagetitle' => 'DNS Failover & Monitoring',
				'shortName' => $shortName,
				'response' => $response,
				'record' => $record,
				'fullHost' => $record['full_host'],
				'uniHost' => $uniHost,
				'settings' => $settings,
				'zone' => $zone,
				'checkTypes' => $checkTypes,
				'cloudAction' => 'failover-edit',
				'version' => $this->params['shortVersion'],
				'theme' => $this->params['theme'],
			);
		} else {
			$failover = $this->core->Failover->failoverSettings($zone, $record_id);
			
			return array(
				'pagetitle' => 'DNS Failover & Monitoring',
				'shortName' => $shortName,
				'response' => $response,
				'failover' => $failover,
				'record' => $record,
				'fullHost' => $record['full_host'],
				'uniHost' => $uniHost,
				'zone' => $zone,
				'settings' => $settings,
				'checkTypes' => $checkTypes,
				'cloudAction' => 'failover-view',
				'version' => $this->params['shortVersion'],
				'theme' => $this->params['theme'],
			);
		}
	}

	public function failoverView($zoneInfo, $record_id) {
		$zone = $zoneInfo['name'];
		$record = $this->core->Controller->getRecordById($zone, $record_id);
		$failover = $this->core->Failover->failoverSettings($zone, $record_id);
		$checkTypes = $this->core->Failover->getCheckTypes();

		$record['full_host'] = $this->core->Helper->getUnicodeName($record['host'] . (mb_strlen($record['host']) > 0 ? '.' : '') . $zoneInfo['name']);
		$shortName = $this->core->Helper->shortenLongName($zone, 34);
		$uniHost = $this->core->Helper->getUnicodeName($record['host']);

		return array(
			'pagetitle' => 'DNS Failover & Monitoring',
			'shortName' => $shortName,
			'record' => $record,
			'failover' => $failover,
			'fullHost' => $record['full_host'],
			'uniHost' => $uniHost,
			'zone' => $zone,
			'settings' => array(),
			'checkTypes' => $checkTypes,
			'cloudAction' => 'failover-view',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	public function failoverActionLog($zoneInfo, $record_id, $page) {
		$zone = $zoneInfo['name'];
		$record = $this->core->Controller->getRecordById($zone, $record_id);
		$rows_per_page = 10;
		$pages = $this->core->Failover->getActionHistoryPages($zone, $record_id, $rows_per_page);

		$pagination = $this->core->helper->showPaging($page, $pages, "clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=failover-action-log&zone={$zone}&dns_record_id={$record_id}&page=PAGE_NUM", null, true);

		$actionLog = $this->core->Failover->getActionHistory($zone, $record_id, $page, $rows_per_page);
		$actionLogTable = '';

		foreach ($actionLog as $row) {
			$date = date('Y-m-d H:i:s', $row['time']);
			if ($row['action'] == Cloudns_Failover::ACTION_RECORD_ACTIVATED) {
				$row['action'] = 'ACTIVATED';
			} elseif ($row['action'] == Cloudns_Failover::ACTION_RECORD_DEACTIVATED) {
				$row['action'] = 'DEACTIVATED';
			} elseif ($row['action'] == Cloudns_Failover::ACTION_RECORD_REPLACED) {
				$row['action'] = 'CHANGED';
			} else {
				$row['action'] = 'UNKNOWN';
			}
			$action = $row['action'];
			$ip = $row['ip'];
			$actionLogTable .= '<tr><td>' . $date . '</td><td class="bold' . (($action == 'CHANGED') ? ' blue"' : (($action == 'ACTIVATED') ? ' green"' : (($action == 'DEACTIVATED') ? ' red"' : (($action == 'UNKNOWN') ? ' grey"' : '')))) . '>' . $action . '</td><td>' . $ip . '</td></tr>';
		}

		$actionLogTable .= '<tr><td class="dataTables_length" colspan="3">' . $pagination . '</td></tr>';

		return array(
			'record' => $record,
			'pagetitle' => 'DNS Failover & Monitoring',
			'actionLogTable' => $actionLogTable,
			'actionLog' => $actionLog,
			'cloudAction' => 'failover-action-log',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	public function failoverMonitoringLog($zoneInfo, $record_id, $page) {
		$zone = $zoneInfo['name'];
		$record = $this->core->Controller->getRecordById($zone, $record_id);
		$rows_per_page = 10;
		$pages = $this->core->Failover->getCheckHistoryPages($zone, $record_id, $rows_per_page);

		$pagination = $this->core->helper->showPaging($page, $pages, "clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=failover-monitoring-log&zone={$zone}&dns_record_id={$record_id}&page=PAGE_NUM", null, true);

		$monitoringLog = $this->core->Failover->getCheckHistory($zone, $record_id, $page, $rows_per_page);
		$monitoringLogTable = '';
		foreach ($monitoringLog as $row) {
			$date = date('Y-m-d H:i:s', $row['time']);
			if ($row['status'] == Cloudns_Failover::CHECK_STATUS_UP) {
				$row['status'] = 'UP';
			} elseif ($row['status'] == Cloudns_Failover::CHECK_STATUS_DOWN) {
				$row['status'] = 'DOWN';
			} else {
				$row['status'] = 'UNKNOWN';
			}
			$status = $row['status'];
			$ip = $row['ip'];
			$location = $row['checker_location'];
			$monitoringLogTable .= '<tr><td>' . $date . '</td><td class="bold' . ($status == 'UP' ? ' green' : (($status == 'DOWN' ? ' red' : ''))) . '">' . $status . '</td><td>' . $ip . '</td><td>' . $location . '</td></tr>';
		}
		$monitoringLogTable .= '<tr><td class="dataTables_length" colspan="4">' . $pagination . '</td></tr>';

		return array(
			'record' => $record,
			'pagetitle' => 'DNS Failover & Monitoring',
			'cloudAction' => 'failover-monitoring-notifications',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
			'monitoringLog' => $monitoringLog,
			'monitoringLogTable' => $monitoringLogTable,
		);
	}
	
	public function addFailoverNotification($zoneInfo, $record_id, $settings, $page) {
		$zone = $zoneInfo['name'];

		$response = $this->core->Failover->createNotification($zone, $record_id, $settings['notification_type'], $settings['notification_value']);
		
		if ($response['status'] == 'success') {
			$response['status'] = 'info';
		}
		
		$rows_per_page = 10;
		$pages = $this->core->Failover->getNotificationPages($zone, $record_id, $rows_per_page);

		$pagination = $this->core->helper->showPaging($page, $pages, "clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=failover-monitoring-notifications&zone={$zone}&dns_record_id={$record_id}&page=PAGE_NUM", null, true);

		$record = $this->core->Failover->failoverSettings($zone, $record_id);
		$notifications = $this->core->Failover->listNotifications($zone, $record_id, $page, $rows_per_page);

		$notificationsTable = '';
		foreach ($notifications as $row) {
			$status = $row['status'];
			$ip = $row['ip'];
			$location = $row['checker_location'];
			$notificationsTable .= '<tr><td>' . $row['type'] . '</td><td>' . $row['value'] . '</td><td><a href="clientarea.php?action=productdetails&id=' . $this->params['serviceid'] . '&customAction=failover-delete-notification&zone=' . $zone . '&dns_record_id=' . $record_id . '&notification_id=' . $row['notification_id'] . '&page=' . $page . '" title="Delete this record" onclick="return confirm(\'Are you sure you want to delete this record?\');">Delete</a></td>';
		}
		$notificationsTable .= '<tr><td class="dataTables_length" colspan="3">' . $pagination . '</td></tr>';

		return array(
		    'record' => $record,
		    'record_id' => $record_id,
		    'pagetitle' => 'DNS Failover & Monitoring',
		    'cloudAction' => 'failover-monitoring-notifications',
		    'response' => $response,
		    'notifications' => $notifications,
		    'notificationsTable' => $notificationsTable,
		    'version' => $this->params['shortVersion'],
		    'theme' => $this->params['theme'],
		);
	}

	public function deleteFailoverNotification($zoneInfo, $record_id, $notification_id, $page) {
		$zone = $zoneInfo['name'];
		$rows_per_page = 10;
		$notifications = $this->core->Failover->listNotifications($zone, $record_id, 1, $rows_per_page);
		
		if (count($notifications) <= 1) {
			$response = array();
			$response['status'] = 'error';
			$response['description'] = 'You need to have at least 1 active failover notification';
		} else {
			$response = $this->core->Failover->deleteNotification($zone, $record_id, $notification_id);
		}
		
		if ($response['status'] == 'success') {
			$response['status'] = 'info';
		} 
		$pages = $this->core->Failover->getNotificationPages($zone, $record_id, $rows_per_page);
		$pagination = $this->core->helper->showPaging($page, $pages, "clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=failover-monitoring-notifications&zone={$zone}&dns_record_id={$record_id}&page=PAGE_NUM", null, true);

		$record = $this->core->Failover->failoverSettings($zone, $record_id);
		$notifications = $this->core->Failover->listNotifications($zone, $record_id, $page, $rows_per_page);
			
		$notificationsTable = '';
		foreach ($notifications as $row) {
			$status = $row['status'];
			$ip = $row['ip'];
			$location = $row['checker_location'];
			$notificationsTable .= '<tr><td>' . $row['type'] . '</td><td>' . $row['value'] . '</td><td><a href="clientarea.php?action=productdetails&id='.$this->params['serviceid'].'&customAction=failover-delete-notification&zone='.$zone.'&dns_record_id='.$record_id.'&notification_id='.$row['notification_id'].'&page='.$page.'" title="Delete this record" onclick="return confirm(\'Are you sure you want to delete this record?\');">Delete</a></td>';
		}
		$notificationsTable .= '<tr><td class="dataTables_length" colspan="3">' . $pagination . '</td></tr>';

		return array(
			'record' => $record,
			'record_id' => $record_id,
			'pagetitle' => 'DNS Failover & Monitoring',
			'cloudAction' => 'failover-monitoring-notifications',
			'response' => $response,
			'notifications' => $notifications,
			'notificationsTable' => $notificationsTable,
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}
	
	public function failoverMonitoringNotifications($zoneInfo, $record_id, $page) {
		$zone = $zoneInfo['name'];
		$rows_per_page = 10;
		$pages = $this->core->Failover->getNotificationPages($zone, $record_id, $rows_per_page);
		
		$pagination = $this->core->helper->showPaging($page, $pages, "clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=failover-monitoring-notifications&zone={$zone}&dns_record_id={$record_id}&page=PAGE_NUM", null, true);
		
		$record = $this->core->Failover->failoverSettings($zone, $record_id);
		
		$notifications = $this->core->Failover->listNotifications($zone, $record_id, $page, $rows_per_page);
		$notificationsTable = '';
		foreach ($notifications as $row) {
			$status = $row['status'];
			$ip = $row['ip'];
			$location = $row['checker_location'];
			$notificationsTable .= '<tr><td>' . $row['type'] . '</td><td>' . $row['value'] . '</td><td><a href="clientarea.php?action=productdetails&id='.$this->params['serviceid'].'&customAction=failover-delete-notification&zone='.$zone.'&dns_record_id='.$record_id.'&notification_id='.$row['notification_id'].'&page='.$page.'" title="Delete this record" onclick="return confirm(\'Are you sure you want to delete this record?\');">Delete</a></td>';
		}
		$notificationsTable .= '<tr><td class="dataTables_length" colspan="3">' . $pagination . '</td></tr>';
		
		return array(
			'record' => $record,
			'record_id' => $record_id,
			'pagetitle' => 'DNS Failover & Monitoring',
			'cloudAction' => 'failover-monitoring-notifications',
			'notifications' => $notifications,
			'notificationsTable' => $notificationsTable,
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}
	
	public function dnssec($zoneInfo, $waitDSrecords) {
		$zone = $zoneInfo['name'];
		$response = $this->core->dnssec->getDSrecords($zone);
		
		if ($response['status'] == '1') {
			return $this->dnssecSettings($zoneInfo);
		} elseif ($response['status'] == 'error' && $waitDSrecords == 1) {
			return $this->dnssecWaiting($zoneInfo);
		} else {
			return $this->dnssecShow($zoneInfo);
		}
	}

	public function dnssecShow($zoneInfo) {
		$zone = $zoneInfo['name'];
	
		return array(
			'pagetitle' => 'DNSSEC for'.$zone,
			'zone' => $zone,
			'cloudAction' => 'dnssec-show',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}
	
	public function dnssecSettings($zoneInfo) {
		$zone = $zoneInfo['name'];
		$dnssec = $this->core->dnssec->getDSrecords($zone);
		
		return array(
			'pagetitle' => 'DNSSEC for '.$zone,
			'zone' => $zone,
			'dnssec' => $dnssec,
			'cloudAction' => 'dnssec-settings',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}
	
	public function dnssecActivate($zoneInfo) {
		$zone = $zoneInfo['name'];
		$response = $this->core->dnssec->activateDnssec($zone);
		$getDSrecords = $this->core->dnssec->getDSrecords($zone);
		
		if ($response['status'] == 'success' && $getDSrecords['status'] == '1') {
			$waitDSrecords = 1;
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=dnssec-settings&zone={$zoneInfo['name']}&waitDS={$waitDSrecords}");
		}
		
		elseif ($response['status'] == 'success' && $getDSrecords['status'] == 'error') {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=dnssec-waiting&zone={$zoneInfo['name']}");
		}

		return array(
			'zone' => $zone,
			'response' => $response,
			'cloudAction' => 'dnssec-activate',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}

	public function dnssecDeactivate($zoneInfo) {
		$zone = $zoneInfo['name'];

		$response = $this->core->dnssec->deactivateDnssec($zone);
		if ($response['status'] == "success") {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=dnssec-show&zone={$zoneInfo['name']}");
		}
		
		return $this->dnssecShow($zoneInfo);
	}
	
	public function dnssecWaiting ($zoneInfo) {
		$zone = $zoneInfo['name'];
		
		$response = $this->core->dnssec->getDSrecords($zone);
		
		if ($response['status'] == '1') {
			$this->core->Helper->redirect("clientarea.php?action=productdetails&id={$this->params['serviceid']}&customAction=dnssec-settings&zone={$zoneInfo['name']}");
		}
		
		return array(
			'pagetitle' => 'DNSSEC for '.$zone,
			'zone' => $zone,
			'response' => $response,
			'cloudAction' => 'dnssec-waiting',
			'version' => $this->params['shortVersion'],
			'theme' => $this->params['theme'],
		);
	}
}
