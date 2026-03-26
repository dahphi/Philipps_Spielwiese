-- liquibase formatted sql
-- changeset AM_MAIN:1774557120658 stripComments:false logicalFilePath:SCDP/am_main/synonyms/v_itwo_site.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/v_itwo_site.sql:null:b94016eab8d0d88a26a0519c8bf7065dde5b1b6e:create

create or replace editionable synonym am_main.v_itwo_site for ims.vi_nc_site@"IMSP.NETCOLOGNE.INTERN@IMS_INF";

