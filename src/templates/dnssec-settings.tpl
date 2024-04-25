<style type="text/css">
{literal}
	.dnssec-digest,
	.dnssec-ds {
		word-break: break-word;
	}
{/literal}
</style>

{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="./"}
{/if}

{include file="$path/header-settings.tpl"}

<form method="post" class="fo-form from-inline" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=dnssec-deactivate&zone={$zone}">
	
	<h3>Status: active</h3>
	<br class='clear'>
	<h4><strong>DS Records:</strong></h4>
	<div class = "table-responsive">
	<table class="table table-hover dnssec-ds">
		{foreach $dnssec['ds'] as $ds} 
			<tr>
				<td class='text-left dnssec-digest'>
					{$ds}
				</td>
			</tr>
		{/foreach}
	</table>
	</div>
	<br class='clear'>
	<div class = "table-responsive">
	<table class="table table-hover dataTable no-footer dtr-inline">
		<thead>
			<tr>
				<th class='text-left'>Key Tag:</th>
				<th class='text-left'>Algorithm</th>
				<th class='text-left'>Digest Type:</th>
				<th class='text-left'>Digest:</th>
			</tr>
		</thead>
		<tbody>
			{foreach $dnssec['ds_records'] as $ds_records}
				<tr>
					<td class='text-left text-nowrap' style='width: 10%'>{$ds_records['key_tag']}</td>
					<td class='text-left text-nowrap' style='width: 20%'>{$ds_records['algorithm_name']} ({$ds_records['algorithm']})</td>
					<td class='text-left text-nowrap' style='width: 20%'>{$ds_records['digest_type_name']} ({$ds_records['digest_type']})</td>
					<td>
						<span class="dnssec-digest">{$ds_records['digest']}</span>
					</td>
				</tr>	
			{/foreach}
		</tbody>
	</table>
	</div>
	<br class='clear'>
	<h4><strong>DNSKEY Records:</strong></h4>
	<div class = "table-responsive">
	<table class="table table-hover dataTable no-footer dtr-inline" cellspacing="0" width="100%" id='dnskey'>
		<tbody>
			{foreach $dnssec['dnskey'] as $dnskey}
				<tr>
					<td class='text-left text-nowrap'>{$dnskey}</td>
				</tr>
			{/foreach}
		</tbody>
	</table>
	</div>
	<br class='clear'>
	<div class="notification">
		DNSSEC strengthens authentication in DNS using digital signatures based on public key cryptography. DNSSEC protected zones are cryptographically signed
		to ensure the DNS records received are identical to the DNS records published by the domain owner.
	</div>
	<br class="clear">
	<input type="submit" name="deactivate_dnssec" id="activate_dnssec" value="Deactivate" class="btn btn-primary btn-input-padded-responsive" />
</form>