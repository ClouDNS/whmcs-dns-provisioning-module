<?php

Class Cloudns_Helper {
	
	public function redirect ($url) {
		header("Location: {$url}");
		exit;
	}
	
	/**
	 * Get a parameter from $_POST variable
	 * @param string $param
	 * @return string 
	 */
	public static function getPost ($param, $default='') {
		if (isset($_POST[$param])) {
			return $_POST[$param];
		}
		return $default;
	}

	/**
	 * Get a parameter  from $_GET variable
	 * @param string $param
	 * @param mixed $default
	 * @return string 
	 */
	public static function getGet ($param, $default='') {
		if (isset($_GET[$param])) {
			return $_GET[$param];
		}
		return $default;
	}
	
	/**
	 * Get a parameter from $_REQUEST variable
	 * @param string $param
	 * @return string 
	 */
	public static function getRequest ($param, $default='') {
		if (isset($_REQUEST[$param])) {
			return $_REQUEST[$param];
		}
		return $default;
	}
	
	/**
	 * 
	 * @param string $zone_name
	 * @param int $shortLenght Maximum lenght of the string to be shortned if above
	 * @return type
	 */
	public function shortenLongName($zone_name, $shortLenght=55) {
		$name = $this->getUnicodeName($zone_name);
		return $this->shortenLongString($name, $shortLenght);
	}
	
	/**
	 * Checks if a sting is longer than $shortLenght symbols and make it shorter to fit on the row.
	 * @param int $string
	 * @param int $shortLenght Maximum lenght of the string to be shortned if above
	 * @return array
	 */
	public function shortenLongString ($string, $shortLenght=55) {
		
		$domainName = array();
		
		$shortName = $string;
		if (mb_strlen($string) > $shortLenght) {
			$shortName = mb_substr($string, 0, $shortLenght, 'UTF-8');
		}
		
		$domainName['title'] = $string;
		$domainName['shortName'] = $shortName;

		return $domainName;
	}
	
	
	/**
	 * Get real ASCII name
	 * @param string $name
	 * @return string
	 */
	public function getAsciiName ($name) {
		if (function_exists('idn_to_ascii')) {
			$convertedName = @idn_to_ascii($name);
		} else {
			$convertedName = $name;
		}

		if (empty($convertedName) && !empty($name)) {
			return $name;
		}
		return $convertedName;
	}

	/**
	 * Get native IDN name in Unicode, readable
	 * @param string $name
	 * @return string
	 */
	public function getUnicodeName ($name) {
		if (function_exists('idn_to_utf8')) {
			return idn_to_utf8($name);
		}
		
		return $name;
	}
	
	/**
	 * Convirts seconds in minutes, hours, days or weeks
	 * @param int $seconds
	 * @return string
	 */
	public function convertSeconds ($seconds) {
		if ($seconds < 3600) {
			return round($seconds / 60).'m';
		} else if ($seconds < 86400) {
			return round($seconds / 3600).'h';
		} else if ($seconds < 604800) {
			return round($seconds / 86400).'d';
		} else if ($seconds <= 2592000) {
			return round($seconds / 604800).'w';
		} else {
			return round($seconds / 604800).'d';
		}
	}
	
	/**
	 * Show paging
	 * @param int $currentPage
	 * @param int $totalRows
	 * @param int $resultPerPage
	 * @param string $href
	 * @param string $onClick
	 * @param boolean $toReturn
	 * @return string 
	 */
	public function showPaging($currentPage, $pageCount, $href, $onClick = null, $toReturn = false) {

		if ($pageCount < 1) {
			$pageCount = 1;
		}

		if ($href == '') {
			$link = 'href="javascript:void(0);"';
		} else {
			$link = 'href="' . $href . '"';
		}

		if (isset($onClick)) {
			$link .= ' onclick="' . $onClick . '"';
		}

		$return = '';

		if ($currentPage > 1) {
			$return .= '<a ' . str_replace("PAGE_NUM", ($currentPage - 1), $link) . ' class="paginate_button previous">&laquo; ' . 'Previous' . '</a> ';
		}

		if ($pageCount > 5) {
			if ($currentPage >= 5) {
				$start_page = $currentPage - 2;
				$first_page = 1; //($currentPage < 5 ? 2:3);
				for ($i = 1; $i <= $first_page; $i ++) {
					$return .= '<a ' . str_replace("PAGE_NUM", $i, $link) . ' class="page">' . $i . '</a> ';
				}

				$return .= "<span>&nbsp;...&nbsp;</span> ";
			} else {
				$start_page = 1;
			}

			if ($currentPage >= $pageCount - 5) {
				$to_loop = $pageCount - $currentPage + 2;
			} else {
				$to_loop = 4;
			}

			$display_last_pages = 0;
			if ($start_page + $to_loop < $pageCount) {
				$display_last_pages = 1;
			}

			for ($i = $start_page; $i <= ($start_page + $to_loop); $i ++) {
				if ($i > $pageCount) {
					break;
				} else if ($i == $currentPage) {
					$return .= '<span class="page current">' . $i . '</span> ';
				} else {
					$return .= '<a ' . str_replace("PAGE_NUM", $i, $link) . ' class="page">' . $i . '</a> ';
				}
			}

			if ($display_last_pages != 0) {
				if ($start_page + $to_loop < $pageCount - 1) {
					$return .= '<span>&nbsp;...&nbsp;</span>';
				}
				for ($i = ($pageCount); $i <= $pageCount; $i ++) {
					if ($i == $currentPage) {
						$return .= '<span class="page current">' . $i . '</span> ';
					} else {
						$return .= '<a ' . str_replace("PAGE_NUM", $i, $link) . ' class="page">' . $i . '</a> ';
					}
				}
			}
		} else {
			for ($i = 1; $i <= $pageCount; $i ++) {
				if ($i == $currentPage) {
					$return .= '<span class="page current">' . $i . '</span> ';
				} else {
					$return .= '<a ' . str_replace("PAGE_NUM", $i, $link) . ' class="page">' . $i . '</a> ';
				}
			}
		}

		if ($currentPage < $pageCount) {
			$return .= '<a ' . str_replace("PAGE_NUM", ($currentPage + 1), $link) . ' class="paginate_button next">' . 'Next' . ' &raquo;</a> ';
		}

		if ($toReturn === true) {
			return $return;
		} else {
			echo $return;
		}
	}
	
	public function convertWRtoAscii($record) {
		$url = parse_url($record);

		if (!$url) {
			return false;
		}

		if (isset($url['host'])) {
			$url['host'] = $this->getAsciiName($url['host']);
			if (isset($url['user'])) {
				if (isset($url['pass'])) {
					$url['user'] = $url['user'] . ':' . $url['pass'];
				}
				$url['host'] = $url['user'] . '@' . $url['host'];
			}
			if (isset($url['port'])) {
				$url['host'] = $url['host'] . ':' . $url['port'];
			}
			if (isset($url['path'])) {
				$url['host'] = $url['host'] . $url['path'];
			}
			if (isset($url['query'])) {
				$url['host'] = $url['host'] . '?' . $url['query'];
			}
			if (isset($url['fragment'])) {
				$url['host'] = $url['host'] . '#' . $url['fragment'];
			}
		}
		unset($url['user'], $url['pass'], $url['port'], $url['query'], $url['fragment'], $url['path']);
		if (isset($url['scheme'])) {
			$url['scheme'] = $url['scheme'] . '://';
		}

		return implode('', $url);
	}

}

