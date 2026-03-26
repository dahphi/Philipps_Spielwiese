-- liquibase formatted sql
-- changeset rk_main:1774555708905 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_oam_risikosteuerung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_oam_risikosteuerung.sql:null:aaa575318e20eb694653a4e312df5a9745c5ec0b:create

comment on column rk_main.isr_oam_risikosteuerung.aktiv is
    'kann verwendet werden';

comment on column rk_main.isr_oam_risikosteuerung.inserted is
    'Insert Datum';

comment on column rk_main.isr_oam_risikosteuerung.inserted_by is
    'Insert User';

comment on column rk_main.isr_oam_risikosteuerung.ris_akzeptanz is
    'Wert ist ein Alzeptanz-Wert';

comment on column rk_main.isr_oam_risikosteuerung.ris_beschreibung is
    'Beschreibung des Objekts';

comment on column rk_main.isr_oam_risikosteuerung.ris_titel is
    'eindeutige Bezeichnung';

comment on column rk_main.isr_oam_risikosteuerung.ris_uid is
    'Primärschlüssel';

comment on column rk_main.isr_oam_risikosteuerung.updated is
    'Update Datum';

comment on column rk_main.isr_oam_risikosteuerung.updated_by is
    'Update User';

