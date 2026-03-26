-- liquibase formatted sql
-- changeset RK_MAIN:1774555708455 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_apex.view.v_risikorelevante_assets_new.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_apex/object_grants/object_grants_as_grantor.rk_apex.view.v_risikorelevante_assets_new.sql:null:0b9553028a4fb0b8c5acf1d7c8d97bf3b51026a0:create

grant read on rk_apex.v_risikorelevante_assets_new to rk_main;

