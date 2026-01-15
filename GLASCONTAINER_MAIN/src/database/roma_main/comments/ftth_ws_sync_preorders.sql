comment on column roma_main.ftth_ws_sync_preorders.account_holder is
    'FTTH-ID=600, JSON-PATH=accountDetails.accountHolder, LABEL=Abweichender Kontoinhaber, APEX=P20_KONTOINHABER, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.account_iban is
    'FTTH-ID=610, JSON-PATH=accountDetails.iban, LABEL=IBAN, APEX=P20_IBAN, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.account_id is
    '@Ticket FTTH-4470, @ticket FTTH-4533: Die Account ID entspricht der Siebel GLOBAL_ID. Sie wird benötigt, um im Glascontainer einen Link zu Siebel anzeigen zu können.'
    ;

comment on column roma_main.ftth_ws_sync_preorders.account_sepamandate is
    'FTTH-ID=590, JSON-PATH=accountDetails.sepaMandate, LABEL=SEPA-Lastschriftmandat, APEX=P20_SEPA, STATUS=NOK///kommt immer leer an'
    ;

comment on column roma_main.ftth_ws_sync_preorders.apex$row_sync_timestamp is
    'Automatisch erzeugte Spalte (wird von APEX zur Protokollierung der REST-Source-Synchronisierung verwendet)';

comment on column roma_main.ftth_ws_sync_preorders.apex$sync_step_static_id is
    'Automatisch erzeugte Spalte (wird von APEX zur Protokollierung der REST-Source-Synchronisierung verwendet)';

comment on column roma_main.ftth_ws_sync_preorders.availability_date is
    'Datum der Verfügbarkeit des Produkts an der Installationsadrese';

comment on column roma_main.ftth_ws_sync_preorders.cancelled_by is
    '2023-06-15 @ticket FTTH-1874: Spalte zur nächtlichen Synchronisation der Storno-Informationen: Mitarbeiter, der das Storno durchgeführt hat'
    ;

comment on column roma_main.ftth_ws_sync_preorders.cancel_date is
    '2023-06-15 @ticket FTTH-1874: Spalte zur nächtlichen Synchronisation der Storno-Informationen: Datum/Uhrzeit der Stornierung';

comment on column roma_main.ftth_ws_sync_preorders.cancel_date$ is
    '2023-06-22: Neue Pseudospalte zur Aufnahme des originalen Strings bei der Synchronisation der Spalte CANCEL_DATE, siehe Kommentar im Data Profile der APEX REST Source'
    ;

comment on column roma_main.ftth_ws_sync_preorders.cancel_reason is
    '2023-06-15 @ticket FTTH-1874: Spalte zur nächtlichen Synchronisation der Storno-Informationen: Grund der Stornierung';

comment on column roma_main.ftth_ws_sync_preorders.changed_by is
    'Name des Mitarbeiters oder Entwicklers, der diesen Datensatz zuletzt geändert hat. JSON-PATH=changedBy, LABEL=zuletzt geändert durch,APEX=P20_CHANGED_BY, STATUS=OK'
    ;

comment on column roma_main.ftth_ws_sync_preorders.client is
    'FTTH-ID=90, JSON-PATH=product.client, LABEL=Mandant, APEX=P20_MANDANT, STATUS=NOK///@klären/hidden';

comment on column roma_main.ftth_ws_sync_preorders.connectivity_id is
    '2024-08-21 @ticket FTTH-3727: Externe Auftragsnummer des Konnektivitätsauftrags';

comment on column roma_main.ftth_ws_sync_preorders.created is
    'Datum/Uhrzeit des Auftragseingangs. JSON-PATH=created, LABEL=Auftragseingang';

comment on column roma_main.ftth_ws_sync_preorders.created$ is
    '2023-06-22: Neue Pseudospalte zur Aufnahme des originalen Strings bei der Synchronisation der Spalte CREATED, siehe Kommentar im Data Profile der APEX REST Source'
    ;

