<?php

add_hook('ClientAreaPrimarySidebar', 1, function ($menu) {
	// Check if the user is logged in
	if (empty($_SESSION['uid'])) {
	    return; // Exit if the user is not logged in
	}
	
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
});

