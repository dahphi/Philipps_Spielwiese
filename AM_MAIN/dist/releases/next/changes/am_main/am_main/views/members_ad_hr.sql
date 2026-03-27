-- liquibase formatted sql
-- changeset AM_MAIN:1774600128016 stripComments:false logicalFilePath:am_main/am_main/views/members_ad_hr.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/views/members_ad_hr.sql:null:790bbeb4a468ce3247130b2eaf0a65f9773fef0d:create

create or replace force editionable view am_main.members_ad_hr (
    type,
    uuid,
    dn,
    samaccountname,
    first_name,
    last_name,
    vorname,
    nachname,
    unit,
    department,
    grp,
    company,
    status,
    persnr,
    organisationseinheit,
    abrechnungskreis,
    uidnumber,
    manager,
    pnr,
    expire_date
) as
    select
        type,
        uuid,
        dn,
        samaccountname,
        first_name,
        last_name,
        vorname,
        nachname,
        unit,
        department,
        grp,
        company,
        status,
        persnr,
        organisationseinheit,
        abrechnungskreis,
        uidnumber,
        manager,
        pnr,
        expire_date
    from
        core.members_ad_hr;

