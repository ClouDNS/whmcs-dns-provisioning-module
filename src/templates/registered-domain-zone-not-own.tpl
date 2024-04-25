
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


<ul class="backToZones pull-right"><li><a href="clientarea.php?action=productdetails&id={$serviceid}">back to the DNS zones list</a></li></ul><br />
<div class="clear"></div><br />


<div class="notification">The DNS zone of {$zone} is not in your account. Please contact the support to resolve the issue.</div><br />
<div class="clear"></div>