<?php

require_once ROOTDIR."/modules/servers/cloudns/cloudns_core/core.php";

$cloudns = Cloudns_Core::inst();
/**
 * id of the product created for DNS management
 * of registered domains. 
 * It will be automatically activated 1 time after a successful domain registration.
 */
$pid = $cloudns->Configuration->getFreeProductId();

// whmcs admin account username
$adminUsername = $cloudns->Configuration->getAdminUser();

/**
 * checking if there are services for that product
 * if there are NO we are adding an order for one
 * if they are we don't need to do anything
 */
$command = 'GetClientsProducts';

$domain = '';
if (isset($vars['domain'])) {
	$domain = $vars['domain'];
	
} else {
	$domain = $vars['params']['sld'].'.'.$vars['params']['tld'];
}

// getting the user's id
$tblParams = array(
	'domain' => $domain,
);
$tbldomains = $cloudns->Database->select('tbldomains', $tblParams, 'id');
$userid = $tbldomains[0]['userid'];

// data to be send
$postData = array(
	'clientid' => $userid,
	'pid' => $pid,
);
// calling the api
$clientProduct = localAPI($command, $postData, $adminUsername);

// if there is no such service we create it
if (empty($clientProduct['products'])) {

	$command = 'AddOrder';
	$postData = array(
		'clientid' => $userid,
		'pid' => $pid,
		'paymentmethod' => 'mailin',
        );
	$orderIt = localAPI($command, $postData, $adminUsername);
	if (isset($orderIt['orderid'])) {
		$command = "AcceptOrder";
		$postData = array(
			'orderid' => $orderIt['orderid'],
		);
		// activate the order
		localAPI($command, $postData, $adminUsername);
	}
}

/* creating the zone when the domain is registered */

$zone = $domain;

$tbl_params = array(
	'id' => $pid,
);
$moduleOptions = $cloudns->Database->select('tblproducts', $tbl_params, 'id');

if ($moduleOptions[0]['templateZone'] != '') {
	$option = 3;
	$servers = '';
} else {
	$option = 1;
	$dnsservers = $cloudns->Configuration->getDnsServers();
	if (!empty($dnsservers)) {
		$servers = $dnsservers;
	} elseif ($moduleOptions[0]['availableServers'] != '') {
		$optionServers = explode("\n", $moduleOptions[0]['availableServers']);
		foreach ($optionServers as $server) {
			$servers[] = trim($server);
		}
	} else {
		$available = $cloudns->Servers->getMasterServers();
		foreach ($available as $server) {
			if (empty($server)) {
				continue;
			}
			$servers[] = trim($server['name']);
		}
	}
}

$response = $cloudns->Zones->addMaster($zone, $option, $servers, 'masterZoneType', $moduleOptions[0]['templateZone']);
if ($response['status'] == 'error') {
	logModuleCall('ClouDNS', 'create-zone-on-domain-registration-and-transfer', 'Register new zone @ ClouDNS', json_encode($response));
}
