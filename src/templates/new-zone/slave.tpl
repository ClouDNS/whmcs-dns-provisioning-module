<div class="newZoneContainer">
	<form action="clientarea.php?action=productdetails&id={$serviceid}&customAction=add-zone" method="post">
		<h4>Slave/Backup zone</h4>
		<table style="width: 100%;" class="newSlaveZoneAdd">
			<tr>
				<td>Domain name:</td>
				<td>IP address:</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><input type="text" class="noMargin" id="slaveDomain" name="zone" /></td>
				<td><input type="text" id="slaveMasterIp" class="noMargin" name="slaveMasterIp" /></td>
				<td style="text-align:center; vertical-align: top;"><input type="hidden" name="zoneType" value="slaveZoneType" /><input type="submit" name="" value="create" class="btn btn-primary btn-input-padded-responsive" /></td>
			</tr>
			<tr>
				<td style="font-size:11px;">/Example: cloudns.net/</td>
				<td style="font-size:11px;">/Example: 127.0.0.1/</td>
				<td></td>
			</tr>
		</table>
		<br />
		<p>
			* Manage the records from your master server<br />
		</p>
	</form>
</div>