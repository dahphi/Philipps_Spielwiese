-- liquibase formatted sql
-- changeset RK_MAIN:1774555713579 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_massnahmenkatalog.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_massnahmenkatalog.sql:null:4f9fd5b42bbcbd2eedab47dcbba83e5d67ac3671:create

create table rk_main.isr_oam_massnahmenkatalog (
    mnk_uid     number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    rsk_uid     number not null enable,
    msn_uid     number not null enable,
    inserted    date default sysdate not null enable,
    updated     date,
    inserted_by varchar2(100 char),
    updated_by  varchar2(100 char)
)
no inmemory;

alter table rk_main.isr_oam_massnahmenkatalog
    add constraint isr_oam_massnahmenkatalog_pk primary key ( mnk_uid )
        using index enable;

