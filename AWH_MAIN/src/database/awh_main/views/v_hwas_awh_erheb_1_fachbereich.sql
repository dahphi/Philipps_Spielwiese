create or replace force editionable view awh_main.v_hwas_awh_erheb_1_fachbereich (
    erf_lfd_nr,
    asy_lfd_nr,
    vet_lfd_nr,
    buu_lfd_nr,
    erf_timestamp,
    erf_user,
    per_lfd_nr
) as
    select
        erf_lfd_nr,
        asy_lfd_nr,
        vet_lfd_nr,
        buu_lfd_nr,
        erf_timestamp,
        erf_user,
        per_lfd_nr
    from
        awh_erheb_1_fachbereich;


-- sqlcl_snapshot {"hash":"cc15b56600c014c4274dc94473d7ff7a6ef5ed7e","type":"VIEW","name":"V_HWAS_AWH_ERHEB_1_FACHBEREICH","schemaName":"AWH_MAIN","sxml":""}