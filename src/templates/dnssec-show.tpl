{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="./"}
{/if}

{include file="$path/header-settings.tpl"}

<form method="post" class="fo-form from-inline" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=dnssec-activate&zone={$zone}">
	
	<h3>Status: inactive</h3>
	<br class="clear">

	<div class="notification">
		DNSSEC strengthens authentication in DNS using digital signatures based on public key cryptography. DNSSEC protected zones are cryptographically signed
		to ensure the DNS records received are identical to the DNS records published by the domain owner.
	</div>
	<br class="clear">
	<input type="submit" name="activate_dnssec" id="activate_dnssec" value="Activate DNSSEC" class="btn btn-primary btn-input-padded-responsive" />
</form>