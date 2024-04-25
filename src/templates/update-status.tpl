{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="./"}
{/if}

{if $zoneInfo.type == 'master'}
	{include file="$path/header-settings.tpl"}
{else}
	{include file="$path/slave/slave-header-settings.tpl"}
{/if}

{assign var="path" value="images/"}
{if $version gte '6'}
	{assign var="path" value="./assets/img/"}
{/if}

{if isset($response.status) && $response.status=='success'}
<div class="notification">{$response.description}</div><br />
<br />
{/if}

<div>{if $updated === true}<img src="{$path}statusok.gif" title="Updated" /> Your DNS zone <b>{$zone}</b> is <b>up to date</b> on all servers.{else}<img src="{$path}loadingsml.gif" title="Not yet updated" /> Your DNS zone <b>{$zone}</b> is still <b>in update process</b> and all changes will be deployed soon.{/if}</div>
	<br />
	<a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=update&zone={$zone}" class="btn btn-primary btn-input-padded-responsive">
		Request new update
	</a>
{literal}
	<script type="text/javascript">
		 window.setTimeout(function(){ document.location.reload(true); }, 60000);
	</script>
{/literal}