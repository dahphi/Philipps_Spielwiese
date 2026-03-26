-- liquibase formatted sql
-- changeset am_main:1774556567641 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_prozess.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_prozess.sql:null:acbacdc61ea9451e4500271b7764304ad5ec7fdb:create

comment on column am_main.hwas_prozess.anwendungen_bic is
    'Anwendungen die aus BIC Sicht zugeordnet wurden beim Import der Daten';

comment on column am_main.hwas_prozess.gek_lfd_nr_fk is
    'Geschäftskritikalität';

comment on column am_main.hwas_prozess.guid_bic is
    'GUID aus dem BIC Import';

comment on column am_main.hwas_prozess.prozess_owner_bic is
    'Der Owner der aus BIC geladen wurde';

