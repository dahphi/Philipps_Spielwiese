-- liquibase formatted sql
-- changeset rk_main:1774561690143 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_oam_adressat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_oam_adressat.sql:null:5ddf33651d8e3ed4e12b9581cd3b3b6420a90ced:create

comment on column rk_main.isr_oam_adressat.adr_accountable is
    'Gesamtverantwortlich';

comment on column rk_main.isr_oam_adressat.adr_bereich is
    'Bereich gemäß Active Directory';

comment on column rk_main.isr_oam_adressat.adr_consulted is
    'Beratend';

comment on column rk_main.isr_oam_adressat.adr_informed is
    'Informiert';

comment on column rk_main.isr_oam_adressat.adr_oe is
    'Organisationseinheit gemäß Active Directory';

comment on column rk_main.isr_oam_adressat.adr_responsible is
    'Durchführungsverantwortlich';

comment on column rk_main.isr_oam_adressat.adr_rolle is
    'Rolle des Adressaten';

comment on column rk_main.isr_oam_adressat.adr_san is
    'sAMAccountName aus dem Active Directory';

comment on column rk_main.isr_oam_adressat.adr_support is
    'Unterstützend';

comment on column rk_main.isr_oam_adressat.adr_uid is
    'Primärschlüssel: SAmAccountName aus Active Directory';

comment on column rk_main.isr_oam_adressat.freigabeprozess is
    '0 abgelehnt,1 akzeptiert, 2 zugewiesen(nominiert)';

comment on column rk_main.isr_oam_adressat.inserted is
    'Insert Datum';

comment on column rk_main.isr_oam_adressat.inserted_by is
    'Insert User';

comment on column rk_main.isr_oam_adressat.msn_uid is
    'Fremdschlüssel Maßnahme';

comment on column rk_main.isr_oam_adressat.updated is
    'Update Datum';

comment on column rk_main.isr_oam_adressat.updated_by is
    'Update User';

