-- liquibase formatted sql
-- changeset AM_MAIN:1774556572499 stripComments:false logicalFilePath:SCDP/am_main/synonyms/v_itwo_raum.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/v_itwo_raum.sql:null:ab6eb00ac83f2be3b2c463bcf8d6962e73b4001d:create

create or replace editionable synonym am_main.v_itwo_raum for ims.vi_nc_raum@"IMSP.NETCOLOGNE.INTERN@IMS_INF";

