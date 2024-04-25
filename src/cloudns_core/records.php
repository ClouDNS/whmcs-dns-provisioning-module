<?php

Class Cloudns_Records {
	
	const STATUS_INACTIVE = 0;
	const STATUS_ACTIVE = 1;
	
	public function __construct ($params) {
		$this->core = Cloudns_Core::inst($params);
	}
	
	/**
	 * 
	 * @param string $zone
	 * @return array
	 */
	public function getRecords ($zone) {
		$request = array('domain-name'=>$zone);
		
		$response = $this->core->Api->call('dns/records.json', $request);
		
		if (isset($response['status']) && $response['status'] == 0) {
			return array();
		}
		
		return $response;
	}
	
	/**
	 * 
	 * @param string $zone
	 * @param string $type
	 * @param array $settings
	 * @param staus $status 1 for active, currently deactivation is not supported
	 * @return array
	 */
	public function recordAdd ($zone, $type, $settings, $status=1) {
		$request = array('domain-name'=>$zone, 'record-type'=>$type);
		foreach ($settings as $key=>$value) {
			$request[$key] = $value;
		}
		$response = $this->core->Api->call('dns/add-record.json', $request);
		
		return $response;
	}
	
	
	/**
	 * 
	 * @param string $zone
	 * @param int $id ID of the record to be edited
	 * @param array $settings
	 * @param staus $status 1 for active, currently deactivation is not supported
	 * @return array
	 */
	public function recordEdit ($zone, $id, $settings, $status=1) {
		$request = array('domain-name'=>$zone, 'record-id'=>$id);
		foreach ($settings as $key=>$value) {
			$request[$key] = $value;
		}
		
		return $this->core->Api->call('dns/mod-record.json', $request);
	}
	
	/**
	 * 
	 * @param string $zone
	 * @param int $record_id
	 * @return array
	 */
	public function delete ($zone, $record_id) {
		$request = array('domain-name'=>$zone, 'record-id'=>$record_id);
		
		return $this->core->Api->call('dns/delete-record.json', $request);
	}
	
	/**
	 * 
	 * @param string $zone
	 * @param string $records
	 * @param string $format
	 * @return array
	 */
	public function import ($zone, $records, $format, $delete=0) {
		$request = array('domain-name'=>$zone, 'content'=>$records, 'format'=>$format, 'delete-existing-records'=>$delete);
		$response = $this->core->Api->call('dns/records-import.json', $request);

		return $response;
	}
	
	public function getAvailableTTL () {
		$request = array();
		$response = $this->core->Api->call('dns/get-available-ttl.json', $request);

		return $response;
	}
	
	public function getAvailableRecords ($type) {
		$request = array('zone-type'=>$type);
		$response = $this->core->Api->call('dns/get-available-record-types.json', $request);

		return $response;
	}
}

