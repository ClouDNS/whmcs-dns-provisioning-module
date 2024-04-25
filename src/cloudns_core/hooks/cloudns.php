<?php

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

function activateFreeDNSHosting($vars) {
	include ROOTDIR.'/modules/servers/cloudns/cloudns_core/hooks/add-free-dns-to-domain.php';
}

add_hook('AfterRegistrarRegistration', 1, 'activateFreeDNSHosting');
add_hook('DomainTransferCompleted', 1, 'activateFreeDNSHosting');