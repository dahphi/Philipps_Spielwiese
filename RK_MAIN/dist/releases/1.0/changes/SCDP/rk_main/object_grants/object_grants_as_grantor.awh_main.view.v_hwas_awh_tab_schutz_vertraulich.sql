-- liquibase formatted sql
-- changeset RK_MAIN:1774561689755 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_vertraulich.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_vertraulich.sql:null:08e6f5582649df96716c4a3d0fa4f0b7ff0ac900:create

grant select on awh_main.v_hwas_awh_tab_schutz_vertraulich to rk_main;

grant references on awh_main.v_hwas_awh_tab_schutz_vertraulich to rk_main;

