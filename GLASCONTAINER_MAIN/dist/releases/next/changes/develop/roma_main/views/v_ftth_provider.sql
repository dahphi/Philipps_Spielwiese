-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991503 stripComments:false logicalFilePath:develop/roma_main/views/v_ftth_provider.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/views/v_ftth_provider.sql:null:b6a487caca324d089c72ea3cef20c9988fe8f9a8:create

create or replace force editionable view roma_main.v_ftth_provider (
    r,
    d1,
    d_siebel
) as
    select
        pv_key2 as r,
        v_wert1 as d1,
        v_wert2 as d_siebel
    from
        params
    where
        pv_key1 = 'FTTH_PROVIDER';

