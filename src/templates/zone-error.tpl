
{if $zone eq ''}
	<script type="text/javascript">
	{literal}
		window.location.href="clientarea.php?action=productdetails&id={/literal}{$serviceid}{literal}";
	{/literal}
	</script>
{/if}

<style type="text/css">
{literal}
.notification {
background-color: #dbe3ff;
border-color: #a2b4ee;
color: #585b66;
display:block;
font-style:normal;
padding: 10px 10px 10px 36px;
line-height: 1.5em;
}

.backToZones {
text-align: right;
list-style-type: none;
}
{/literal}
</style>

{if isset($response.status) && $response.status=='error'}
<div class="notification">{$response.description}</div><br />
{/if}

<ul class="backToZones pull-right"><li><a href="clientarea.php?action=productdetails&id={$serviceid}" >back to the DNS zones list</a></li></ul>
<div class="clear"></div>

<form action="clientarea.php?action=productdetails&id={$serviceid}&customAction=add-existing-zone" method="post">
	<input type="hidden" name="zone" id="zone" value="{$zone}" />
	<input type="submit" name="" value="Add {$zone} to the DNS servers" class="btn btn-primary btn-input-padded-responsive" />
</form>