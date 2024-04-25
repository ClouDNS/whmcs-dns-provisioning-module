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
{/literal}
</script>

{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="./"}
{/if}

{include file="$path/header-settings.tpl"}

<form method="post" class="from-inline" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=failover-add-notification&zone={$zone}&dns_record_id={$record_id}">
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
        <div style="text-align: center">
		<input type="submit" name="add_fo_notification" id="add_fo_notification" value="Create new notification" class="btn btn-primary btn-input-padded-responsive" />
	</div>
</form>
<br class="clear">   

<h2>Notifications</h2>
{if !$notifications}
	<p>There are no notifications for this Failover record.</p>
{else}
<table class="table table-list dataTable no-footer dtr-inline" cellspacing="0" cellpadding="0">
	<tr>
		<th>Type</th>
		<th>Value</th>
                <th></th>
	</tr>
	<tbody>
		{* This var comes from actions.php and is the body of the table *}
		{$notificationsTable}
	</tbody>
</table>
{/if}

<form method="post" class="from-inline" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=get-failover-settings&zone={$zone}&dns_record_id={$record_id}">
        <input type="submit" name="fo_action_log" value="« Back to Failover settings" class="btn btn-primary btn-input-padded-responsive" />
</form>
