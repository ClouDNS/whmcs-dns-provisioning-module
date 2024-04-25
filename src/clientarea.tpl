
{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="./templates/"}
{/if}

{if ($cloudAction eq 'zone-settings')}
	{if isset($zoneInfo) && isset($zoneInfo.type) && $zoneInfo.type eq 'slave'}
		{include file="$path/slave/master-servers.tpl"}
	{else}
		{include file="$path/records.tpl"}
	{/if}
	
{elseif $cloudAction eq 'delete-record'}
	{include file="$path/records.tpl"}
	
{elseif $cloudAction eq 'add-new-record'}
	{include file="$path/add-new-record.tpl"}
	
{elseif $cloudAction eq 'add-record'}
	{include file="$path/add-new-record.tpl"}
	
{elseif $cloudAction eq 'edit-record'}
	{include file="$path/edit-record.tpl"}
	
{elseif $cloudAction eq 'add-new-zone' || $cloudAction eq 'add-excisting-zone'}
	{include file="$path/add-new-zone.tpl"}
	
{elseif $cloudAction eq 'add-zone'}
	{include file="$path/add-new-zone.tpl"}
	
{elseif $cloudAction eq 'add-existing-zone'}
	{include file="$path/add-new-zone.tpl"}
	
{elseif $cloudAction eq 'soa-settings' || $cloudAction eq 'edit-soa-settings'}
	{include file="$path/soa.tpl"}
	
{elseif $cloudAction eq 'statistics'}
	{include file="$path/statistics.tpl"}
	
{elseif $cloudAction eq 'failover-new' || $cloudAction eq 'failover-activate'}
	{include file="$path/failover-new.tpl"}
	
{elseif $cloudAction eq 'failover-view' || $cloudAction eq 'failover-edit'}
	{include file="$path/failover-view.tpl"}
	
{elseif $cloudAction eq 'failover-action-log'}
	{include file="$path/failover-action-log.tpl"}
	
{elseif $cloudAction eq 'failover-monitoring-log'}
	{include file="$path/failover-monitoring-log.tpl"}
        
{elseif $cloudAction eq 'failover-monitoring-notifications'}
	{include file="$path/failover-monitoring-notifications.tpl"}
	
{elseif $cloudAction eq 'dnssec-show'}
	{include file="$path/dnssec-show.tpl"}
	
{elseif $cloudAction eq 'dnssec-settings'}
	{include file="$path/dnssec-settings.tpl"}
	
{elseif $cloudAction eq 'dnssec-waiting'}
	{include file="$path/dnssec-waiting.tpl"}	

{elseif $cloudAction eq 'import' || $cloudAction eq 'import-records'}
	{include file="$path/import.tpl"}
	
{elseif $cloudAction eq 'update-status'}
	{include file="$path/update-status.tpl"}
	
{elseif $cloudAction eq 'add-master-server' || $cloudAction eq 'delete-master-server'}
	{include file="$path/slave/master-servers.tpl"}
	
{elseif $cloudAction eq 'bind-settings'}
	{include file="$path/slave/slave-bind-settings.tpl"}
	
{elseif $cloudAction eq 'error'}
	{include file="$path/zone-error.tpl"}
	
{else}
	{include file="$path/zones.tpl"}
	
{/if}
