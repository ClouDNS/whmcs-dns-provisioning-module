
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

.newZoneBox {

{/literal}{if $version gte '6' && $theme eq 'six'}{literal}height: 90px; width: 32.2%;{/literal}{else}{literal}height: 30px; width: 24.4%;{/literal}{/if}
{literal}
border: 1px solid #dddddd;
padding: 20px;
float: left;
margin: 0 14px 10px 0;
cursor: pointer;
vertical-align: middle;
text-align: center;
}
.newZoneBox:hover {
text-decoration: underline;
}
.noMargin {
margin-right: 0;
}
.clear {
clear: both;
}
.zoneType {
display: none;
}
.newSlaveZoneAdd tr td {
width: 42%;
}
.newSlaveZoneAdd tr td input {
width: 93%;
}
.newSlaveZoneAdd tr td input.btn {
width: auto;
}
form.recordsForm select {
width: auto;
}
form.recordsForm input.form-control {
width: 67%;
}
form.recordsForm input.slaveZone {
width: 78%;
}
.newZoneContainer label {
text-align: left;	
}
.zoneType {
text-align: left;	
}
#masterZone span {
margin-top: 3px;	
}
.zoneType .btn {
margin-left: 5px;	
}
.newSlaveZoneAdd input {
margin-bottom: 0;	
}
.breadcrumb, .form-control {
text-align: left;	
}
.backToZones {
text-align: right;
list-style-type: none;
{/literal}{if $theme eq 'six'}{literal}margin: 10px 0 0 0;{/literal}{/if}{literal}
}
.nsServer {
margin-right: 15px;
}
.newZoneContainer .servers-list {
{/literal}{if $version gte '6' && $theme eq 'six'}{literal}margin-top: 10px;{/literal}{else}{literal}margin-top: 3px;{/literal}{/if}{literal}
}
{/literal}

.chooseZoneType {
width: auto;
}
</style>

{literal}
	<script type="text/javascript">
		function checkUncheckAll (controller, container) {
			var isChecked = $('#' + controller).prop('checked');
			$('#' + container).find('input[type="checkbox"]').prop('checked', isChecked);
		}
		function showNewZoneOptions(options) {
			$('.zoneOptions').css('display', 'none');
			$('#zoneOptions' + options).css('display', 'block');
		}
		function showNewZoneType(type) {
			$('.zoneType').css('display', 'none');
			$('#' + type + 'Zone').css('display', 'block');
			document.getElementById(type + "Zone").scrollIntoView();
		}
	</script>
{/literal}


{assign var="path" value="../modules/servers/cloudns/templates/new-zone"}
{if $version gte '6'}
	{assign var="path" value="./new-zone"}
{/if}


<h4 class="pull-left">Add new DNS zone</h4><ul class="backToZones pull-right"><li><a href="clientarea.php?action=productdetails&id={$serviceid}" >back to the DNS zones list</a></li></ul>
<div class="clear"></div>

{if $response}
	<div class="notification">{$response.description}</div><br />
{/if}
<div class="newZoneButtonsContainer">
	<div class="pull-left">Type:&nbsp;</div> <select name="zoneTypeSelect" class="chooseZoneType form-control pull-left" onChange="showNewZoneType(this.value)">
		<option value="noType">-- types --</option>
		<option value="master">Master (Primary) Domain Zone</option>
		<option value="slave">Slave (Secondary) Domain Zone</option>
		<option value="masterReverse">Master (Primary) Reverse Zone</option>
		<option value="slaveReverse">Slave (Secondary) Reverse zone</option>
	</select>
</div>
<div class="clear"></div>
<br />

<div id="noTypeZone" style="display:none;"></div>
<div id="masterZone" class="zoneType" style="display:none;">
	{include file="$path/master.tpl"}
</div>

<div id="slaveZone" class="zoneType" style="display:none;">
	{include file="$path/slave.tpl"}
</div>

<div id="masterReverseZone" class="zoneType" style="display:none;">
	{include file="$path/master-reverse.tpl"}
</div>

<div id="slaveReverseZone" class="zoneType" style="display:none;">
	{include file="$path/slave-reverse.tpl"}
</div>