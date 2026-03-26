-- liquibase formatted sql
-- changeset RK_MAIN:1774561694566 stripComments:false logicalFilePath:SCDP/rk_main/tables/ad_abteilungsaccount.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/ad_abteilungsaccount.sql:null:5de4ed10b2df676344152a262756138749c9b755:create

create table rk_main.ad_abteilungsaccount (
    aaa_uid               number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    aa_uid                number,
    aaa_san               varchar2(20 byte),
    aaa_displayname       varchar2(1024 byte),
    aaa_distinguishedname varchar2(4000 byte)
)
no inmemory;

alter table rk_main.ad_abteilungsaccount
    add constraint ad_abteilungsaccount_pk primary key ( aaa_uid )
        using index enable;

