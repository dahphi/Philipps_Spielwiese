-- liquibase formatted sql
-- changeset RK_MAIN:1774554920963 stripComments:false logicalFilePath:SCDP/rk_main/tables/ad_abteilung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/ad_abteilung.sql:null:7d1dc44dc9b410d6b30b7dae094c10bafec590cd:create

create table rk_main.ad_abteilung (
    aa_uid number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    aa_dn  varchar2(1024 byte)
)
no inmemory;

alter table rk_main.ad_abteilung
    add constraint ad_abteilung_pk primary key ( aa_uid )
        using index enable;

