-- liquibase formatted sql
-- changeset RK_MAIN:1774554915826 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_erheb_1_fachbereich.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_erheb_1_fachbereich.sql:null:a65ec8c1c07211b8248b0406caf667b163f46986:create

grant select on awh_main.v_hwas_awh_erheb_1_fachbereich to rk_main;

grant references on awh_main.v_hwas_awh_erheb_1_fachbereich to rk_main;

