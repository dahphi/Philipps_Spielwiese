-- liquibase formatted sql
-- changeset AM_MAIN:1774605608517 stripComments:false logicalFilePath:am_main/am_main/tables/bsi_grundschutzbausteine.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/bsi_grundschutzbausteine.sql:e9cb22d7b9151411535ae53fa97a1c8e3f9e968d:e48b0e45d35fb8660ea6280702f1d8789cb2218e:alter

alter table am_main.bsi_grundschutzbausteine add (
    art number
)
/

alter table am_main.bsi_grundschutzbausteine add (
    iv_relevanz number
)
/

alter table am_main.bsi_grundschutzbausteine add (
    bemerkung varchar2(400)
)
/

