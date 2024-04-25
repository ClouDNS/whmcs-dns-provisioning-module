<?php

class Cloudns_Model {
	
	/**
	 * @var Objects 
	 */
	protected $core;

	/**
	 * @return Model
	 */
	public function __construct () {
		$this->core = Cloudns_Core::inst($params);
	}
}
