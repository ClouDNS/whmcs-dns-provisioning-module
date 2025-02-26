<?php

class Cloudns_Zones {
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
	 * @return array
	 */
	public function getZoneInfo ($zone) {
		if ($this->core->Controller->clearZoneInfoCache($zone)) {
			$request = array('domain-name'=>$zone);

			$response = $this->core->Api->call('dns/get-zone-info.json', $request);
			
			$_SESSION['zoneInfo'] = array_merge($response, array('time'=>time()));
			if (isset($response['status']) && $response['status'] == 'error') {
				return array();
			}
		} else {
			$response = $_SESSION['zoneInfo'];
		}
		return $response;
	}

	/**
	 * 
	 * @param string $zone
	 * @param int $option 1 or 0 for "with NS records" or "without any records"
	 * @param array $servers An array with the servers to be use for NS records if $option is 1
	 * @return type
	 */
	public function addMaster ($zone, $option, $servers, $zoneType = '', $templateZone = '') {
		$ns = array();
		
		if ($zoneType !== 'masterZoneType' && empty($servers) || $option == 2) {
			$ns = array('');
		} elseif ($option == 1 && !empty($servers)) {
			$ns = $servers;
		} 
		
		if ($option == 3) {
			if (isset($this->params['templateZone'])) {
				$templateZone = $this->params['templateZone'];
			}
		}
		
		$request = array('domain-name'=>$zone, 'zone-type'=>'master', 'ns'=>$ns);
		$response = $this->core->Api->call('dns/register.json', $request);
		if ($response['status'] == 'success') {
			$response['zone'] = $zone;
			if ($option == 3) {
				$request = array('domain-name'=>$zone, 'from-domain'=>$templateZone, 'delete-current-records'=>'1', 'follow-domain' => '1');
				$copy = $this->core->Api->call('dns/copy-records.json', $request);
				if ($copy['status'] == 'error') {
					logModuleCall('ClouDNS', 'copy-records-from-template-zone', 'Template zone: '.$templateZone, $copy['description']);
						}
					}
				}
		return $response;
	}
	
	/**
	 * 
	 * @param string $zone
	 * @param string $master_ip
	 * @return array
	 */
	public function addSlave($zone, $master_ip) {
		$request = array('domain-name'=>$zone, 'zone-type'=>'slave', 'master-ip'=>$master_ip);
		
		return $this->core->Api->call('dns/register.json', $request);
	}
	
	/**
	 * 
	 * @param string $zone
	 * @return array
	 */
	public function getUpdateStatus ($zone) {
		$request = array('domain-name'=>$zone);
		
		return $this->core->Api->call('dns/is-updated.json', $request);
	}
	
	/**
	 * 
	 * @param string $zone
	 * @return array
	 */
	public function updateZone ($zone) {
		$request = array('domain-name'=>$zone);
		
		return $this->core->Api->call('dns/update-zone.json', $request);
	}
	
	/**
	 * 
	 * @param string $zone
	 * @return array
	 */
	public function delete ($zone) {
		$request = array('domain-name'=>$zone);
		
		return $this->core->Api->call('dns/delete.json', $request);
	}
	
	/**
	 * Make zone inactive (after suspend of service)
	 * @param string $zone The name of the zone
	 * @return array
	 */
	public function suspend ($zone) {
		$request = array('domain-name'=>$zone, 'status'=>0);
		
		return $this->core->Api->call('dns/change-status.json', $request);
	}
	
	/**
	 * Make zone active again (after unsuspend of service)
	 * @param string $zone The name of the zone
	 * @return array
	 */
	public function unSuspend ($zone) {
		$request = array('domain-name'=>$zone, 'status'=>1);
		
		return $this->core->Api->call('dns/change-status.json', $request);
	}
}

