-- liquibase formatted sql
-- changeset AM_MAIN:1774556573976 stripComments:false logicalFilePath:SCDP/am_main/views/v_assets.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/views/v_assets.sql:null:8c26c79a3cc2d6c25d1a0b25c2e6417bd36229b6:create

create or replace force editionable view am_main.v_assets (
    asset_typ,
    asset_uid,
    asset_bezeichnung,
    asset_beschreibung,
    asset_kritis_relevant,
    asset_verantwortlich_sans
) as
    select
        'Site'                  as asset_typ,
        geb.geb_uid             as asset_uid,
        case
            when si.stadt is null then
                geb.site
            else
                si.strasse
                || ' '
                || si.haus_nr
                || ', '
                || si.plz
                || ' '
                || si.stadt
        end                     as asset_bezeichnung,
        geb.geb_beschreibung    as asset_beschreibung,
        geb.geb_kritis_relevant as asset_kritis_relevant,
        null                    as asset_verantwortlich_sans
    from
             hwas_gebaeude geb
        join itwo_site si on si.site = geb.site
    union all
    select
        'Raum'             as asset_typ,
        rm.rm_uid          as asset_uid,
        ir.raum
        || ' ('
        || replace(ir.standortpfad, ' ¤ ', ', ')
        || ')'             as asset_bezeichnung,
        rm.rm_beschreibung as asset_beschreibung,
        0                  as asset_kritis_relevant,
        null               as asset_verantwortlich_sans
    from
             hwas_raum rm
        join itwo_raum ir on ir.raum = rm.raum
    union all
    select
        'Hersteller'         as asset_typ,
        hst.hst_uid          as asset_uid,
        hst.hst_bezeichnung  as asset_bezeichnung,
        hst.hst_beschreibung as asset_beschreibung,
        0                    as asset_kritis_relevant,
        null                 as asset_verantwortlich_sans
    from
        hwas_hersteller hst
    union all
    select
        'Modell'               as asset_typ,
        mdl.mdl_uid            as asset_uid,
        hst.hst_bezeichnung
        || ' '
        || mdl.mdl_bezeichnung as asset_bezeichnung,
        null                   as asset_beschreibung,
        0                      as asset_kritis_relevant,
        null                   as asset_verantwortlich_sans
    from
             hwas_modell mdl
        join hwas_hersteller      hst on hst.hst_uid = mdl.hst_uid
        left outer join hwas_funktionsklasse fkl on fkl.fkl_uid = mdl.fkl_uid
    union all
    select
        'Gerät'                         as asset_typ,
        grt.grt_uid                     as asset_uid,
        grt.grt_assetname               as asset_bezeichnung,
        null                            as asset_beschreibung,
        nvl(fkl.fkl_kritis_relevant, 0) as asset_kritis_relevant,
        grt.grt_data_custodian          as asset_verantwortlich_sans
    from
        hwas_geraet          grt
        left outer join hwas_modell          mdl on mdl.mdl_uid = grt.mdl_uid
        left outer join hwas_funktionsklasse fkl on fkl.fkl_uid = mdl.fkl_uid
    union all
    select
        'Virtuelle Maschine' as asset_typ,
        vm.vm_uid            as asset_uid,
        vm.vm_bezeichnung    as asset_bezeichnung,
        vm.vm_beschreibung   as asset_beschreibung,
        0                    as asset_kritis_relevant,
        vm.vm_san            as asset_verantwortlich_sans
    from
        hwas_virtuelle_maschinen vm
    union all
    select
        'elementares Gerät'             as asset_typ,
        elg.elg_uid                     as asset_uid,
        elg.elg_geraetename             as asset_bezeichnung,
        null                            as asset_beschreibung,
        nvl(fkl.fkl_kritis_relevant, 0) as asset_kritis_relevant,
        elg.elg_data_custodian          as asset_verantwortlich_sans
    from
        hwas_elem_geraet     elg
        left outer join hwas_modell          mdl on mdl.mdl_uid = elg.mdl_uid
        left outer join hwas_funktionsklasse fkl on fkl.fkl_uid = mdl.fkl_uid
    union all
    select
        'Funktionsklasse'       as asset_typ,
        fkl_uid                 as asset_uid,
        fkl.fkl_bezeichnung     as asset_bezeichnung,
        fkl.fkl_beschreibung    as asset_beschreibung,
        fkl.fkl_kritis_relevant as asset_kritis_relevant,
        null                    as asset_verantwortlich_sans
    from
        hwas_funktionsklasse fkl
/*    
union all
select 'Informationssicherheits-Richtlinie' as asset_typ, ll.ll_uid as asset_uid,
ll.ll_titel as asset_bezeichnung,
ll.ll_beschreibung as asset_beschreibung,
1 as asset_kritis_relevant
from hwas_leitlinie ll
*/;

