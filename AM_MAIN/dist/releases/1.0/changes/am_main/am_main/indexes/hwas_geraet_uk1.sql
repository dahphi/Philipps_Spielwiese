-- liquibase formatted sql
-- changeset AM_MAIN:1774600099516 stripComments:false logicalFilePath:am_main/am_main/indexes/hwas_geraet_uk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/indexes/hwas_geraet_uk1.sql:null:3567ea472e5b50eb29cb116269bf5d3d457a80f1:create

create unique index am_main.hwas_geraet_uk1 on
    am_main.hwas_geraet (
        grt_inventartnr
    );

