
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

#recordsForm .addNewRecord, #recordsForm .editNewRecord {
width: 105px;
}
#recordsForm .addNewRecord img {
margin-right: 5px;
}
#recordsForm.ttl {
width: 50px;
}
form#recordsForm.recordsForm .selectTLSA, 
form#recordsForm.recordsForm .selectDS,
form#recordsForm.recordsForm .selectCERT,
form#recordsForm.recordsForm .selectHINFO {
width: 32.2%;
margin-right: 8.7px;
float: left;
}
form#recordsForm.recordsForm select,
#recordsForm .inputTitle,
#recordsForm .RP_fields div {
width: 49.7%;
box-sizing: border-box;
}
#recordsForm .RP_fields input,
#recordsForm #addRecordHost, 
#recordsForm #editRecordHost, 
#recordsForm .MX_fields input,
#recordsForm .NAPTR_fields input,
#recordsForm .HINFO_fields input{
width: 47.3%;
}
#recordsForm .inputSRV {
width: 29.8%;
margin-left: 8px;
float: left;
}
#recordsForm .titleLOC {
width: 24.8%;
margin-left: 0;
float: left;
}
#recordsForm .inputLOC {
width: 23%;
margin-left: 14px;
float: left;
}
#recordsForm .inputFirstLOC {
width: 23%;
margin-left: 0;
float: left;
}
form#recordsForm.recordsForm .selectLOC {
width: 23%;
margin-left: 14px;
float: left;
}
#recordsForm div.inputSRV.srvInputTitle {
width: 32.4%;
margin-left: 5px;
float: left;
}
#recordsForm div.inputTLSA.tlsaInputTitle,
#recordsForm div.inputDS.dsInputTitle,
#recordsForm div.inputCERT.certInputTitle,
#recordsForm div.inputHINFO.hinfoInputTitle {
width: 32.2%;
margin-right: 9.3px;
float: left;
}
#recordsForm div.inputSRV.noMargin {
margin: 0;
}

#recordsForm .SRV_fields .noMargin {
margin: 0;
}
#recordsForm .pointsTo {
width: 98%;
}
#recordsForm .importForm table th {
width: 100px;
}

{/literal}
{if $version gte '6'}
{literal}

#cloudnsMobileSettingsMenu {
	display: none;
}	
	
#recordsForm .RP_fields input,
#recordsForm #addRecordHost, 
#recordsForm #editRecordHost, 
#recordsForm .MX_fields input,
#recordsForm .NAPTR_fields input,
#recordsForm .HINFO_fields input{
width: 49.7%;
}

#recordsForm .inputSRV {
width: 32.7%;
margin-left: 5px;
float: left;
}

#recordsForm div.inputSRV.srvInputTitle {
width: 32.7%;
float: left;
}
	
#recordsForm .pointsTo {
width: 100%;
}

@media only screen and (max-width: 870px) {
	#cloudnsSettingsMenu {
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
}

@media only screen and (max-width: 320px) {
	section#header .logo-text {
		font-size: 1.9em;
	}
}
{/literal}
{/if}
{literal}
.importForm textarea {
{/literal}
{if $version gte '6' && $theme eq 'six'}{literal}width: 100%;{/literal}{else}{literal}width: 98%;{/literal}
{/if}{literal}
	
height: 600px;
}
.clear {
clear: both;
}
.pointer {
cursor: pointer;
}
.newZoneContainer label {
text-align: left;	
}

.breadcrumb {
text-align: left;	
}

.form-control {
text-align: left;
display: inline;
}

.backToZones {
text-align: right;
list-style-type: none;
}

.whmcscontainer .moduleoutput form {
text-align: left;	
}
#table-records.dns-records .text-right {
text-align: right;	
}
.text-left {
text-align: left;
}
.table-update-status, .import-table, .import-table tbody label {
width: 100%;
}
#recordsType {
width: auto;
}
#recordsForm label {
width: 100%;
}

