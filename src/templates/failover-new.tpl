<style type="text/css">
{literal}
	.w-50{
		width: 50%;
	}
	
	.mTitle {
		display: none;
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
                failoverChangeNotifications();

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
        
        function failoverChangeNotifications () {
                var fo_notification = $('#fo_notification_type').val();
                var placeholder = '';
                
                $('.notificationType').css('display', 'none');
		$('.notificationType' + fo_notification).css('display', '');
                
                if (fo_notification == 1) {
                    placeholder = 'your_email@example.com';
                } else if (fo_notification == 2) {
                    placeholder = 'http://example.com?content=up';
                } else if (fo_notification == 3) {
                    placeholder = 'http://example.com?content=down';
                }
                
                $('#fo_notification_value').attr('placeholder', placeholder);
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
{/literal}
</script>
{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="./"}
{/if}

{include file="$path/header-settings.tpl"}

<form method="post" class="from-inline" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=failover-activate&zone={$zone}&dns_record_id={$record.id}">
	
	<div class="pull-left inputTitle fleft">Settings for <strong>{$fullHost}</strong> with current <strong>{$record.type}</strong> record to IP <strong>{$record.record}</strong></div>
	<br />
	<br />
	<br class="clear">
	<div class="flex">
		<label class="pull-left inputLabel fleft">Main IP:</label>
		<input id="fo_main_ip" name="fo_main_ip" type="text" value="{$record.record|@htmlspecialchars}" class="input-text form-control" />
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
			<option value="{$id}">{$name}</option>
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
	<div class="flex">
		<label class="pull-left inputLabel fleft">Monitoring region:</label>
		<select id="fo_monitoring_region" name="fo_monitoring_region" class="pull-left form-control">
			<option value="global">Global</option>
			<option value="eur">Europe</option>
			<option value="nam">North America</option>
		</select>
		<span class="info dTitle">
			<img src="./assets/img/help.gif" class="showTitle" title="The record will be monitored only from this area" alt="[?]" />
		</span>
		<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="The record will be monitored only from this area" alt="[?]">
			<img src="./assets/img/help.gif">
		</span>
	</div>
	<br class="clear">
	
	<div class="monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_HTTP} monitoringType{Cloudns_Failover::CHECK_TYPE_HTTPS} monitoringType{Cloudns_Failover::CHECK_TYPE_HTTP_CUSTOM} monitoringType{Cloudns_Failover::CHECK_TYPE_HTTPS_CUSTOM}">
		<label class="pull-left inputLabel fleft dTitle">URL to check:</label>
		<label class="pull-left inputLabel fleft mTitle">Domain:</label>
		<br class="clear">
		<div class="flex">
			http<span class="monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_HTTPS} monitoringType{Cloudns_Failover::CHECK_TYPE_HTTPS_CUSTOM}">s</span>://&nbsp;
			<input id="fo_http_host" name="fo_http_host" class="form-control fo-domain" value="{$fullHost}" type="text" placeholder="FQDN"><span class="dTitle">&nbsp;:&nbsp;</span>
			<label class="pull-left inputLabel fleft mTitle"><br>Port:</label>
			<input id="fo_http_port" name="fo_http_port" class="form-control fo-port" type="text" value="80" placeholder="port"><span class="dTitle">&nbsp;/&nbsp;</span>
			<label class="pull-left inputLabel fleft mTitle"><br>Path:</label>
			<input id="fo_http_path" name="fo_http_path" class="form-control fo-path" type="text" placeholder="Path">
			<span class="info dTitle">
				<img src="./assets/img/help.gif" class="showTitle" title="The FQDN will be monitored on the main and backup IPs" alt="[?]" />
			</span>
			<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="The FQDN will be monitored on the main and backup IPs" alt="[?]">
				<img src="./assets/img/help.gif">
			</span>
		</div>
		<br class="clear">
	</div>
	<div class="monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_HTTP_CUSTOM} monitoringType{Cloudns_Failover::CHECK_TYPE_HTTPS_CUSTOM}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">String to match:</label>
			<input id="fo_http_content" name="fo_http_content" type="text" class="input-text form-control" placeholder="OK">
			<span class="info dTitle">
				<img src="./assets/img/help.gif" class="showTitle" title="The content returned by the checked URL should be equal to this string." alt="[?]" />
			</span>
			<span class="info mTitle mobileInfo mTooltip" id="mTooltip" rel="popover" data-placement="bottom" data-content="The content returned by the checked URL should be equal to this string." alt="[?]">
				<img src="./assets/img/help.gif">
			</span>
		</div>
		<br class="clear">
	</div>
	<div class="monitoringType monitoringType{Cloudns_Failover::CHECK_TYPE_TCP_SOCKET} monitoringType{Cloudns_Failover::CHECK_TYPE_UDP_SOCKET}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Port:</label>
			<input id="fo_port" name="fo_port" type="text" class="input-text form-control" placeholder="Port number">
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
			<input id="fo_dns_host" name="fo_dns_host" type="text" class="input-text form-control" value="{$fullHost}" placeholder="FQDN">
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
				<option value="A" {if $record.type == 'A'} selected="selected" {/if}>A</option>
				<option value="AAAA" {if $record.type == 'AAAA'} selected="selected" {/if}>AAAA</option>
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
			<input id="fo_dns_response" name="fo_dns_response" type="text" class="input-text form-control" placeholder="Response to the query" value="{$record.record}">
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
			<option value={Cloudns_Failover::DOWN_EVENT_HANDLER_MONITORING}>Monitoring only, e-mail notification</option>
			<option value={Cloudns_Failover::DOWN_EVENT_HANDLER_PASSIVE}>Deactivate the DNS record</option>
			<option value={Cloudns_Failover::DOWN_EVENT_HANDLER_ACTIVE}>Replace with working backup IP</option>
		</select>
	</div>
	<br class="clear">
	<div class="monitoringDownEvent monitoringDownEvent{Cloudns_Failover::DOWN_EVENT_HANDLER_ACTIVE}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Backup IP 1:</label>
			<input id="fo_backup_ip_1" name="fo_backup_ip_1" type="text" class="input-text form-control" placeholder="Required">
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
			<input id="fo_backup_ip_2" name="fo_backup_ip_2" type="text" class="input-text form-control" placeholder="Optional">
		</div>
			<br class="clear">
	</div>
	<div class="monitoringDownEvent monitoringDownEvent{Cloudns_Failover::DOWN_EVENT_HANDLER_ACTIVE}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Backup IP 3:</label>
			<input id="fo_backup_ip_3" name="fo_backup_ip_3" type="text" class="input-text form-control" placeholder="Optional">
		</div>
		<br class="clear">
	</div>
	<div class="monitoringDownEvent monitoringDownEvent{Cloudns_Failover::DOWN_EVENT_HANDLER_ACTIVE}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Backup IP 4:</label>
			<input id="fo_backup_ip_4" name="fo_backup_ip_4" type="text" class="input-text form-control" placeholder="Optional">
		</div>
		<br class="clear">
	</div>
	<div class="monitoringDownEvent monitoringDownEvent{Cloudns_Failover::DOWN_EVENT_HANDLER_ACTIVE}">
		<div class="flex">
			<label class="pull-left inputLabel fleft">Backup IP 5:</label>
			<input id="fo_backup_ip_5" name="fo_backup_ip_5" type="text" class="input-text form-control" placeholder="Optional">
		</div>
		<br class="clear">
	</div>
	<div class="flex">
		<label class="pull-left inputLabel fleft">If the main IP is up:</label>
		<select id="fo_up_event_handler" name="fo_up_event_handler" class="pull-left form-control">
			<option value={Cloudns_Failover::BACK_UP_EVENT_HANDLER_MONITORING}>Monitoring only, e-mail notification</option>
			<option value={Cloudns_Failover::BACK_UP_EVENT_HANDLER_MANUAL}>Do not monitor it, if it is back up</option>
			<option id="fo_up_handler_active" value={Cloudns_Failover::BACK_UP_EVENT_HANDLER_AUTOMATIC}>Activate the main IP for the DNS record</option>
		</select>
	</div>
        <br class="clear">
        <div class="flex">
		<label class="pull-left inputLabel fleft">Notification Type:</label>
		<select id="fo_notification_type" name="fo_notification_type" class="pull-left form-control" onChange="failoverChangeNotifications();">
			<option value={Cloudns_Failover::NOTIFICATION_TYPE_EMAIL}>E-mail</option>
			<option value={Cloudns_Failover::NOTIFICATION_TYPE_WEBHOOK_UP}>Webhook - UP event</option>
			<option value={Cloudns_Failover::NOTIFICATION_TYPE_WEBHOOK_DOWN}>Webhook - DOWN event</option>
		</select>
	</div>
	<br class="clear">
        <div class="flex">
		<label class="pull-left notificationType notificationType{Cloudns_Failover::NOTIFICATION_TYPE_EMAIL} inputLabel fleft">E-mail:</label>
                <label class="pull-left notificationType notificationType{Cloudns_Failover::NOTIFICATION_TYPE_WEBHOOK_UP} notificationType{Cloudns_Failover::NOTIFICATION_TYPE_WEBHOOK_DOWN} inputLabel fleft">URL:</label>
		<input id="fo_notification_value" name="fo_notification_value" type="text" class="input-text form-control" />
	</div>
	<br class="clear">
	<input type="submit" name="activate_fo" value="Activate" class="btn btn-primary btn-input-padded-responsive" />
</form>