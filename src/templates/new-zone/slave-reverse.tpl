<style type="text/css">
{if $version gte '6'}	
{literal}	

.notification {

	word-break: break-all;
}	
	
@media only screen and (max-width: 660px) {
	
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
		<h4>Slave reverse zone</h4>
		<table style="width: 100%;" class="newSlaveZoneAdd">
			<tr><td colspan="3">Reverse zone name: <br /> <input type="text" class="pull-left form-control slaveZone" maxlength="63" name="zone" /><span class="pull-left dDot">&nbsp;.&nbsp;</span>
			<br class="mBr clear">
			<br class="mBr">
				<select name="zoneSufix" id="zoneType" class="pull-left form-control">
					<option value="in-addr.arpa">in-addr.arpa</option>
					<option value="ip6.arpa">ip6.arpa</option>
				</select>
			</td></tr>
			<tr><td colspan="3" style="padding-top: 15px;">Master server IP:<br /> <input type="text" class="slaveZone form-control pull-left" id="slaveMasterIp" name="slaveMasterIp" />
			<br class="mButton clear">
			<br class="mButton">		
			<input type="hidden" name="zoneType" value="slaveReverseZoneType" /><input type="submit" value="create" class="btn btn-primary btn-input-padded-responsive" /></td></tr>

			<tr><td colspan="3">
			<br><p>* Manage the records from your master server</p><br />
			</td></tr>
		</table>
	</form>	

	<div class="notification">
		<p>The IPv4 zone needs to be in the format 1.0.0.127 for IP 127.0.0.1 and from the drop-down menu needs to be chosen in-addr.arpa.</p><br />

		<p>The IPv6 zone needs to be in the format 1.2.3.4.5.6.7.8.9.0.1.2.3.4.5.6.7.8.9.0.1.2.3.4.5.6.7.8.9.0.1.2 for IPv6 2109:8765:4321:0987:6543:2109:8765:4321 and from the drop-down menu needs to be chosen ip6.arpa.</p>
	</div>
</div>