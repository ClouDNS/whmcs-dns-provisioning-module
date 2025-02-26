<?php

use Illuminate\Database\Capsule\Manager as Capsule;

class Cloudns_Controller {
	
	/**
	 * @var core 
	 */
	protected $core;
	protected $params;
	
	public function __construct ($params) {
		$this->core = Cloudns_Core::inst($params);
		$this->params = $params;
	}
	
	/**
	 * 
	 * @param string $zone
	 * @param string $zoneType
	 * @param int $option 1 or 0, with NS records or without records
	 * @param array $ns The servers to be used for NS records
	 * @param string $master_ip
	 * @param array $zoneExists Status and error/message/zoneInfo
	 * @return array
	 */
	public function addNewZone ($zone, $zoneType, $option, $ns, $master_ip, $zoneExists) {
		
		try {
			if (!empty($zoneExists['zoneInfo']['name'])) {
				return array('status'=>'error','description'=>'The zone was already added by you or another customer!');
			}
			$usersZones = $this->countUsersZones($this->params['serviceid']);
			if ($usersZones >= $this->params['zonesLimit']) {
				return array('status'=>'error','description'=>'You reached your zones limit of '.$this->params['zonesLimit'].', having '.$usersZones.' zones and can\'t add new zones.');
			}
			
			if ($option == 3 && isset($this->params['templateZone'])) {
				$recordsCount = $this->core->Records->getRecordsCount($this->params['templateZone']);
			} elseif ($option == 1) {
				$recordsCount = count($ns);
				if ($recordsCount == 0) {
					$servers = $this->core->Servers->getAvailableServers();
					$recordsCount = count($servers);
				}
			} else {
				$recordsCount = 0;
			}
			
			if ($this->params['recordsLimit'] != '' && $this->params['recordsLimit'] != -1 && $recordsCount > $this->params['recordsLimit']) {
				return array('status' => 'error', 'description' => 'You have reached your limit of ' . $this->params['recordsLimit'] . ' records per zone.');
			}

			if ($zoneType == 'masterZoneType' || $zoneType == 'masterReverseZoneType') {
				$response = $this->core->Zones->addMaster($zone, $option, $ns, $zoneType);
			} else {
				$response = $this->core->Zones->addSlave($zone, $master_ip);
			}
			
			if ($response['status'] == 'success') {				
				$tbl_params = array(
					'serviceid' => $this->params['serviceid'],
					'name' => $zone,
				);
				if (!$this->core->Database->insert('mod_cloudns_zones', $tbl_params)) {
					return array('status'=>'error','description'=>'The zone was not added!');
				}
				
				return array('status'=>'success', 'zone'=>$zone);
			} else {
				return $response;
			}
		} catch (\Exception $e) {
			return array('status'=>'error','description'=>$e->getMessage());
		}
	}
	
	/**
	 * If for some reason a zone is added to WHMCS, but not to ClouDNS this method will add it to ClouDNS.
	 * It can be used for faster zones adding
	 * @param type $zone
	 * @return array
	 */
	public function addNewExistingZone ($zone, $option) {
		try {
			$ns = array();
			$servers = $this->core->Servers->getAvailableServers();
			foreach ($servers as $server) {
				$ns[] = $server;
			}
			$response = $this->core->Zones->addMaster($zone, $option, $ns);
			return $response;
		} catch (\Exception $e) {
			return array('status'=>'error','description'=>$e->getMessage());
		}
	}

