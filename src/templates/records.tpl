
{* the pats are different for the different versions *}
{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="./"}

<style type="text/css">
{literal}
	
	.addNewRecordMobile {
		display: none;
	}

	@media only screen and (max-width: 650px) {
		
		.addNewRecord {
			display: none;
		}
		
		.addNewRecordMobile {
			display: inline-block;
			width: 100%;
			text-align: center;
			
		}
		
		.table-bordered>thead>tr>td, 
		.table-bordered>thead>tr>th {
			border-bottom-width: 0px;
		}
		
		.overflow .overflowDiv {
			width: 100% !important;
			position: unset !important;
		}
		
		.overflow .overflowDiv.overflowRecordRecord {
			max-width: 500px !important;
			position: unset !important;
		}
	}

	
{/literal}
</style>


{/if}

{include file="$path/header-settings.tpl"}

{* we rewrite the $path var, because its current value is needed only above *}
{assign var="path" value="images/"}
{if $version gte '6'}
	{assign var="path" value="./assets/img/"}
{/if}

{if $error}
	<div class="notification">You have reached your limit of {$recordsLimit} records per zone.</div><br />
{/if}

<form method="post" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=zone-settings&zone={$zone}">
	<div class="fleft" style="padding-top: 3px;">Filter: &nbsp;</div> <select style="" name="recordsType" id="recordsType" class="form-control pull-left" onChange="this.form.submit();">
	<option value="all">All records</option>
	{foreach from=$recordTypes key=key item=recordType}
		<option value="{$recordType}" {if $recordType == $defaultType} selected="selected" {/if}>{if $recordType == 'WR'}Web Redirect{else}{$recordType}{/if}</option>
	{/foreach}
</select>

{if $recordsCount gt '0'}
	<div class="fright" style="padding-top: 3px;">Records Count: {$recordsCount}</div>
{/if}
</form>
<div class="clear"></div>
<br />
<div class = "table-responsive">
<table class="table-bordered table-hover table dns-records" id="table-records">
	<thead>
	<tr class="active" style="background-color: #f5f5f5;">
		<th>Host</th>
		<th>Type</th>
		<th>Points to</th>
		<th class="ttl">TTL</th>
		<th class="addNewRecord text-right">
			<img class="pull-left" src="{$path}add.gif" />
			<a class="pull-left" href="clientarea.php?action=productdetails&id={$serviceid}&customAction=add-new-record&zone={$zone}{if $defaultType != 'all'}&type={$defaultType}{/if}">add new</a>
		</th>
		<th class="addNewRecordMobile" style="border-left-width: 0px;">
			<a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=add-new-record&zone={$zone}{if $defaultType != 'all'}&type={$defaultType}{/if}"><img class="image-link" src="{$path}add.gif" /></a>
		</th>
	</tr>
	</thead>
	<tbody>
{if empty($records)}
	{if $defaultType == 'all'}
		<tr><td colspan="5">There are no records!</td></tr>
	{else}
		<tr><td colspan="5">There are no {$defaultType} records!</td></tr>
	{/if}
{/if}
{foreach from=$records item=record}
	<tr>
		<td class="overflow" title="{$record.shortHost.title|@htmlspecialchars}"><div class="overflowDiv"><div>{$record.shortHost.title|@htmlspecialchars}</div></div></td>
		<td>{$record.type}</td>
		<td class="overflow" title="{$record.record|@htmlspecialchars}"><div class="overflowDiv overflowRecordRecord"><div>{$record.shortRecord.title|@htmlspecialchars}</div></div></td>
		<td>{$record.ttl_seconds}</td>
		<td class="text-right">
			{if $failoverChecks > 0 && $foColumn == 1}
			{if $record.type == 'A' || $record.type == 'AAAA'}
			<a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=get-failover-settings&zone={$zone}&dns_record_id={$record.id}" {if $record.failover == '1'} title="Edit DNS Failover & Monitoring" {else} title="Activate DNS Failover & Monitoring"{/if}>
				{if $record.failover == '1'}
					<img src="{$path}hosting.gif" /></a>
				{else}
					<img src="{$path}hosting.gif" style="opacity: 0.5;" /></a>
				{/if}
			{/if}
			{/if}
			<a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=edit-record&zone={$zone}&dns_record_id={$record.id}" title="Edit this record">
				<img src="{$path}supporttickets.gif" /></a>
				
			<a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=delete-record&zone={$zone}&record={$record.id}" title="Delete this record" onclick="return confirm('Are you sure you want to delete this record?');">
				<img src="{$path}statusfailed.gif" /></a>
		</td>
	</tr>
{/foreach}
	</tbody>
</table>
</div>