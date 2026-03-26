create or replace force editionable view awh_main.v_isr_awh_tab_schutz_authentizitaet (
    aut_lfd_nr,
    aut_bedeutung
) as
    select
        aut_lfd_nr,
        aut_bedeutung
    from
        awh_tab_schutz_authentizitaet;


-- sqlcl_snapshot {"hash":"28ecd3069a30fc754df236c2d2c2292251f56e70","type":"VIEW","name":"V_ISR_AWH_TAB_SCHUTZ_AUTHENTIZITAET","schemaName":"AWH_MAIN","sxml":""}