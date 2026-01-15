-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991472 stripComments:false logicalFilePath:develop/roma_main/views/lov_siebel_ansprechpartner.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/views/lov_siebel_ansprechpartner.sql:null:bf00e4499764093f9f8b4a965e49ce801d2f82e3:create

create or replace force editionable view roma_main.lov_siebel_ansprechpartner (
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

