<?php

/**
 * Description of dnssec
 *
 * @author angelo
 */

class Cloudns_Dnssec {
	
	protected $core;
	protected $params;
	
	public function __construct ($params) {
		$this->core = Cloudns_Core::inst($params);
		$this->params = $params;
	}
	
	public function activateDnssec($zone) {

		$request = array('domain-name' => $zone);
		$response = $this->core->Api->call('dns/activate-dnssec.json', $request);

		return $response;
	}

	public function deactivateDnssec($zone) {
		
		$request = array('domain-name' => $zone);
		$response = $this->core->Api->call('dns/deactivate-dnssec.json', $request);

		return $response;
	}

	public function getDSrecords($zone) {
		
		$request = array('domain-name' => $zone);
		$response = $this->core->Api->call('dns/get-dnssec-ds-records.json', $request);

		return $response;
	}
	
}