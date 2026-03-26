create or replace force editionable view awh_main.v_isr_awh_infosec_sysverbindung (
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


-- sqlcl_snapshot {"hash":"17b99dbb37efb8757ac0bff5d2613047c4af9304","type":"VIEW","name":"V_ISR_AWH_INFOSEC_SYSVERBINDUNG","schemaName":"AWH_MAIN","sxml":""}