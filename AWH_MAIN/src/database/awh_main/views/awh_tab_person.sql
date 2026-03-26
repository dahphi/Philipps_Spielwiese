create or replace force editionable view awh_main.awh_tab_person (
    id,
    per_ad_short,
    per_name,
    per_abteilung,
    per_email,
    per_telefon,
    per_bereich,
    per_gruppe,
    per_buero,
    erzeugt,
    geaendert
) as
    select
        uuid                  as id,
        upper(samaccountname) as per_ad_short,
        name                  as per_name,
        department            as per_abteilung,
        mail                  as per_email,
        telephone             as per_telefon,
        unit                  as per_bereich,
        grp                   as per_gruppe,
        office                as per_buero,
        created               as erzeugt,
        updated               as geaendert
    from
        core.v_members
    where
            status = 'ENABLED'
        and company like 'Net%';


-- sqlcl_snapshot {"hash":"ffefe62e16b3b4cc0f03da15926970042e08f332","type":"VIEW","name":"AWH_TAB_PERSON","schemaName":"AWH_MAIN","sxml":""}