create or replace package pck_glascontainer_order_gk as 

/**
  * Hilfsroutinen für die Applikation 2022 "Glascontainer" zur Durchführung von
  * internen GK Vorbestellungen (Seiten 150, 160, 170, 180)
  *
  * @date    2025-11-20
  *
  */

  -- Umlaut-Test: ÄÖÜäöüß?

  -- Alle Fehlermeldungen aus diesem Package benutzen diesen Scope: 
    g_scope constant logs.scope%type := 'GLASCONTAINER';
    anbieter_telekom constant varchar2(4) := 'TCOM';
    anbieter_deutsche_glasfaser constant varchar2(2) := 'DG';
    c_plausi_error_number constant integer := -20002;
    e_plausi_error exception;
    pragma exception_init ( e_plausi_error,
    c_plausi_error_number );
    type t_gk_order_tracking is record (
            pos       number        -- Sortierung
            ,
            infolevel number        -- "Einrückung" 0...4: In dieser >Displayspalte steht der Beschreibungstext
            ,
            vorgang   varchar2(255),
            anzahl    number        -- zur besseren Auswertung per SQL: Gleiche Information wie in der rechten Displayspalte
                              -- (diese variiert aber mit dem Infolevel)
            ,
            d0        varchar2(255) -- Displayspalte 0
            ,
            d1        varchar2(255) -- Displayspalte 1
            ,
            d2        varchar2(255) -- Displayspalte 2
            ,
            d3        varchar2(255) -- Displayspalte 3
            ,
            d4        varchar2(255) -- Displayspalte 4   
            ,
            d5        varchar2(255) -- Displayspalte 5
            ,
            d6        varchar2(255) -- Displayspalte 6   
    );
    type t_gk_order_trackings is
        table of t_gk_order_tracking;
    type t_gk_funnel is record (
            pos           number        -- Sortierung
            ,
            l             varchar2(255),
            anzahl        number,
            anzahl_target number
    );
    type t_gk_funnels is
        table of t_gk_funnel;
    type t_contact_person is record (
            contact_type                  varchar2(255),
            siebelrowid                   varchar2(255),
            salutation                    varchar2(255),
            firstname                     varchar2(255),
            lastname                      varchar2(255),
            phonenumber_countrycode       varchar2(255),
            phonenumber_areacode          varchar2(255),
            phonenumber_number            varchar2(255),
            mobilephonenumber_countrycode varchar2(255),
            mobilephonenumber_areacode    varchar2(255),
            mobilephonenumber_number      varchar2(255),
            email                         varchar2(255)
    );
    type t_contact_persons is
        table of t_contact_person;

 -- -----------------------------------------------------------------------------------------------

/**
  * GK relevante Daten aus dem A-Check Light ermitteln
  *
  * @param       pin_haus_lfd_nr        IN     NUMBER        => HAUS_LFD_NR
  * @param       piv_app_user           IN     VARCHAR2      => APP User
  * @param       pov_mandant               OUT VARCHAR2      => Mandant
  * @param       pov_wholebuy_partner      OUT VARCHAR2      => Wholebuy Partner
  * @param       pov_ausbaus_status        OUT VARCHAR2      => Ausbau Status
  * @param       pov_merged_access_type    OUT VARCHAR2      => Technologie
  * @param       pov_planned_bandwidth     OUT VARCHAR2      => max. Bandbreite
  *                                                  
  *
  */
    procedure p_gk_daten_acheck_light (
        pin_haus_lfd_nr        in number,
        piv_app_user           in varchar2,
        pov_mandant            out varchar2,
        pov_wholebuy_partner   out varchar2,
        pov_ausbaus_status     out varchar2,
        pov_merged_access_type out varchar2,
        pov_planned_bandwidth  out varchar2,
        pov_eigentuemerdaten   out varchar2,
        pov_adress_complete    out varchar2
    ); 

 -- -----------------------------------------------------------------------------------------------
 
/**
  * Kundennummer für die Anzeige darstellen.
  *
  * @param       pin_haus_lfd_nr        IN     NUMBER        => HAUS_LFD_NR
  * @param       piv_app_user           IN     VARCHAR2      => APP User
  *                                                  
  * @return      Kundennummer 
  *
  */
    function fv_format_knd_nr (
        pin_knd_nr       in number,
        piv_unter_knd_nr in varchar2
    ) return varchar2;
  
-- -----------------------------------------------------------------------------------------------
 
/**
  * HAUS_LFD_NR als Link 
  *
  * @param       pin_haus_lfd_nr        IN     NUMBER        => HAUS_LFD_NR
  *                                                  
  * @return      Kundennummer mit Unterkundennummer 
  *
  */
    function fv_format_haus_lfd_nr (
        pin_haus_lfd_nr in number
    ) return varchar2;
 
-- -----------------------------------------------------------------------------------------------
 
