-- liquibase formatted sql
-- changeset AM_MAIN:1774600102226 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_geraet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_geraet.sql:null:902726d9c4109f055c39c1f8d95178df9ea4d909:create

grant select on am_main.v_awh_hwas_geraet to awh_apex;

grant select on am_main.v_awh_hwas_geraet to awh_main;

