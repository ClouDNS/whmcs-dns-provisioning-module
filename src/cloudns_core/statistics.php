<?php

class Cloudns_Statistics {
	
	/**
	 * @var core 
	 */
	protected $core;

	
	public function __construct ($params) {
		$this->core = Cloudns_Core::inst($params);
	}
	
	/**
	 * Calls a method depending on the stats you want
	 * @param string $zone
	 * @param int $date
	 * @return array
	 */
	public function getZoneStats ($zone, $date) {
		$stats = array();
		
		if (strlen($date) == 8) {
			$year = substr($date, 0, 4);
			$month = substr($date, 4, 2);
			$day = substr($date, -2);
			$stats = $this->getHourlyStats($zone, $year, $month, $day);
		} elseif (strlen($date) == 6) {
			$year = substr($date, 0, 4);
			$month = substr($date, -2);
			$stats = $this->getDailyStats($zone, $year, $month);
		} elseif (strlen($date) == 4) {
			$stats = $this->getMonthlyStats($zone, $date);
		} elseif ($date == 'last-30-days') {
			$stats = $this->get30DaysStats($zone);
		} else {
			$stats = $this->getYearlyStats($zone);
			if (empty($stats)) {
				$stats = array(date('Y')=>0);
			}
		}
		
		return $stats;
	}
	
	/**
	 * Stats for the last 30 days
	 * @param string $zone
	 * @return array
	 */
	public function get30DaysStats ($zone) {
		$request = array('domain-name'=>$zone);
		
		$response = $this->core->Api->call('dns/statistics-last-30-days.json', $request);
		
		if (isset($response['status']) && $response['status'] == 0) {
			return array();
		}
		
		return $response;
	}
	
	/**
	 * Yearly stats
	 * @param string $zone
	 * @return array
	 */
	public function getYearlyStats ($zone) {
		$request = array('domain-name'=>$zone);
		
		$response = $this->core->Api->call('dns/statistics-yearly.json', $request);
		
		if (isset($response['status']) && $response['status'] == 0) {
			return array();
		}
		
		return $response;
	}
	
	/**
	 * Monthly stats
	 * @param string $zone
	 * @param int $year
	 * @return array
	 */
	public function getMonthlyStats ($zone, $year) {
		$request = array('domain-name'=>$zone, 'year'=>$year);
		
		$response = $this->core->Api->call('dns/statistics-monthly.json', $request);
		
		if (isset($response['status']) && $response['status'] == 0) {
			return array();
		}
		
		return $response;
	}
	
	/**
	 * Daily stats
	 * @param string $zone
	 * @param int $year
	 * @param int $month
	 * @return array
	 */
	public function getDailyStats ($zone, $year, $month) {
		$request = array('domain-name'=>$zone, 'year'=>$year, 'month'=>$month);
		
		$response = $this->core->Api->call('dns/statistics-daily.json', $request);
		
		if (isset($response['status']) && $response['status'] == 0) {
			return array();
		}
		
		return $response;
	}
	
	/**
	 * Hourly stats
	 * @param string $zone
	 * @param int $year
	 * @param int $month
	 * @param int $day
	 * @return array
	 */
	public function getHourlyStats ($zone, $year, $month, $day) {
		$request = array('domain-name'=>$zone, 'year'=>$year, 'month'=>$month, 'day'=>$day);
		
		$response = $this->core->Api->call('dns/statistics-hourly.json', $request);
		
		if (isset($response['status']) && $response['status'] == 0) {
			return array();
		}
		
		return $response;
	}
}