	/**
	 * Checks if the zone exists in ClouDNS and here
	 * @param string $zone
	 * @return array
	 */
	public function zoneExists ($zone) {
		$whmcsZone = $this->getZoneByName($zone);
		$cloudnsZone = $this->core->Zones->getZoneInfo($zone);
		if (empty($cloudnsZone)) {
			return array('status'=>'error', 'description'=>'There is no such DNS zone with the DNS servers', 'zoneInfo'=>array('name'=>''));
		} elseif ($this->params['registeredDomains'] != 'on' && empty($whmcsZone)) {
			return array('status'=>'info', 'description'=>'There is no such DNS zone in the system', 'zoneInfo'=>array('name'=>''));
		} elseif ($cloudnsZone['status'] == 0) {
			return array('status'=>'paused', 'description'=>'Unfortunately, this zone is currently not accessible. Please contact our support team.', 'zoneInfo'=>$cloudnsZone);
		}
		
		return array('status' => 'success', 'zoneInfo'=>$cloudnsZone);
	}
	
	/**
	 * Checks if a zone is already added in ClouDNS
	 * @param string $zone
	 * @return boolean
	 */
	public function checkForFreeZone ($zone) {
		$response = $this->core->Zones->getZoneInfo($zone);
		// empty $response means that there is no such zone 
		// e.g. it's free and the check can continue
		if (empty($response)) {
			return false;
		} else {
			$tbl_params = array(
				'name' => $zone,
			);
			$zone = $this->core->Database->select('mod_cloudns_zones', $tbl_params);
			if (!empty($zone)) {
				return false;
			}
		}
		return true;
	}
	
	/**
	 * Gets the zones added in the module table here to be displayed in the zones list
	 * @return array
	 */
	public function getZones() {
		try {
			
			$tbl_params = array(
				'serviceid' => $this->params['serviceid']
			);
			$order = 'name';
			$zones = $this->core->Database->select('mod_cloudns_zones', $tbl_params, $order);
			foreach ($zones as &$zone) {
				$zone['ascii'] = $this->core->Helper->getUnicodeName($zone['name']);
			}
			if (empty($zones)) {
				return array('status'=>'error','description'=>'You don\'t have any DNS zones yet.');
			}
			
			return $zones;

		} catch (\Exception $e) {
			return array('status'=>'error','description'=>$e->getMessage());
		}
	}
	
	/**
	 * Count the zones for this service
	 * @return int 
	 */
	public function countUsersZones () {
		try {
			
			$tbl_params = array(
				'serviceid' => $this->params['serviceid']
			);
			
			$count = $this->core->Database->count('mod_cloudns_zones', $tbl_params);
			
			return $count;

		} catch (\Exception $e) {
			return array('status'=>'error','description'=>$e->getMessage());
		}
	}
	
	/**
	 * Checks if there is a zone with that name. It's used above to check if the zone exists in WHMCS
	 * @param string $zone
	 * @return boolean
	 */
	public function getZoneByName ($zone) {
		return $this->core->Database->select('mod_cloudns_zones', array('name'=>$zone));
		
	}
	
	/**
	 * Gets the records of a zone, all of them or only by selected type
	 * @param string $zone
	 * @param string $type
	 * @return array
	 */
	public function getRecords ($zone, $type) {
		if ($type == 'all') {
			return $this->core->Records->getRecords($zone);
		}
		
		$recordsList = $this->core->Records->getRecords($zone);
		
		$records = array();
		foreach ($recordsList as $record) {
			if ($type == $record['type']) {
				$records[] = $record;
			}
		}
		
		return $records;
	}
	
	/**
	 * Gets record by ID for the Edit record page
	 * @param string $zone
	 * @param int $record_id
	 * @return array
	 */
	public function getRecordById ($zone, $record_id) {
		$recordsList = $this->core->Records->getRecords($zone);
		
		if (!isset($recordsList[$record_id])) {
			return array();
		}
		return $recordsList[$record_id];
	}
	
	/**
	 * Gets the record types for this zone type (forward or reverse)
	 * @param string $zone_type
	 * @return array
	 */
	public function getRecordTypes($zone_type) {
		if ($zone_type == 'ipv4' || $zone_type == 'ipv6') {
			$zone_type = 'reverse';
		}
		if ($this->core->Controller->clearRecordTypesCache($zone_type)) {
			$types = $this->core->Records->getAvailableRecords($zone_type);
			$_SESSION['recordTypes'] = array(
				$zone_type => array(
					'types' => $types,
					'time' => time()
				),
				
			);
		} else {
			$types = $_SESSION['recordTypes'][$zone_type]['types'];
		}
		return $types;
	}
	
