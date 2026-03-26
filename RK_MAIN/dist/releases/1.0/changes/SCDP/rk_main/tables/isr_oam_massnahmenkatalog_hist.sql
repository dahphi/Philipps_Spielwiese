-- liquibase formatted sql
-- changeset RK_MAIN:1774561695094 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_massnahmenkatalog_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_massnahmenkatalog_hist.sql:null:8f7d929a1e5388a51dd2a95325214f49c91f7a1e:create

create table rk_main.isr_oam_massnahmenkatalog_hist (
    mnkh_uid         number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    mnk_uid          number,
    rsk_uid          number,
    msn_uid          number,
    inserted         date,
    updated          date,
    inserted_by      varchar2(255 byte),
    updated_by       varchar2(255 byte),
    insert_info      varchar2(400 byte),
    mnkh_inserted    date,
    mnkh_inserted_by varchar2(200 byte)
)
no inmemory;

alter table rk_main.isr_oam_massnahmenkatalog_hist
    add constraint mnkh_uid_pk primary key ( mnkh_uid )
        using index enable;

