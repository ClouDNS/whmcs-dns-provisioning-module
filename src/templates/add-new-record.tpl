{assign var="path" value="../modules/servers/cloudns/templates"}
{if $version gte '6'}
	{assign var="path" value="."}
	
<style type="text/css">
	{literal}
	.mTitle, 
	.srvTitleM, 
	.tlsaTitleM,
	.dsTitleM,
	.certTitleM {
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
	
	input[type=checkbox], input[type=radio] {
		    margin: 2px 4px 0px 0px;
	}
	
	@media only screen and (max-width: 1200px) {
		#recordsForm .inputSRV,
		#recordsForm div.inputSRV.srvInputTitle,
		#recordsForm .selectTLSA,
		#recordsForm .selectDS,
		#recordsForm .selectCERT {
			width: 100% !important;
			margin-left: 0 !important;
		}
		
		.srvTitleD,
		.tlsaTitleD,
		.dsTitleD, 
		.certTitleD,
		.locTitleD{
			display: none;
		}
		
		.srvTitleM,
		.tlsaTitleM,
		.dsTitleM,
		.certTitleM,
		.hinfoTitleM,
		.locTitleM{
			display: block;
		}
	}
	@media only screen and (max-width: 650px) {
		form#recordsForm.recordsForm select,
		#recordsForm #addRecordHost,
		#recordsForm .pointsTo,
		#recordsForm .MX_fields input,
		#recordsForm .inputTitle,
		#recordsForm .RP_fields input,
		#recordsForm .RP_fields div,
		#recordsForm .HINFO_fields input,
		#recordsForm .HINFO_fields div,
		#recordsForm .LOC_fields input,
		#recordsForm .LOC_fields div,
		#recordsForm .NAPTR_fields input{
			width: 100% !important;
			margin-left: 0 !important;
		}
		
		#addRecordHost {
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

{/if}
{include file="$path/header-settings.tpl"}

