<?php

class Cloudns_Core {
	/**
	 * Objects manager to use a single instance in all scripts
	 * 
	 * @Author	ClouDNS.net <support@cloudns.net>
	 * @Copyright	ClouDNS
	 * @Package	core
	 *
	 * @param Actions $Actions
	 * @param Api $Api
	 * @param Configuration Configuration
	 * @param Controller $Controller
	 * @param Database $Database 
	 * @param Helper $Helper
	 * @param Records $Records
	 * @param Servers $Servers
	 * @param Slave $Slave
	 * @param SOA $SOA
	 * @param Statistics $Statistics
	 * @param Zones $Zones 
	 * 
	 */
	
	
	/**
	 * @var Cloudns_Core
	 */
	private static $instance;
	
	/**
	 * Object instances
	 * @var array
	 */
	private $instances;
	
	protected $params;
	
	public function __construct($params) {
		if (!isset($params['whmcsVersion'])) {
			$params['whmcsVersion'] = '5.undefined';
		}
		$version = explode('.', $params['whmcsVersion']);
		$this->params = array(
			'version' => $params['whmcsVersion'],		// full version
			'serviceid'=>$params['serviceid'],
			'userid'=>(isset($params['clientsdetails']['userid']) ? $params['clientsdetails']['userid'] : $params['userid']), // in v < 6 the client id is in the clientdetails
			'shortVersion'=>$version[0],			// short version (6, 7...)
			'theme'=>$params['clientareatemplate'],		// the theme
			'zonesLimit'=>$params['configoption1'],		// number of zones
			'availableServers'=>$params['configoption2'],	// list with server names
			'registeredDomains'=>$params['configoption3'],	// 'on' or empty, if 'on' number of zones is ignored
			'templateZone'=>$params['configoption4'],	// domain name or empty, if not empty new zones will be added with its records
			'failoverChecks'=>$params['configoption5'],	// number of Failover chekcs
			'recordsLimit' => $params['configoption6'],	// limit of records
			'moduleVersion'=>'1.8',
			'productid'=>$params['pid'],
		);
	}
	
	/**
	 * @return Core 
	 */
	public static function inst ($params=array()) {
		if (is_null(self::$instance)) {
			self::$instance = new Cloudns_Core($params);
		}
		return self::$instance;
	}
	
	public function __get ($name) {
		$name = strtolower($name);
		if (!isset($this->instances[$name])) {
			if (!class_exists($name)) {
				$file = dirname(__FILE__) . "/" . $name.'.php';
				if (file_exists($file)) {
					include_once $file;
				} else {
					throw new Exception("The module file ".$file." does not exists");
				}
			}
			$classname = "Cloudns_{$name}";
			$this->instances[$name] = new $classname($this->params);
		}
		
		return $this->instances[$name];
	}
}

