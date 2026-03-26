-- liquibase formatted sql
-- changeset rk_main:1774555708462 stripComments:false logicalFilePath:SCDP/rk_main/comments/ad_abteilungsaccount.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/ad_abteilungsaccount.sql:null:d3a82110f2aeca1c6bece90836f996750f38cd79:create

comment on column rk_main.ad_abteilungsaccount.aaa_displayname is
    'Anzeigename des Accounts';

comment on column rk_main.ad_abteilungsaccount.aaa_distinguishedname is
    'DistinguischedName aus dem Acitve Driectory';

comment on column rk_main.ad_abteilungsaccount.aaa_san is
    'sAMAccountName des Accounts';

comment on column rk_main.ad_abteilungsaccount.aaa_uid is
    'unique key';

comment on column rk_main.ad_abteilungsaccount.aa_uid is
    'Fremdschlussel AD-Abteiung';