ul#cloudnsSettingsMenu li {
float: left;
list-style-type: none;
margin-left: 10px;
}
ul#cloudnsSettingsMenu li a {
margin-right: 10px;	
}
ul#cloudnsSettingsMenu {
{/literal}
{if $version lte '6'}{literal}height: 20px;{/literal}{else}{literal}height: 40px;{/literal}
{/if}{literal}
}
.pull-left {
text-align: left;
}
.pull-right {
text-align: right;
}
.fleft {
float: left;
}
.fright {
float: right;
}
form#recordsForm {
text-align: left;
}
#table-records .overflow {
overflow: hidden;
position: relative;
width: 32%;
}
#table-records .overflow .overflowDiv {
width: 94%; 
overflow: hidden;
position: absolute;
white-space: nowrap;
}
{/literal}
</style>


<script type="text/javascript">
{literal}
function toggleOptions (element) {
	$('#' + element).toggle();
}
{/literal}
</script>
{*
{assign var="menuSeparator" value="&nbsp;&nbsp;"}
{if $theme eq 'five' || $theme eq 'default'}
	{assign var="menuSeparator" value=" /"}
{/if}
*}
{assign var="menuSeparator" value=" /"}
{if $theme eq 'six'}
	{assign var="menuSeparator" value=""}
{/if}

<div>
	<h4 class="pull-left">{$pagetitle}</h4>
	<ul class="backToZones pull-right">
		<li><a href="clientarea.php?action=productdetails&id={$serviceid}" >back to the DNS zones list</a></li>
	</ul>
</div>
<div class="clear"></div>

<ul class="breadcrumb" id="cloudnsSettingsMenu"> 
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=zone-settings&zone={$zone}" >Records</a> {$menuSeparator}</li> 
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=dnssec&zone={$zone}" >DNSSEC</a> {$menuSeparator}</li>
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=soa-settings&zone={$zone}" >SOA</a> {$menuSeparator}</li>
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=statistics&zone={$zone}&date=last-30-days" >DNS Statistics</a> {$menuSeparator}</li>
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=import&zone={$zone}" >Import records</a> {$menuSeparator}</li>
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=update-status&zone={$zone}" >Status</a> {$menuSeparator}</li>	
{if $registeredDomains != 'on'}<li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=delete-zone&zone={$zone}" title="Delete this DNS zone and all its records" onclick="return confirm('Are you sure you want to delete {$zone} and all its records?');" >Delete</a></li>{/if}
</ul>
<div class="dropdown" id="cloudnsMobileSettingsMenu">
	<a href="#" class="dropdown-toggle" data-toggle="dropdown">Settings Menu<b class="caret"></b></a>
    <ul class="dropdown-menu">
	    <li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=zone-settings&zone={$zone}" >Records</a> {$menuSeparator}</li> 
	    <li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=dnssec&zone={$zone}" >DNSSEC</a> {$menuSeparator}</li>
	    <li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=soa-settings&zone={$zone}" >SOA</a> {$menuSeparator}</li>
	    <li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=statistics&zone={$zone}&date=last-30-days" >DNS Statistics</a> {$menuSeparator}</li>
	    <li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=import&zone={$zone}" >Import records</a> {$menuSeparator}</li>
	    <li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=update-status&zone={$zone}" >Status</a> {$menuSeparator}</li>
{if $registeredDomains != 'on'}
	    <li><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=delete-zone&zone={$zone}" title="Delete this DNS zone and all its records" onclick="return confirm('Are you sure you want to delete {$zone} and all its records?');" >Delete</a></li>{/if}
    </ul>
    <ul class="backToZonesMobile pull-right">
	<li><a href="clientarea.php?action=productdetails&id={$serviceid}" >DNS zones list</a></li>
    </ul>
</div>
<div class="clear"></div>
{if (isset($response.status) && ($response.status=='error' || $response.status=='info'))}
<div class="notification">{$response.description}</div><br />
{/if}
<br />
