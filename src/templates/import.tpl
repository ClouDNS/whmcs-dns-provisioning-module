{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="./"}
{/if}

{include file="$path/header-settings.tpl"}



<form action="clientarea.php?action=productdetails&id={$serviceid}&customAction=import-records&zone={$zone}" method="post" class="importForm">
	<table class="table-bordered table import-table">
		<thead>
			<tr>
				<th colspan="2">Paste the records from your zone file here</th>
			</tr>
		</thead>
		
		<tbody>
			<tr>
				<th>Format:</th>
				<td>
					<label><input class="pull-left" type="radio" name="type" value="bind" checked="checked" />&nbsp; BIND</label>
					<label><input class="pull-left" type="radio" name="type" value="tinydns" />&nbsp; TinyDNS</label>
				</td>

			</tr>
			<tr>
				<th>Action:</th>
				<td>
					<label><input class="pull-left" title="The current records of the zone will be replaced by the new ones" type="checkbox" name="delete" value="1" />&nbsp; Delete all existing records</label>
				</td>
			</tr>
			<tr>
				<th>Records:</th>
				<td>
					<textarea class="form-control" name="recordsList"></textarea>
				</td>
			</tr>
		</tbody>
		
		<tfoot>
			<tr>
				<th></th>
				<td class="text-right" style="border-left: 0;">
					<input type="submit" class="btn btn-primary btn-input-padded-responsive" value="Import records">
				</td>
			</tr>
		</tfoot>
	</table>
</form>