comment on column roma_main.ftth_ws_sync_preorders.customernumber is
    'FTTH-ID=100, JSON-PATH=customerNumber, LABEL=Kunden-Nr/KNr., APEX=P20_KUNDENNUMMER, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_birthdate is
    'FTTH-ID=170, JSON-PATH=customer.birthDate, LABEL=P20_GEBURTSDATUM, APEX=P20_P20_GEBURTSDATUM, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_birthdate$ is
    '2023-06-22: Neue Pseudospalte zur Aufnahme des originalen Strings bei der Synchronisation der Spalte CUSTOMER_BIRTHDATE, siehe Kommentar im Data Profile der APEX REST Source'
    ;

comment on column roma_main.ftth_ws_sync_preorders.customer_businessname is
    'FTTH-ID=120, JSON-PATH=customer.businessName, LABEL=Firma, APEX=P20_FIRMENNAME, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_email is
    'FTTH-ID=180, JSON-PATH=customer.email, LABEL=E-Mail-Adresse, APEX=P20_EMAIL, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_name_first is
    'FTTH-ID=150, JSON-PATH=customer.name.first, LABEL=Vorname, APEX=P20_VORNAME, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_name_last is
    'FTTH-ID=160, JSON-PATH=customer.name.last, LABEL=Nachname, APEX=P20_NACHNAME, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_phone_areacode is
    'FTTH-ID=208, JSON-PATH=customer.phoneNumber.areaCode, LABEL=Vorwahl, APEX=P20_VORWAHL, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_phone_countrycode is
    'FTTH-ID=200, JSON-PATH=customer.phoneNumber.countryCode, LABEL=Ländervorwahl, APEX=P20_LAENDERVORWAHL, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_phone_number is
    'FTTH-ID=210, JSON-PATH=customer.phoneNumber.number, LABEL=Telefonnummer, APEX=P20_TELEFON, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_prev_addr_addition is
    'FTTH-ID=1130, JSON-PATH=customer.previousAddress.postalAddition, LABEL=Zusatz, APEX=P20_VORADRESSE_ZUSATZ, STATUS=NOK /// ist im WS nie gefüllt'
    ;

comment on column roma_main.ftth_ws_sync_preorders.customer_prev_addr_city is
    'FTTH-ID=1150, JSON-PATH=customer.previousAddress.city, LABEL=Ort, APEX=P20_VORADRESSE_ORT, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_prev_addr_country is
    'FTTH-ID=1160, JSON-PATH=customer.previousAddress.country, LABEL=Land, APEX=P20_VORADRESSE_LAND, STATUS=NOK/// im WS immer leer';

comment on column roma_main.ftth_ws_sync_preorders.customer_prev_addr_housenumber is
    'FTTH-ID=1120, JSON-PATH=customer.previousAddress.houseNumber, LABEL=Nr., APEX=P20_VORADRESSE_HAUSNR, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_prev_addr_street is
    'FTTH-ID=1110, JSON-PATH=customer.previousAddress.street, LABEL=Straße, APEX=P20_VORADRESSE_STRASSE, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_prev_addr_zipcode is
    'FTTH-ID=1140, JSON-PATH=customer.previousAddress.zipCode, LABEL=PLZ, APEX=P20_VORADRESSE_PLZ, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_residentstatus is
    'FTTH-ID=370, JSON-PATH=customer.residentStatus, LABEL=Wohndauer, APEX=P20_WOHNDAUER, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_salutation is
    'FTTH-ID=130, JSON-PATH=customer.salutation, LABEL=Anrede, APEX=P20_ANREDE, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_title is
    'FTTH-ID=140, JSON-PATH=customer.title, LABEL=Titel, APEX=P20_TITEL, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.customer_upd_email is
    'FTTH-ID=2031, JSON-PATH=customerUpdate.email, LABEL=?, APEX=?, STATUS=NOK /// unklar, ob überhaupt verwendet';

comment on column roma_main.ftth_ws_sync_preorders.customer_upd_phone_areacode is
    'FTTH-ID=2033, JSON-PATH=customerUpdate.phoneNumber.areaCode, LABEL=?, APEX=?, STATUS=NOK /// unklar, ob überhaupt verwendet';

comment on column roma_main.ftth_ws_sync_preorders.customer_upd_phone_countrycode is
    'FTTH-ID=2032, JSON-PATH=customerUpdate.phoneNumber.countryCode, LABEL=?, APEX=?, STATUS=NOK /// unklar, ob überhaupt verwendet';

