
<style type="text/css">
{literal}
.notification {
background-color: #dbe3ff;
border-color: #a2b4ee;
color: #585b66;
display:block;
font-style:normal;
padding: 10px 10px 10px 36px;
line-height: 1.5em;
}
.table tr#zones td ul.breadcrumb {
padding: 0;
margin: 0;
background: none;
}
.table tr#zones td:first-child {
width: 69%;
overflow: hidden;
vertical-align: middle;
}
.backToZones {
text-align: right;
list-style-type: none;
}
.clear {
clear: both;
}
#zones-list.table.table-hover td.text-right {
text-align: right;
}
#zones-list {
width: 100%;
}
{/literal}
{if $version gte '6'}
{literal}
.vDots:after {
	content: '\2807';
	font-size: inherit;
}

#mobile-zones-options {
	display: none;
}

.mr-10 {
	margin-right: 10px;
}

@media only screen and (max-width: 1200px) {
	
	.zones-options {
		display: none;
	}
	
	#mobile-zones-options {
		display: block;
	}
}

@media only screen and (max-width: 870px) {
	
	section#header .logo-text {
		font-size: 2.3em;
	}
}

@media only screen and (max-width: 650px) {
	
	#mobile-zones-options a:focus, a:hover {
		text-decoration: none;
	}
	
	ol, ul {
		margin-top: 5px;
	}
}
{/literal}
{/if}
{if $version gte '7.7'}
{literal}
.zones-options {
	min-width: 260px;
}

{/literal}
{/if}
</style>

<h4 class="pull-left">DNS Zones</h4>
{if $registeredDomains != 'on'}<ul class="backToZones pull-right"><li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=add-new-zone" >add new zone</a></li></ul>{/if}

<div class="clear"></div>

{if is_array($response) && $response.status eq 'error'}
	<div class="notification">{$response.description}</div><br />
{/if}
{if !empty($zones) && !isset($zones.status)}
	<table class="table-hover table" id="zones-list">
	{foreach from=$zones item=zone}
		<tr id="zones">
			<td>
				<a title="DNS records of {$zone.name}" href="clientarea.php?action=productdetails&id={$serviceid}&customAction=zone-settings&zone={$zone.name}">{$zone.ascii}</a>
			</td>
			<td class="text-right">
				<div class="zones-options">
					<a class="btn btn-primary btn-input-padded-responsive" title="DNS records of {$zone.name}" href="clientarea.php?action=productdetails&id={$serviceid}&customAction=zone-settings&zone={$zone.name}">Manage</a>
{if $registeredDomains != 'on'}
					<a class="btn btn-danger btn-input-padded-responsive" title="Delete the DNS zone of {$zone.name}" href="clientarea.php?action=productdetails&id={$serviceid}&customAction=delete-zone&zone={$zone.name}" onclick="return confirm('Are you sure you want to delete {$zone.name} and all its records?');">Delete</a>{/if}
				</div>
				<div id="mobile-zones-options" class="dropdown">
					<a href="#" class="dropdown-toggle vDots" data-toggle="dropdown"></a>
					<ul class="dropdown-menu pull-right">
						<li><a title="DNS records of {$zone.name}" href="clientarea.php?action=productdetails&id={$serviceid}&customAction=zone-settings&zone={$zone.name}"><span class="glyphicon glyphicon-pencil mr-10"></span>Manage</a></li>
						<li>
						{if $registeredDomains != 'on'}
							<a title="Delete the DNS zone of {$zone.name}" href="clientarea.php?action=productdetails&id={$serviceid}&customAction=delete-zone&zone={$zone.name}" onclick="return confirm('Are you sure you want to delete {$zone.name} and all its records?');"><span class="glyphicon glyphicon-remove mr-10"></span>Delete</a>{/if}
						</li>
					</ul>
				</div>
			</td>
		</tr>
	{/foreach}
	</table>
{/if}
