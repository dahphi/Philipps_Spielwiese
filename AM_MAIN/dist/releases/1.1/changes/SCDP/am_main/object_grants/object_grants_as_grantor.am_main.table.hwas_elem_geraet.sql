-- liquibase formatted sql
-- changeset AM_MAIN:1774557115789 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_elem_geraet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_elem_geraet.sql:null:23e1da1d9de6e51a50d1d539777d693af74392f5:create

grant insert on am_main.hwas_elem_geraet to am_apex;

grant select on am_main.hwas_elem_geraet to am_apex;

grant select on am_main.hwas_elem_geraet to rk_apex;

grant read on am_main.hwas_elem_geraet to awh_apex;

grant read on am_main.hwas_elem_geraet to rk_apex;

grant read on am_main.hwas_elem_geraet to rk_main;

grant read on am_main.hwas_elem_geraet to awh_read_jira;