comment on column roma_main.ftth_ws_sync_preorders.customer_upd_phone_number is
    'FTTH-ID=2034, JSON-PATH=customerUpdate.phoneNumber.number, LABEL=?, APEX=?, STATUS=NOK /// unklar, ob überhaupt verwendet';

comment on column roma_main.ftth_ws_sync_preorders.devicecategory is
    'FTTH-ID=30, JSON-PATH=product.deviceCategory, LABEL=Router-Auswahl, APEX=P20_ROUTER_AUSWAHL, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.deviceownership is
    'FTTH-ID=31, JSON-PATH=product.deviceOwnership, LABEL=Router-Eigentum,APEX=P20_ROUTER_EIGENTUM, Status=OK';

comment on column roma_main.ftth_ws_sync_preorders.errorstatus is
    '@ticket FTTH-4643: Wenn nicht leer, dann gab es beim letzten Versuch der Synchronisierung ein Problem. Bisher definierte Werte: SIEBEL: Name/Vorname/Adresse konnte nicht abgerufen werden'
    ;

comment on column roma_main.ftth_ws_sync_preorders.home_id is
    '@ticket FTTH-4143: homeId aus dem Attribut Glasfaser-ID (Eingang über WITA oder SPRI-Schnittstelle)';

comment on column roma_main.ftth_ws_sync_preorders.houseconnectionprice is
    'FTTH-ID=34, JSON-PATH=product.houseConnectionPrice, LABEL=Haus-Anschlusspreis, APEX=P20_HAUS_ANSCHLUSSPREIS, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.houseserialnumber is
    'FTTH-ID=350, JSON-PATH=installation.houseSerialNumber, LABEL=HAUS_LFD_NR, APEX=P20_HAUS_LFD_NR, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.id is
    'FTTH-ID=1, JSON-PATH=id, LABEL=UUID/Auftragsnummer, APEX=P20_UUID, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.installationservice is
    'FTTH-ID=32, JSON-PATH=product.installationService, LABEL=Einrichtungsservice, APEX=P20_INSTALLATIONSSERVICE, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.install_addr_addition is
    'FTTH-ID=412, JSON-PATH=installation.address.postalAddition, LABEL=Zusatz, APEX=P20_ANSCHLUSS_ZUSATZ, STATUS=///?';

comment on column roma_main.ftth_ws_sync_preorders.install_addr_city is
    'FTTH-ID=390, JSON-PATH=installation.address.city, LABEL=Ort, APEX=P20_ANSCHLUSS_ORT, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.install_addr_country is
    'FTTH-ID=378, JSON-PATH=installation.address.country, LABEL=Land, APEX=P20_ANSCHLUSS_LAND, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.install_addr_housenumber is
    'FTTH-ID=410, JSON-PATH=installation.address.houseNumber, LABEL=Nr., APEX=P20_ANSCHLUSS_HAUSNR, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.install_addr_street is
    'FTTH-ID=400, JSON-PATH=installation.address.street, LABEL=Straße, APEX=P20_ANSCHLUSS_STRASSE, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.install_addr_zipcode is
    'FTTH-ID=380, JSON-PATH=installation.address.zipCode, LABEL=PLZ, APEX=P20_ANSCHLUSS_PLZ, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.landlord_addr_addition is
    'FTTH-ID=770, JSON-PATH=propertyOwnerDeclaration.landlord.address.postalAddition, LABEL=Zusatz, APEX=P20_VERMIETER_ZUSATZ, STATUS=OK'
    ;

