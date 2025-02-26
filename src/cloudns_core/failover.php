<?php

/**
 * Description of failover
 *
 * @author angelo
 */
class Cloudns_Failover {
	
	protected $core;
	protected $params;
	
	public function __construct ($params) {
		$this->core = Cloudns_Core::inst($params);
		$this->params = $params;
	}
	
	const CHECKER_STATUS_INACTIVE = -1;
	const CHECKER_STATUS_OFFLINE = 0;
	const CHECKER_STATUS_ACTIVE = 1;

	const CHECK_TYPE_PING_15 = 1;
	const CHECK_TYPE_PING_25 = 2;
	const CHECK_TYPE_PING_50 = 3;
	const CHECK_TYPE_HTTP = 4;
	const CHECK_TYPE_HTTPS = 5;
	const CHECK_TYPE_HTTP_CUSTOM = 6;
	const CHECK_TYPE_HTTPS_CUSTOM = 7;
	const CHECK_TYPE_TCP_SOCKET = 8;
	const CHECK_TYPE_UDP_SOCKET = 9;
	const CHECK_TYPE_DNS = 10;
	const CHECK_TYPE_PING = 17;
	const CHECK_TYPE_WEB = 18;

	const CHECK_STATUS_UNKNOWN = -1;
	const CHECK_STATUS_DOWN = 0;
	const CHECK_STATUS_UP = 1;

	const DOWN_EVENT_HANDLER_MONITORING = 0;
	const DOWN_EVENT_HANDLER_PASSIVE = 1;
	const DOWN_EVENT_HANDLER_ACTIVE = 2;

	const BACK_UP_EVENT_HANDLER_MONITORING = 0;
	const BACK_UP_EVENT_HANDLER_AUTOMATIC = 1;
	const BACK_UP_EVENT_HANDLER_MANUAL = 2;

	const ACTION_RECORD_DEACTIVATED = 1;
	const ACTION_RECORD_ACTIVATED = 2;
	const ACTION_RECORD_REPLACED = 3;
	
	const NOTIFICATION_TYPE_EMAIL = 'mail';
	const NOTIFICATION_TYPE_WEBHOOK_UP = 'webhook-up';
	const NOTIFICATION_TYPE_WEBHOOK_DOWN = 'webhook-down';
	
	const PING_THRESHOLD_15 = 15;
	const PING_THRESHOLD_25 = 25;
	const PING_THRESHOLD_50 = 50;
	const PING_THRESHOLD_100 = 100;	
	
	const MONITORING_PING_THRESHOLD = array(
		Cloudns_Failover::PING_THRESHOLD_15,
		Cloudns_Failover::PING_THRESHOLD_25,
		Cloudns_Failover::PING_THRESHOLD_50,
		Cloudns_Failover::PING_THRESHOLD_100,
	);
	
	private $_checkTypes = array(
		17=>'Ping',
		18=>'Web',
		8=>'TCP',
		9=>'UDP',
		10=>'DNS'
	);
	
	public function getCheckTypes () {
		
		return $this->_checkTypes;
	}
	
	public function failoverSettings ($zone, $record_id) {
		
		$request = array('domain-name'=>$zone, 'record-id'=>$record_id);
		
		$response = $this->core->Api->call('dns/failover-settings.json', $request);
		
		return $response;
	}
	
	public function failoverActivate($zone, $record_id, $settings) {

		$usersFOchecks = $this->core->Controller->sumFailoverChecks();
		if ($usersFOchecks >= $this->params['failoverChecks']) {
			$response = array('status' => 'error', 'description' => 'You reached your Failover checks limit of ' . $this->params['failoverChecks'] . '.');
		} else {

			$request = array('domain-name' => $zone, 'record-id' => $record_id);

			foreach ($settings as $key => $value) {
				$request[$key] = $value;
			}

			$response = $this->core->Api->call('dns/failover-activate.json', $request);
		}
		
		if ($response['status'] == "success") {
			$this->core->Controller->incrementFailoverChecks($zone);
		}
		
		return $response;
	}

	public function failoverDeactivate($zone, $record_id) {
		
		$request = array('domain-name'=>$zone, 'record-id'=>$record_id);
		$response = $this->core->Api->call('dns/failover-deactivate.json', $request);
		
		if ($response['status'] == "success") {
			$this->core->Controller->decrementFailoverChecks($zone);
		}
		
		return $response;
	}
	
	public function failoverEdit ($zone, $record_id, $settings) {
		
		$request = array('domain-name'=>$zone, 'record-id'=>$record_id);
		
		foreach ($settings as $key=>$value) {
			$request[$key] = $value;
		}
		
		$response = $this->core->Api->call('dns/failover-modify.json', $request);
		
		return $response;
		
	}
	
	public function getCheckHistoryPages($zone, $record_id, $rows_per_page) {
		
		$request = array('domain-name'=>$zone, 'record-id'=>$record_id, 'rows-per-page'=>$rows_per_page);
				
		return $this->core->Api->call('dns/failover-check-history-pages.json', $request);
	}
	
	public function getCheckHistory($zone, $record_id, $page, $rows_per_page) {
		
		$request = array('domain-name'=>$zone, 'record-id'=>$record_id, 'page'=>$page, 'rows-per-page'=>$rows_per_page);
		
		return $this->core->Api->call('dns/failover-check-history.json', $request);
	}
	
	public function getActionHistoryPages($zone, $record_id, $rows_per_page) {
		
		$request = array('domain-name'=>$zone, 'record-id'=>$record_id, 'rows-per-page'=>$rows_per_page);
		
		return $this->core->Api->call('dns/failover-action-history-pages.json', $request);
		
	}
	
	public function getActionHistory($zone, $record_id, $page, $rows_per_page) {
		
		$request = array('domain-name'=>$zone, 'record-id'=>$record_id, 'page'=>$page, 'rows-per-page'=>$rows_per_page);
		
		return $this->core->Api->call('dns/failover-action-history.json', $request);
	}
	
	public function createNotification($zone, $record_id, $type, $value) {

		$request = array('domain-name' => $zone, 'record-id' => $record_id, 'type' => $type, 'value' => $value);

		return $this->core->Api->call('dns/create-failover-notification.json', $request);
	}
	
	public function deleteNotification($zone, $record_id, $notification_id) {
		$request = array('domain-name' => $zone, 'record-id' => $record_id, 'notification-id' => $notification_id);

		return $this->core->Api->call('dns/delete-failover-notification.json', $request);
	}
	
	public function getNotificationPages($zone, $record_id, $rows_per_page) {

		$request = array('domain-name' => $zone, 'record-id' => $record_id, 'rows-per-page' => $rows_per_page);

		return $this->core->Api->call('dns/get-failover-notifications-pages.json', $request);
	}
	
	public function listNotifications($zone, $record_id, $page, $rows_per_page) {

		$request = array('domain-name' => $zone, 'record-id' => $record_id, 'page' => $page, 'rows-per-page' => $rows_per_page);

		return $this->core->Api->call('dns/list-failover-notifications.json', $request);
	}
}