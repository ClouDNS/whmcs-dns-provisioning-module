<style type="text/css">
{literal}
	.w-50{
		width: 50%;
	}

	.mTitle {
		display: none;
	}
		
	.text-center {
		text-align: center;
	}
	
	.mt-8 {
		margin-top: 8px;
	}
	
	.inputLabel {
		width: auto;
		min-width: 40%;
	}
	
	.fo-domain {
		max-width: 100%;
	}
	
	.fo-port {
		max-width: 60px;
	}
	
	.fo-path {
		max-width: 20%;
	}
	
	.flex {
		display: flex;	
		flex: 1 0 auto;
		align-items:center;
		white-space: nowrap;
		flex-wrap: wrap;
		height: auto;
	}
	
	.flex input, .flex select {
		flex: 1 0 235px;
	}
	
	.mobileInfo {
		position: relative;
	}

	.mobileInfo .title {
		position: absolute;
		top: 20px;
		background: black;
		color: white;
		padding: 4px;
		left: 0;
		white-space: nowrap;
	}
	
	.popover {
		max-width: 100%;
	}
	
	@media only screen and (max-width: 650px) {
		.dTitle {
			display: none;
		}
		
		.mTitle {
			display: block;
		}
		
		.fo-domain, 
		.fo-port,
		.fo-path {
			max-width: none;
			width: 100%;
		}
	}
{/literal}
</style>

<script>
{literal}
	$(document).ready (function() {
		failoverChangeType();
		zone_failoverChangeDownEvent();
                toggleCustomStringOptions();
                toggleProtocolOptions();
		
		var element = '.mTooltip';
		$(element).popover({
		});

		$('body').on('click', function (e) {
				
			$(element).each(function(index, elm) {
				hidePopover(elm, e);
			}); 
		});

		var hidePopover = function(element, e){
			if (!$(element).is(e.target) && $(element).has(e.target).length === 0 && $('.popover').has(e.target).length === 0){
				$(element).popover('hide');
			}
		};
	});
	
	function failoverChangeType() {
		var foType = parseInt($('#fo_check_type').val());
		$('.monitoringType').css('display', 'none');
		$('.monitoringType' + foType).css('display', '');

		var foHttpPort = parseInt($('#fo_http_port').val());

		// http
		if ((foType === 4 || foType === 6) && foHttpPort === 443) {
		$('#fo_http_port').val(80);
		}

		// https
		if ((foType === 5 || foType === 7) && foHttpPort === 80) {
			$('#fo_http_port').val(443);
		}
	}
	function zone_failoverChangeDownEvent() {
		var downEventHandler = $('#fo_down_event_handler').val();
		$('.monitoringDownEvent').css('display', 'none');
		$('.monitoringDownEvent' + downEventHandler).css('display', '');

		// down event handler - monitoring
		if (downEventHandler == 0) {
			$('#fo_up_handler_active').attr('disabled', 'disabled');
		} else {
			$('#fo_up_handler_active').removeAttr('disabled');
		}
	}
        
        function toggleCustomStringOptions () {
                if ($('#web_custom_string_yes').is(':checked')) {
                        $('.customStringOptions').css('display', 'block');
                } else {
                        $('.customStringOptions').css('display', 'none');
                }
        }
        
        function toggleProtocolOptions () {
                if ($('#web_protocol_https').is(':checked')) {
                        $('.protocol-type').html('https');
                } else if ($('#web_protocol_http').is(':checked')){
                        $('.protocol-type').html('http');
                }
        }
{/literal}
</script>

{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="./"}
{/if}

{include file="$path/header-settings.tpl"}

