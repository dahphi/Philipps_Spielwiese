create or replace force editionable view awh_main.v_isr_awh_erhebungsbogen_7 (
    eb7_lfd_nr,
    asy_lfd_nr,
    eb7_hersteller,
    eb7_backend,
    eb7_schnittstellen,
    eb7_timestamp,
    eb7_user
) as
    select
        eb7_lfd_nr,
        asy_lfd_nr,
        eb7_hersteller,
        eb7_backend,
        eb7_schnittstellen,
        eb7_timestamp,
        eb7_user
    from
        awh_erhebungsbogen_7;


-- sqlcl_snapshot {"hash":"4992826de3788338b3bc34b4b61f4fae101ba72a","type":"VIEW","name":"V_ISR_AWH_ERHEBUNGSBOGEN_7","schemaName":"AWH_MAIN","sxml":""}