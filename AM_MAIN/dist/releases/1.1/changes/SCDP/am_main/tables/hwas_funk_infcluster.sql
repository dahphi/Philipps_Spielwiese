-- liquibase formatted sql
-- changeset AM_MAIN:1774557120989 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_funk_infcluster.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_funk_infcluster.sql:null:fbdb7a5e5e3a4093abc59cda63d8479f1d3f16d2:create

create table am_main.hwas_funk_infcluster (
    fkin_uid    number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    fkl_uid     number,
    incl_uid    number,
    inserted    date,
    updated     date,
    inserted_by varchar2(100 byte),
    updated_by  varchar2(100 byte)
)
no inmemory;

alter table am_main.hwas_funk_infcluster
    add constraint fkin_uid_pk primary key ( fkin_uid )
        using index enable;