<form method="post" class="from-inline" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=failover-edit&zone={$zone}&dns_record_id={$record.id}">
	
	<div class="pull-left inputTitle fleft">Settings for <strong>{$fullHost}</strong> with current <strong>{$record.type}</strong> record to IP <strong>{$record.record}</strong></div>
	<br />
	<br />
	<br class="clear">
	<div class="flex">
		<label class="pull-left inputLabel fleft">Main IP:</label>
		<input id="fo_main_ip" name="fo_main_ip" type="text" value="{$failover.main_ip|@htmlspecialchars}" class="input-text form-control" />
		<span class="info dTitle">
			<img src="./assets/img/help.gif" class="showTitle" title="This is the main IP address which will be monitored and the failover will manage" alt="[?]">
		</span>
		<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="This is the main IP address which will be monitored and the failover will manage" alt="[?]">
			<img src="./assets/img/help.gif">
		</span>
	</div>
	<br class="clear">
	
	<div class="flex">
		<label class="pull-left inputLabel fleft">Monitoring type:</label>
		<select id="fo_check_type" name="fo_check_type" class="pull-left form-control" onChange="failoverChangeType();">
		{foreach $checkTypes as $id=>$name}
			<option value="{$id}" {if $id == $failover.check_type} selected="selected"{/if}>{$name}</option>
		{/foreach}
		</select>
		<span class="info dTitle">
			<img src="./assets/img/help.gif" class="showTitle" title="Choose the check which will be monitored to the main and backup IPs" alt="[?]" />
		</span>
		<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="Choose the check which will be monitored to the main and backup IPs" alt="[?]">
			<img src="./assets/img/help.gif">
		</span>
	</div>
	<br class="clear">
        <div class="flex monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_WEB} failover-notifications">
		<label class="pull-left inputLabel fleft">Protocol:</label>
                <div class="flex">
                    <label class="w-50" onclick="toggleProtocolOptions();"><input class="inputRadio pull-left" type="radio" name="web_protocol" id="web_protocol_https" value="https" {if !isset($failover.check_settings.http_protocol) || isset($failover.check_settings.http_protocol) && $failover.check_settings.http_protocol == 'https'} checked="checked"{/if}> HTTPS</label>
                    <label class="flex-element" onclick="toggleProtocolOptions();"><input class="inputRadio pull-left" type="radio" name="web_protocol" id="web_protocol_http" value="http" {if isset($failover.check_settings.http_protocol) && $failover.check_settings.http_protocol == 'http'} checked="checked"{/if}> HTTP</label>
                </div>
                <span class="info dTitle">
			<img src="./assets/img/help.gif" class="showTitle" title="Choose your desired protocol" alt="[?]" />
		</span>
                <span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="Choose your desired protocol" alt="[?]">
			<img src="./assets/img/help.gif">
		</span>
                <br class="clear">
	</div>
        <br class="clear monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_WEB}">
        <div class="flex monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_WEB}">
		<label class="pull-left inputLabel fleft">Custom string:</label>
                <div class="flex">
                    <label class="w-50" onclick="toggleCustomStringOptions();"><input class="inputRadio pull-left" type="radio" name="web_custom_string" id="web_custom_string_yes" value="1" {if isset($failover.check_settings.content) && $failover.check_settings.content != ''} checked="checked"{/if}> Yes</label>
                    <label class="flex-element" onclick="toggleCustomStringOptions();"><input class="inputRadio pull-left" type="radio" name="web_custom_string" id="web_custom_string_no" value="0" {if !isset($failover.check_settings.content)} checked="checked"{/if}> No</label>
                </div>
                <span class="info dTitle">
			<img src="./assets/img/help.gif" class="showTitle" title="If you want to check a custom string on the web page, mark YES" alt="[?]" />
		</span>
                <span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="If you want to check a custom string on the web page, mark YES" alt="[?]">
			<img src="./assets/img/help.gif">
		</span>
                <br class="clear">
	</div>
        <br class="clear monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_WEB}">
	
	<div class="flex">
		<label class="pull-left inputLabel fleft">Monitoring region:</label>
		<select id="fo_monitoring_region" name="fo_monitoring_region" class="pull-left form-control">
			<option value="global" {if $failover.check_region == 'global'} selected="selected"{/if}>Global</option>
			<option value="eur" {if $failover.check_region == 'eur'} selected="selected"{/if}>Europe</option>
			<option value="nam" {if $failover.check_region == 'nam'} selected="selected"{/if}>North America</option>
		</select>
		<span class="info dTitle">
			<img src="./assets/img/help.gif" class="showTitle" title="The record will be monitored only from this area" alt="[?]" />
		</span>
		<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="The record will be monitored only from this area" alt="[?]">
			<img src="./assets/img/help.gif">
		</span>
	</div>
	<br class="clear">

	<div class="monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_WEB}">
		<label class="pull-left inputLabel fleft dTitle">URL to check:</label>
		<label class="pull-left inputLabel fleft mTitle">Domain:</label>
		<br class="clear">
		<div class="flex">
                        <span class="protocol-type">http</span><span class="monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_HTTPS} monitoringType{Cloudns_Failover::CHECK_TYPE_HTTPS_CUSTOM}">s</span>://&nbsp;
			<input id="fo_http_host" name="fo_http_host" class="form-control fo-domain" value="{if isset($failover.check_settings.host)}{$failover.check_settings.host|@htmlspecialchars}{else}{$fullHost}{/if}" type="text" placeholder="FQDN"><span class="dTitle">&nbsp;:&nbsp;</span>
			<label class="pull-left inputLabel fleft mTitle"><br>Port:</label>
			<input id="fo_http_port" name="fo_http_port" class="form-control fo-port" type="text" value="{if isset($failover.check_settings.port)}{$failover.check_settings.port|@htmlspecialchars}{else}80{/if}" placeholder="port"><span class="dTitle">&nbsp;/&nbsp;</span>
			<label class="pull-left inputLabel fleft mTitle"><br>Path:</label>
			<input id="fo_http_path" name="fo_http_path" class="form-control fo-path" type="text" value="{if isset($failover.check_settings.path)}{$failover.check_settings.path|@htmlspecialchars}{else} {/if}" placeholder="Path">
			<span class="info dTitle">
				<img src="./assets/img/help.gif" class="showTitle" title="The FQDN will be monitored on the main and backup IPs" alt="[?]" />
			</span>
			<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="The FQDN will be monitored on the main and backup IPs" alt="[?]">
				<img src="./assets/img/help.gif">
			</span>
		</div>
		<br class="clear">
	</div>
	
	<div class="monitoringType customStringOptions" style="display:none">
		<div class="flex">
			<label class="pull-left inputLabel fleft">String to match:</label>
			<input id="fo_http_content" name="fo_http_content" type="text" class="input-text form-control" value="{if isset($failover.check_settings.content)}{$failover.check_settings.content|@htmlspecialchars}{else} {/if}" placeholder="OK">
			<span class="info dTitle">
				<img src="./assets/img/help.gif" class="showTitle" title="The content returned by the checked URL should be equal to this string." alt="[?]" />
			</span>
			<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="The content returned by the checked URL should be equal to this string." alt="[?]">
				<img src="./assets/img/help.gif">
			</span>
		</div>
		<br class="clear">
	</div>
                        
        <div class="flex monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_PING}">
                <label class="pull-left inputLabel fleft">Threshold:</label>
                <select id="fo_ping_threshold" name="fo_ping_threshold" class="pull-left form-control">
                    {foreach Cloudns_Failover::MONITORING_PING_THRESHOLD as $threshold}
			<option value="{$threshold}" {if isset($failover.check_settings.ping_threshold) && $failover.check_settings.ping_threshold == $threshold} selected="selected"{/if}>{$threshold}%</option>  
                    {/foreach}
                </select>
                <span class="info dTitle">
			<img src="./assets/img/help.gif" class="showTitle" title="Choose your preferred threshold for packet loss." alt="[?]" />
		</span>
                <span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="Choose your preferred threshold for packet loss." alt="[?]">
			<img src="./assets/img/help.gif">
		</span>
	</div>
        <br class="clear monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_PING}">
	
	<div class="monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_TCP_SOCKET} monitoringType{Cloudns_Failover::CHECK_TYPE_UDP_SOCKET}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Port:</label>
			<input id="fo_port" name="fo_port" type="text" class="input-text form-control" value="{if isset($failover.check_settings.port)}{$failover.check_settings.port|@htmlspecialchars}{else} {/if}" placeholder="Port number">
			<span class="info dTitle">
				<img src="./assets/img/help.gif" class="showTitle" title="The port number to which the TCP or UDP check will be made." alt="[?]" />
			</span>
			<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="The port number to which the TCP or UDP check will be made." alt="[?]">
				<img src="./assets/img/help.gif">
			</span>
			
		</div>
		<br class="clear">
	</div>
			
	<div class="monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_DNS}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Host to query:</label>
			<input id="fo_dns_host" name="fo_dns_host" type="text" class="input-text form-control" {if isset($failover.check_settings.host)}value="{$failover.check_settings.host|@htmlspecialchars}"{else} {/if} placeholder="FQDN">
			<span class="info dTitle">
				<img src="./assets/img/help.gif" class="showTitle" title="The FQDN for which the DNS check will be made." alt="[?]" />
			</span>
			<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="The FQDN for which the DNS check will be made." alt="[?]">
				<img src="./assets/img/help.gif">
			</span>
		</div>
		<br class="clear">
	</div>
	
	<div class="monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_DNS}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Query type:</label>
			<select id="fo_dns_type" name="fo_dns_type" class="pull-left form-control">
				<option value="A" {if isset($failover.check_settings.query_type) && $failover.check_settings.query_type == 'A'} selected="selected" {elseif !isset($failover.check_settings.query_type) && $record.type == 'A'} selected="selected" {else} {/if}>A</option>
				<option value="AAAA" {if isset($failover.check_settings.query_type) && $failover.check_settings.query_type == 'AAAA'} selected="selected" {elseif !isset($failover.check_settings.query_type) && $record.type == 'AAAA'} selected="selected" {else} {/if}>AAAA</option>
			</select>
			<span class="info dTitle">
				<img src="./assets/img/help.gif" class="showTitle" title="DNS query type for the DNS check." alt="[?]" />
			</span>
			<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="DNS query type for the DNS check." alt="[?]">
				<img src="./assets/img/help.gif">
			</span>
		</div>
		<br class="clear">
	</div>
			
	<div class="monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_DNS}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Required response:</label>
			<input id="fo_dns_response" name="fo_dns_response" type="text" class="input-text form-control" {if isset($failover.check_settings.response)} value="{$failover.check_settings.response|@htmlspecialchars}" {else} {/if} placeholder="Response to the query">
			<span class="info dTitle">
				<img src="./assets/img/help.gif" class="showTitle" title="Expected response for the DNS check." alt="[?]" />
			</span>
			<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="Expected response for the DNS check." alt="[?]">
				<img src="./assets/img/help.gif">
			</span>
		</div>
		<br class="clear">
	</div>
			
	<div class="flex">
		<label class="pull-left inputLabel fleft">If the main IP is down:</label>
		<select id="fo_down_event_handler" name="fo_down_event_handler" class="pull-left form-control" onchange="zone_failoverChangeDownEvent()">
			<option value="{Cloudns_Failover::DOWN_EVENT_HANDLER_MONITORING}" {if $failover.down_event_handler == Cloudns_Failover::DOWN_EVENT_HANDLER_MONITORING} selected="selected" {/if}>Monitoring only, e-mail notification</option>
			<option value="{Cloudns_Failover::DOWN_EVENT_HANDLER_PASSIVE}" {if $failover.down_event_handler == Cloudns_Failover::DOWN_EVENT_HANDLER_PASSIVE} selected="selected" {/if}>Deactivate the DNS record</option>
			<option value="{Cloudns_Failover::DOWN_EVENT_HANDLER_ACTIVE}" {if $failover.down_event_handler == Cloudns_Failover::DOWN_EVENT_HANDLER_ACTIVE} selected="selected" {/if}>Replace with working backup IP</option>
		</select>
	</div>
	<br class="clear">
	
	<div class="monitoringDownEvent monitoringDownEvent{Cloudns_Failover::DOWN_EVENT_HANDLER_ACTIVE}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Backup IP 1:</label>
			<input id="fo_backup_ip_1" name="fo_backup_ip_1" type="text" class="input-text form-control" placeholder="Required" value="{$failover.backup_ip_1|@htmlspecialchars}">
			<span class="info dTitle">
				<img src="./assets/img/help.gif" class="showTitle" title="IP to be changed to if the main IP is down" alt="[?]" />
			</span>
			<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="IP to be changed to if the main IP is down" alt="[?]">
				<img src="./assets/img/help.gif">
			</span>
		</div>
		<br class="clear">
	</div>
	<div class="monitoringDownEvent monitoringDownEvent{Cloudns_Failover::DOWN_EVENT_HANDLER_ACTIVE}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Backup IP 2:</label>
			<input id="fo_backup_ip_2" name="fo_backup_ip_2" type="text" class="input-text form-control" value="{$failover.backup_ip_2|@htmlspecialchars}" placeholder="Optional">
		</div>
			<br class="clear">
	</div>
	<div class="monitoringDownEvent monitoringDownEvent{Cloudns_Failover::DOWN_EVENT_HANDLER_ACTIVE}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Backup IP 3:</label>
			<input id="fo_backup_ip_3" name="fo_backup_ip_3" type="text" class="input-text form-control" value="{$failover.backup_ip_3|@htmlspecialchars}" placeholder="Optional">
		</div>
		<br class="clear">
	</div>
	<div class="monitoringDownEvent monitoringDownEvent{Cloudns_Failover::DOWN_EVENT_HANDLER_ACTIVE}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Backup IP 4:</label>
			<input id="fo_backup_ip_4" name="fo_backup_ip_4" type="text" class="input-text form-control" value="{$failover.backup_ip_4|@htmlspecialchars}" placeholder="Optional">
		</div>
		<br class="clear">
	</div>
	<div class="monitoringDownEvent monitoringDownEvent{Cloudns_Failover::DOWN_EVENT_HANDLER_ACTIVE}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Backup IP 5:</label>
			<input id="fo_backup_ip_5" name="fo_backup_ip_5" type="text" class="input-text form-control" value="{$failover.backup_ip_5|@htmlspecialchars}" placeholder="Optional">
		</div>
		<br class="clear">
	</div>
		
	<div class="flex">
		<label class="pull-left inputLabel fleft">If the main IP is up:</label>
		<select id="fo_up_event_handler" name="fo_up_event_handler" class="pull-left form-control">
			<option value="{Cloudns_Failover::BACK_UP_EVENT_HANDLER_MONITORING}" {if $failover.up_event_handler == Cloudns_Failover::BACK_UP_EVENT_HANDLER_MONITORING} selected="selected" {/if}>Monitoring only, e-mail notification</option>
			<option value="{Cloudns_Failover::BACK_UP_EVENT_HANDLER_MANUAL}" {if $failover.up_event_handler == Cloudns_Failover::BACK_UP_EVENT_HANDLER_MANUAL} selected="selected" {/if}>Do not monitor it, if it is back up</option>
			<option id="fo_up_handler_active" value="{Cloudns_Failover::BACK_UP_EVENT_HANDLER_AUTOMATIC}" {if $failover.up_event_handler == Cloudns_Failover::BACK_UP_EVENT_HANDLER_AUTOMATIC} selected="selected" {/if}>Activate the main IP for the DNS record</option>
		</select>
	</div>
	<br class="clear">
	<div style="align: right">
		<input type="submit" name="activate_fo" id="activate_fo" value="Modify" class="btn btn-primary btn-input-padded-responsive" />
	</div>
	<br class="clear">
