-- liquibase formatted sql
-- changeset AM_MAIN:1774556568242 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_anlagenkategorie_e3.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_anlagenkategorie_e3.sql:null:2317b6b2ccafdb0019844f1a223561e0d576b778:create

grant select on am_main.v_awh_hwas_anlagenkategorie_e3 to awh_apex;

