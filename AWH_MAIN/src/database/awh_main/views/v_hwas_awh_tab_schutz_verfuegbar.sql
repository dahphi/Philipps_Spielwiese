create or replace force editionable view awh_main.v_hwas_awh_tab_schutz_verfuegbar (
    vef_lfd_nr,
    vef_bedeutung
) as
    select
        vef_lfd_nr,
        vef_bedeutung
    from
        awh_tab_schutz_verfuegbar;


-- sqlcl_snapshot {"hash":"c1bd24076351d81f7c28ebe6d502ef1117e7cbd9","type":"VIEW","name":"V_HWAS_AWH_TAB_SCHUTZ_VERFUEGBAR","schemaName":"AWH_MAIN","sxml":""}