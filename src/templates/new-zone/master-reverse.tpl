<style type="text/css">
{if $version gte '6'}	
{literal}	

.mBr, .mButton {

	display: none;
}	

.notification {

	word-break: break-all;
}
	
@media only screen and (max-width: 1200px) {
	
	.mButton {
		display: block;
	}
}

@media only screen and (max-width: 500px) {
	
	.dDot {
		display: none;
	}
	
	.mBr {
		display: block;
	}	
	
	form.recordsForm input.form-control,
	form.recordsForm select {
		width: 100%;
	}
}
	
{/literal}	
{/if}
</style>

<div class="newZoneContainer">
	<form action="clientarea.php?action=productdetails&id={$serviceid}&customAction=add-zone" method="post" class="recordsForm">
		<h4>Master reverse zone</h4>
		<p><b>Create the zone with the following NS records:</b></p>
			<div id="masterDNSservers" style="margin: 10px 10px 0px 30px;">
			{foreach from=$serversList item=name}
				<label title="{$name}" class="nsServer pull-left"><input type="checkbox" value="{$name}" checked="checked" name="masterDNSServer[]" class="pull-left" /> <span class="pull-left">{$name}</span></label>
			{/foreach}
			<div class="clear"></div>
			<p><label><input type="checkbox" id="checkallr" name="checkallr" onclick="checkUncheckAll('checkallr', 'masterDNSservers');" checked="checked" class="pull-left" /><span class="pull-left">Check / Uncheck all</span></label></p>

			</div>
			
			<div class="clear"></div>
			
			<br clear="all" />
			Reverse zone name:<br /> <input type="text" class="pull-left form-control" maxlength="63" name="zone" /><span class="pull-left dDot">&nbsp;.&nbsp;</span>
			<br class="mBr clear">
			<br class="mBr">
			<select name="zoneSufix" id="zoneType" class="form-control pull-left">
				<option value="in-addr.arpa">in-addr.arpa</option>
				<option value="ip6.arpa">ip6.arpa</option>
			</select>

			<input type="hidden" name="zoneType" value="masterReverseZoneType" />
			<br class="mButton clear">
			<br class="mButton">
			<input type="submit" value="create" class="btn btn-primary btn-input-padded-responsive" />
		 <br /><br><p>* Manage records from our system</p><br>
	</form>	

	<div class="notification">
		<p>The IPv4 zone needs to be in the format 1.0.0.127 for IP 127.0.0.1 and from the drop-down menu needs to be chosen in-addr.arpa.</p><br />

		<p>The IPv6 zone needs to be in the format 1.2.3.4.5.6.7.8.9.0.1.2.3.4.5.6.7.8.9.0.1.2.3.4.5.6.7.8.9.0.1.2 for IPv6 2109:8765:4321:0987:6543:2109:8765:4321 and from the drop-down menu needs to be chosen ip6.arpa.</p>
	</div>
</div>