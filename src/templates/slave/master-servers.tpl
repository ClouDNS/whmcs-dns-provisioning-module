{assign var="path" value="../modules/servers/cloudns/templates/slave"}
{if $version gte '6'}
	{assign var="path" value="."}

<style type="text/css">
{literal}
	
	#masterIP.form-control {
		width: auto;
		display: inline-block;
	}
	
	.btn {
		margin-bottom: 3px;
	}
	
{/literal}
</style>
{/if}
{include file="$path/slave-header-settings.tpl"}

{assign var="path" value="images/"}
{if $version gte '6'}
	{assign var="path" value="./assets/img/"}
{/if}

<table class="table table-hover pull-left masterServers">

<tbody>


{foreach from=$masterServers key=id item=ip}
		<tr>
			<td>{$ip|@htmlspecialchars}</td>
			<td class="text-right masterServerDelete">
				<a href="clientarea.php?action=productdetails&id={$serviceid}&customAction=delete-master-servers&zone={$zone}&master_server_id={$id}"><img src="{$path}statusfailed.gif" alt="" title="Delete this master server"/></a>
			</td>
		</tr>
{/foreach}

	<tr class="newMasterServer" style="background-color:#cdcdcd;">
		<td colspan="2">
			<form method="post" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=add-master-servers&zone={$zone}" >
				<span class="pull-left">Add new master server:&nbsp;</span>
					<input id="masterIP" class="form-control" title="" type="text" name="masterIP" class="pull-left" value="" />
					<input type="submit" name="master_server_add" value="Add" class="btn btn-primary btn-input-padded-responsive" />
			</form>
		</td>
	</tr>
</tbody>
</table>
<div class="clear"></div>