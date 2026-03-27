-- liquibase formatted sql
-- changeset AM_MAIN:1774600129468 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_authentizitaet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_authentizitaet.sql:null:e59d404ef24847b23cb5f4678c971ec2d0776266:create

grant select on awh_main.v_hwas_awh_tab_schutz_authentizitaet to am_main;

grant references on awh_main.v_hwas_awh_tab_schutz_authentizitaet to am_main;

