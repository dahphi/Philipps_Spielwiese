create or replace force editionable view awh_main.v_hwas_awh_tab_schutz_authentizitaet (
    aut_lfd_nr,
    aut_bedeutung
) as
    select
        aut_lfd_nr,
        aut_bedeutung
    from
        awh_tab_schutz_authentizitaet;


-- sqlcl_snapshot {"hash":"0e8a6eccaea68ca9496c4514052b8fbae3965bcf","type":"VIEW","name":"V_HWAS_AWH_TAB_SCHUTZ_AUTHENTIZITAET","schemaName":"AWH_MAIN","sxml":""}