-- liquibase formatted sql
-- changeset AM_MAIN:1774600123399 stripComments:false logicalFilePath:am_main/am_main/tables/bic_import_februar_mod.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/bic_import_februar_mod.sql:null:6db23bb5ed712b2cc6e41b235b9586fd39ad283f:create

create table am_main.bic_import_februar_mod (
    typ          varchar2(2000 byte),
    guid         varchar2(2000 byte),
    pfad         varchar2(2000 byte),
    typname      varchar2(2000 byte),
    at_name      varchar2(2000 byte),
    at_pers_resp varchar2(2000 byte),
    at_resp_mail varchar2(2000 byte),
    at_org       varchar2(2000 byte)
)
no inmemory;

