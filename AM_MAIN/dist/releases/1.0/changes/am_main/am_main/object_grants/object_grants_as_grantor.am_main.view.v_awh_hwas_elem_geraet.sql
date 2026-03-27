-- liquibase formatted sql
-- changeset AM_MAIN:1774600102180 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_elem_geraet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_elem_geraet.sql:null:8a992d23db84b1f80f56867803269c7bcc38159d:create

grant select on am_main.v_awh_hwas_elem_geraet to awh_apex;

grant select on am_main.v_awh_hwas_elem_geraet to awh_main;

