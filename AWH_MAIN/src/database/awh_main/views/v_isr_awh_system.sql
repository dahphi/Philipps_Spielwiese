create or replace force editionable view awh_main.v_isr_awh_system (
    asy_lfd_nr,
    asy_name,
    asy_funktion,
    asy_abgrenzung,
    asy_einfuehrung,
    asy_kommentar,
    asy_timestamp,
    asy_user,
    asy_aktiv,
    asy_aufrufpfad,
    asy_geloescht,
    asy_startapp
) as
    select
        asy_lfd_nr,
        asy_name,
        asy_funktion,
        asy_abgrenzung,
        asy_einfuehrung,
        asy_kommentar,
        asy_timestamp,
        asy_user,
        asy_aktiv,
        asy_aufrufpfad,
        asy_geloescht,
        asy_startapp
    from
        awh_system;


-- sqlcl_snapshot {"hash":"daef4fde5714bc75d4de12f3dcc07bbee7cb2511","type":"VIEW","name":"V_ISR_AWH_SYSTEM","schemaName":"AWH_MAIN","sxml":""}