comment on column roma_main.ftth_ws_sync_preorders.landlord_addr_city is
    'FTTH-ID=790, JSON-PATH=propertyOwnerDeclaration.landlord.address.city, LABEL=Ort, APEX=P20_VERMIETER_ORT, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.landlord_addr_country is
    'FTTH-ID=800, JSON-PATH=propertyOwnerDeclaration.landlord.address.country, LABEL=Land, APEX=P20_VERMIETER_LAND, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.landlord_addr_housenumber is
    'FTTH-ID=760, JSON-PATH=propertyOwnerDeclaration.landlord.address.houseNumber, LABEL=Nr., APEX=P20_VERMIETER_HAUSNR, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.landlord_addr_street is
    'FTTH-ID=750, JSON-PATH=propertyOwnerDeclaration.landlord.address.street, LABEL=Straße, APEX=P20_VERMIETER_STRASSE, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.landlord_addr_zipcode is
    'FTTH-ID=780, JSON-PATH=propertyOwnerDeclaration.landlord.address.zipCode, LABEL=PLZ, APEX=P20_VERMIETER_PLZ, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.landlord_agreed is
    'FTTH-ID=840, JSON-PATH=propertyOwnerDeclaration.landlordAgreedToBeContacted, LABEL=Einverständnis Vermieter, APEX=P20_VERMIETER_EINVERSTAENDNIS, STATUS=NOK /// kommt im JSON nicht vor'
    ;

comment on column roma_main.ftth_ws_sync_preorders.landlord_businessorname is
    'FTTH-ID=700, JSON-PATH=propertyOwnerDeclaration.landlord.businessOrName, LABEL=Firmenname, APEX=P20_VERMIETER_FIRMENNAME, STATUS=OK'
    ;

comment on column roma_main.ftth_ws_sync_preorders.landlord_email is
    'FTTH-ID=810, JSON-PATH=propertyOwnerDeclaration.landlord.email, LABEL=E-Mail, APEX=P20_VERMIETER_EMAIL, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.landlord_information_required is
    '2024-08-21 @ticket FTTH-3727: true|false, NULL: Gibt an, ob für den Auftrag Eigenrtümerdaten notwendig sind';

comment on column roma_main.ftth_ws_sync_preorders.landlord_legalform is
    'FTTH-ID=690, JSON-PATH=propertyOwnerDeclaration.landlord.legalForm, LABEL=Rechtsform, APEX=P20_VERMIETER_RECHTSFORM, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.landlord_name_first is
    'FTTH-ID=730, JSON-PATH=propertyOwnerDeclaration.landlord.name.first, LABEL=Vorname, APEX=P20_VERMIETER_VORNAME, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.landlord_name_last is
    'FTTH-ID=740, JSON-PATH=propertyOwnerDeclaration.landlord.name.last, LABEL=Nachname, APEX=P20_VERMIETER_NACHNAME, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.landlord_phone_areacode is
    'FTTH-ID=825, JSON-PATH=propertyOwnerDeclaration.landlord.phoneNumber.areaCode, LABEL=Vorwahl, APEX=P20_VERMIETER_VORWAHL, STATUS=NOK ///ist im JSON nie gefüllt'
    ;

comment on column roma_main.ftth_ws_sync_preorders.landlord_phone_countrycode is
    'FTTH-ID=820, JSON-PATH=propertyOwnerDeclaration.landlord.phoneNumber.countryCode, LABEL=Ländervorwahl, APEX=P20_VERMIETER_LAENDERVORWAHL, STATUS=OK'
    ;

comment on column roma_main.ftth_ws_sync_preorders.landlord_phone_number is
    'FTTH-ID=830, JSON-PATH=propertyOwnerDeclaration.landlord.phoneNumber.number, LABEL=Telefonnr., APEX=P20_VERMIETER_TELEFON, STATUS=OK'
    ;

comment on column roma_main.ftth_ws_sync_preorders.landlord_salutation is
    'FTTH-ID=710, JSON-PATH=propertyOwnerDeclaration.landlord.salutation, LABEL=Anrede, APEX=P20_VERMIETER_ANREDE, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.landlord_title is
    'FTTH-ID=720, JSON-PATH=propertyOwnerDeclaration.landlord.title, LABEL=Titel, APEX=P20_VERMIETER_TITEL, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.last_modified is
    'Datum/Uhrzeit der letzten Änderung des Datensatzes';

comment on column roma_main.ftth_ws_sync_preorders.last_modified$ is
    '2023-06-22: Neue Pseudospalte zur Aufnahme des originalen Strings bei der Synchronisation der Spalte LAST_MODIFIED, siehe Kommentar im Data Profile der APEX REST Source'
    ;

