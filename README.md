# ClouDNS WHMCS DNS Provisioning Module

Offer free or paid DNS hosting through WHMCS using the ClouDNS API. Customers can manage DNS records, import zones, edit SOA settings, and view DNS statistics from the WHMCS client area. Products can use per-service zone and record limits, branded name servers, zone templates, and DNS Failover.

## Download and requirements

- [Download the official ClouDNS v1.9 package](https://www.cloudns.net/download/cloudns_provisioning_module_for_WHMCS.v1.9.zip).
- ClouDNS lists WHMCS 5 through 9 as compatible. Use the PHP version and extensions required by your WHMCS release. The module uses PHP cURL for API requests and can use PHP Intl for internationalized domain names.
- Use a ClouDNS Premium DNS or DDoS Protected DNS plan with API credentials.

The release ZIP contains a `cloudns/` directory. In this repository, the module files are under `src/`. For a source checkout, deploy the contents of `src/` as `<whmcs>/modules/servers/cloudns/`.

## Install

1. Extract the release and copy the `cloudns/` directory into `<whmcs>/modules/servers/`. The resulting entry point is `<whmcs>/modules/servers/cloudns/cloudns.php`.
2. Create the module table in the WHMCS database for a new installation.

   ```sql
   CREATE TABLE IF NOT EXISTS mod_cloudns_zones (
       id INT UNSIGNED NOT NULL AUTO_INCREMENT,
       serviceid INT NOT NULL,
       name VARCHAR(255) NOT NULL,
       fo_checks INT UNSIGNED NOT NULL DEFAULT 0,
       PRIMARY KEY (id),
       UNIQUE KEY zone_name (name)
   ) ENGINE=InnoDB;
   ```

3. Edit `cloudns_core/configuration.php` in the deployed module. Set `$_apiAuthId` and `$_apiAuthPassword` to your ClouDNS API credentials. Keep the configured file out of source control.
4. Create a WHMCS product or open an existing one. On **Module Settings**, select **ClouDNS DNS Manager**. Set the zone limit and any record limit, then save. Use **Servers** for product-level name servers or set `$_DnsServers` for a global override. If both are empty, the module uses the account's default name servers.

### DNS for registered domains

1. Enable **Registered domains** on the product's **Module Settings** tab.
2. To provision the DNS service automatically on registration or completed transfer, set `$_pid` to that WHMCS product ID and `$_admin` to a WHMCS administrator with API access. Install the supplied `cloudns_core/hooks/cloudns.php` as `<whmcs>/includes/hooks/cloudns.php`. The module's own `hooks.php` stays in the module directory.
3. If you offer DNS Failover for registered domains, check that `tbldomains.fo_checks` exists. Add it through the [registered domains setup guide](https://www.cloudns.net/wiki/article/180/) if it is missing, then configure the product's **DNS Failover checks** limit.

## Upgrade to v1.9

1. Back up the installed module, the WHMCS database, and any customized copy of the registered domains hook.
2. Extract v1.9 outside the live modules directory. Transfer your existing API credentials, product ID, administrator setting, name servers, and relevant customizations into the new version.
3. For installations from v1.4 or earlier, check the existing schema before applying the [legacy upgrade steps](https://www.cloudns.net/wiki/article/179/). The `fo_checks` column belongs in `mod_cloudns_zones` for standard services and in `tbldomains` for registered domains using DNS Failover. `CREATE TABLE IF NOT EXISTS` leaves an existing table's columns as they are.
4. Replace `<whmcs>/modules/servers/cloudns/` with the prepared directory. If you use the registered domains hook, compare its installed copy with the supplied hook. Clear the WHMCS template cache if the client area still shows the old forms.
5. Check the module settings and open an existing DNS service in the client area. Verify the existing zones and try adding and editing a record in a test zone.

## What's new in v1.9

- Support for HTTPS and SVCB records.
- Support for the CAA tags `issuemail`, `issuevmc`, `contactemail`, and `contactphone`.
- WHMCS 9 support and bug fixes.

## Documentation and support

- [ClouDNS module overview](https://www.cloudns.net/whmcs-module/)
- [Installation and configuration guide](https://www.cloudns.net/wiki/article/176/)
- [Upgrade guide](https://www.cloudns.net/wiki/article/179/)
- [Changelog](https://www.cloudns.net/wiki/article/177/)
- [ClouDNS support](https://www.cloudns.net/contact/)
- [Report a repository issue](https://github.com/ClouDNS/whmcs-dns-provisioning-module/issues). Remove credentials from diagnostic output and logs before attaching them.
