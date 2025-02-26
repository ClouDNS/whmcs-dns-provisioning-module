{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="./"}
<style type="text/css">
	{literal}
	.mTitle, 
	.srvTitleM, 
	.tlsaTitleM,
	.dsTitleM,
	.certTitleM,
	.hinfoTitleM {
		display: none;
	}
	
	.flex {
		display: flex;	
		flex: 1 0 auto;
		align-items:center;
		white-space: nowrap;
		overflow: hidden;
		height: 40px;
	}
	
	.small, small {
		font-style: italic;
		color: #777;
	}
	
	input[type=checkbox], input[type=radio] {
		    margin: 2px 4px 0px 0px;
	}
	
	@media only screen and (max-width: 1200px) {
		#recordsForm .inputSRV,
		#recordsForm div.inputSRV.srvInputTitle,
		#recordsForm .selectTLSA,
		#recordsForm .selectDS,
		#recordsForm .selectCERT{
			width: 100% !important;
			margin-left: 0 !important;
		}
		
		.srvTitleD,
		.tlsaTitleD,
		.dsTitleD,
		.certTitleD,
		.hinfoTitleD{
			display: none;
		}
		
		.srvTitleM,
		.tlsaTitleM, 
		.dsTitleM,
		.certTitleM,
		.hinfoTitleM{
			display: block;
		}
	}
	
	@media only screen and (max-width: 650px) {
		form#recordsForm.recordsForm select,
		#recordsForm #editRecordHost,
		#recordsForm .pointsTo,
		#recordsForm .MX_fields input,
		#recordsForm .inputSRV,
		#recordsForm div.inputSRV.srvInputTitle,
		#recordsForm .inputTitle,
		#recordsForm .RP_fields input,
		#recordsForm .RP_fields div,
		#recordsForm .HINFO_fields input,
		#recordsForm .HINFO_fields div,
		#recordsForm .LOC_fields input,
		#recordsForm .LOC_fields div,
		#recordsForm .NAPTR_fields input{
			width: 100% !important;
			margin-left: 0;
		}
		
		#editRecordHost {
			flex: 1 0 220px;
		}
		
		#recordsForm .spanHost {
			flex-wrap: wrap;
			width: 100%;
			display: flex;
			align-items: center;
			word-break: break-all;
		}
		
		.dTitle {
			display: none;
		}
		
		.mTitle {
			display: block;
		}
		
		t {
			width: 100%;
		}
		
	}
	
	{/literal}
</style>
<script>
	{literal}
	$(document).ready (function() {
		
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
		}
	});	
	{/literal}
</script>
{/if}

{include file="$path/header-settings.tpl"}

<form class="recordsForm" id="recordsForm" method="post" action="clientarea.php?action=productdetails&id={$serviceid}&customAction=do-edit-record&zone={$zone}&dns_record_id={$record.id}">
	Type: {if $record.type == 'WR'}Web Redirect{else} {$record.type}{/if}
	<input type="hidden" value="{$record.type}" name="recordType" /><br/><br />
	TTL:<br />
	<select id="editRecordTtl" name="editRecordTtl" class="form-control editRecordField">
		{foreach from=$ttls key=key item=value}
		<option value="{$value}"{if $record.ttl == $value} selected="selected"{/if}>{$key}</option>
		{/foreach}
	</select><br /><br class="clear" />
	<div>Host: {if $record.type == 'OPENPGPKEY'}<span class="info OPENPGPKEY_fields type_fields"><img src="./assets/img/help.gif" class="showTitle" title="The hashed representation of the local-part of the email address using the SHA2-256 algorithm followed by ._openpgpkey" alt="[?]"/></span>{/if}</div>
	<span class="spanHost"><input type="text" id="editRecordHost" name="editRecordHost" class="input-text form-control editRecordField"
