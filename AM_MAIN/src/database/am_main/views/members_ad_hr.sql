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


-- sqlcl_snapshot {"hash":"790bbeb4a468ce3247130b2eaf0a65f9773fef0d","type":"VIEW","name":"MEMBERS_AD_HR","schemaName":"AM_MAIN","sxml":""}