-- liquibase formatted sql
-- changeset AM_MAIN:1774556571716 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pkg_bic_import.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pkg_bic_import.sql:null:e0f62b1680f47f4d7a77a8ea9f84e2fd5a44ac1d:create

create or replace package body am_main.pkg_bic_import as

------------------------------------------------------------
-- Prozedur um die Daten von BIC_MODELLE_IMPORT zu kopieren nach BIC_IMPORT
-- ein Teil von PFAD wird ignoriert da die ersten 2 Segmente unwichtig für uns sind
-- PFAD wird in Segmente unterteielt und dann aufgesplittet in Pfad1 (Prozesstyp) bis Pfad6 (Prozessstufen)
--SYSDATE Speichert das ImportDatum damit wir in Zukunft den letzten Import mit dem Aktuellen vergleichen können.
------------------------------------------------------------
    procedure prc_bic_modelle_to_import as
    begin
        insert into am_main.bic_import (
            unknown,
            guid,
            typname,
            pfad1,
            pfad2,
            pfad3,
            pfad4,
            pfad5,
            pfad6,
            prozessname,
            bereich,
            prozessowner,
            import_datum
        )
            select
                m.at_name  as unknown,
                m.bic_guid as guid,
                m.typname  as typname,
    /* PFAD: erste 2 Segmente ignorieren -> 3..8 in PFAD1..6  */
                trim(regexp_substr(
                    trim(both '/' from m.pfad),
                    '[^/]+',
                    1,
                    3
                ))         as pfad1,
                trim(regexp_substr(
                    trim(both '/' from m.pfad),
                    '[^/]+',
                    1,
                    4
                ))         as pfad2,
                trim(regexp_substr(
                    trim(both '/' from m.pfad),
                    '[^/]+',
                    1,
                    5
                ))         as pfad3,
                trim(regexp_substr(
                    trim(both '/' from m.pfad),
                    '[^/]+',
                    1,
                    6
                ))         as pfad4,
                trim(regexp_substr(
                    trim(both '/' from m.pfad),
                    '[^/]+',
                    1,
                    7
                ))         as pfad5,
                trim(regexp_substr(
                    trim(both '/' from m.pfad),
                    '[^/]+',
                    1,
                    8
                ))         as pfad6,
                m.name     as prozessname,
                null       as bereich,
                null       as prozessowner,
                sysdate    as import_datum
            from
                am_main.bic_modelle_import m;

        commit;
    end prc_bic_modelle_to_import;

--------------------------------------------------------------------------------
--Prozedur die prüft ob aus den neuen Daten ein neuer PROZESSTYP angelegt werden muss
--------------------------------------------------------------------------------

    procedure prc_sync_prozesstyp_from_import as
        v_cutoff_day date;
    begin
  -- Stichtag bestimmen: jüngster Import-Tag (oder heute, falls INSERTED leer ist)
        select
            nvl(
                max(trunc(i.import_datum)),
                trunc(sysdate)
            )
        into v_cutoff_day
        from
            am_main.bic_import i;

  -- Einfügen fehlender Prozesstypen basierend auf PFAD1 der neuen Importe
        insert into am_main.hwas_prozesstyp (
            prz_uid,
            name,
            beschreibung,
            inserted,
            inserted_by,
            updated,
            updated_by
        )
            select
                to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') as prz_uid,
                t.pfad1                                                         as name,
                null                                                            as beschreibung,
                sysdate                                                         as inserted,
                user                                                            as inserted_by,
                sysdate                                                         as updated,
                user                                                            as updated_by
            from
                (
                    select distinct
                        trim(pfad1) as pfad1
                    from
                        am_main.bic_import
                    where
                            trunc(nvl(import_datum, sysdate)) = v_cutoff_day
                        and pfad1 is not null
                ) t
            where
                not exists (
                    select
                        1
                    from
                        am_main.hwas_prozesstyp p
                    where
                        upper(p.name) = upper(t.pfad1)
                );

    end prc_sync_prozesstyp_from_import;

end pkg_bic_import;
/

