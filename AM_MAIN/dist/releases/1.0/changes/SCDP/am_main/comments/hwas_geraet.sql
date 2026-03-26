-- liquibase formatted sql
-- changeset am_main:1774556567409 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_geraet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_geraet.sql:null:ceadfa9889d4b26d7342c8fb04c3c03386640b64:create

comment on column am_main.hwas_geraet.fkl_uid is
    'Fremdschlüssel Funktionsklasse, falls nicht Funktionklsasse vom Modell übernommen werden soll (falls GRT.FKL_UID is NULL)';

comment on column am_main.hwas_geraet.grt_assetname is
    'tdb';

comment on column am_main.hwas_geraet.grt_data_custodian is
    'AD-SAN der Verantwortlichen Person';

comment on column am_main.hwas_geraet.grt_herstell_inbetrnhm_jahr is
    'Jahr der Herstellung/Inbetriebnahme';

comment on column am_main.hwas_geraet.grt_inventartnr is
    'Intentarnummer; wird derzeit nicht verwendet';

comment on column am_main.hwas_geraet.grt_link_fremdsystem is
    'Link zum Fremdsystem';

comment on column am_main.hwas_geraet.grt_quellsystem is
    'Bezeichnung des Quellsystems der Gerätedefinition';

comment on column am_main.hwas_geraet.grt_uid is
    'Primärschlüssel';

comment on column am_main.hwas_geraet.grt_zielsystem is
    'NetCologne-Wiki, andere';

comment on column am_main.hwas_geraet.gvb_uid is
    'Fremschlüssel Geräteverbund';

comment on column am_main.hwas_geraet.hst_uid is
    'Fremdschlüssel Hersteller';

comment on column am_main.hwas_geraet.inserted is
    'Insert Datum';

comment on column am_main.hwas_geraet.inserted_by is
    'Insert User';

comment on column am_main.hwas_geraet.mdl_uid is
    'Fremdschlüssel Modell';

comment on column am_main.hwas_geraet.quellsystem_id is
    'Fremdschlüssel im definierenden Quell-System';

comment on column am_main.hwas_geraet.rm_uid is
    'Fremdschlüssel Raum (->Gebäude)';

comment on column am_main.hwas_geraet.status is
    'Lebenszyklus des Gerätes. Aktiv/ Inaktiv';

comment on column am_main.hwas_geraet.updated is
    'Update Datum';

comment on column am_main.hwas_geraet.updated_by is
    'Update User';

