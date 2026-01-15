-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991492 stripComments:false logicalFilePath:develop/roma_main/views/v_ftth_factory.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/views/v_ftth_factory.sql:null:d38ec316b669631d73297d75cb55fca4bfd68f9f:create

create or replace force editionable view roma_main.v_ftth_factory (
    ftth_id,
    ftthag_id,
    ansichtsgruppe,
    rf1,
    rf2,
    status,
    label,
    typ,
    apex_label,
    apex_anzeige,
    apex_modus,
    ws_name,
    ws_path,
    ws_datatype,
    ws_datalength,
    ws_required,
    werte,
    kommentar,
    offen,
    ag_status,
    apex_item_name
) as
    (
        select
            f.ftth_id,
            f.ftthag_id,
            ag.name        as ansichtsgruppe,
            ag.reihenfolge as rf1,
            f.reihenfolge  as rf2,
            f.status       as status,
            f.label,
            f.typ,
            f.apex_label,
            f.apex_anzeige,
            f.apex_modus,
            null           ws_name,
            f.ws_path,
            f.ws_datatype,
            f.ws_datalength,
            f.ws_required,
            f.werte,
            f.kommentar,
            f.offen,
            ag.status      as ag_status,
            f.apex_item_name
        from
            ftth_factory                 f
            left join ftth_factory_ansichtsgruppen ag on ( ag.ftthag_id = f.ftthag_id )
    );

