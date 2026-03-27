create or replace force editionable view am_main.v_awh_hwas_informationscluster (
    incl_uid,
    incl_bezeichnung,
    incl_beschreibung,
    vet_lfd_nr,
    vef_lfd_nr,
    int_lfd_nr,
    aut_lfd_nr,
    inserted,
    updated,
    inserted_by,
    updated_by,
    dom_uid_fk
) as
    select
        incl_uid,
        incl_bezeichnung,
        incl_beschreibung,
        vet_lfd_nr,
        vef_lfd_nr,
        int_lfd_nr,
        aut_lfd_nr,
        inserted,
        updated,
        inserted_by,
        updated_by,
        dom_uid_fk
    from
        hwas_informationscluster;


-- sqlcl_snapshot {"hash":"c4ab9b3c93c82204ffa0773d6c7a50e8fef2241b","type":"VIEW","name":"V_AWH_HWAS_INFORMATIONSCLUSTER","schemaName":"AM_MAIN","sxml":""}