/**
  * Check der Parameter des Aufruflinks 
  *
  * @param       piv_parameter        IN     VARCHAR2      => Parameter der zu prüfen ist
  * @param       piv_parameter_name   IN     VARCHAR2      => Name des Parameters
  * @param       piv_check_typ        IN     VARCHAR2      => Art der Prüfung
  * @param       piv_check_condition  IN     VARCHAR2      => gegen welche Werte soll geprüft werden
  *                                                  
  * @return      Error Message
  *
  */
    function fv_check_link_parameter (
        piv_parameter       in varchar2,
        piv_parameter_name  in varchar2,
        piv_check_typ       in varchar2 default 'NOT NULL',
        piv_check_condition in varchar2 default null
    ) return varchar2;

-- -----------------------------------------------------------------------------------------------
 
/**
  * Check der GK Wholeby Bestellung 
  *
  * @param       pin_haus_lfd_nr               IN     NUMBER        => HAUS_LFD_NR
  * @param       piv_app_user                  IN     VARCHAR2      => APP User
  *                                                  
  * @return      Y/N
  *
  */
    function fv_check_gk_wb_order (
        pin_haus_lfd_nr in number,
        piv_app_user    in varchar2
    ) return varchar2;

-- -----------------------------------------------------------------------------------------------

/**
  * Wertet das User-Verhalten in der Bestellerfassung anonym aus und gibt die Zahlen pipelined zurück,
  * die dann vom Classic Report auf Seite 10056 im Glascontainer angezeigt werden.
  *
  * Die Spalten im Ergebnis sind:
  * POS                    Anzeige-Reihenfolge
  * INFOLEVEL              [0..3] Einrückungsebene
  * VORGANG                String (AUFRUF|BESTELLUNG) zur Kontrolle des Ergebnisse, wird nicht angezeigt
  * ANZAHL                 Gezählte Ereignisse. Entspricht derselben Zahl in der ganz rechten Spalte, diese ist dort
  *                        nur aus Gründen der Report-Darstellung erneut vorhanden - so muss man bei Abfragen nicht wissen, 
  *                        in welcher Spalte D1...D4 sie steht
  * D0, D1, D2, D3, D4     Der gemäß @ticket FTTH-4003 anzuzeigende Text (Display-Spalten von links nach rechts)
  *
  * @param pid_von  [IN ]  Tagesdatum entsprechend dem Eingabefeld "von"
  * @param pid_bis  [IN ]  Tagesdatum entsprechend dem Eingabefeld "vbis"
  *
  * @example Order-Statistik vom gestrigen Tag:
  * SELECT * FROM TABLE(PCK_GLASCONTAINER_ORDER.FP_ORDER_TRACKING(SYSDATE-1)) ORDER BY POS NULLS LAST;
  */
    function fp_order_tracking2 (
        pid_von in date default null,
        pid_bis in date default null,
        piv_vkz in varchar2 default null
    ) return t_gk_order_trackings
        pipelined;      

-- -----------------------------------------------------------------------------------------------

/**
  * Gibt die Bandbreite mit " Mbit/s" zurück
  */
    function fv_format_bandwith (
        pi_bandwith in number
    ) return varchar2;

-- -----------------------------------------------------------------------------------------------

/**
  * Gibt die Werte für die Funnel Dartsllung zurück
  */
    function fp_funnel_gk (
        pid_von in date default null,
        pid_bis in date default null,
        piv_vkz in varchar2 default null
    ) return t_gk_funnels
        pipelined;

-- -----------------------------------------------------------------------------------------------

