-- liquibase formatted sql
-- changeset AM_MAIN:1774556574036 stripComments:false logicalFilePath:SCDP/am_main/views/v_awh_hwas_elem_geraet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/views/v_awh_hwas_elem_geraet.sql:null:c19d630e32b0f12ef99160da62b396ee2f7a7dc8:create

create or replace force editionable view am_main.v_awh_hwas_elem_geraet (
    elg_uid,
    mdl_uid,
    elg_geraetename,
    elg_herstell_inbetrnhm_jahr,
    rm_uid,
    inserted,
    updated,
    inserted_by,
    updated_by,
    elg_link_fremdsystem,
    elg_zielsystem,
    geb_uid,
    hst_uid,
    elg_data_custodian,
    quellsystem_id,
    elg_quellsystem,
    gvb_uid,
    fkl_uid,
    status
) as
    select
        elg.elg_uid,
        elg.mdl_uid,
        elg.elg_geraetename,
        elg.elg_herstell_inbetrnhm_jahr,
        rm.rm_uid,
        elg.inserted,
        elg.updated,
        elg.inserted_by,
        elg.updated_by,
        elg.elg_link_fremdsystem,
        elg.elg_zielsystem,
        rm.geb_uid,
        elg.hst_uid,
        elg.elg_data_custodian,
        elg.quellsystem_id,
        elg.elg_quellsystem,
        elg.gvb_uid,
        elg.fkl_uid,
        elg.status
    from
             hwas_elem_geraet elg
        join hwas_raum rm on elg.rm_uid = rm.rm_uid;

