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
.addNewRecord, .editNewRecord {
width: 102px;
}
.ttl {
width: 50px;
}
form.recordsForm select,
.inputTitle,
#addRecordHost, #editRecordHost,
.RP_fields div, .RP_fields input {
width: 49%;
}

.inputSRV {
width: 32.7%;
margin-left: 8px;
}
.SRV_fields .noMargin {
margin: 0;
}
.pointsTo {
width: 100%;
}
.breadcrumb, .form-control {
text-align: left;	
}
.backToZones {
text-align: right;
list-style-type: none;
{/literal}{if $theme eq 'six'}{literal}margin: 10px 0 0 0;{/literal}{/if}{literal}
}
.newMasterServer td form span {
margin-top: 5px;
}
.newMasterServer td form .btn {
margin-left: 5px;
}
.clear {
clear: both;
}
.masterServers .text-right {
text-align: right;
}

.text-left {
text-align: left;
}
.masterServers .masterServerDelete {
width: 16px;	
}

{/literal} {if $version gte '6'}{literal}

#cloudnsMobileSettingsMenu {
	display: none;
}		
		
@media only screen and (max-width: 870px) {
	#cloudnsSlaveMenu {
		display: none;
	}
	
	#cloudnsMobileSettingsMenu {
		display: block;
	}
	
	.backToZones {
		display: none;
	}
	
	.backToZonesMobile {
		list-style-type: none;
	}
	
	section#header .logo-text {
		font-size: 2.3em;
	}
	
	li {
		list-style-type: none;
	}
}

@media only screen and (max-width: 320px) {
	section#header .logo-text {
		font-size: 1.9em;
	}
}
{/literal}{/if}
{if $version gte '7.7'}
{literal}
ul#cloudnsSlaveMenu li {
	float: left;
	list-style-type: none;
	margin-left: 10px;
}
ul#cloudnsSlaveMenu li a {
	margin-right: 10px;	
}	
{/literal}
{/if}
</style>

<script type="text/javascript">
{literal}
function toggleOptions (element) {
	$('#' + element).toggle();
}
{/literal}
</script>

{assign var="menuSeparator" value=" /"}
{if $theme eq 'six'}
	{assign var="menuSeparator" value=""}
{/if}

<h4 class="pull-left">{$pagetitle}</h4><ul class="backToZones pull-right"><li><a href="clientarea.php?action=productdetails&id={$serviceid}" >back to the DNS zones list</a></li></ul>
<div class="clear"></div>
<ul class="breadcrumb" id="cloudnsSlaveMenu">
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=zone-settings&zone={$zone}" >Master servers</a></li>{$menuSeparator} 
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=bind-settings&zone={$zone}" >BIND settings</a></li>{$menuSeparator}
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=statistics&zone={$zone}&date=last-30-days" >DNS Statistics</a></li>{$menuSeparator} 
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=update-status&zone={$zone}" >Status</a></li>{$menuSeparator} 
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=delete-zone&zone={$zone}" title="Delete this DNS zone" onclick="return confirm('Are you sure you want to delete {$zone}?');">Delete</a></li>
</ul>
<div class="dropdown" id="cloudnsMobileSettingsMenu">
	<a href="#" class="dropdown-toggle" data-toggle="dropdown">Settings Menu<b class="caret"></b></a>
    <ul class="dropdown-menu">
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=zone-settings&zone={$zone}" >Master servers</a></li>{$menuSeparator} 
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=bind-settings&zone={$zone}" >BIND settings</a></li>{$menuSeparator}
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=statistics&zone={$zone}&date=last-30-days" >DNS Statistics</a></li>{$menuSeparator} 
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=update-status&zone={$zone}" >Status</a></li>{$menuSeparator} 
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=delete-zone&zone={$zone}" title="Delete this DNS zone" onclick="return confirm('Are you sure you want to delete {$zone}?');">Delete</a></li>
    </ul>
    <ul class="backToZonesMobile pull-right">
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}" >DNS zones list</a></li>
    </ul>
</div>


{if isset($response.status) && $response.status=='error'}
<div class="notification">{$response.description}</div><br />
{/if}
<br />