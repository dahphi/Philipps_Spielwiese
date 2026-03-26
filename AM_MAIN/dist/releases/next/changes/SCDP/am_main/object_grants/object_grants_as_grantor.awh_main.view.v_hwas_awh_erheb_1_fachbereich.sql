-- liquibase formatted sql
-- changeset AM_MAIN:1774556574184 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_erheb_1_fachbereich.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_erheb_1_fachbereich.sql:null:23ab07ede2de82eebc706b2b4696e29cde91b13e:create

grant select on awh_main.v_hwas_awh_erheb_1_fachbereich to am_main;

grant references on awh_main.v_hwas_awh_erheb_1_fachbereich to am_main;