comment on column roma_main.ftth_ws_sync_preorders.manual_transfer is
    'true|false: Gibt an, ob ein Kommentar zu diesem Auftrag gespeichert ist ("Sonderwünsche"), der dazu führt, dass der Auftrag manuell gegen Siebel ausgesteuert werden muss.'
    ;

comment on column roma_main.ftth_ws_sync_preorders.ont_provider is
    'Beschreibt, wer den ONT (Optischer Netzwerkterminator) bereitstellt. Erlaubte Werte sind NETCOLOGNE|BYOD|NONE';

comment on column roma_main.ftth_ws_sync_preorders.process_lock_last_modified is
    'Datum/Uhrzeit des letzten, vom Server gesetzten Process Locks';

comment on column roma_main.ftth_ws_sync_preorders.process_lock_last_modified$ is
    '2023-06-22: Neue Pseudospalte zur Aufnahme des originalen Strings bei der Synchronisation der Spalte PROCESS_LOCK_LAST_MODIFIED, siehe Kommentar im Data Profile der APEX REST Source'
    ;

comment on column roma_main.ftth_ws_sync_preorders.prop_owner_role is
    'FTTH-ID=650, JSON-PATH=propertyOwnerDeclaration.propertyOwnerRole, LABEL=Wohnverhältnis, APEX=P20_GEE_ROLLE, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.prop_residential_unit is
    'FTTH-ID=660, JSON-PATH=propertyOwnerDeclaration.residentialUnit, LABEL=Anzahl WE, APEX=P20_ANZAHL_WE, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.providerchg_cancellation_date is
    'FTTH-ID=530, JSON-PATH=providerChange.cancellationDate, LABEL=Kündigungsdatum, APEX=P20_PROVIDERW_KUENDIGUNGSDATUM, STATUS=///?'
    ;

comment on column roma_main.ftth_ws_sync_preorders.providerchg_cancellation_date$ is
    '2023-06-22: Neue Pseudospalte zur Aufnahme des originalen Strings bei der Synchronisation der Spalte PROVIDERCHG_CANCELLATION_DATE, siehe Kommentar im Data Profile der APEX REST Source'
    ;

comment on column roma_main.ftth_ws_sync_preorders.providerchg_contract_cancelled is
    'FTTH-ID=520, JSON-PATH=providerChange.currentContractCancelled, LABEL=Anschluss gekündigt?, APEX=P20_PROVIDERW_ANSCHLUSS_GEKUENDIGT, STATUS=/// OK, soll aber nicht sichtbar sein lt. Jira'
    ;

comment on column roma_main.ftth_ws_sync_preorders.providerchg_current_provider is
    'FTTH-ID=480, JSON-PATH=providerChange.currentProvider, LABEL=Aktueller Anbieter, APEX=P20_PROVIDERW_AKTUELLER_ANBIETER, STATUS=///?'
    ;

comment on column roma_main.ftth_ws_sync_preorders.providerchg_keep_phone_number is
    'FTTH-ID=490, JSON-PATH=providerChange.keepCurrentLandlineNumber, LABEL=Nummer behalten?, APEX=P20_PROVIDERW_NUMMER_BEHALTEN, STATUS=///testen mit true?'
    ;

comment on column roma_main.ftth_ws_sync_preorders.providerchg_owner_name_first is
    'FTTH-ID=560, JSON-PATH=providerChange.contractOwnerName.first, LABEL=Vorname, APEX=P20_PROVIDERW_ANMELDUNG_VORNAME, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.providerchg_owner_name_last is
    'FTTH-ID=570, JSON-PATH=providerChange.contractOwnerName.last, LABEL=Nachname, APEX=P20_PROVIDERW_ANMELDUNG_NACHNAME, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.providerchg_owner_salutation is
    'FTTH-ID=550, JSON-PATH=providerChange.contractOwnerSalutation, LABEL=Anrede, APEX=P20_PROVIDERW_ANMELDUNG_ANREDE, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.providerchg_phone_areacode is
    'FTTH-ID=500, JSON-PATH=providerChange.landlinePhoneNumber.areaCode, LABEL=Vorwahl, APEX=P20_PROVIDERW_VORWAHL, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.providerchg_phone_countrycode is
    'FTTH-ID=499, JSON-PATH=providerChange.landlinePhoneNumber.countryCode, LABEL=Ländervorwahl, APEX=P20_PROVIDERW_LAENDERVORWAHL, STATUS=OK'
    ;

