-- liquibase formatted sql
-- changeset rk_main:1774554915991 stripComments:false logicalFilePath:SCDP/rk_main/comments/ad_abteilung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/ad_abteilung.sql:null:4009ae208c6bde8a58d69f5715b7dadbd054f270:create

comment on column rk_main.ad_abteilung.aa_dn is
    'DistinguishedName';

comment on column rk_main.ad_abteilung.aa_uid is
    'primary Key';

