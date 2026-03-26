create or replace force editionable view awh_main.v_hwas_awh_erhebungsbogen_7 (
    eb7_lfd_nr,
    asy_lfd_nr,
    eb7_hersteller,
    eb7_backend,
    eb7_schnittstellen,
    eb7_timestamp,
    eb7_user
) as
    select
        eb7_lfd_nr,
        asy_lfd_nr,
        eb7_hersteller,
        eb7_backend,
        eb7_schnittstellen,
        eb7_timestamp,
        eb7_user
    from
        awh_erhebungsbogen_7;


-- sqlcl_snapshot {"hash":"b955361809c0b7fc9c4c64eda48cd66d5207f049","type":"VIEW","name":"V_HWAS_AWH_ERHEBUNGSBOGEN_7","schemaName":"AWH_MAIN","sxml":""}