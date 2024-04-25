<?php

class Cloudns_SOA {
	
	protected $core;
	
	public function __construct ($params) {
		$this->core = Cloudns_Core::inst($params);
	}
	
	/**
	 * 
	 * @param string $zone
	 * @return array
	 */
	public function getSOA ($zone) {
		$request = array('domain-name'=>$zone);
		
		$response = $this->core->Api->call('dns/soa-details.json', $request);
		
		if (isset($response['status']) && $response['status'] == 0) {
			return array();
		}
		
		return $response;
	}
	
	/**
	 * 
	 * @param string $zone
	 * @param string $primary_ns
	 * @param string $mail
	 * @param int $refresh
	 * @param int $retry
	 * @param int $expire
	 * @param int $minimum
	 * @return array
	 */
	public function editSOA($zone, $primary_ns, $mail, $refresh, $retry, $expire, $minimum) {
		$request = array('domain-name'=>$zone, 'primary-ns'=>$primary_ns, 'admin-mail'=>$mail, 'refresh'=>$refresh, 'retry'=>$retry, 'expire'=>$expire, 'default-ttl'=>$minimum);
		
		return $this->core->Api->call('dns/modify-soa.json', $request);
	}
	
	/**
	 * 
	 * @param string $zone
	 * @return array
	 */
	public function resetSOA($zone) {		
		$request = array('domain-name'=>$zone);
		
		return $this->core->Api->call('dns/reset-soa.json', $request);
	}
}

