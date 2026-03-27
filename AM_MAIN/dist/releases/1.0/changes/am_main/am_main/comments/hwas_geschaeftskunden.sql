-- liquibase formatted sql
-- changeset am_main:1774600098211 stripComments:false logicalFilePath:am_main/am_main/comments/hwas_geschaeftskunden.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_geschaeftskunden.sql:null:70773a5c1f7e42f76cd263c46f9b90e78557c859:create

comment on column am_main.hwas_geschaeftskunden.bsi_it_grundschutz_relevanz is
    '0 =  nein, 1 = ja';

