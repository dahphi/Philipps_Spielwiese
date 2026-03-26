-- liquibase formatted sql
-- changeset RK_MAIN:1774561689775 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_isr_awh_system.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_isr_awh_system.sql:null:dfc1eb72103f7c3c4659aeb31f658b92421182db:create

grant read on awh_main.v_isr_awh_system to rk_main;

