create or replace force editionable view awh_main.v_hwas_awh_infosec_sysverbindung (
    svb_lfd_nr,
    asy_lfd_nr_out,
    asy_lfd_nr_in,
    trv_lfd_nr,
    vet_lfd_nr,
    int_lfd_nr,
    vef_lfd_nr,
    aut_lfd_nr,
    svb_timestamp,
    svb_user,
    svb_erlauterung
) as
    select
        svb_lfd_nr,
        asy_lfd_nr_out,
        asy_lfd_nr_in,
        trv_lfd_nr,
        vet_lfd_nr,
        int_lfd_nr,
        vef_lfd_nr,
        aut_lfd_nr,
        svb_timestamp,
        svb_user,
        svb_erlauterung
    from
        awh_infosec_sysverbindung;


-- sqlcl_snapshot {"hash":"cf103525c9f14cb0fdeea77d5e4de2f78ebf1564","type":"VIEW","name":"V_HWAS_AWH_INFOSEC_SYSVERBINDUNG","schemaName":"AWH_MAIN","sxml":""}