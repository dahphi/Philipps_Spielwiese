-- liquibase formatted sql
-- changeset AM_MAIN:1774605607229 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_prozesse_bsi_bausteine.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_prozesse_bsi_bausteine.sql:null:eb4aeec439d0c5de41f1062de74eaf744628c9f5:create

create table am_main.hwas_prozesse_bsi_bausteine (
    przpbsi_uid   number default to_number(substr(
        rawtohex(sys_guid()),
        1,
        30
    ),
          'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    bsi_uid_fk    number not null enable,
    przp_uid_fk   number not null enable,
    inserted_date date default sysdate,
    inserted_by   varchar2(100 byte),
    updated_date  date,
    updated_by    varchar2(100 byte)
)
no inmemory;

alter table am_main.hwas_prozesse_bsi_bausteine
    add constraint pk_hwas_przpbsi_uid primary key ( przpbsi_uid )
        using index enable;

alter table am_main.hwas_prozesse_bsi_bausteine
    add constraint uk_hwas_przp_bsi unique ( przp_uid_fk,
                                             bsi_uid_fk )
        using index enable;

