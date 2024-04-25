<?php

class Cloudns_Servers {
	
	/**
	 * @var core 
	 */
	protected $core;
	protected $params;
	protected $servers;
		
	public function __construct ($params) {
		$this->core = Cloudns_Core::inst($params);
		$this->params = $params;
	}
	
	/**
	 * Gets the servers you have access to
	 * @return array
	 */
	public function getAvailableServers () {
		$servers = $this->core->Configuration->getDnsServers();
		if (!empty($servers)) {
			return $servers;
		}
		
		if (!empty($this->params['availableServers'])) {
		
			$servers = array();
			$serversList = explode("\n", $this->params['availableServers']);
			foreach ($serversList as $name) {
				$name = trim($name);
				if (empty($name)) {
					continue;
				}

				$servers[] = $name;
			}

			return $servers;
		}
		
		$available = $this->core->Servers->getMasterServers();
		
		foreach ($available as $server) {
			if (empty($server)) {
				continue;
			}
			$servers[] = trim($server['name']);
		}
			
		return $servers;
	}
	
	/**
	 * Gets the available servers from the API
	 * @return type
	 */
	public function getMasterServers ($request = array()) {

		return $this->core->Api->call('dns/available-name-servers.json', $request);
	}
}
