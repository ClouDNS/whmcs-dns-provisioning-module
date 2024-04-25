<?php

class Cloudns_Slave {
	/**
	 * @var core 
	 */
	protected $core;

	public function __construct ($params) {
		$this->core = Cloudns_Core::inst($params);
	}
	
	/**
	 * Gets the master servers of a slave zone
	 * @param string $zone
	 * @return array
	 */
	public function getMasterServers($zone) {
		$request = array('domain-name'=>$zone);
		
		return $this->core->Api->call('dns/master-servers.json', $request);
	}
	
	/**
	 * 
	 * @param string $zone
	 * @param string $master
	 * @return array
	 * 
	 */
	public function deleteMasterServer ($zone, $master) {
		
		$request = array('domain-name'=>$zone, 'master-id'=>$master);
		
		return $this->core->Api->call('dns/delete-master-server.json', $request);
	}
	
	/**
	 * 
	 * @param string $zone
	 * @param string $server_ip
	 * @return array
	 */
	public function addMasterServer($zone, $server_ip) {
		$request = array('domain-name'=>$zone, 'master-ip'=>$server_ip);
		
		return $this->core->Api->call('dns/add-master-server.json', $request);
	}
}
