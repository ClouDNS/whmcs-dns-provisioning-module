{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="."}
{/if}
{if $zoneInfo.type == 'master'}
	{include file="$path/header-settings.tpl"}
{else}
	{include file="$path/slave/slave-header-settings.tpl"}
{/if}
<div class="text-left"><a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=statistics&zone={$zone}&date=last-30-days">Last 30 days</a> | <a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=statistics&zone={$zone}">Yearly statistics</a> {$statLinks}</div>
<div class="clear"></div><br />
<table class="table table-bordered table-hover" cellspacing="0" cellpadding="0">
	<tr class="active">
		<th colspan="2">{$requests|@number_format} Requests</th>
	</tr>
	<tbody>
		{* This var comes from actions.php and is the body of the table *}
		{$statsTable}
	</tbody>
</table>
