<?php

class Cloudns_Api {
	
	protected $params;
	protected $core;
	
	public function __construct($params) {
		$this->core = Cloudns_Core::inst($params);
		$this->params = $params;
	}
	
	/**
	 * 
	 * @param string $url The method you need to call
	 * @param mixed $data Array or string, depending on what keys we need
	 * @return array
	 */
	public function call ($url, $data) {
		
		$auth_id = $this->core->Configuration->getApiUser();
		$auth_password = $this->core->Configuration->getApiPassword();
		$authData = array('auth-id' => $auth_id , 'auth-password' => $auth_password);
		
		$request = http_build_query(array_merge($authData, $data));
		
		$url = 'https://apidev.cloudns.net/' . $url;
		
		$init = curl_init();
		curl_setopt($init, CURLOPT_SSL_VERIFYPEER, FALSE);
		curl_setopt($init, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($init, CURLOPT_URL, $url);
		curl_setopt($init, CURLOPT_POST, true);
		curl_setopt($init, CURLOPT_POSTFIELDS, $request);
		curl_setopt($init, CURLOPT_USERAGENT, 'cloudns-whmcs/v'.$this->params['version'].'-'.$this->params['moduleVersion'].' - page: '.$this->params['page']);

		$content = curl_exec($init);
		
		curl_close($init);
		
		$response = json_decode($content, true);
		
		if (isset($response['status'])) {
			if ($response['status'] == 'Failed') {
				$response['status'] = 'error';
				$response['description'] = $response['statusDescription'];
				unset($response['statusDescription']);
			} elseif ($response['status'] == 'Success') {
				$response['status'] = 'success';
				$response['description'] = $response['statusDescription'];
				unset($response['statusDescription']);
			}
		}
		
		return $response;
	}
}