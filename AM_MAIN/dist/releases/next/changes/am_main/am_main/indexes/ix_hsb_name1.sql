-- liquibase formatted sql
-- changeset AM_MAIN:1774600099558 stripComments:false logicalFilePath:am_main/am_main/indexes/ix_hsb_name1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/indexes/ix_hsb_name1.sql:null:562f16d0aaf7dca58a0fc9be1ddb21366d861824:create

create index am_main.ix_hsb_name1 on
    am_main.hwas_sap_beauftragungen (
        name1
    );

