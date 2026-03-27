create or replace force editionable view am_main.v_awh_hwas_funktionsklasse (
    fkl_uid,
    fkl_bezeichnung,
    fkl_beschreibung,
    inserted,
    updated,
    inserted_by,
    updated_by,
    tkt_uid,
    fkl_kritis_relevant
) as
    select
        fkl_uid,
        fkl_bezeichnung,
        fkl_beschreibung,
        inserted,
        updated,
        inserted_by,
        updated_by,
        tkt_uid,
        fkl_kritis_relevant
    from
        hwas_funktionsklasse;


-- sqlcl_snapshot {"hash":"b145c093c18b0e4b21ee49270b87f473b69ec78f","type":"VIEW","name":"V_AWH_HWAS_FUNKTIONSKLASSE","schemaName":"AM_MAIN","sxml":""}