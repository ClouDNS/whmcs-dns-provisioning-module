
<div class="newZoneContainer">
	<form action="clientarea.php?action=productdetails&id={$serviceid}&customAction=add-zone" method="post">
		<h4>Master zone</h4>
		{if !$templateZone}
		<label><input type="radio" name="newZoneOptions" value="1" onclick="showNewZoneOptions(1)" checked="checked" style="float:left; margin-right:5px;" />Create the zone with the following NS records:</label>
		
		<div id="zoneOptions1" class="zoneOptions" style="margin: 10px 10px 0px 30px;">
			<div id="masterDNSServers">

			{foreach from=$serversList item=name}
				<label title="{$name}" class="nsServer pull-left"><input type="checkbox" value="{$name}" checked="checked" name="masterDNSServer[]"  class="pull-left servers-list" /><span class="pull-left">&nbsp;{$name}</span></label>
			{/foreach}

			</div>
			<div class="clear"></div>
			<label><input type="checkbox" style="float:left; margin-right:5px;" id="checkall" name="checkall" onclick="checkUncheckAll('checkall', 'masterDNSServers');" checked="checked"/>Check / Uncheck all</label>

		</div>
		
		<div class="clear"></div>
		<label><input type="radio" name="newZoneOptions" value="2" onclick="showNewZoneOptions(2)" style="float:left; margin-right:5px;" />Create the zone without any records</label>
		<br />
		{/if}
		
		<span class="pull-left" >Domain name: &nbsp; </span>
		<input class="pull-left" type="text" name="zone" id="zone" />
		<input type="hidden" name="zoneType" value="masterZoneType" />
		<input type="submit" name="" value="create" class="btn btn-primary btn-input-padded-responsive" />
	</form>
</div>