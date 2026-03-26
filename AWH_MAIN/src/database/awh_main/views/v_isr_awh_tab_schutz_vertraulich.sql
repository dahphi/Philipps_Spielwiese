create or replace force editionable view awh_main.v_isr_awh_tab_schutz_vertraulich (
    vet_lfd_nr,
    vet_bedeutung
) as
    select
        vet_lfd_nr,
        vet_bedeutung
    from
        awh_tab_schutz_vertraulich;


-- sqlcl_snapshot {"hash":"a9d0d2cf128fc939cbbf5cecaac42c1d58650edf","type":"VIEW","name":"V_ISR_AWH_TAB_SCHUTZ_VERTRAULICH","schemaName":"AWH_MAIN","sxml":""}