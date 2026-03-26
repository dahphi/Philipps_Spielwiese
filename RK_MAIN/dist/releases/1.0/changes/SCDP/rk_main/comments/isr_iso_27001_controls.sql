-- liquibase formatted sql
-- changeset rk_main:1774561690092 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_iso_27001_controls.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_iso_27001_controls.sql:null:72258fbbb43f40cefa4b3be8d49362f2b88b9a27:create

comment on column rk_main.isr_iso_27001_controls.bemerkung is
    'Bemerkungsfeld';

comment on column rk_main.isr_iso_27001_controls.control_jahr is
    'Das Jahr des Controls, derzeit 2013 oder 2022, in Zukunft weitere';

comment on column rk_main.isr_iso_27001_controls.grund_ba is
    'Bussines-Anforderung';

comment on column rk_main.isr_iso_27001_controls.grund_bp is
    'Best practice';

comment on column rk_main.isr_iso_27001_controls.grund_ga is
    'Gesetzliche Anforderung';

comment on column rk_main.isr_iso_27001_controls.grund_ra is
    'Ergebniss der Risikoanalyse';

comment on column rk_main.isr_iso_27001_controls.grund_vv is
    'Vertragliche Verpflichtungen';

comment on column rk_main.isr_iso_27001_controls.i2c_control is
    'Bezeichnung';

comment on column rk_main.isr_iso_27001_controls.i2c_control_objective is
    'Beschreibung';

comment on column rk_main.isr_iso_27001_controls.i2c_uid is
    'Primärschlüssel';

comment on column rk_main.isr_iso_27001_controls.inserted is
    'Insert Datum';

comment on column rk_main.isr_iso_27001_controls.inserted_by is
    'Insert User';

comment on column rk_main.isr_iso_27001_controls.kap_uid_fk is
    'FK des KAPITELS';

comment on column rk_main.isr_iso_27001_controls.umsetzungshinweis is
    'UMSETZUNGSHINWEIS für lange Texte';

comment on column rk_main.isr_iso_27001_controls.updated is
    'Update Datum';

comment on column rk_main.isr_iso_27001_controls.updated_by is
    'Update User';