	/**
	 * Gets the SOA Primary NS, which is the first server in the list
	 * @return string
	 */
	public function getSOAPrimaryNS () {
		$servers = $this->core->Servers->getAvailableServers();
		
		return $servers[0];
	}
	
	/**
	 * 
	 * @param string $zone
	 * @return array
	 */
	public function deleteZone ($zone) {
		try {
			$tbl_params = array(
				'serviceid' => $this->params['serviceid'],
				'name' => $zone
			);
			/* we are deleting the zone from the module table */
			$zones = $this->core->Database->delete('mod_cloudns_zones', $tbl_params);

			if (empty($zones)) {
				return array('status'=>'error','description'=>'There is no such zone in your account');
			}

		} catch (\Exception $e) {
			return array('status'=>'error','description'=>$e->getMessage());
		}
		
		/* deleting the zone from WHMCS clears the cache if it's for this zone */
		if ($_SESSION['zoneInfo']['name'] = $zone) {
			$_SESSION['zoneInfo'] = array();
		}
		
		/* if everything is okay we can delete the zone from ClouDNS */
		return $this->core->Zones->delete($zone);
	}
	
	public function getAvailableTTL () {
		if ($this->core->Controller->clearTTLCache()) {
			$ttlValues = $this->core->Records->getAvailableTTL();
			$ttl = array();
			foreach ($ttlValues as $value) {
				if ($value < 60) {
					$ttl[$value . ' seconds'] = $value;
				} elseif ($value == 60) {
					$ttl['1 minute'] = $value;
				} elseif ($value < 3600) {
					$ttl[($value / 60) . ' minutes'] = $value;
				} elseif ($value == 3600) {
					$ttl['1 hour'] = $value;
				} elseif ($value < 86400) {
					$ttl[($value / 3600) . ' hours'] = $value;
				} elseif ($value == 86400) {
					$ttl['1 day'] = $value;
				} elseif ($value < 604800) {
					$ttl[($value / 86400) . ' days'] = $value;
				} elseif ($value == 604800) {
					$ttl['1 week'] = $value;
				} elseif ($value < 2592000) {
					$ttl[($value / 604800) . ' weeks'] = $value;
				} elseif ($value == 2592000) {
					$ttl['1 month'] = $value;
				}
			}
			$_SESSION['ttl'] = $ttl;
		} else {
			$ttl = $_SESSION['ttl']['values'];
		}


		return $ttl;
	}

	public function getRegisteredDomains () {
		// connect to db and get registered domains of user
		try {
			$tbl_params = array(
				'userid' => $this->params['userid'],
				'status' => 'Active',
			);
			
			$domains = $this->core->Database->select('tbldomains', $tbl_params, 'id');

			return $domains;

		} catch (\Exception $e) {
			return array('status'=>'error','description'=>$e->getMessage());
		}
	}
	
	public function getRegisteredDomainByName ($domain) {
		// connect to db and get registered domains of user
		try {
			$tbl_params = array(
				'userid' => $this->params['userid'],
				'status' => 'Active',
				'domain' => $domain
			);
			
			$domains = $this->core->Database->select('tbldomains', $tbl_params, 'id');

			return $domains;

		} catch (\Exception $e) {
			return array('status'=>'error','description'=>$e->getMessage());
		}
	}
	
	/**
	 * Check if the cached info needs to be updated
	 * @param string $zone The name of the zone
	 * @return boolean
	 */
	public function clearZoneInfoCache ($zone) {
		if (
			!isset($_SESSION['zoneInfo']) || // no info
			$_SESSION['zoneInfo']['name'] != $zone || // the info is for another zone
			($_SESSION['zoneInfo']['time']+1200) < time()) { // the info was cached 20 minutes ago
			return true;
		}
		
		return false;
	}
	