value="{$uniHost}" autocapitalize="off" spellcheck="false"/>.{$shortName.shortName}</span><br class="dTitle">
{if in_array($record.type, array('A', 'AAAA', 'NS', 'MX', 'TXT', 'SPF', 'RP', 'WR', 'CAA', 'CERT', 'HINFO', 'LOC'))}
	<small>Leave empty for {$zone}<br /></small>
{/if}
	{if $record.type == 'SRV'}
		<br />
		<div class="SRV_fields type_fields" >
			<div class="pull-left inputSRV srvInputTitle srvTitleD noMargin">Priority: <span class="info"><img src="./assets/img/help.gif" class="showTitle" title="0 - 65535" alt="[?]" /></span></div>
			<div class="pull-left inputSRV srvInputTitle srvTitleD">Weight: <span class="info"><img src="./assets/img/help.gif" class="showTitle" title="0 - 65535" alt="[?]" /></span></div>
			<div class="pull-left inputSRV srvInputTitle srvTitleD">Port: <span class="info"><img src="./assets/img/help.gif" class="showTitle" title="0 - 65535" alt="[?]" /></span></div>
			<div class="clear"></div>
			<div class="pull-left inputSRV srvInputTitle srvTitleM noMargin">Priority: <span class="info mTooltip" rel="popover" data-content="0 - 65535" alt="[?]"><img src="./assets/img/help.gif" class="showTitle"/></span></div>
			<input type="text" id="editRecordPriority" name="editRecordPriority" value="{$record.priority|@abs}" class="pull-left form-control inputSRV noMargin" autocapitalize="off" spellcheck="false"/>
			<div class="pull-left inputSRV srvInputTitle srvTitleM"><br>Weight: <span class="info mTooltip" rel="popover" data-content="0 - 65535" alt="[?]"><img src="./assets/img/help.gif" class="showTitle"/></span></div>
			<input type="text" id="editRecordWeight" name="editRecordWeight" value="{$record.weight|@abs}" class="pull-left form-control inputSRV" autocapitalize="off" spellcheck="false"/>
			<div class="pull-left inputSRV srvInputTitle srvTitleM"><br>Port: <span class="info mTooltip" rel="popover" data-content="0 - 65535" alt="[?]"><img src="./assets/img/help.gif" class="showTitle"/></span></div>
			<input type="text" id="editRecordPort" name="editRecordPort" value="{$record.port|@abs}" class="pull-left form-control inputSRV" /><br class="clear" autocapitalize="off" spellcheck="false"/>
		</div>
		
	{/if}
	
	{if $record.type == 'MX'}
		<br /><div>Priority:</div><input type="text" id="editRecordPriority" name="editRecordPriority" class="input-text form-control editRecordField" value="{$record.priority}" autocapitalize="off" spellcheck="false"/><br />
	{elseif $record.type == 'NAPTR'}
		<div class="NAPTR_fields type_fields"><br />
		<div class="pull-left inputTitle dTitle">Order:</div>
		<div class="pull-right inputTitle dTitle">Preference:</div>
		<div class="clear"></div>
		<div class="pull-left inputTitle mTitle">Order:</div>
		<input type="text" id="editRecordOrder" name="editRecordOrder" value="{if isset($record.order)}{$record.order|@htmlspecialchars}{/if}" class="pull-left form-control input-text" autocapitalize="off" spellcheck="false"/>
		<div class="pull-right inputTitle mTitle"><br>Preference:</div>
		<input type="text" id="editRecordPref" name="editRecordPref" value="{if isset($record.pref)}{$record.pref|@htmlspecialchars}{/if}" class="pull-right form-control input-text" autocapitalize="off" spellcheck="false"/><br /><br />
	</div>

	<div class="NAPTR_fields type_fields"><br />
		<div class="pull-left inputTitle dTitle"><br>Flag:</div>
		<div class="pull-right inputTitle dTitle"><br>Protocol+Resolution service:</div>
		<div class="clear"></div>
		<div class="pull-left inputTitle mTitle"><br>Flag:</div>
		<select id="editRecordFlag" name="flag" class="pull-left form-control">
			<option value="">Empty flag</option>
			<option value="U" {if $record.flag == 'U'}selected="selected"{/if}>U</option>
			<option value="S" {if $record.flag == 'S'}selected="selected"{/if}>S</option>
			<option value="A" {if $record.flag == 'A'}selected="selected"{/if}>A</option>
			<option value="P" {if $record.flag == 'P'}selected="selected"{/if}>P</option>
		</select>
		<div class="pull-right inputTitle mTitle"><br>Protocol+Resolution service:</div>
		<input type="text" id="editRecordParams" name="editRecordParams" class="pull-right form-control input-text" value="{if isset($record.params)}{$record.params|@htmlspecialchars}{/if}" autocapitalize="off" spellcheck="false"/><br /><br />
	</div>

	<div class="NAPTR_fields type_fields"><br />
		<div class="pull-left inputTitle dTitle"><br>Regular Expression:</div>
		<div class="pull-right inputTitle dTitle"><br>Replacement:</div>
		<div class="clear"></div>
		<div class="pull-left inputTitle mTitle"><br>Regular Expression:</div>
		<input type="text" id="editRecordRegexp" name="editRecordRegexp" class="pull-left form-control input-text" value="{if isset($record.regexp)}{$record.regexp|@htmlspecialchars}{/if}" autocapitalize="off" spellcheck="false"/>
		<div class="pull-right inputTitle mTitle"><br>Replacement:</div>
		<input type="text" id="editRecordReplace" name="editRecordReplace" class="pull-right form-control input-text" value="{if isset($record.replace)}{$record.replace|@htmlspecialchars}{/if}" autocapitalize="off" spellcheck="false"/><br class="clear"/>
	</div>
	{elseif $record.type == 'SSHFP'}
		<br /><div class="SSHFP_fields type_fields">
			<div class="pull-left inputTitle dTitle">Algorithm:</div>
			<div class="pull-right inputTitle dTitle">Fingerprint type:</div>
			<div class="clear"></div>
			<div class="pull-left inputTitle fleft mTitle">Algorithm:</div>
			<select id="editRecordAlgorithm" name="algorithm" class="pull-left form-control editRecordField">
				<option value="1" {if $record.algorithm == 1}selected="selected"{/if}>RSA</option>
				<option value="2" {if $record.algorithm == 2}selected="selected"{/if}>DSA</option>
				<option value="3" {if $record.algorithm == 3}selected="selected"{/if}>ECDSA</option>
				<option value="4" {if $record.algorithm == 4}selected="selected"{/if}>Ed25519</option>
			</select>
			<div class="pull-left inputTitle fleft mTitle"><br>Fingerprint Type:</div>
			<select id="editRecordFingerprintType" name="fp_type" class="pull-right form-control editRecordField">
				<option value="1" {if $record.fp_type == 1}selected="selected"{/if}>SHA-1</option>
				<option value="2" {if $record.fp_type == 2}selected="selected"{/if}>SHA-256</option>
			</select><br class="clear">
		</div>
	{/if}
	{if $record.type == 'TLSA'}
		<br>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleD">Usage:</div>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleD">Selector:</div>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleD">Matching Type:</div>
		<div class="clear"></div>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleM">Usage:</div>
		<select id="editRecordUsage" name="editRecordUsage" class="pull-left form-control editRecordField selectTLSA">
			<option value="0" {if $record.tlsa_usage == 0}selected="selected"{/if}>(0) PKIX-TA: Certificate Authority Constraint</option>
			<option value="1" {if $record.tlsa_usage == 1}selected="selected"{/if}>(1) PKIX-EE: Service Certificate Constraint</option>
			<option value="2" {if $record.tlsa_usage == 2}selected="selected"{/if}>(2) DANE-TA: Trust Anchor Assertion</option>
			<option value="3" {if $record.tlsa_usage == 3}selected="selected"{/if}>(3) DANE-EE: Domain Issued Certificate</option>
		</select>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleM"><br>Selector:</div>
		<select id="editRecordSelector" name="editRecordSelector" class="pull-left form-control editRecordField selectTLSA">
			<option value="0" {if $record.tlsa_selector == 0}selected="selected"{/if}>(0) Cert: Use full certificate</option>
			<option value="1" {if $record.tlsa_selector == 1}selected="selected"{/if}>(1) SPKI: Use subject public key</option>
		</select>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleM"><br>Matching Type:</div>
		<select id="editRecordMatchingType" name="editRecordMatchingType" class="pull-left form-control editRecordField selectTLSA">
			<option value="0" {if $record.tlsa_matching_type == 0}selected="selected"{/if}>(0) Full: No Hash</option>
			<option value="1" {if $record.tlsa_matching_type == 1}selected="selected"{/if}>(1) SHA-256: SHA-256 hash</option>
			<option value="2" {if $record.tlsa_matching_type == 2}selected="selected"{/if}>(2) SHA-512: SHA-512 hash</option>
		</select><br class="clear" />
	{/if}
	{if $record.type == 'DS'}
		<br>
		<div class="pull-left inputDS dsInputTitle fleft dsTitleD">Key Tag:</div>
		<div class="pull-left inputDS dsInputTitle fleft dsTitleD">Algorithm:</div>
		<div class="pull-left inputDS dsInputTitle fleft dsTitleD">Digest Type:</div>
		<div class="clear"></div>
		<div class="pull-left inputDS dsInputTitle fleft dsTitleM">Key Tag</div>
		<input type="text" autocapitalize="off" spellcheck="false" autocorrect="off" name="editRecordKeyTag" id="editRecordKeyTag" class="pull-left form-control selectDS" value="{if isset($record.key_tag)}{$record.key_tag|@htmlspecialchars}{/if}">
		<div class="pull-left inputTitle fleft dsTitleM"><br>Algorithm:</div>
		<select id="editRecordDsAlgorithm" name="editRecordDsAlgorithm" class="pull-left form-control selectDS">
			<option value="2" {if $record.algorithm == 2}selected="selected"{/if}>(2) Diffie-Hellman</option>
			<option value="3" {if $record.algorithm == 3}selected="selected"{/if}>(3) DSA-SHA1</option>
			<option value="4" {if $record.algorithm == 4}selected="selected"{/if}>(4) Elliptic Curve (ECC)</option>
			<option value="5" {if $record.algorithm == 5}selected="selected"{/if}>(5) RSA-SHA1</option>
			<option value="6" {if $record.algorithm == 6}selected="selected"{/if}>(6) DSA-SHA1-NSEC3</option>
			<option value="7" {if $record.algorithm == 7}selected="selected"{/if}>(7) RSA-SHA1-NSEC3</option>
			<option value="8" {if $record.algorithm == 8}selected="selected"{/if}>(8) RSA-SHA256</option>
			<option value="10" {if $record.algorithm == 10}selected="selected"{/if}>(10) RSA-SHA512</option>
			<option value="13" {if $record.algorithm == 13}selected="selected"{/if}>(13) ECDSA Curve P-256 with SHA-256</option>
			<option value="14" {if $record.algorithm == 14}selected="selected"{/if}>(14) ECDSA Curve P-384 with SHA-384</option>
			<option value="15" {if $record.algorithm == 15}selected="selected"{/if}>(15) Ed25519</option>
			<option value="16" {if $record.algorithm == 16}selected="selected"{/if}>(16) Ed448</option>
			<option value="252" {if $record.algorithm == 252}selected="selected"{/if}>(252) Indirect</option>
			<option value="253" {if $record.algorithm == 253}selected="selected"{/if}>(253) Private [PRIVATEDNS]</option>
			<option value="254" {if $record.algorithm == 254}selected="selected"{/if}>(254) Private [PRIVATEOID]</option>
		</select>
		<div class="pull-left inputTitle fleft dsTitleM"><br>Digest Type:</div>	
		<select id="editRecordDigestType" name="editRecordDigestType" class="pull-left form-control selectDS">
			<option value="1" {if $record.digest_type == 1}selected="selected"{/if}>(1) SHA-1</option>
			<option value="2" {if $record.digest_type == 2}selected="selected"{/if}>(2) SHA-256</option>
			<option value="3" {if $record.digest_type == 3}selected="selected"{/if}>(3) GOST R 34.11-94</option>
			<option value="4" {if $record.digest_type == 4}selected="selected"{/if}>(4) SHA-384</option>
		</select><br class="clear" />
	{/if}
	{if $record.type == 'CERT'}
		<br>
		<div class="pull-left inputCERT certInputTitle fleft certTitleD">Digest Type:</div>
		<div class="pull-left inputCERT certInputTitle fleft certTitleD">Key Tag:</div>
		<div class="pull-left inputCERT certInputTitle fleft certTitleD">Algorithm:</div>
		<div class="clear"></div>
		<div class="pull-left inputCERT certInputTitle fleft certTitleM">Type</div>
		<select id="editRecordCertType" name="editRecordCertType" class="pull-left form-control selectCERT">
			<option value="1" {if $record.cert_type == 1}selected="selected"{/if}>(1) PKIX</option>
			<option value="2" {if $record.cert_type == 2}selected="selected"{/if}>(2) SPKI</option>
			<option value="3" {if $record.cert_type == 3}selected="selected"{/if}>(3) PGP</option>
			<option value="4" {if $record.cert_type == 4}selected="selected"{/if}>(4) IPKIX</option>
			<option value="5" {if $record.cert_type == 5}selected="selected"{/if}>(5) ISPKI</option>
			<option value="6" {if $record.cert_type == 6}selected="selected"{/if}>(6) IPGP</option>
			<option value="7" {if $record.cert_type == 7}selected="selected"{/if}>(7) ACPKIX</option>
			<option value="8" {if $record.cert_type == 8}selected="selected"{/if}>(8) IACPKIX</option>
			<option value="253" {if $record.cert_type == 253}selected="selected"{/if}>(253) URI</option>
			<option value="254" {if $record.cert_type == 254}selected="selected"{/if}>(254) OID</option>
		</select>
		<div class="pull-left inputTitle fleft certTitleM"><br>Key Tag:</div>
		<input type="text" autocapitalize="off" spellcheck="false" autocorrect="off" name="editRecordCertKeyTag" id="editRecordCertKeyTag" class="pull-left form-control selectCERT" value="{if isset($record.key_tag)}{$record.key_tag|@htmlspecialchars}{/if}">
		<div class="pull-left inputTitle fleft certTitleM"><br>Algorithm:</div>
		<select id="editRecordCertAlgorithm" name="editRecordCertAlgorithm" class="pull-left form-control selectCERT">
			<option value="2" {if $record.algorithm == 2}selected="selected"{/if}>(2) Diffie-Hellman</option>
			<option value="3" {if $record.algorithm == 3}selected="selected"{/if}>(3) DSA-SHA1</option>
			<option value="4" {if $record.algorithm == 4}selected="selected"{/if}>(4) Elliptic Curve (ECC)</option>
			<option value="5" {if $record.algorithm == 5}selected="selected"{/if}>(5) RSA-SHA1</option>
			<option value="6" {if $record.algorithm == 6}selected="selected"{/if}>(6) DSA-SHA1-NSEC3</option>
			<option value="7" {if $record.algorithm == 7}selected="selected"{/if}>(7) RSA-SHA1-NSEC3</option>
			<option value="8" {if $record.algorithm == 8}selected="selected"{/if}>(8) RSA-SHA256</option>
			<option value="10" {if $record.algorithm == 10}selected="selected"{/if}>(10) RSA-SHA512</option>
			<option value="13" {if $record.algorithm == 13}selected="selected"{/if}>(13) ECDSA Curve P-256 with SHA-256</option>
			<option value="14" {if $record.algorithm == 14}selected="selected"{/if}>(14) ECDSA Curve P-384 with SHA-384</option>
			<option value="15" {if $record.algorithm == 15}selected="selected"{/if}>(15) Ed25519</option>
			<option value="16" {if $record.algorithm == 16}selected="selected"{/if}>(16) Ed448</option>
			<option value="252" {if $record.algorithm == 252}selected="selected"{/if}>(252) Indirect</option>
			<option value="253" {if $record.algorithm == 253}selected="selected"{/if}>(253) Private [PRIVATEDNS]</option>
			<option value="254" {if $record.algorithm == 254}selected="selected"{/if}>(254) Private [PRIVATEOID]</option>
		</select>
		<br class="clear" />
	{/if}
	{if $record.type == 'SMIMEA'}
		<br>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleD">Usage:</div>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleD">Selector:</div>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleD">Matching Type:</div>
		<div class="clear"></div>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleM">Usage:</div>
		<select id="editRecordSmimeaUsage" name="editRecordSmimeaUsage" class="pull-left form-control editRecordField selectTLSA">
			<option value="0" {if $record.smimea_usage == 0}selected="selected"{/if}>(0) PKIX-TA: Certificate Authority Constraint</option>
			<option value="1" {if $record.smimea_usage == 1}selected="selected"{/if}>(1) PKIX-EE: Service Certificate Constraint</option>
			<option value="2" {if $record.smimea_usage == 2}selected="selected"{/if}>(2) DANE-TA: Trust Anchor Assertion</option>
			<option value="3" {if $record.smimea_usage == 3}selected="selected"{/if}>(3) DANE-EE: Domain Issued Certificate</option>
		</select>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleM"><br>Selector:</div>
		<select id="editRecordSmimeaSelector" name="editRecordSmimeaSelector" class="pull-left form-control editRecordField selectTLSA">
			<option value="0" {if $record.smimea_selector == 0}selected="selected"{/if}>(0) Cert: Use full certificate</option>
			<option value="1" {if $record.smimea_selector == 1}selected="selected"{/if}>(1) SPKI: Use subject public key</option>
		</select>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleM"><br>Matching Type:</div>
		<select id="editRecordSmimeaMatchingType" name="editRecordSmimeaMatchingType" class="pull-left form-control editRecordField selectTLSA">
			<option value="0" {if $record.smimea_matching_type == 0}selected="selected"{/if}>(0) Full: No Hash</option>
			<option value="1" {if $record.smimea_matching_type == 1}selected="selected"{/if}>(1) SHA-256: SHA-256 hash</option>
			<option value="2" {if $record.smimea_matching_type == 2}selected="selected"{/if}>(2) SHA-512: SHA-512 hash</option>
		</select><br class="clear" />
	{/if}
	{if $record.type != 'RP' && $record.type != 'NAPTR' && $record.type != 'CAA' && $record.type != 'HINFO' && $record.type != 'LOC'}
		<br class="clear" /><div>{if $record.type == 'OPENPGPKEY'}PGP key{elseif $record.type == 'SMIMEA'}Certificate{else}Points to:{/if}</div>
		<input type="text" id="editRecordRecord" name="editRecordRecord" value="{$record.record|@htmlspecialchars}" class="input-text editRecordField pointsTo form-control" autocapitalize="off" spellcheck="false"/> 
		{if $record.type == 'WR'}Example: http://google.com{/if}<br />
	{/if}
	
	{if $record.type == 'WR'}
			<br />
			<div><label><input type="checkbox" class="pull-left" id="editRecordWRFrame" name="editRecordWRFrame" value="1" {if isset($record.frame) && $record.frame == 1}checked="checked"{/if} style="width:15px !important;" onclick="toggleOptions('WRFrameOptions');" autocapitalize="off" spellcheck="false"/>Redirect with frame</label></div>

			<div id="WRFrameOptions" style="{if !isset($record.frame) || $record.frame != 1}display:none;{/if}">
				Title:<br />
				<input type="text" id="editRecordWRFrameTitle" name="editRecordWRFrameTitle" class="input-text form-control editRecordField pointsTo" value="{if isset($record.frame_title)}{$record.frame_title|@htmlspecialchars}{/if}" autocapitalize="off" spellcheck="false"/><br /><br />
				Description:<br />
				<input type="text" id="editRecordWRFrameDescription" name="editRecordWRFrameDescription" class="input-text form-control editRecordField pointsTo" value="{if isset($record.frame_description)}{$record.frame_description|@htmlspecialchars}{/if}" autocapitalize="off" spellcheck="false"/><br /><br />
				Keywords:<br />
				<input type="text" id="editRecordWRFrameKeywords" name="editRecordWRFrameKeywords" class="input-text form-control editRecordField pointsTo" value="{if isset($record.frame_keywords)}{$record.frame_keywords|@htmlspecialchars}{/if}" autocapitalize="off" spellcheck="false"/><br /><br />
				<label><input type="checkbox" class="pull-left" id="editRecordWRMobileMeta" name="editRecordWRMobileMeta" value="1" {if isset($record.mobile_meta) && $record.mobile_meta == 1}checked="checked"{/if} style="width:15px !important;" autocapitalize="off" spellcheck="false"/>Add mobile responsive meta tags</label>
			</div>

			<label><input type="checkbox" class="pull-left" id="editRecordWRSavePath" name="editRecordWRSavePath" value="1" {if isset($record.save_path) && $record.save_path == 1}checked="checked"{/if} style="width:15px !important;" autocapitalize="off" spellcheck="false"/>Save path</label>

		<div id="WRTypeOptions" style="{if !isset($record.frame) || $record.frame == 0} {else}display:none;{/if}"><br />
			Redirect type:<br />
			<label><input type="radio" name="wr_type" id="editRecordWRType" {if isset($record.redirect_type) && $record.redirect_type == 301}checked="checked"{/if} value="301" class="inputRadio pull-left" autocapitalize="off" spellcheck="false"/> 301 Moved permanently</label>
			<label><input type="radio" name="wr_type" id="editRecordNewWRType" {if isset($record.redirect_type) && $record.redirect_type != 301}checked="checked"{/if} value="302" class="inputRadio pull-left" autocapitalize="off" spellcheck="false"/> 302 Temporary redirect</label>

		</div>
	{elseif $record.type == 'RP'}
			<br /><div class="RP_fields type_fields">
			<div class="pull-left inputTitle fleft dTitle">Responsible person (Email):</div>
			<div class="pull-right inputTitle fright dTitle">TXT Record:</div>
			<div class="clear"></div>
			<div class="pull-left inputTitle fleft mTitle">Responsible person (E-mail):</div>
			<input type="text" id="editRecordMail" name="editRecordMail" class="pull-left fleft form-control" value="{$record.mail|@htmlspecialchars}" autocapitalize="off" spellcheck="false"/>
			<div class="pull-right inputTitle fleft mTitle"><br>TXT record:</div>
			<input type="text" id="editRecordTxt" name="editRecordTxt" class="pull-right form-control fright" value="{$record.txt|@htmlspecialchars}" autocapitalize="off" spellcheck="false"/><br class="clear" />
		</div>
	{elseif $record.type == 'CAA'}
		<div class="CAA_fields type_fields">
			<div class="pull-left fleft inputTitle dTitle">Flag: <img src="./assets/img/help.gif" class="showTitle" title="The flag depends on your needs. It can be either Non Critical or Critical. Usually the Non Critical is used." alt="[?]" /></div>
			<div class="pull-right fright inputTitle dTitle">Type: <img src="./assets/img/help.gif" class="showTitle" title="The Type is one of issue, issuewild or iodef. Issue is for the specified hostname; Issuewild is for wildcard of the hostname; iodef is for a way to notify the domain owner in case someone tries to order an SSL for the hostname, it's usually an email 'mailto:owner@example.com' or an URL to a web form 'http://falsessl.example.com'." alt="[?]" /></div>
			<div class="clear"></div>
			<div class="pull-left fleft inputTitle mTitle"><br>Flag: <img src="./assets/img/help.gif" class="showTitle mTooltip" rel="popover" data-content="The flag depends on your needs. It can be either Non Critical or Critical. Usually the Non Critical is used." alt="[?]" /></div>
			<select id="editRecordCAAflag" name="editRecordCAAflag" class="pull-left form-control inputTitle fleft">
				<option value="0" {if $record.caa_flag == 0}selected="selected"{/if}>(0) Non critical</option>
				<option value="128" {if $record.caa_flag == 128}selected="selected"{/if}>(128) Critical</option>
			</select>
			<div class="pull-right fright inputTitle mTitle"><br>Type: <img src="./assets/img/help.gif" class="showTitle mTooltip"  rel="popover" data-content="The Type is one of issue, issuewild or iodef. Issue is for the specified hostname; Issuewild is for wildcard of the hostname; iodef is for a way to notify the domain owner in case someone tries to order an SSL for the hostname, it's usually an email 'mailto:owner@example.com' or an URL to a web form 'http://falsessl.example.com'." alt="[?]" /></div>
			<select id="editRecordCAAtype" name="editRecordCAAtype" class="pull-right form-control inputTitle fright">
				<option value="issue" {if $record.caa_type == 'issue'}selected="selected"{/if}>issue</option>
				<option value="issuewild" {if $record.caa_type == 'issuewild'}selected="selected"{/if}>issuewild</option>
				<option value="iodef" {if $record.caa_type == 'iodef'}selected="selected"{/if}>iodef</option>
			</select>
			<br class="clear" />
		</div>

		<div class="CAA_fields type_fields"><br />
			<div class="fleft inputSRV inputTitle dTitle">Value: <img src="./assets/img/help.gif" class="showTitle" title="The value given from your preferred CA or a value of your choice. It can be the CA hostname or mailto:you@your-mail.com, it depends on the Type and your needs." alt="[?]" /></div>
			<div class="fleft inputSRV inputTitle mTitle">Value: <img src="./assets/img/help.gif" class="showTitle mTooltip" rel="popover" data-content="The value given from your preferred CA or a value of your choice. It can be the CA hostname or mailto:you@your-mail.com, it depends on the Type and your needs." alt="[?]" /></div>
			<br />
			<input type="text" id="editRecordCAAvalue" name="editRecordCAAvalue" value="{$record.caa_value|@htmlspecialchars}" class="form-control input-text editRecordField pointsTo" autocapitalize="off" spellcheck="false"/>
			<br class="clear" /><br />
		</div>
	{elseif $record.type == 'HINFO'}
			<br /><div class="HINFO_fields type_fields">
			<div class="pull-left inputTitle fleft dTitle">CPU:</div>
			<div class="pull-right inputTitle fright dTitle">OS:</div>
			<div class="clear"></div>
			<div class="pull-left inputTitle fleft mTitle">CPU:</div>
			<input type="text" id="editRecordCPU" name="editRecordCPU" class="pull-left fleft form-control" value="{$record.cpu|@htmlspecialchars}" autocapitalize="off" spellcheck="false"/>
			<div class="pull-right inputTitle fleft mTitle"><br>OS:</div>
			<input type="text" id="editRecordOS" name="editRecordOS" class="pull-right form-control fright" value="{$record.os|@htmlspecialchars}" autocapitalize="off" spellcheck="false"/><br class="clear" />
		</div>
	{elseif $record.type == 'LOC'}
			<br />
		<div class="LOC_fields type_fields">
			<h5 class="pull-left">Latitude</h5>
		</div>
		<div class="LOC_fields type_fields">
			<div class="pull-left inputTitle fleft dTitle titleLOC" >Degrees: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 90" alt="[?]" /></div>
			<div class="pull-right inputTitle fleft dTitle titleLOC">Minutes: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 59 If omitted will default to 0." alt="[?]" /></div>
			<div class="pull-right inputTitle fleft dTitle titleLOC">Seconds: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 59.999 If omitted will default to 0." alt="[?]" /></div>
			<div class="pull-right inputTitle fleft dTitle titleLOC">Direction:</div>
			<div class="clear"></div>
			<div class="pull-left inputTitle fleft mTitle">Degrees: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 90" alt="[?]" /></div>
			<input type="text" id="editRecordLatDeg" name="editRecordLatDeg" value="{$record.lat_deg|@htmlspecialchars}" class="form-control pull-left fleft inputFirstLOC" autocapitalize="off" spellcheck="false"/>
			<div class="pull-left inputTitle fleft mTitle">Minutes: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 59 If omitted will default to 0." alt="[?]" /></div>
			<input type="text" id="editRecordLatMin" name="editRecordLatMin" value="{$record.lat_min|@htmlspecialchars}" class="form-control pull-left fleft inputLOC" autocapitalize="off" spellcheck="false"/>
			<div class="pull-left inputTitle fleft mTitle">Seconds: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 59.999 If omitted will default to 0." alt="[?]" /></div>
			<input type="text" id="editRecordLatSec" name="editRecordLatSec" value="{$record.lat_sec|@htmlspecialchars}" class="form-control pull-left fleft inputLOC" autocapitalize="off" spellcheck="false"/>
			<div class="pull-right inputTitle fleft mTitle selectLOC">Direction:</div>
			<select id="editRecordLatDir" name="editRecordLatDir" class="form-control inputTitle selectLOC">
				<option value="N" {if $record.lat_dir == 'N'}selected="selected"{/if}>North</option>
				<option value="S" {if $record.lat_dir == 'S'}selected="selected"{/if}>South</option>
			</select>
			<br class="clear" /><br>
		</div>
		<div class="LOC_fields type_fields">
			<h5 class="pull-left">Longtitude</h5>
		</div>
		<div class="LOC_fields type_fields">
			<div class="pull-left inputTitle fleft dTitle titleLOC" >Degrees: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 180" alt="[?]" /></div>
			<div class="pull-right inputTitle fleft dTitle titleLOC">Minutes: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 59 If omitted will default to 0." alt="[?]" /></div>
			<div class="pull-right inputTitle fleft dTitle titleLOC">Seconds: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 59.999 If omitted will default to 0." alt="[?]" /></div>
			<div class="pull-right inputTitle fleft dTitle titleLOC">Direction:</div>
			<div class="clear"></div>
			<div class="pull-left inputTitle fleft mTitle">Degrees: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 180" alt="[?]" /></div>
			<input type="text" id="editRecordLongDeg" name="editRecordLongDeg" value="{$record.long_deg|@htmlspecialchars}" class="form-control pull-left fleft inputFirstLOC" autocapitalize="off" spellcheck="false"/>
			<div class="pull-left inputTitle fleft mTitle">Minutes: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 59 If omitted will default to 0." alt="[?]" /></div>
			<input type="text" id="editRecordLongMin" name="editRecordLongMin" value="{$record.long_min|@htmlspecialchars}" class="form-control pull-left fleft inputLOC" autocapitalize="off" spellcheck="false"/>
			<div class="pull-left inputTitle fleft mTitle">Seconds: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 59.999 If omitted will default to 0." alt="[?]" /></div>
			<input type="text" id="editRecordLongSec" name="editRecordLongSec" value="{$record.long_sec|@htmlspecialchars}" class="form-control pull-left fleft inputLOC" autocapitalize="off" spellcheck="false"/>
			<div class="pull-right inputTitle fleft mTitle">Direction:</div>
			<select id="editRecordLongDir" name="editRecordLongDir" class="form-control inputTitle selectLOC">
				<option value="W" {if $record.long_dir == 'W'}selected="selected"{/if}>West</option>
				<option value="E" {if $record.long_dir == 'E'}selected="selected"{/if}>East</option>
			</select>
			<br class="clear" /><br>
		</div>
		<div class="LOC_fields type_fields">
			<h5 class="pull-left">Precision (in meters)</h5>
		</div>
		<div class="LOC_fields type_fields">
			<div class="pull-left inputTitle fleft dTitle titleLOC" >Altitude: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="-100000.00 - 42849672.95" alt="[?]" /></div>
			<div class="pull-right inputTitle fleft dTitle titleLOC">Size: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 90000000.00 If omitted, size defaults to 1." alt="[?]" /></div>
			<div class="pull-right inputTitle fleft dTitle titleLOC">Horizontal: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 90000000.00 If omitted, horizontal precision defaults to 10000." alt="[?]" /></div>
			<div class="pull-right inputTitle fleft dTitle titleLOC">Vertical: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 90000000.00 If omitted, vertical precision defaults to 10." alt="[?]" /></div>
			<div class="clear"></div>
			<div class="pull-left inputTitle fleft mTitle">Altitude: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="-100000.00 - 42849672.95" alt="[?]" /></div>
			<input type="text" id="editRecordAltitude" name="editRecordAltitude" value="{$record.altitude|@htmlspecialchars}" class="form-control pull-left fleft inputFirstLOC" autocapitalize="off" spellcheck="false"/>
			<div class="pull-left inputTitle fleft mTitle">Size: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 90000000.00 If omitted, size defaults to 1." alt="[?]" /></div>
			<input type="text" id="editRecordSize" name="editRecordSize" value="{$record.size|@htmlspecialchars}" class="form-control pull-left fleft inputLOC" autocapitalize="off" spellcheck="false"/>
			<div class="pull-left inputTitle fleft mTitle">Horizontal: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 90000000.00 If omitted, horizontal precision defaults to 10000." alt="[?]" /></div>
			<input type="text" id="editRecordHPrecision" name="editRecordHPrecision" value="{$record.h_precision|@htmlspecialchars}" class="form-control pull-left fleft inputLOC" autocapitalize="off" spellcheck="false"/>
			<div class="pull-right inputTitle fleft mTitle"><br>Vertical: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 90000000.00 If omitted, vertical precision defaults to 10." alt="[?]" /></div>
			<input type="text" id="editRecordVPrecision" name="editRecordVPrecision" value="{$record.v_precision|@htmlspecialchars}" class="form-control pull-right fright inputLOC" autocapitalize="off" spellcheck="false"/><br class="clear" /><br />
		</div>
	{/if}

	<br /><br />
	
	<input type="submit" value="Update" class="btn btn-primary btn-input-padded-responsive" />

	{if $record.type == 'WR'}
	<br /><br />
	<div class="notification">
		<b>You can use these variables for your record:</b><br /><br />
		<b>{literal}{*host*}{/literal}</b> = The current host (ex. www.{$zone})<br />
		<b>{literal}{*domain*}{/literal}</b> = The current domain ({$zone})<br />
		<b>{literal}{*subdomain*}{/literal}</b> = The value of the field Host (ex. your-name)<br /><br />

		<b>Example 1:</b><br />
		Host: www<br />
		Points to: http://{literal}{*domain*}{/literal}/?ref={literal}{*host*}{/literal}<br />

		<b>What will happen?</b><br />
		When a user goes to <b>http://www.{$zone}</b> he will be redirected to
		<b>http://{$zone}/?ref=www.{$zone}</b><br /><br />

		<b>Example 2:</b><br />
		Host: ref-id-123<br />
		Points to: http://some-referal-site.net/?ref={literal}{*host*}{/literal}<br />

		<b>What will happen?</b><br />
		When a user goes to <b>http://ref-id-123.{$zone}</b> he will be redirected to
		<b>http://some-referal-site.net/?ref=ref-id-123.{$zone}</b><br /><br />

		<b>Example 3:</b><br />
		Host: your-name<br />
		Points to: http://some-referal-site.net/?ref={literal}{*subdomain*}{/literal}<br />

		<b>What will happen?</b><br />
		When a user goes to <b>http://your-name.{$zone}</b> he will be redirected to
		<b>http://some-referal-site.net/?ref=your-name</b>
	</div>
	{/if}

</form>
