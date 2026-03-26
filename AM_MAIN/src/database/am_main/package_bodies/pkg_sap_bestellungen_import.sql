create or replace package body am_main.pkg_sap_bestellungen_import as

    procedure pr_update_bestellungen_import is
    begin
        merge into hwas_sap_beauftragungen z
        using sap_inf.ekko_export q on ( z.primarykey_sap = q.primaerkey )
        when matched then update
        set z.lieferant = q.lieferant,
            z.name1 = q.name1,
            z.bestellung = q.bestellung,
            z.bestellposition = q.bestellposition,
            z.lieferdatum_position = q.lieferdatum_position,
            z.warengruppe = q.warengruppe,
            z.bezeichnung_warengruppe = q.bezeichnung_warengruppe,
            z.kurztext_position = q.kurztext_position,
            z.buchungskreis = q.buchungskreis,
            z.ersteller = q.ersteller,
            z.vorname = q.vorname,
            z.nachname = q.nachname,
            z.erstellungsdatum = q.erstellungsdatum,
            z.einkaeufergruppe = q.einkaeufergruppe,
            z.bezeichnung_einkaeufergruppe = q.bezeichnung_einkaeufergruppe,
            z.anforderer = q.anforderer,
            z.nettobestellwert_bestellwaehrung = q.nettobestellwert,
            z.waehrung = q.waehrung,
            z.kontierungstyp = q.kontierungstyp,
            z.kontierungsobjekt = q.kontierungsobjekt,
            z.verantwortlicher = q.verantwortlicher,
            z.verantwortliche_kostenstelle = q.verantwortlicher_kostenstelle,
            z.sachkonto = q.sachkonto,
            z.auftrag = q.auftrag,
            z.splitwert = q.splitwert
        where
            nvl(z.lieferant, '§NULL§') <> nvl(q.lieferant, '§NULL§')
            or nvl(z.name1, '§NULL§') <> nvl(q.name1, '§NULL§')
            or nvl(z.bestellung, '§NULL§') <> nvl(q.bestellung, '§NULL§')
            or nvl(z.bestellposition, '§NULL§') <> nvl(q.bestellposition, '§NULL§')
            or nvl(z.lieferdatum_position, '§NULL§') <> nvl(q.lieferdatum_position, '§NULL§')
            or nvl(z.warengruppe, '§NULL§') <> nvl(q.warengruppe, '§NULL§')
            or nvl(z.bezeichnung_warengruppe, '§NULL§') <> nvl(q.bezeichnung_warengruppe, '§NULL§')
            or nvl(z.kurztext_position, '§NULL§') <> nvl(q.kurztext_position, '§NULL§')
            or nvl(z.buchungskreis, '§NULL§') <> nvl(q.buchungskreis, '§NULL§')
            or nvl(z.ersteller, '§NULL§') <> nvl(q.ersteller, '§NULL§')
            or nvl(z.vorname, '§NULL§') <> nvl(q.vorname, '§NULL§')
            or nvl(z.nachname, '§NULL§') <> nvl(q.nachname, '§NULL§')
            or nvl(z.erstellungsdatum, '§NULL§') <> nvl(q.erstellungsdatum, '§NULL§')
            or nvl(z.einkaeufergruppe, '§NULL§') <> nvl(q.einkaeufergruppe, '§NULL§')
            or nvl(z.bezeichnung_einkaeufergruppe, '§NULL§') <> nvl(q.bezeichnung_einkaeufergruppe, '§NULL§')
            or nvl(z.anforderer, '§NULL§') <> nvl(q.anforderer, '§NULL§')
            or nvl(z.nettobestellwert_bestellwaehrung, '§NULL§') <> nvl(q.nettobestellwert, '§NULL§')
            or nvl(z.waehrung, '§NULL§') <> nvl(q.waehrung, '§NULL§')
            or nvl(z.kontierungstyp, '§NULL§') <> nvl(q.kontierungstyp, '§NULL§')
            or nvl(z.kontierungsobjekt, '§NULL§') <> nvl(q.kontierungsobjekt, '§NULL§')
            or nvl(z.verantwortlicher, '§NULL§') <> nvl(q.verantwortlicher, '§NULL§')
            or nvl(z.verantwortliche_kostenstelle, '§NULL§') <> nvl(q.verantwortlicher_kostenstelle, '§NULL§')
            or nvl(z.sachkonto, '§NULL§') <> nvl(q.sachkonto, '§NULL§')
            or nvl(z.auftrag, '§NULL§') <> nvl(q.auftrag, '§NULL§')
            or nvl(z.splitwert, '§NULL§') <> nvl(q.splitwert, '§NULL§');

    end pr_update_bestellungen_import;

    procedure pr_neuer_lieferanten_import is
    begin
        insert into sap_lieferanten (
            lie_uid,
            bezeichnung,
            inserted,
            inserted_by,
            updated,
            updated_by,
            kreditoren_nr,
            link_kooperationsfreigabe,
            bemerkung
        )
            select
                to_number(substr(
                    rawtohex(sys_guid()),
                    1,
                    30
                ),
                          'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                q.name1,
                sysdate,
                user,
                null,
                null,
                null,
                null,
                null
            from
                (
                    select distinct
                        name1
                    from
                        sap_inf.ekko_export
                    where
                        name1 is not null
                ) q
            where
                not exists (
                    select
                        1
                    from
                        sap_lieferanten z
                    where
                        z.bezeichnung = q.name1
                );

        insert into sap_lieferanten_kreditoren_nr (
            likr_uid,
            lie_uid_fk,
            kred_nr_sap,
            inserted,
            inserted_by,
            kred_nr_sap_vc
        )
            select
                to_number(substr(
                    rawtohex(sys_guid()),
                    1,
                    30
                ),
                          'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                sl.lie_uid,
                q.lieferant,
                sysdate,
                user,
                null
            from
                     (
                    select distinct
                        name1,
                        lieferant
                    from
                        sap_inf.ekko_export
                    where
                        name1 is not null
                        and lieferant is not null
                ) q
                join sap_lieferanten sl on sl.bezeichnung = q.name1
            where
                not exists (
                    select
                        1
                    from
                        sap_lieferanten_kreditoren_nr skr
                    where
                            skr.lie_uid_fk = sl.lie_uid
                        and skr.kred_nr_sap = q.lieferant
                );

    end pr_neuer_lieferanten_import;

    procedure pr_neue_warengruppen_import is
    begin
        insert into sap_warengruppen (
            war_uid,
            sap_id,
            warengruppenbezeichnung,
            warengruppenbezeichnung_2,
            is_relevant,
            bemerkung,
            inserted,
            inserted_by,
            updated,
            updated_by,
            capex_opex
        )
            select
                to_number(substr(
                    rawtohex(sys_guid()),
                    1,
                    30
                ),
                          'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                src.warengruppe,
                src.bezeichnung_warengruppe,
                null,
                null,
                null,
                sysdate,
                user,
                null,
                null,
                null
            from
                (
                    select
                        warengruppe,
                        bezeichnung_warengruppe
                    from
                        (
                            select
                                q.warengruppe,
                                q.bezeichnung_warengruppe,
                                row_number()
                                over(partition by q.warengruppe
                                     order by
                                         q.bezeichnung_warengruppe nulls last
                                ) as rn
                            from
                                sap_inf.ekko_export q
                            where
                                q.warengruppe is not null
                        )
                    where
                        rn = 1
                ) src
            where
                not exists (
                    select
                        1
                    from
                        sap_warengruppen z
                    where
                        z.sap_id = src.warengruppe
                );

    end pr_neue_warengruppen_import;

    procedure pr_neue_bestellungen_import is
    begin
        insert into hwas_sap_beauftragungen (
            sap_bea_guid,
            primarykey_sap,
            lieferant,
            name1,
            bestellung,
            bestellposition,
            lieferdatum_position,
            warengruppe,
            bezeichnung_warengruppe,
            kurztext_position,
            buchungskreis,
            ersteller,
            vorname,
            nachname,
            erstellungsdatum,
            einkaeufergruppe,
            bezeichnung_einkaeufergruppe,
            anforderer,
            nettobestellwert_bestellwaehrung,
            waehrung,
            kontierungstyp,
            kontierungsobjekt,
            verantwortlicher,
            verantwortliche_kostenstelle,
            sachkonto,
            auftrag,
            splitwert
        )
            select
                to_number(substr(
                    rawtohex(sys_guid()),
                    1,
                    30
                ),
                          'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                q.primaerkey,
                q.lieferant,
                q.name1,
                q.bestellung,
                q.bestellposition,
                q.lieferdatum_position,
                q.warengruppe,
                q.bezeichnung_warengruppe,
                q.kurztext_position,
                q.buchungskreis,
                q.ersteller,
                q.vorname,
                q.nachname,
                q.erstellungsdatum,
                q.einkaeufergruppe,
                q.bezeichnung_einkaeufergruppe,
                q.anforderer,
                q.nettobestellwert,
                q.waehrung,
                q.kontierungstyp,
                q.kontierungsobjekt,
                q.verantwortlicher,
                q.verantwortlicher_kostenstelle,
                q.sachkonto,
                q.auftrag,
                q.splitwert
            from
                sap_inf.ekko_export q
            where
                q.primaerkey is not null
                and not exists (
                    select
                        1
                    from
                        hwas_sap_beauftragungen z
                    where
                        z.primarykey_sap = q.primaerkey
                );

    end pr_neue_bestellungen_import;

end pkg_sap_bestellungen_import;
/


-- sqlcl_snapshot {"hash":"0d05cb5f801f6fcb43772f2d3b5e5051ab46e081","type":"PACKAGE_BODY","name":"PKG_SAP_BESTELLUNGEN_IMPORT","schemaName":"AM_MAIN","sxml":""}