	/**
	 * Check if the cached record types need to be updated
	 * @param string $type The zone type - domain or reverse
	 * @return boolean
	 */
	public function clearRecordTypesCache ($type = 'domain') {
		if (
			!isset($_SESSION['recordTypes']) || // no record types info
			($_SESSION['recordTypes'][$type]['time']+1200) < time() || // the info was cached 20 minutes ago
			!isset($_SESSION['recordTypes'][$type]) // the types are not for this zone type
		) { 
			return true;
		}
		
		return false;
	}
	
	/**
	 * Check if the cached TTL values need to be updated
	 * @return boolean
	 */
	public function clearTTLCache () {
		if (
			!isset($_SESSION['ttl']) || // no TTL info
			// the TTL was last updated 2 hours ago. 
			// This value can be higher, since the TTL is equal for
			// all records and new values are rearly added
			($_SESSION['ttl']['time']+7200) < time() 
		) {
			return true;
		}
		
		return false;
	}
	
	public function defaultZone () {
		if (!empty($this->params['templateZone'])) {
			return true;
		}
		
		return false;
	}
	
	public function sumFailoverChecks() {
		$productid = $this->params['productid'];
		$freeProductId = $this->core->Configuration->getFreeProductId();
		try {
			if ($productid != $freeProductId) {
				$tbl_params = array(
					'serviceid' => $this->params['serviceid']
				);
				$sum = $this->core->Database->sum('mod_cloudns_zones', 'fo_checks', $tbl_params);
			} else {
				$tbl_params = array(
					'userid'=> $this->params['userid']
				);
				$sum = $this->core->Database->sum('tbldomains', 'fo_checks', $tbl_params);
			}

			return $sum;
		} catch (\Exception $e) {
			return array('status' => 'error', 'description' => $e->getMessage());
		}
	}

	public function incrementFailoverChecks($zone) {

		$productid = $this->params['productid'];
		$freeProductId = $this->core->Configuration->getFreeProductId();
		try {
			if ($productid != $freeProductId) {
				$tbl_params = array(
					'name' => $zone
				);
				$this->core->Database->increment('mod_cloudns_zones', 'fo_checks', $tbl_params);
			} else {
				$tbl_params = array(
					'domain' => $zone
				);
				$this->core->Database->increment('tbldomains', 'fo_checks', $tbl_params);
			}

		} catch (\Exception $e) {
			return array('status' => 'error', 'description' => $e->getMessage());
		}
	}
	
	public function decrementFailoverChecks($zone) {

		$productid = $this->params['productid'];
		$freeProductId = $this->core->Configuration->getFreeProductId();
		try {
			if ($productid != $freeProductId) {
				$tbl_params = array(
					'name' => $zone
				);
				$this->core->Database->decrement('mod_cloudns_zones', 'fo_checks', $tbl_params);
			} else {
				$tbl_params = array(
					'domain' => $zone
				);
				$this->core->Database->decrement('tbldomains', 'fo_checks', $tbl_params);
			}
		} catch (\Exception $e) {
			return array('status' => 'error', 'description' => $e->getMessage());
		}
	}
	
	public function deleteRecord ($zone, $record_id) {
		
		$record = $this->getRecordById($zone, $record_id);
		$checkFailover = $this->core->Failover->failoverSettings($zone, $record_id);
		
		if ($record['type'] == 'A' || $record['type'] == 'AAAA') {
			if (isset($checkFailover['status']) && $checkFailover['status'] != 'error') {
				$this->core->Failover->failoverDeactivate($zone, $record_id);
			}
		}
		
		return $this->core->Records->delete($zone, $record_id);
	}
	
	public function getRecordsCount ($zone) {
		try {
			$response = $this->core->Records->getRecordsCount($zone);
			return $response;
		} catch (\Exception $e) {
			return array('status'=>'error','description'=>$e->getMessage());
		}
	}
}
