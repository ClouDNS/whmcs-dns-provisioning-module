<?php

class Cloudns_Configuration {
	
	// api user login details
	public static $_apiAuthId =  0000; // your ClouDNS API ID
	public static $_apiAuthPassword = 'XXXXXX'; // your ClouDNS API password

	// servers to be used for all products different than the default ClouDNS servers
	public static $_DnsServers = array(
		/* uncomment the below block if you have server names other 
		 * than the default ClouDNS servers and want your customers 
		 * to use them instead
		 */
		
		/*
		'ns1.your-domain.com',
		'ns2.your-domain.com',
		 */
	);
	// whmcs admin account username
	// depending on the WHMCS version it can either be
	// a username or an email address
	// you can check it in database table tbladmins
	public static $_admin = 'admin@example.com';
	
	/**
	 * id of the product created for Free DNS management
	 * of registered domains. 
	 * It will be automatically activated 1 
	 * time after a successful domain registration.
	 */
	public static $_pid = 0;
	
	/*
	 * Do Not Edit Anything Below This Line
	 */
	
	public function getDnsServers () {
		return self::$_DnsServers;
	}
	
	public function getApiUser () {
		return self::$_apiAuthId;
	}
	
	public function getApiPassword () {
		return self::$_apiAuthPassword;
	}
	
	public function getAdminUser () {
		return self::$_admin;
	}
	
	public function getFreeProductId () {
		return self::$_pid;
	}
	
}
