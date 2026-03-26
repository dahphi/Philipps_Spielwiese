-- liquibase formatted sql
-- changeset rk_main:1774555708692 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_iso_27001_anhang_a.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_iso_27001_anhang_a.sql:null:6843ad3008fc4aadbb5750a45a26c1d657e213cc:create

comment on column rk_main.isr_iso_27001_anhang_a.i2a_nummer is
    'Nummer des Anhangs';

comment on column rk_main.isr_iso_27001_anhang_a.i2a_titel is
    'Titel des Anhangs';

comment on column rk_main.isr_iso_27001_anhang_a.i2a_uid is
    'Primärschlüssel';

