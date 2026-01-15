create or replace force editionable view lov_siebel_ansprechpartner (
    anrede,
    titel,
    vorname,
    nachname,
    phone_number,
    mobile_number,
    ap_email,
    rolle,
    return,
    display,
    sort,
    ap_x_fix_phon_country,
    ap_x_fix_phon_onkz,
    ap_x_fix_phon_nr,
    ap_mobil_country,
    ap_mobil_onkz,
    ap_x_mobil_nr,
    kundennummer,
    filialnummer,
    ap_row_id
) as
    select
        anrede,
        titel,
        vorname,
        nachname,
        '+'
        || ap_x_fix_phon_country
        || ap_x_fix_phon_onkz
        || ap_x_fix_phon_nr as phone_number,
        '+'
        || ap_mobil_country
        || ap_mobil_onkz
        || ap_x_mobil_nr    as mobile_number,
        ap_email,
        rolle,
        ap_row_id           as return,
        vorname
        || ' '
        || nachname         as display,
        nachname
        || ' '
        || vorname          as sort,
        ap_x_fix_phon_country,
        ap_x_fix_phon_onkz,
        ap_x_fix_phon_nr,
        ap_mobil_country,
        ap_mobil_onkz,
        ap_x_mobil_nr,
        kundennummer,
        filialnummer,
        ap_row_id
    from
        v_siebel_ansprechpartner
    order by
        nachname,
        vorname asc nulls last;


-- sqlcl_snapshot {"hash":"456a170dad69f75e1ef17ed0f3bc748c1c2f1793","type":"VIEW","name":"LOV_SIEBEL_ANSPRECHPARTNER","schemaName":"ROMA_MAIN","sxml":""}