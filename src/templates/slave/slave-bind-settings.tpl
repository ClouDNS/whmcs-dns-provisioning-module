{assign var="path" value="../modules/servers/cloudns/templates/slave"}
{if $version gte '6'}
	{assign var="path" value="."}
{/if}
{include file="$path/slave-header-settings.tpl"}

<div style="width: 100%;">

<div style="text-align: left;">
<pre class="slaveConfig">
{literal}
zone "{/literal}{$zone}{literal}" {
	type master;

	# your parameters ...

	allow-transfer {
{/literal}{$ipv4}{literal}

		# If you use IPv6:
{/literal}{$ipv6}{literal}	};

	also-notify {
{/literal}{$ipv4}{literal}

		# If you use IPv6:
{/literal}{$ipv6}{literal}	};
};
{/literal}
</pre>
</div>
</div>	