</form>

<br class="clear">
<br class="clear">
		
<div class="flex fo-form">
	<form method="post" class="fo-form from-inline" style="margin-right:2px" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=failover-action-log&zone={$zone}&dns_record_id={$record.id}">
		<input type="submit" name="fo_action_log" value="Failover DNS history" class="btn btn-primary btn-block btn-input-padded-responsive" />
	</form>
	<form method="post" class="fo-form from-inline" style="margin-right:2px" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=failover-monitoring-log&zone={$zone}&dns_record_id={$record.id}">
		<input type="submit" name="fo_monitoring_log" value="Monitoring history" class="btn btn-primary btn-block btn-input-padded-responsive" />
	</form>
        <form method="post" class="fo-form from-inline" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=failover-monitoring-notifications&zone={$zone}&dns_record_id={$record.id}">
		<input type="submit" name="fo_monitoring_log" value="Notifications" class="btn btn-primary btn-block btn-input-padded-responsive" />
	</form>
</div>

<br class="clear">
<br class="clear">
<br class="clear">

<div class="text-center fo-form">
	<form method="post" class="from-inline" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=failover-deactivate&zone={$zone}&dns_record_id={$record.id}">
		<input type="submit" name="fo_monitoring_log" value="Deactivate this DNS Failover and Monitoring check" class="btn btn-danger btn-md btn-input-padded-responsive" />
	</form>
</div>
		
<br class="clear">