comment on column roma_main.ftth_ws_sync_preorders.providerchg_phone_number is
    'FTTH-ID=510, JSON-PATH=providerChange.landlinePhoneNumber.number, LABEL=Festnetznummer, APEX=P20_PROVIDERW_TELEFON, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.rt_contact_data_ticket_id is
    '2024-08-21 @ticket FTTH-3727: ID des Kontaktdaten-Akquise-Tickets';

comment on column roma_main.ftth_ws_sync_preorders.service_plus_email is
    '2023-08: @ticket FTTH-2411, servicePlusEmail (je nach Produkt obligatorische E-Mail-Adresse für das Sicherheitspaket)';

comment on column roma_main.ftth_ws_sync_preorders.siebel_order_number is
    '2023-07-05: PATH=siebelOrderNumber';

comment on column roma_main.ftth_ws_sync_preorders.siebel_order_rowid is
    '2023-07-05: PATH=siebelOrderRowId';

comment on column roma_main.ftth_ws_sync_preorders.state is
    'FTTH-ID=60, JSON-PATH=state, LABEL=Auftragsstatus, APEX=P20_STATUS, STATUS=NOK@klären: CANCELED|CANCELLED';

comment on column roma_main.ftth_ws_sync_preorders.summ_emailmarketing is
    'FTTH-ID=880, JSON-PATH=summary.emailMarketing, LABEL=per E-Mail, APEX=P20_OPT_IN_EMAIL, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.summ_generaltermsandconditions is
    'FTTH-ID=860, JSON-PATH=summary.generalTermsAndConditions, LABEL=AGB, APEX=P20_ZUSTIMMUNG_AGB, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.summ_mailmarketing is
    'FTTH-ID=910, JSON-PATH=summary.mailMarketing, LABEL=postalisch, APEX=P20_OPT_IN_POST, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.summ_ordersummaryfileid is
    'FTTH-ID=50, JSON-PATH=summary.orderSummaryFileId, LABEL=Vertragszusammenfassung, APEX=P20_VERTRAGSZUSAMMENFASSUNG, STATUS=///';

comment on column roma_main.ftth_ws_sync_preorders.summ_phonemarketing is
    'FTTH-ID=890, JSON-PATH=summary.phoneMarketing, LABEL=telefonisch, APEX=P20_OPT_IN_TELEFON, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.summ_precontractinformation is
    'FTTH-ID=850, JSON-PATH=summary.summary.preContractualInformation, LABEL=Bestätigung VZF, APEX=P20_BESTAETIGUNG_VZF, STATUS=NOK /// LOV-Werte sind nicht klar'
    ;

comment on column roma_main.ftth_ws_sync_preorders.summ_smsmmsmarketing is
    'FTTH-ID=900, JSON-PATH=summary.smsMmsMarketing, LABEL=per SMS und MMS, APEX=P20_OPT_IN_SMS_MMS, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.summ_waiverightofrevocation is
    'FTTH-ID=870, JSON-PATH=summary.waiveRightOfRevocation, LABEL=Verzicht auf Widerruf, APEX=P20_ZUSTIMMUNG_WIDERRUF, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.templateid is
    'FTTH-ID=10, JSON-PATH=product.templateId, LABEL=Produkt, APEX=P20_PROMOTION, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.update_customer_in_siebel is
    '@ticket FTTH-3711: false: Es existieren beim Bestandskunden auftragsbezogene Kontaktdaten; true: existieren nicht';

comment on column roma_main.ftth_ws_sync_preorders.vkz is
    'FTTH-ID=70, JSON-PATH=vkz, LABEL=VKZ, APEX=P20_VKZ, STATUS=OK';

comment on column roma_main.ftth_ws_sync_preorders.wholebuy_partner is
    'true|false: Gibt an, ob ein Auftrag mit einem Wholebuy-Vermarktungscluster verknüpft ist';


-- sqlcl_snapshot {"hash":"e81114ad0da385d039199e4c80c72ce3f6651dbe","type":"COMMENT","name":"ftth_ws_sync_preorders","schemaName":"roma_main","sxml":""}