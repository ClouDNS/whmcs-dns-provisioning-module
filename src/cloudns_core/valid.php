<?php

/**
 * Data validating class with methods only
 * 
 */

class Cloudns_Valid {
	protected $core;
	protected $params;
	protected $_tld = array('valid'=>array(), 'invalid'=>array());
	protected $_labelLen = 64;
	protected $_domainLen = 255;
	
	public function __construct ($params) {
		$this->core = Cloudns_Core::inst($params);
		$this->params = $params;
	}
	
	public function ip ($ip, $ver=4) {
		if ($ver == 4 && filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)) {
			return true;
		}

		if ($ver == 6 && filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6)) {
			return true;
		}

		return false;
	}
	
	public function mail ($mail, $interface='web') {
		if (!is_string($mail)) {
			return false;
		}
		
		if (strlen($mail) > 255) {
			return false;
		}
		
		if ($interface == 'web') {
		
			$parts = explode('@', $mail);
			
			if (isset($parts[1]) && !$this->domain($parts[1])) {
				return false;
			}
		}
		
		if (empty($mail)) {
			return false;
		}
		
		if (preg_match("/\A([a-z0-9!#$%&'*+\/=?^_`{|}~-]+(\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*|\"([\040-\041\043-\133\135-\176]|\134[\040-\176])*\")@([0-9a-z]([0-9a-z-]*[0-9a-z])?(\.[0-9a-z]([0-9a-z-]*[0-9a-z])?)+|\[((0|[1-9][0-9]{0,2})(.(0|[1-9][0-9]{0,2})){3}|IPv6:([0-9a-f]{1,4}(:[0-9a-f]{1,4}){7}|([0-9a-f]{1,4}(:[0-9a-f]{1,4}){0,5})?::([0-9a-f]{1,4}(:[0-9a-f]{1,4}){0,5})?|[0-9a-f]{1,4}(:[0-9a-f]{1,4}){3}:(0|[1-9][0-9]{0,2})(.(0|[1-9][0-9]{0,2})){3}|([0-9a-f]{1,4}(:[0-9a-f]{1,4}){0,3})?::([0-9a-f]{1,4}(:[0-9a-f]{1,4}){0,3})?:(0|[1-9][0-9]{0,2})(.(0|[1-9][0-9]{0,2})){3}))\])\Z/i", $mail)) {
			return true;
		}
		if (preg_match("/^[a-zA-Z0-9._%-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,6}$/", $mail)) {
			return true;
		}
		return false;
	}
	
	public function host ($host, $require=true) {
		if ($require == false && empty($host)) {
			return array('status'=>1);
		}

		if (!is_string($host)) {
			return array('status'=>0, 'message'=>'This is not a domain name.');
		}
		
		if (!$this->hostLength($host)) {
			return array('status'=>0, 'message'=>'This is not a valid domain name.');
		}
		
		$parts = explode('.', $host);
		if (count($parts) < 2) {
			return array('status'=>0, 'message'=>'This is not a domain name.');
		}
		if (!$this->domain(strtolower($parts[count($parts)-2] .'.'. $parts[count($parts)-1]))) {
			return array('status'=>0, 'message'=>'This is not a valid domain name');
		}
		
		foreach ($parts as $part) {
			if (in_array($parts[0], array('_domainkey', '_dmark'))) {
				continue;
			}
			
			if (!preg_match("/^([a-z0-9-_]*)$/i", $part)) {
				return array('status'=>0, 'message'=>'This is not a domain name.');
			}

			$len = mb_strlen($part);
			if ($len == 0) {
				return array('status'=>0, 'message'=>'This is not a domain name.');
			}
			if ($part[0] == '.' || $part[$len-1] == '.') {
				return array('status'=>0, 'message'=>'This is not a domain name.');
			}
			if ($part[0] == '-' || $part[$len-1] == '-') {
				return array('status'=>0, 'message'=>'This is not a domain name.');
			}
		}

		return array('status'=>1);
	}
	
	public function domain ($domain) {
		if (!preg_match('/^[a-z0-9-._]+$/i', $domain)) {
			return false;
		}
		
		if (!$this->hostLength($domain)) {
			return false;
		}
		
		// check tld
		$part = explode('.', $domain);
		$tld = strtoupper($part[count($part)-1]);

		if (in_array($tld, $this->_tld['invalid'])) {
			return false;
		}

		// second-level domain
		if (preg_match("/^([a-z0-9-]*)\.([a-z]{2,4})$/i", $domain)) {
			return true;
		}
		// allow up to 10 levels
		if (count($part) >= 2 || count($part) <= 10) {
			return true;
		}

		return false;
	}
	
	public function hostLength ($host) {
		if (mb_strlen($host) > $this->_domainLen) {
			return false;
		}
		
		$parts = explode('.', $host);
		foreach ($parts as $part) {
			if (mb_strlen($part) > $this->_labelLen) {
				return false;
			}
		}
		
		return true;
	}
}
