-- liquibase formatted sql
-- changeset rk_main:1774555708776 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_oam_massnahme.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_oam_massnahme.sql:null:13894b9832a3f48d2ba7b6e8fffb8b9b6b99a3db:create

comment on column rk_main.isr_oam_massnahme.inserted is
    'Insert Datum';

comment on column rk_main.isr_oam_massnahme.inserted_by is
    'Insert User';

comment on column rk_main.isr_oam_massnahme.mka_uid is
    'Fremschlüssel Maßnahmenkategorie';

comment on column rk_main.isr_oam_massnahme.mkp_uid is
    'Fremdschlüssel Maßnahmenkomplexität';

comment on column rk_main.isr_oam_massnahme.msn_beschreibung is
    'Beschreibung des Objekts';

comment on column rk_main.isr_oam_massnahme.msn_intern is
    'intern = 1, extern = 0';

comment on column rk_main.isr_oam_massnahme.msn_statusbeschreibung is
    'Bescheribung des Maßnahmenstatus';

comment on column rk_main.isr_oam_massnahme.msn_titel is
    'eindeutige Bezeichnung';

comment on column rk_main.isr_oam_massnahme.msn_uid is
    'Primärschlüssel';

comment on column rk_main.isr_oam_massnahme.updated is
    'Update Datum';

comment on column rk_main.isr_oam_massnahme.updated_by is
    'Update User';

comment on column rk_main.isr_oam_massnahme.uss_ready_date is
    'Datum der "Fertig"-Setzung der Maßnahme';

comment on column rk_main.isr_oam_massnahme.uss_uid is
    'Fremdschlüssel Umsetzungsstatus';

comment on column rk_main.isr_oam_massnahme.zieltermin is
    'geplanter Termin für den Abschluss der Umsetzung der Maßnahme';

