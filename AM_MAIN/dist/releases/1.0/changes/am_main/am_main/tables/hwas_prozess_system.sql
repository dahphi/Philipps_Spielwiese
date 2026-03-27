-- liquibase formatted sql
-- changeset AM_MAIN:1774600126271 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_prozess_system.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_prozess_system.sql:null:a3a08b8564f70799d36565ce863630c15957e9e2:create

create table am_main.hwas_prozess_system (
    przp_asy_uid  number not null enable,
    przp_uid_fk   number not null enable,
    asy_lfd_nr_fk number not null enable,
    inserted      date default sysdate not null enable,
    inserted_by   varchar2(100 byte) not null enable,
    updated       date,
    updated_by    varchar2(100 byte)
)
no inmemory;

alter table am_main.hwas_prozess_system
    add constraint pk_hwas_przp_asy primary key ( przp_asy_uid )
        using index enable;

alter table am_main.hwas_prozess_system
    add constraint uk_przp_asy unique ( przp_uid_fk,
                                        asy_lfd_nr_fk )
        using index enable;

