-- liquibase formatted sql
-- changeset AM_MAIN:1774557116144 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_tk_technologie.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_tk_technologie.sql:null:f31801637fde424856a7237fff20022466d30ca5:create

grant select on am_main.v_awh_hwas_tk_technologie to awh_apex;

grant select on am_main.v_awh_hwas_tk_technologie to awh_main;