<script>
	{literal}
	$(document).ready (function() {
		selectType();
		
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
		
	function selectType() {
		var type = $('#addRecordType').val();
		$('.type_fields').hide();
		$('.' + type + '_fields').show();

		if (type == 'RP' || type == 'NAPTR' || type == 'CAA' || type =='HINFO' || type =='LOC') {
			$('.recordContainter').hide();
		} else {
			$('.recordContainter').show();
		}
		
		if (type == 'OPENPGPKEY' || type == 'SMIMEA') {
			$('.recordContainter .records-label').hide();
		} else {
			$('.recordContainter .records-label').show();
		}
	}
	{/literal}
</script>


<form action="clientarea.php?action=productdetails&id={$serviceid}&customAction=add-record&zone={$zone}&type={$defaultType}" method="post" id="recordsForm" class="recordsForm">
	<div class="pull-left inputTitle fleft">Type:</div><div class="pull-right inputTitle fleft dTitle">TTL:</div>
	<div class="clear"></div>
	<select id="addRecordType" name="addRecordType" class="pull-left form-control" onChange="selectType();">
	{foreach from=$recordTypes key=key item=type}
		<option value="{$type}"{if $defaultType == $type} selected="selected" {/if}>{if $type == 'WR'}Web Redirect{else}{$type}{/if}</option>
	{/foreach}

	</select>
	<div class="pull-left inputTitle fleft mTitle"><br>TTL:</div>
	<select id="addRecordTtl" name="addRecordTtl" class="pull-right form-control">
		{foreach from=$ttls key=key item=value}
		<option value="{$value}"{if isset($settings.ttl) && $settings.ttl == $value} selected="selected"{elseif !isset($settings.ttl) && $value == '3600'} selected="selected"{/if}>{$key}</option>
		{/foreach}
	</select>

	<br />
	<div class="dTitle"><br /><br />Host: <span class="info OPENPGPKEY_fields type_fields"><img src="./assets/img/help.gif" class="showTitle" title="The hashed representation of the local-part of the email address using the SHA2-256 algorithm followed by ._openpgpkey" alt="[?]"/></span><small class="OPENPGPKEY_fields type_fields">(e.g.: &lt;hash&gt;._openpgpkey)</small><small class="SRV_fields type_fields">(_service._protocol e.g.: _sip._tcp)</small><small class="TLSA_fields type_fields">(_port._protocol e.g.: _100._tcp)</small></div>
	<div class="clear"></div>
	<div class="pull-left inputTitle fleft mTitle"><br> Host:  <span class="info OPENPGPKEY_fields type_fields"><img src="./assets/img/help.gif" class="showTitle" title="The hashed representation of the local-part of the email address using the SHA2-256 algorithm followed by ._openpgpkey" alt="[?]"/></span><small class="OPENPGPKEY_fields type_fields">(e.g.: &lt;hash&gt;._openpgpkey)</small><small class="SRV_fields type_fields">(_service._protocol e.g.: _sip._tcp)</small><small class="TLSA_fields type_fields">(_port._protocol e.g.: _100._tcp)</small></div>
	<span class="spanHost"><input type="text" id="addRecordHost" name="addRecordHost" class="form-control" value="{if isset($settings.host)}{$settings.host}{/if}" autocapitalize="off" spellcheck="false"/>.{$shortName.shortName}</span><br class="dTitle">
	
	<small class="A_fields AAAA_fields MX_fields TXT_fields SPF_fields NS_fields WR_fields RP_fields SSHFP_fields CAA_fields type_fields">Leave empty for {$zone}<br /></small>
	
	
	<div class="SRV_fields SRV_fields type_fields"><br />
		<div class="pull-left inputSRV srvInputTitle srvTitleD noMargin">Priority: <span class="info"><img src="./assets/img/help.gif" class="showTitle" title="0 - 65535" alt="[?]"/></span></div>
		<div class="pull-left inputSRV srvInputTitle srvTitleD">Weight: <span class="info"><img src="./assets/img/help.gif" class="showTitle" title="0 - 65535" alt="[?]"/></span></div>
		<div class="pull-left inputSRV srvInputTitle srvTitleD">Port: <span class="info"><img src="./assets/img/help.gif" class="showTitle" title="0 - 65535" alt="[?]" /></span></div>
		<div class="clear"></div>
		<div class="pull-left inputSRV srvInputTitle srvTitleM noMargin">Priority: <span class="mobileInfo mTooltip" rel="popover" data-content="0 - 65535" alt="[?]"><img src="./assets/img/help.gif" class="showTitle" title="0 - 65535" alt="[?]" /></span></div>
		<input type="text" id="addRecordSRVPriority" name="addRecordSRVPriority" value="{if isset($settings.addRecordSRVPriority)}{$settings.addRecordSRVPriority}{else}0{/if}" class="form-control pull-left inputSRV noMargin" autocapitalize="off" spellcheck="false"/>
		<div class="pull-left inputSRV srvInputTitle srvTitleM"><br>Weight: <span class="mobileInfo mTooltip" rel="popover" data-content="0 - 65535" alt="[?]"><img src="./assets/img/help.gif" class="showTitle" title="0 - 65535" alt="[?]" /></span></div>
		<input type="text" id="addRecordWeight" name="addRecordWeight" value="{if isset($settings.addRecordWeight)} {$settings.addRecordWeight}{else}0{/if}" class="form-control pull-left inputSRV" autocapitalize="off" spellcheck="false"/>
		<div class="pull-left inputSRV srvInputTitle srvTitleM"><br>Port: <span class="mobileInfo mTooltip" rel="popover" data-content="0 - 65535" alt="[?]"><img src="./assets/img/help.gif" class="showTitle" title="0 - 65535" alt="[?]" /></span></div>
		<input type="text" id="addRecordPort" name="addRecordPort" value="{if isset($settings.addRecordPort)}{$settings.addRecordPort}{else}0{/if}" class="form-control pull-left inputSRV" autocapitalize="off" spellcheck="false"/>
		<br class="clear" />
	</div>
	
	
	<div class="MX_fields type_fields"><br />
		<div>Priority:</div>
		<input type="text" id="addRecordMXPriority" name="addRecordMXPriority" value="{if isset($settings.addRecordMXPriority)}{$settings.addRecordMXPriority}{else}10{/if}" class="input-text form-control" autocapitalize="off" spellcheck="false"/><br />
	</div>
	
	<div class="NAPTR_fields type_fields"><br />
		<div class="pull-left fleft inputTitle dTitle">Order:</div>
		<div class="pull-right fleft inputTitle dTitle">Preference:</div>
		<div class="clear"></div>
		<div class="pull-left inputTitle mTitle">Order:</div>
		<input type="text" id="addRecordOrder" name="addRecordOrder" value="{if isset($settings.addRecordOrder)}{$settings.addRecordOrder}{else}0{/if}" class="pull-left form-control input-text" autocapitalize="off" spellcheck="false"/>
		<div class="pull-right inputTitle mTitle"><br>Preference:</div>
		<input type="text" id="addRecordPref" name="addRecordPref" value="{if isset($settings.addRecordPref)}{$settings.addRecordPref}{else}0{/if}" class="pull-right form-control input-text" autocapitalize="off" spellcheck="false"/><br /><br />
	</div>

	<div class="NAPTR_fields type_fields"><br />
		<div class="pull-left fleft inputTitle dTitle">Flag:</div>
		<div class="pull-right fleft inputTitle dTitle">Protocol+Resolution service:</div>
		<div class="clear"></div>
		<div class="pull-left inputTitle mTitle"><br>Flag:</div>
		<select id="addRecordFlag" name="flag" class="pull-left form-control">
			<option value="">Empty flag</option>
			<option value="U" {if $settings.flag == 'U'}selected="selected"{/if}>U</option>
			<option value="S" {if $settings.flag == 'S'}selected="selected"{/if}>S</option>
			<option value="A" {if $settings.flag == 'A'}selected="selected"{/if}>A</option>
			<option value="P" {if $settings.flag == 'P'}selected="selected"{/if}>P</option>
		</select>
		<div class="pull-right inputTitle mTitle"><br>Protocol+Resolution service:</div>
		<input type="text" id="addRecordParams" name="addRecordParams" class="pull-right form-control input-text" value="{if isset($settings.addRecordParams)}{$settings.addRecordParams}{/if}" autocapitalize="off" spellcheck="false"/><br /><br />
	</div>

	<div class="NAPTR_fields type_fields"><br class="clear" />
		<div class="pull-left fleft inputTitle dTitle">Regular Expression:</div>
		<div class="pull-right fleft inputTitle dTitle">Replacement:</div>
		<div class="clear"></div>
		<div class="pull-left inputTitle mTitle"><br>Regular Expression:</div>
		<input type="text" id="addRecordRegexp" name="addRecordRegexp" class="pull-left form-control input-text" value="{if isset($settings.addRecordRegexp)}{$settings.addRecordRegexp}{/if}" autocapitalize="off" spellcheck="false"/>
		<div class="pull-right inputTitle mTitle"><br>Replacement:</div>
		<input type="text" id="addRecordReplace" name="addRecordReplace" class="pull-right form-control input-text" value="{if isset($settings.addRecordReplace)}{$settings.addRecordReplace}{/if}" autocapitalize="off" spellcheck="false"/><br class="clear" />
	</div>
	
	<div class="SSHFP_fields type_fields"><br class="clear" />
		<div class="pull-left inputTitle fleft dTitle">Algorithm:</div>
		<div class="pull-left inputTitle fleft dTitle">Fingerprint Type:</div>
		<div class="clear"></div>
		<div class="pull-left inputTitle fleft mTitle">Algorithm:</div>
		<select id="addRecordAlgorithm" name="algorithm" class="pull-left form-control">
			<option value="1" {if $settings.algorithm == 1}selected="selected"{/if}>RSA</option>
			<option value="2" {if $settings.algorithm == 2}selected="selected"{/if}>DSA</option>
			<option value="3" {if $settings.algorithm == 3}selected="selected"{/if}>ECDSA</option>
			<option value="4" {if $settings.algorithm == 4}selected="selected"{/if}>Ed25519</option>
		</select>
		<div class="pull-left inputTitle fleft mTitle"><br>Fingerprint Type:</div>
		<select id="addRecordFingerprintType" name="fp_type" class="pull-right form-control">
			<option value="1" {if $settings.fptype == 1}selected="selected"{/if}>SHA-1</option>
			<option value="2" {if $settings.fptype == 2}selected="selected"{/if}>SHA-256</option>
		</select><br class="clear" />
	</div>
	<div class="TLSA_fields type_fields"><br>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleD">Usage:</div>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleD">Selector:</div>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleD">Matching Type:</div>
		<div class="clear"></div>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleM">Usage:</div>
		<select id="addRecordUsage" name="addRecordUsage" class="pull-left form-control selectTLSA">
			<option value="0" {if $settings.usage == 0}selected="selected"{/if}>(0) PKIX-TA: Certificate Authority Constraint</option>
			<option value="1" {if $settings.usage == 1}selected="selected"{/if}>(1) PKIX-EE: Service Certificate Constraint</option>
			<option value="2" {if $settings.usage == 2}selected="selected"{/if}>(2) DANE-TA: Trust Anchor Assertion</option>
			<option value="3" {if $settings.usage == 3}selected="selected"{/if}>(3) DANE-EE: Domain Issued Certificate</option>
		</select>
		<div class="pull-left inputTitle fleft tlsaTitleM"><br>Selector:</div>
		<select id="addRecordSelector" name="addRecordSelector" class="pull-left form-control selectTLSA">
			<option value="0" {if $settings.selector == 0}selected="selected"{/if}>(0) Cert: Use full certificate</option>
			<option value="1" {if $settings.selector == 1}selected="selected"{/if}>(1) SPKI: Use subject public key</option>
		</select>
		<div class="pull-left inputTitle fleft tlsaTitleM"><br>Matching Type:</div>
		<select id="addRecordMatchingType" name="addRecordMatchingType" class="pull-left form-control selectTLSA">
			<option value="0" {if $settings.matchingtype == 0}selected="selected"{/if}>(0) Full: No Hash</option>
			<option value="1" {if $settings.matchingtype == 1}selected="selected"{/if}>(1) SHA-256: SHA-256 hash</option>
			<option value="2" {if $settings.matchingtype == 2}selected="selected"{/if}>(2) SHA-512: SHA-512 hash</option>
		</select><br class="clear" />
	</div>
	<div class="DS_fields type_fields"><br>
		<div class="pull-left inputDS dsInputTitle fleft dsTitleD">Key Tag:</div>
		<div class="pull-left inputDS dsInputTitle fleft dsTitleD">Algorithm:</div>
		<div class="pull-left inputDS dsInputTitle fleft dsTitleD">Digest Type:</div>
		<div class="clear"></div>
		<div class="pull-left inputDS dsInputTitle fleft dsTitleM">Key Tag</div>
		<input type="text" autocapitalize="off" spellcheck="false" autocorrect="off" name="addRecordKeyTag" id="addRecordKeyTag" value="{if isset($settings['key-tag'])}{$settings['key-tag']|@htmlspecialchars}{/if}" class="pull-left form-control selectDS">
		<div class="pull-left inputTitle fleft dsTitleM"><br>Algorithm:</div>
		<select id="addRecordDsAlgorithm" name="addRecordDsAlgorithm" class="pull-left form-control selectDS">
			<option value="2" {if $settings.algorithm == 2}selected="selected"{/if}>(2) Diffie-Hellman</option>
			<option value="3" {if $settings.algorithm == 3}selected="selected"{/if}>(3) DSA-SHA1</option>
			<option value="4" {if $settings.algorithm == 4}selected="selected"{/if}>(4) Elliptic Curve (ECC)</option>
			<option value="5" {if $settings.algorithm == 5}selected="selected"{/if}>(5) RSA-SHA1</option>
			<option value="6" {if $settings.algorithm == 6}selected="selected"{/if}>(6) DSA-SHA1-NSEC3</option>
			<option value="7" {if $settings.algorithm == 7}selected="selected"{/if}>(7) RSA-SHA1-NSEC3</option>
			<option value="8" {if $settings.algorithm == 8}selected="selected"{/if}>(8) RSA-SHA256</option>
			<option value="10" {if $settings.algorithm == 10}selected="selected"{/if}>(10) RSA-SHA512</option>
			<option value="13" {if $settings.algorithm == 13}selected="selected"{/if}>(13) ECDSA Curve P-256 with SHA-256</option>
			<option value="14" {if $settings.algorithm == 14}selected="selected"{/if}>(14) ECDSA Curve P-384 with SHA-384</option>
			<option value="15" {if $settings.algorithm == 15}selected="selected"{/if}>(15) Ed25519</option>
			<option value="16" {if $settings.algorithm == 16}selected="selected"{/if}>(16) Ed448</option>
			<option value="252" {if $settings.algorithm == 252}selected="selected"{/if}>(252) Indirect</option>
			<option value="253" {if $settings.algorithm == 253}selected="selected"{/if}>(253) Private [PRIVATEDNS]</option>
			<option value="254" {if $settings.algorithm == 254}selected="selected"{/if}>(254) Private [PRIVATEOID]</option>
		</select>
		<div class="pull-left inputTitle fleft dsTitleM"><br>Digest Type:</div>	
		<select id="addRecordDigestType" name="addRecordDigestType" class="pull-left form-control selectDS">
			<option value="1" {if $settings['digest-type'] == 1}selected="selected"{/if}>(1) SHA-1</option>
			<option value="2" {if $settings['digest-type'] == 2}selected="selected"{/if}>(2) SHA-256</option>
			<option value="3" {if $settings['digest-type'] == 3}selected="selected"{/if}>(3) GOST R 34.11-94</option>
			<option value="4" {if $settings['digest-type'] == 4}selected="selected"{/if}>(4) SHA-384</option>
		</select><br class="clear" />
	</div>
	<div class="CERT_fields type_fields"><br>
		<div class="pull-left inputCERT certInputTitle fleft certTitleD">Type:</div>
		<div class="pull-left inputCERT certInputTitle fleft certTitleD">Key Tag:</div>
		<div class="pull-left inputCERT certInputTitle fleft certTitleD">Algorithm:</div>
		<div class="pull-left inputCERT certInputTitle fleft certTitleM">Type:</div>
		<select id="addRecordCertType" name="addRecordCertType" class="pull-left form-control selectCERT">
			<option value="1" {if $settings['cert-type'] == 1}selected="selected"{/if}>(1) PKIX</option>
			<option value="2" {if $settings['cert-type'] == 2}selected="selected"{/if}>(2) SPKI</option>
			<option value="3" {if $settings['cert-type'] == 3}selected="selected"{/if}>(3) PGP</option>
			<option value="4" {if $settings['cert-type'] == 4}selected="selected"{/if}>(4) IPKIX</option>
			<option value="5" {if $settings['cert-type'] == 5}selected="selected"{/if}>(5) ISPKI</option>
			<option value="6" {if $settings['cert-type'] == 6}selected="selected"{/if}>(6) IPGP</option>
			<option value="7" {if $settings['cert-type'] == 7}selected="selected"{/if}>(7) ACPKIX</option>
			<option value="8" {if $settings['cert-type'] == 8}selected="selected"{/if}>(8) IACPKIX</option>
			<option value="253" {if $settings['cert-type'] == 253}selected="selected"{/if}>(253) URI</option>
			<option value="254" {if $settings['cert-type'] == 254}selected="selected"{/if}>(254) OID</option>
		</select>
		<div class="pull-left inputTitle fleft certTitleM"><br>Key Tag:</div>
		<input type="text" autocapitalize="off" spellcheck="false" autocorrect="off" name="addRecordCertKeyTag" id="addRecordCertKeyTag" value="{if isset($settings['key-tag'])}{$settings['key-tag']|@htmlspecialchars}{/if}" class="pull-left form-control selectCERT">
		<div class="pull-left inputTitle fleft certTitleM"><br>Algorithm:</div>
		<select id="addRecordCertAlgorithm" name="addRecordCertAlgorithm" class="pull-left form-control selectCERT">
			<option value="2" {if $settings.algorithm == 2}selected="selected"{/if}>(2) Diffie-Hellman</option>
			<option value="3" {if $settings.algorithm == 3}selected="selected"{/if}>(3) DSA-SHA1</option>
			<option value="4" {if $settings.algorithm == 4}selected="selected"{/if}>(4) Elliptic Curve (ECC)</option>
			<option value="5" {if $settings.algorithm == 5}selected="selected"{/if}>(5) RSA-SHA1</option>
			<option value="6" {if $settings.algorithm == 6}selected="selected"{/if}>(6) DSA-SHA1-NSEC3</option>
			<option value="7" {if $settings.algorithm == 7}selected="selected"{/if}>(7) RSA-SHA1-NSEC3</option>
			<option value="8" {if $settings.algorithm == 8}selected="selected"{/if}>(8) RSA-SHA256</option>
			<option value="10" {if $settings.algorithm == 10}selected="selected"{/if}>(10) RSA-SHA512</option>
			<option value="13" {if $settings.algorithm == 13}selected="selected"{/if}>(13) ECDSA Curve P-256 with SHA-256</option>
			<option value="14" {if $settings.algorithm == 14}selected="selected"{/if}>(14) ECDSA Curve P-384 with SHA-384</option>
			<option value="15" {if $settings.algorithm == 15}selected="selected"{/if}>(15) Ed25519</option>
			<option value="16" {if $settings.algorithm == 16}selected="selected"{/if}>(16) Ed448</option>
			<option value="252" {if $settings.algorithm == 252}selected="selected"{/if}>(252) Indirect</option>
			<option value="253" {if $settings.algorithm == 253}selected="selected"{/if}>(253) Private [PRIVATEDNS]</option>
			<option value="254" {if $settings.algorithm == 254}selected="selected"{/if}>(254) Private [PRIVATEOID]</option>
		</select><br class="clear" />
	</div>
	<div class="SMIMEA_fields type_fields"><br>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleD">Usage:</div>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleD">Selector:</div>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleD">Matching Type:</div>
		<div class="clear"></div>
		<div class="pull-left inputTLSA tlsaInputTitle fleft tlsaTitleM">Usage:</div>
		<select id="addRecordSmimeaUsage" name="addRecordSmimeaUsage" class="pull-left form-control selectTLSA">
			<option value="0" {if $settings['smimea-usage'] == 0}selected="selected"{/if}>(0) PKIX-TA: Certificate Authority Constraint</option>
			<option value="1" {if $settings['smimea-usage'] == 1}selected="selected"{/if}>(1) PKIX-EE: Service Certificate Constraint</option>
			<option value="2" {if $settings['smimea-usage'] == 2}selected="selected"{/if}>(2) DANE-TA: Trust Anchor Assertion</option>
			<option value="3" {if $settings['smimea-usage'] == 3}selected="selected"{/if}>(3) DANE-EE: Domain Issued Certificate</option>
		</select>
		<div class="pull-left inputTitle fleft tlsaTitleM"><br>Selector:</div>
		<select id="addRecordSmimeaSelector" name="addRecordSmimeaSelector" class="pull-left form-control selectTLSA">
			<option value="0" {if $settings['smimea-selector'] == 0}selected="selected"{/if}>(0) Cert: Use full certificate</option>
			<option value="1" {if $settings['smimea-selector'] == 1}selected="selected"{/if}>(1) SPKI: Use subject public key</option>
		</select>
		<div class="pull-left inputTitle fleft tlsaTitleM"><br>Matching Type:</div>
		<select id="addRecordSmimeaMatchingType" name="addRecordSmimeaMatchingType" class="pull-left form-control selectTLSA">
			<option value="0" {if $settings['smimea-matching-type'] == 0}selected="selected"{/if}>(0) Full: No Hash</option>
			<option value="1" {if $settings['smimea-matching-type'] == 1}selected="selected"{/if}>(1) SHA-256: SHA-256 hash</option>
			<option value="2" {if $settings['smimea-matching-type'] == 2}selected="selected"{/if}>(2) SHA-512: SHA-512 hash</option>
		</select><br class="clear" />
	</div>
	<br class="clear" />
	<div class="recordContainter">
		<div class="inputTitle records-label">Points to:</div>
		<div class="inputTitle OPENPGPKEY_fields type_fields">PGP key:</div>
		<div class="inputTitle SMIMEA_fields type_fields">Certificate:</div>
		<input type="text" id="addRecordRecord" name="addRecordRecord" value="{if isset($settings.record)}{$settings.record}{/if}" class="pointsTo form-control" autocapitalize="off" spellcheck="false"/> <span class="WR_fields type_fields"><small>Example: http://google.com</small></span><br /><br />
	</div>
	
	<div class="WR_fields type_fields">
		<div><label style="width: 100%;"><input class="pull-left" type="checkbox" id="addRecordWRFrame" name="addRecordWRFrame" value="1" style="width:15px !important;" onClick="toggleOptions('WRFrameOptions');" />Redirect with frame</label></div>
		<div id="WRFrameOptions" style="display:none;">
			Title:<br />
			<input type="text" id="addRecordWRFrameTitle" name="addRecordWRFrameTitle" value="{if isset($settings.addRecordWRFrameTitle)}{$settings.addRecordWRFrameTitle|@htmlspecialchars}{/if}" class="pointsTo" autocapitalize="off" spellcheck="false"/><br /><br />
			Description:<br />
			<input type="text" id="addRecordWRFrameDescription" name="addRecordWRFrameDescription" value="{if isset($settings.addRecordWRFrameDescription)}{$settings.addRecordWRFrameDescription|@htmlspecialchars}{/if}" class="pointsTo" autocapitalize="off" spellcheck="false"/><br /><br />
			Keywords:<br />
			<input type="text" id="addRecordWRFrameKeywords" name="addRecordWRFrameKeywords" value="{if isset($settings.addRecordWRFrameKeywords)}{$settings.addRecordWRFrameKeywords|@htmlspecialchars}{/if}" class="pointsTo" autocapitalize="off" spellcheck="false"/><br /><br />
			<label style="width: 100%;"><input class="pull-left" type="checkbox" id="addRecordWRMobileMeta" name="addRecordWRMobileMeta" value="1" style="width:15px !important;"/>Add mobile responsive meta tags</label>
		</div>


		<label style="width: 100%;"><input class="pull-left" type="checkbox" id="addRecordWRSavePath" name="addRecordWRSavePath" value="1" style="width:15px !important;"/>Save path</label>
		<div id="WRTypeOptions"><br />
			Redirect Type:<br />
			<label style="width: 100%;"><input class="inputRadio pull-left" type="radio" name="wr_type" {if (isset($settings.addRecordWRType) && $settings.addRecordWRType == 301) || !isset($settings.addRecordWRType)}checked="checked"{/if} value="301" /> 301 Moved permanently</label>
			<label style="width: 100%;"><input class="inputRadio pull-left" type="radio" name="wr_type" {if isset($settings.addRecordWRType) && $settings.addRecordWRType != 301}checked="checked"{/if}value="302" /> 302 Temporary redirect</label>
		</div>
		<br />
	</div>
	
	
	<div class="RP_fields type_fields">
		<div class="pull-left inputTitle fleft dTitle" >Responsible person (E-mail):</div>
		<div class="pull-right inputTitle fright dTitle">TXT record:</div>
		<div class="clear"></div>
		<div class="pull-left inputTitle fleft mTitle">Responsible person (E-mail):</div>
		<input type="text" id="addRecordMail" name="addRecordMail" value="{$settings.mail}" class="form-control pull-left fleft" autocapitalize="off" spellcheck="false"/>
		<div class="pull-right inputTitle fleft mTitle"><br>TXT record:</div>
		<input type="text" id="addRecordTxt" name="addRecordTxt" value="{$settings.txt}" class="form-control pull-right fright" autocapitalize="off" spellcheck="false"/><br class="clear" /><br />
	</div>
	
	<div class="CAA_fields type_fields" style="display:none;">
		<div class="pull-left fleft inputTitle dTitle">Flag: <img src="./assets/img/help.gif" class="showTitle" title="The flag depends on your needs. It can be either Non Critical or Critical. Usually the Non Critical is used." alt="[?]" /></div>
		<div class="pull-right fright inputTitle dTitle">Type: <img src="./assets/img/help.gif" class="showTitle" title="The Type is one of issue, issuewild or iodef. Issue is for the specified hostname; Issuewild is for wildcard of the hostname; iodef is for a way to notify the domain owner in case someone tries to order an SSL for the hostname, it's usually an email 'mailto:owner@example.com' or an URL to a web form 'http://falsessl.example.com'." alt="[?]" /></div>
		<div class="clear"></div>
		<div class="pull-left fleft inputTitle mTitle">Flag: <img src="./assets/img/help.gif" class="showTitle mobileInfo mTooltip" rel="popover" data-content="The flag depends on your needs. It can be either Non Critical or Critical. Usually the Non Critical is used." alt="[?]" /></div>
		<select id="addRecordCAAflag" name="addRecordCAAflag" class="pull-left form-control inputTitle fleft">
			<option value="0" {if $settings.caa_flag == 0}selected="selected"{/if}>(0) Non critical</option>
			<option value="128" {if $settings.caa_flag == 128}selected="selected"{/if}>(128) Critical</option>
		</select>
		<div class="pull-right fright inputTitle mTitle"><br>Type: <img src="./assets/img/help.gif" class="showTitle mobileInfo mTooltip" rel="popover" data-content="The Type is one of issue, issuewild or iodef. Issue is for the specified hostname; Issuewild is for wildcard of the hostname; iodef is for a way to notify the domain owner in case someone tries to order an SSL for the hostname, it's usually an email 'mailto:owner@example.com' or an URL to a web form 'http://falsessl.example.com'." alt="[?]" /></div>
		<select id="addRecordCAAtype" name="addRecordCAAtype" class="pull-right form-control inputTitle fright">
			<option value="issue" {if $settings.caa_type == 'issue'}selected="selected"{/if}>issue</option>
			<option value="issuewild" {if $settings.caa_type == 'issuewild'}selected="selected"{/if}>issuewild</option>
			<option value="iodef" {if $settings.caa_type == 'iodef'}selected="selected"{/if}>iodef</option>
		</select>
		<br class="clear" />
	</div>

	<div class="CAA_fields type_fields" style="display:none;"><br />
		<div class="fleft inputSRV inputTitle dTitle">Value: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="The value given from your preferred CA or a value of your choice. It can be the CA hostname or mailto:you@your-mail.com, it depends on the Type and your needs." alt="[?]" /></div>
		<div class="fleft inputSRV inputTitle mTitle">Value: <img src="./assets/img/help.gif" class="showTitle mobileInfo mTooltip" rel="popover" data-content="The value given from your preferred CA or a value of your choice. It can be the CA hostname or mailto:you@your-mail.com, it depends on the Type and your needs." alt="[?]" /></div>
		<br />
		<input type="text" id="addRecordCAAvalue" name="addRecordCAAvalue" value="{$settings.caa_value}" class="form-control input-text addRecordField pointsTo" autocapitalize="off" spellcheck="false"/>
		<br class="clear" /><br />
	</div>
	
	<div class="HINFO_fields type_fields">
		<div class="pull-left inputTitle fleft dTitle">CPU:</div>
		<div class="pull-right inputTitle fright dTitle">OS:</div>
		<div class="clear"></div>
		<div class="pull-left inputTitle fleft mTitle">CPU:</div>
		<input type="text" id="addRecordCPU" name="addRecordCPU" value="{$settings.cpu}" class="form-control pull-left fleft" autocapitalize="off" spellcheck="false"/>
		<div class="pull-right inputTitle fleft mTitle"><br>OS:</div>
		<input type="text" id="addRecordOS" name="addRecordOS" value="{$settings.os}" class="form-control pull-right fright" autocapitalize="off" spellcheck="false"/><br class="clear" /><br />
	</div>
	
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
		<input type="text" id="addRecordLatDeg" name="addRecordLatDeg" value="{$settings['lat-deg']}" class="form-control pull-left fleft inputFirstLOC" autocapitalize="off" spellcheck="false"/>
		<div class="pull-left inputTitle fleft mTitle">Minutes: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 59 If omitted will default to 0." alt="[?]" /></div>
		<input type="text" id="addRecordLatMin" name="addRecordLatMin" value="{$settings['lat-min']}" class="form-control pull-left fleft inputLOC" autocapitalize="off" spellcheck="false"/>
		<div class="pull-left inputTitle fleft mTitle">Seconds: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 59.999 If omitted will default to 0." alt="[?]" /></div>
		<input type="text" id="addRecordLatSec" name="addRecordLatSec" value="{$settings['lat-sec']}" class="form-control pull-left fleft inputLOC" autocapitalize="off" spellcheck="false"/>
		<div class="pull-right inputTitle fleft mTitle selectLOC">Direction:</div>
		<select id="addRecordLatDir" name="addRecordLatDir" class="form-control inputTitle selectLOC">
			<option value="N" {if $settings['lat-dir'] == 'N'}selected="selected"{/if}>North</option>
			<option value="S" {if $settings['lat-dir'] == 'S'}selected="selected"{/if}>South</option>
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
		<input type="text" id="addRecordLongDeg" name="addRecordLongDeg" value="{$settings['long-deg']}" class="form-control pull-left fleft inputFirstLOC" autocapitalize="off" spellcheck="false"/>
		<div class="pull-left inputTitle fleft mTitle">Minutes: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 59 If omitted will default to 0." alt="[?]" /></div>
		<input type="text" id="addRecordLongMin" name="addRecordLongMin" value="{$settings['long-min']}" class="form-control pull-left fleft inputLOC" autocapitalize="off" spellcheck="false"/>
		<div class="pull-left inputTitle fleft mTitle">Seconds: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 59.999 If omitted will default to 0." alt="[?]" /></div>
		<input type="text" id="addRecordLongSec" name="addRecordLongSec" value="{$settings['long-sec']}" class="form-control pull-left fleft inputLOC" autocapitalize="off" spellcheck="false"/>
		<div class="pull-right inputTitle fleft mTitle">Direction:</div>
		<select id="addRecordLongDir" name="addRecordLongDir" class="form-control inputTitle selectLOC">
			<option value="W" {if $settings['long-dir'] == 'W'}selected="selected"{/if}>West</option>
			<option value="E" {if $settings['long-dir'] == 'E'}selected="selected"{/if}>East</option>
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
		<input type="text" id="addRecordAltitude" name="addRecordAltitude" value="{$settings['altitude']}" class="form-control pull-left fleft inputFirstLOC" autocapitalize="off" spellcheck="false"/>
		<div class="pull-left inputTitle fleft mTitle">Size: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 90000000.00 If omitted, size defaults to 1." alt="[?]" /></div>
		<input type="text" id="addRecordSize" name="addRecordSize" value="{$settings['size']}" class="form-control pull-left fleft inputLOC" autocapitalize="off" spellcheck="false"/>
		<div class="pull-left inputTitle fleft mTitle">Horizontal: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 90000000.00 If omitted, horizontal precision defaults to 10000." alt="[?]" /></div>
		<input type="text" id="addRecordHPrecision" name="addRecordHPrecision" value="{$settings['h-precision']}" class="form-control pull-left fleft inputLOC" autocapitalize="off" spellcheck="false"/>
		<div class="pull-right inputTitle fleft mTitle"><br>Vertical: <img src="./assets/img/help.gif" class="showTitle mobileInfo" title="0 - 90000000.00 If omitted, vertical precision defaults to 10." alt="[?]" /></div>
		<input type="text" id="addRecordVPrecision" name="addRecordVPrecision" value="{$settings['v-precision']}" class="form-control pull-right fright inputLOC" autocapitalize="off" spellcheck="false"/><br class="clear" /><br />
	</div>

	<input type="submit" name="do_save" value="Save" class="btn btn-primary btn-input-padded-responsive" />
	
	<br /><br />
	<div class="WR_fields type_fields notification">
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
</form>