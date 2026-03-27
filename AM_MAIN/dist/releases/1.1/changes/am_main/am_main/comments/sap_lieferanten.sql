-- liquibase formatted sql
-- changeset am_main:1774605606930 stripComments:false logicalFilePath:am_main/am_main/comments/sap_lieferanten.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/sap_lieferanten.sql:null:5433cbb0e544a127afd1fac6a8a4c42eda29af64:create

comment on column am_main.sap_lieferanten.gek_lfd_nr is
    'Geschäftskritikalität';

