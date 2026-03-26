create or replace force editionable view awh_main.v_hwas_awh_tab_schutz_vertraulich (
    vet_lfd_nr,
    vet_bedeutung
) as
    select
        vet_lfd_nr,
        vet_bedeutung
    from
        awh_tab_schutz_vertraulich;


-- sqlcl_snapshot {"hash":"01f468cfde6bf2d2ea9ef19781708be3918e9c4e","type":"VIEW","name":"V_HWAS_AWH_TAB_SCHUTZ_VERTRAULICH","schemaName":"AWH_MAIN","sxml":""}