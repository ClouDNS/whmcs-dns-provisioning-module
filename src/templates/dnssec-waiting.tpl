<script>
{literal}
	var dots = window.setInterval( function() {
		var wait = document.getElementById("wait");
		if ( wait.innerHTML.length > 3 ) 
			wait.innerHTML = "";
		else 
			wait.innerHTML += ".";
	}, 500);
{/literal}
</script>

{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="./"}
{/if}

{include file="$path/header-settings.tpl"}
<meta http-equiv="refresh" content="10" >

<h3>Status: in progress<span id="wait">.</span></h3>

Currently we are generating the keys and signatures of your zone. It may take up to few minutes until the DNSSEC is deployed.
