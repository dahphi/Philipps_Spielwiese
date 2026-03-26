-- liquibase formatted sql
-- changeset am_main:1774557115104 stripComments:false logicalFilePath:SCDP/am_main/comments/bsi_grundschutzbausteine.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/bsi_grundschutzbausteine.sql:null:67a2c47dd9f291c2156c2f4500bc7eaa26539e2d:create

comment on column am_main.bsi_grundschutzbausteine.bausteintyp is
    'Schicht seit 10.03.2026';

comment on column am_main.bsi_grundschutzbausteine.iv_relevanz is
    'Relevanz für Informationsverbund';

