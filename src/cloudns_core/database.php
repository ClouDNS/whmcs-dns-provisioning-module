<?php

use Illuminate\Database\Capsule\Manager as Capsule;
class Cloudns_Database {
	
	protected $version;
	
	public function __construct ($params) {
		$this->version = $params['shortVersion'];
	}
	
	public function select ($table, $tbl_params=array(), $order='name') {
		$response = array();
		if ($this->version >= 6) {			
			$query = Capsule::table($table);
			foreach ($tbl_params as $column=>$value) {
				$query->where($column, $value);
			}
			
			$query->orderBy($order, 'ASC');
			
			$rows = $query->get();
			foreach ($rows as $row) {
				if ($table == 'tbldomains') {
					$response[] = array(
						'name' => $row->domain,
						'serviceid' => '',
						'userid' => $row->userid,
					);
				} elseif ($table == 'tblproducts') {
					$response[] = array(
						'templateZone' => $row->configoption4,
						'availableServers' => $row->configoption2,
						'registeredDomains' => $row->configoption3,
					);
				} else {
					$response[] = array(
						'name' => $row->name,
						'serviceid' => $row->serviceid,
					);
				}
			}
		// versions below 6 use currently depricated query builders
		} else {
			
			$where = array();
			foreach ($tbl_params as $param=>$value) {
				$where[] = "`{$param}`='{$value}'";
			}
			
			$where = implode(' AND ', $where);
			$query = full_query("SELECT * FROM `{$table}` WHERE 1=1 AND {$where} ORDER BY {$order} ASC");
			
			while ($row = mysql_fetch_assoc($query)) {
				
				if ($table == 'tbldomains') {
					$response[] = array(
						'name' => $row['domain'],
						'serviceid' => '',
						'userid' => $row['userid'],
					);
				} elseif ($table == 'tblproducts') {
					$response[] = array(
						'templateZone' => $row['configoption4'],
						'availableServers' => $row['configoption2'],
						'registeredDomains' => $row['configoption3'],
					);
				} else {
					$response[] = array(
						'name' => $row['name'],
						'serviceid' => $row['serviceid'],
					);
				}
			}
		}
		
		return $response;
	}
	
	public function insert ($table, $tbl_params=array()) {
		$response = array();
	
		if ($this->version >= 6) {
			$response = Capsule::connection()->transaction(
				function ($connectionManager) use ($table, $tbl_params) {
					$connectionManager->table($table)->insert($tbl_params);
				}
			);
		// versions below 6 use currently depricated query builders
		} else {
			if (!insert_query($table, $tbl_params)) {
				return false;
			}
		}
		return true;
	}
	
	public function delete ($table, $tbl_params=array()) {
		$response = array();
		
		if ($this->version >= 6) {
			$response = Capsule::connection()->transaction(
				function ($connectionManager) use ($table, $tbl_params) {
					$connectionManager->table($table)
						->where('serviceid', '=', $tbl_params['serviceid'])
						->where('name', '=', $tbl_params['name'])
						->delete();
				}
			);
		// versions below 6 use currently depricated query builders
		} else {
			$where = array();
			foreach ($tbl_params as $param=>$value) {
				$where[] = "`{$param}`='{$value}'";
			}
			
			$where = implode(' AND ', $where);
			
			if (!full_query("DELETE FROM `{$table}` WHERE {$where}")) {
				return false;
			}
		}
		return true;
	}
	
	
	public function count ($table, $tbl_params=array()) {
		$response = 0;
		if ($this->version >= 6) {
			$query = Capsule::table($table);
			foreach ($tbl_params as $column=>$value) {
				$query->where($column, $value);
			}
			
			
			$response = $query->count();
			
		// versions below 6 use currently depricated query builders
		} else {
			$where = array();
			foreach ($tbl_params as $param=>$value) {
				$where[] = "`{$param}`='{$value}'";
			}
			
			$where = implode(' AND ', $where);
			$query = full_query("SELECT COUNT(*) as `count` FROM `{$table}` WHERE 1=1 AND {$where}");
		
			$count = mysql_fetch_assoc($query);
			$response = $count['count'];
		}
		
		return $response;
	}
	
	public function sum ($table, $column_to_sum,  $tbl_params=array()) {
		$response = 0;
		if ($this->version >= 6) {
			$query = Capsule::table($table);
			foreach ($tbl_params as $column => $value) {
				$query->where($column, $value);
			}


			$response = $query->sum($column_to_sum);

		// versions below 6 use currently depricated query builders
		} else {
			$where = array();
			foreach ($tbl_params as $param => $value) {
				$where[] = "`{$param}`='{$value}'";
			}

			$where = implode(' AND ', $where);
			$query = full_query("SELECT SUM(`{$column_to_sum}`) as `sum` FROM `{$table}` WHERE 1=1 AND {$where}");

			$sum = mysql_fetch_assoc($query);
			$response = $sum['sum'];
		}

		return $response;
	}

	public function increment ($table, $column_to_increment, $tbl_params=array(), $increment_by=1) {
		
		if ($this->version >= 6) {
			$query = Capsule::table($table);
			foreach ($tbl_params as $column=>$value) {
				$query->where($column, $value);
			}
			
			$query->increment($column_to_increment, $increment_by);
		
		// versions below 6 use currently depricated query builders
		} else {
			$where = array();
			foreach ($tbl_params as $param=>$value) {
				$where[] = "`{$param}`='{$value}'";
			}
			
			$where = implode(' AND ', $where);
			$query = full_query("UPDATE `{$table}` SET `{$column_to_increment}` = `{$column_to_increment}` + {$increment_by} WHERE 1=1 AND {$where}");
		}
	}
	
	public function decrement ($table, $column_to_decrement, $tbl_params=array(), $decrement_by=1) {
		
		if ($this->version >= 6) {
			$query = Capsule::table($table);
			foreach ($tbl_params as $column=>$value) {
				$query->where($column, $value);
			}
			
			$query->decrement($column_to_decrement, $decrement_by);
			
		// versions below 6 use currently depricated query builders
		} else {
			$where = array();
			foreach ($tbl_params as $param=>$value) {
				$where[] = "`{$param}`='{$value}'";
			}
			
			$where = implode(' AND ', $where);
			$query = full_query("UPDATE `{$table}` SET `{$column_to_decrement}` = `{$column_to_decrement}` - {$decrement_by} WHERE 1=1 AND {$where}");
		}
	}
	
	public function columnCheck($table, $column_to_check) {
		$response = 0;
		if ($this->version >= 6) {
			$query = Capsule::schema()->hasColumn($table, $column_to_check);

			// if the column exists
			if ($query) {
				$response = 1;
			}
			// versions below 6 use currently depricated query builders
		} else {
			$query = full_query("SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{$table}' AND COLUMN_NAME = '{$column_to_check}'");

			if (mysql_num_rows($query) > 0) {
				$response = 1;
			}
		}

		return $response;
	}

}
