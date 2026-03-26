-- liquibase formatted sql
-- changeset am_main:1774556567327 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_elem_geraet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_elem_geraet.sql:null:b4817f8d8210dc10963985c53b846454691986b6:create

comment on column am_main.hwas_elem_geraet.elg_anschaffung_dat is
    'Anschaffungsdatum';

comment on column am_main.hwas_elem_geraet.elg_data_custodian is
    'Data Custorian (AD-SAN)';

comment on column am_main.hwas_elem_geraet.elg_geraetename is
    'Bezeichnung des elementaren Geräts';

comment on column am_main.hwas_elem_geraet.elg_herstell_inbetrnhm_jahr is
    'Inbetriebnahme
';

comment on column am_main.hwas_elem_geraet.elg_inventur_dat is
    'Letztes Inventurdatum';

comment on column am_main.hwas_elem_geraet.elg_kommentar is
    'Kommentarfeld';

comment on column am_main.hwas_elem_geraet.elg_link_fremdsystem is
    'Link zu Informationen in einem Fremdsystem';

comment on column am_main.hwas_elem_geraet.elg_quellsystem is
    'Bezeich nung des Quellsystems der Gerätedefinition';

comment on column am_main.hwas_elem_geraet.elg_uid is
    'Primärschlüssel';

comment on column am_main.hwas_elem_geraet.elg_zielsystem is
    'NetCologne-Wiki, andere';

comment on column am_main.hwas_elem_geraet.fkl_uid is
    'Fremschlüssel Funktionsklasse';

comment on column am_main.hwas_elem_geraet.geb_uid is
    'Gebäude Fremschlüssel';

comment on column am_main.hwas_elem_geraet.gvb_uid is
    'Fremdschlüssel Geräteverbund';

comment on column am_main.hwas_elem_geraet.hst_uid is
    'Fremdschlüssel Hersteller';

comment on column am_main.hwas_elem_geraet.inserted is
    'Insert Datum';

comment on column am_main.hwas_elem_geraet.mdl_uid is
    'Fremdschlüssel Modell';

comment on column am_main.hwas_elem_geraet.quellsystem_id is
    'Fremschlüssel im definierenden Quellsystem';

comment on column am_main.hwas_elem_geraet.rm_uid is
    'Fremdschlüssel Raum';

comment on column am_main.hwas_elem_geraet.status is
    'Lebenszyklus des Elm. Gerätes. Status in AWH_main.AWH_TAB_INFOSEC_SYS_STATUS';