/**
  * Aufbereiten der Daten für die Übergabe an das Backend.
  * JSON Struktur erstellen
  */
    function fj_gk_order (
        piv_gee_kontaktdaten_bekannt                                  in varchar2, -- 1|0
        piv_customernumber                                            in varchar2,
        piv_subcustomernumber                                         in varchar2,
        piv_siebelordernumber                                         in varchar2,
        piv_siebelorderrowid                                          in varchar2,
        piv_client                                                    in varchar2,
        piv_templateid                                                in varchar2,-- ftth-connectivity-100-50
                          --piv_expansionStatus                                                                 IN VARCHAR2,--AREA_PLANNED
        piv_availabilitydate                                          in varchar2,--2025-11-27
        piv_createdby                                                 in varchar2,
        piv_houseserialnumber                                         in varchar2,
        piv_propertyownerdeclaration_propertyownerrole                in varchar2,
        piv_propertyownerdeclaration_residentialunit                  in varchar2,
        piv_propertyownerdeclaration_landlord_legalform               in varchar2,
        piv_propertyownerdeclaration_landlord_businessorname          in varchar2,
        piv_propertyownerdeclaration_landlord_salutation              in varchar2,
        piv_propertyownerdeclaration_landlord_title                   in varchar2,
        piv_propertyownerdeclaration_landlord_name_first              in varchar2,
        piv_propertyownerdeclaration_landlord_name_last               in varchar2,
        piv_propertyownerdeclaration_landlord_address_street          in varchar2,
        piv_propertyownerdeclaration_landlord_address_housenumber     in varchar2,
        piv_propertyownerdeclaration_landlord_address_zipcode         in varchar2,
        piv_propertyownerdeclaration_landlord_address_city            in varchar2,
        piv_propertyownerdeclaration_landlord_address_postaladdition  in varchar2,
        piv_propertyownerdeclaration_landlord_address_country         in varchar2,
        piv_propertyownerdeclaration_landlord_email                   in varchar2,
        piv_propertyownerdeclaration_landlord_phonenumber_countrycode in varchar2,
        piv_propertyownerdeclaration_landlord_phonenumber_areacode    in varchar2,
        piv_propertyownerdeclaration_landlord_phonenumber_number      in varchar2,
        piv_contactpersons                                            in t_contact_persons
                                /*
                                piv_propertyOwnerDeclaration_landlord_contactPersons_type                           IN VARCHAR2,
                          piv_propertyOwnerDeclaration_landlord_contactPersons_siebelRowId                    IN VARCHAR2,
                          piv_propertyOwnerDeclaration_landlord_contactPersons_salutation                     IN VARCHAR2,
                          piv_propertyOwnerDeclaration_landlord_contactPersons_firstName                      IN VARCHAR2,
                          piv_propertyOwnerDeclaration_landlord_contactPersons_lastName                       IN VARCHAR2,
                          piv_propertyOwnerDeclaration_landlord_contactPersons_phoneNumber_countryCode        IN VARCHAR2,
                          piv_propertyOwnerDeclaration_landlord_contactPersons_phoneNumber_areaCode           IN VARCHAR2,
                          piv_propertyOwnerDeclaration_landlord_contactPersons_phoneNumber_number             IN VARCHAR2,
                          piv_propertyOwnerDeclaration_landlord_contactPersons_mobilePhoneNumber_countryCode  IN VARCHAR2,
                          piv_propertyOwnerDeclaration_landlord_contactPersons_mobilePhoneNumber_areaCode     IN VARCHAR2,
                          piv_propertyOwnerDeclaration_landlord_contactPersons_mobilePhoneNumber_number       IN VARCHAR2,
                          piv_propertyOwnerDeclaration_landlord_contactPersons_email                          IN VARCHAR2
                          */
    ) return clob;

-- -----------------------------------------------------------------------------------------------

/**
  * 
  * 
  */
    function fn_gk_vorbestellung (
        piv_app_user                         in varchar2,
        piv_gee_kontaktdaten_bekannt         in varchar2, -- 1|0
        piv_customernumber                   in varchar2,
        piv_subcustomernumber                in varchar2,
        piv_siebelordernumber                in varchar2,
        piv_siebelorderrowid                 in varchar2,
        piv_client                           in varchar2,
        piv_templateid                       in varchar2,-- ftth-connectivity-100-50
                                --piv_expansionStatus                                        IN VARCHAR2,--AREA_PLANNED
        piv_availabilitydate                 in varchar2,--2025-11-27
        piv_createdby                        in varchar2,
        piv_houseserialnumber                in varchar2,
        piv_propertyownerrole                in varchar2,
        piv_residentialunit                  in varchar2,
        piv_landlord_legalform               in varchar2,
        piv_landlord_businessorname          in varchar2,
        piv_landlord_salutation              in varchar2,
        piv_landlord_title                   in varchar2,
        piv_landlord_name_first              in varchar2,
        piv_landlord_name_last               in varchar2,
        piv_landlord_address_street          in varchar2,
        piv_landlord_address_housenumber     in varchar2,
        piv_landlord_address_zipcode         in varchar2,
        piv_landlord_address_city            in varchar2,
        piv_landlord_address_postaladdition  in varchar2,
        piv_landlord_address_country         in varchar2,
        piv_landlord_email                   in varchar2,
        piv_landlord_phonenumber_countrycode in varchar2,
        piv_landlord_phonenumber_areacode    in varchar2,
        piv_landlord_phonenumber_number      in varchar2,
        piv_contactpersons                   in t_contact_persons
/*
                                piv_landlord_contactPersons_type                           IN VARCHAR2,
                                piv_landlord_contactPersons_siebelRowId                    IN VARCHAR2,
                                piv_landlord_contactPersons_salutation                     IN VARCHAR2,
                                piv_landlord_contactPersons_firstName                      IN VARCHAR2,
                                piv_landlord_contactPersons_lastName                       IN VARCHAR2,
                                piv_landlord_contactPersons_phoneNumber_countryCode        IN VARCHAR2,
                                piv_landlord_contactPersons_phoneNumber_areaCode           IN VARCHAR2,
                                piv_landlord_contactPersons_phoneNumber_number             IN VARCHAR2,
                                piv_landlord_contactPersons_mobilePhoneNumber_countryCode  IN VARCHAR2,
                                piv_landlord_contactPersons_mobilePhoneNumber_areaCode     IN VARCHAR2,
                                piv_landlord_contactPersons_mobilePhoneNumber_number       IN VARCHAR2,
                                piv_landlord_contactPersons_email                          IN VARCHAR2
                                */
    ) return ftth_ws_sync_preorders.id%type;

end;
/


-- sqlcl_snapshot {"hash":"7f43c9d9ed716539eec0c8049dd24eaa682d2a6d","type":"PACKAGE_SPEC","name":"PCK_GLASCONTAINER_ORDER_GK","schemaName":"ROMA_MAIN","sxml":""}