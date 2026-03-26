create or replace force editionable view awh_main.v_isr_awh_tab_schutz_verfuegbar (
    vef_lfd_nr,
    vef_bedeutung
) as
    select
        vef_lfd_nr,
        vef_bedeutung
    from
        awh_tab_schutz_verfuegbar;


-- sqlcl_snapshot {"hash":"d9fc71ca46fc5187f5aab8b9d6e190cec79d294a","type":"VIEW","name":"V_ISR_AWH_TAB_SCHUTZ_VERFUEGBAR","schemaName":"AWH_MAIN","sxml":""}