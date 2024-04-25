<style type="text/css">
{literal}
	.green {
		color: #48b300;
	}
	
	.red {
		color: #f10000;
	}
	
	.grey {
		color: grey;
	}
	
	.blue {
		color: blue;
	}
	
	.bold {
		font-weight: bold;
	}	
{/literal}
</style>

{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="./"}
{/if}

{include file="$path/header-settings.tpl"}

<h2>Monitoring history</h2>
{if !$monitoringLog}
	<p>Missing history information</p>
{else}
<table class="table table-list dataTable no-footer dtr-inline" cellspacing="0" cellpadding="0">
	<tr>
		<th>Date</th>
		<th>Status</th>
		<th>IP address</th>
		<th>Location</th>
	</tr>
	<tbody>
		{* This var comes from actions.php and is the body of the table *}
		{$monitoringLogTable}
	</tbody>
</table>
{/if}

<form method="post" class="from-inline" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=get-failover-settings&zone={$zone}&dns_record_id={$record.id}">
	
	<input type="submit" name="fo_action_log" value="« Back to Failover settings" class="btn btn-primary btn-input-padded-responsive" />
</form>