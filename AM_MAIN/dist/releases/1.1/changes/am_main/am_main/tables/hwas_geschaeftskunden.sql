-- liquibase formatted sql
-- changeset AM_MAIN:1774605609162 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_geschaeftskunden.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_geschaeftskunden.sql:cd5bc74fdc99fb1172e69daa098f6461a747c243:694b8141ccb6fc202f64a12fa471fa1069dc9335:alter

alter table am_main.hwas_geschaeftskunden modify (
    ansprech_telefon varchar2(50)
)
/

alter table am_main.hwas_geschaeftskunden add constraint siebel_geschaeftskunden_uk1 unique ( kundennr_siebel )
    using index enable
/

