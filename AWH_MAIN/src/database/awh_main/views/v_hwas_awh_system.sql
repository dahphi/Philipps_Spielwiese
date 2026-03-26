create or replace force editionable view awh_main.v_hwas_awh_system (
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


-- sqlcl_snapshot {"hash":"758b77d4fa7bc60c50d8615a2a90825ebd39fab6","type":"VIEW","name":"V_HWAS_AWH_SYSTEM","schemaName":"AWH_MAIN","sxml":""}