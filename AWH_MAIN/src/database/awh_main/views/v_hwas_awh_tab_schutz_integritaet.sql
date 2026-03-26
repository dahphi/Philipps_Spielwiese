create or replace force editionable view awh_main.v_hwas_awh_tab_schutz_integritaet (
    int_lfd_nr,
    int_bedeutung
) as
    select
        int_lfd_nr,
        int_bedeutung
    from
        awh_tab_schutz_integritaet;


-- sqlcl_snapshot {"hash":"65eef3c9110de8145266aef9b6165016aa4169f4","type":"VIEW","name":"V_HWAS_AWH_TAB_SCHUTZ_INTEGRITAET","schemaName":"AWH_MAIN","sxml":""}