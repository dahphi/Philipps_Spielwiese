create or replace force editionable view awh_main.v_isr_awh_tab_schutz_integritaet (
    int_lfd_nr,
    int_bedeutung
) as
    select
        int_lfd_nr,
        int_bedeutung
    from
        awh_tab_schutz_integritaet;


-- sqlcl_snapshot {"hash":"18b61f495eb16950f978753becb005992933c215","type":"VIEW","name":"V_ISR_AWH_TAB_SCHUTZ_INTEGRITAET","schemaName":"AWH_MAIN","sxml":""}