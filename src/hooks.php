<?php
use Illuminate\Database\Capsule\Manager as Capsule;

add_hook('ClientAreaPrimarySidebar', 1, function ($menu) {
	// Check whether the services menu exists.
	if (!is_null($menu->getChild('Service Details Overview'))) {
		// Add a link to the zones list.
		$newMenu = $menu->getChild('Service Details Overview')
			->addChild(
				'Zones list',
				array(
					'uri' => 'clientarea.php?action=productdetails&id='.$_GET['id'],
					'order' => 11,
				)
			);
		$menu->getChild('Service Details Overview')
			->removeChild('Information');
	}

// add "DNS Management" button in clientarea.php?action=domaindetails&id=x
	if (!is_null($menu->getChild('Domain Details Management'))) {
	    $domainId = intval($_GET['id']);
	    $domainDetails = Capsule::table('tbldomains')
            ->where('id', $domainId)
            ->first();
	    $domainName = $domainDetails->domain;	
        $menu->getChild('Domain Details Management')
        ->addChild('DNS Management')
        ->setLabel('DNS Management')
        ->setUri('/clientarea.php?action=productdetails&id=1&customAction=zone-settings&zone='.$domainName)
        ->setOrder(100);
    }

});

