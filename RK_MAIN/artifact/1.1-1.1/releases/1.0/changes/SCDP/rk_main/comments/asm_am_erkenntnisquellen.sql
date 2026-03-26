-- liquibase formatted sql
-- changeset rk_main:1774554916058 stripComments:false logicalFilePath:SCDP/rk_main/comments/asm_am_erkenntnisquellen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/asm_am_erkenntnisquellen.sql:null:660f3f1cc303cf067e81af7e602ce15f93a95601:create

comment on column rk_main.asm_am_erkenntnisquellen.ekq_beschreibung is
    'Beschreibung';

comment on column rk_main.asm_am_erkenntnisquellen.ekq_bezeichnung is
    'eindeutige Bezeichnung';

comment on column rk_main.asm_am_erkenntnisquellen.ekq_uid is
    'Primärschlüssel';

comment on column rk_main.asm_am_erkenntnisquellen.ekw_input_sans is
    ':-getrennte Liste der AD-SANS der Input-Geber';

comment on column rk_main.asm_am_erkenntnisquellen.inserted is
    'Insert Datum';

comment on column rk_main.asm_am_erkenntnisquellen.inserted_by is
    'Insert User';

comment on column rk_main.asm_am_erkenntnisquellen.updated is
    'Update Datum';

comment on column rk_main.asm_am_erkenntnisquellen.updated_by is
    'Update User';

