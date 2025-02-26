{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="."}
	
<style type="text/css">
	{literal}
		
	.form-control{
		width: auto;
		
	}
	
	td {
		flex: 1 0 235px;
	}
	
	.small, small {
		font-style: italic;
		color: #777;
	}
	
	.table>tbody>tr>th {
		vertical-align: middle;
		white-space: nowrap;
	}
	
	tr {
		flex-wrap: wrap;
		align-items: center;
	}
	
	@media only screen and (max-width: 650px) {
		table, thead, tbody, th, td, tr { 
			display: block; 
		}
		
		.text-right {
			text-align: left;
		}
		
		.table>tbody>tr>th,
		.table>tbody>tr>td{
			border-top: none;
			padding: 0;
		}
		
		.table>tbody>tr>td {
			margin-bottom: 15px;
		}
		
		.form-control {
			width: 100%;
		}
	}
	
	{/literal}
</style>

{/if}
{include file="$path/header-settings.tpl"}


<form action="clientarea.php?action=productdetails&id={$serviceid}&customAction=edit-soa-settings&zone={$zone}" method="post">
	<table class="table">
		<tr>
			<th class="text-right">Serial:</th>
			<td>{$soa.serialNumber|@htmlspecialchars}</td>
		</tr>
		<tr>
			<th class="text-right">Primary NS:</th>
			<td><input class="form-control" type="text" name="primaryNS" value="{$soa.primaryNS|@htmlspecialchars}" /></td>
		</tr>
		<tr>
			<th class="text-right">DNS admin e-mail:</th>
			<td><input class="form-control" type="text" name="adminMail" value="{$soa.adminMail|@htmlspecialchars}" /></td>
		</tr>
		<tr>
			<th class="text-right">Refresh rate:</th>
			<td><input class="form-control" type="text" name="refresh" value="{$soa.refresh|@htmlspecialchars}" /><small> From 1200 to 43200 seconds</small></td>
		</tr>
		<tr>
			<th class="text-right">Retry rate:</th>
			<td><input class="form-control" type="text" name="retry" value="{$soa.retry|@htmlspecialchars}" /><small> From 180 to 2419200 seconds</small></td>
		</tr>
		<tr>
			<th class="text-right">Expire time:</th>
			<td><input class="form-control" type="text" name="expire" value="{$soa.expire|@htmlspecialchars}" /><span><small> From 1209600 to 2419200 seconds</small></span></td>
		</tr>
		<tr>
			<th class="text-right">Default TTL:</th>
			<td><input class="form-control" type="text" name="defaultTTL" value="{$soa.defaultTTL|@htmlspecialchars}" /></td>
		</tr>
		<tr>
			<th></th>
			<td>
				<input type="submit" class="btn btn-primary btn-input-padded-responsive" name="do_save" value="Save" /> 
				<input type="submit" class="btn btn-primary btn-input-padded-responsive" name="do_reset" value="Reset" />
			</td>
		</tr>
	</table>
</form>
		
