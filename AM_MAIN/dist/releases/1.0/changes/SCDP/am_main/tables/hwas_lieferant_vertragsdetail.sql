-- liquibase formatted sql
-- changeset AM_MAIN:1774556573097 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_lieferant_vertragsdetail.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_lieferant_vertragsdetail.sql:null:a7cd07209e6858eba8d363c51ab04df5a697ac58:create

create table am_main.hwas_lieferant_vertragsdetail (
    verlie_uid  number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    vd_uid_fk   number not null enable,
    lie_uid_fk  number not null enable,
    inserted    date default sysdate not null enable,
    inserted_by varchar2(100 byte) not null enable,
    updated     date,
    updated_by  varchar2(100 byte)
)
no inmemory;

alter table am_main.hwas_lieferant_vertragsdetail
    add constraint pk_hwas_lieferant_vertragsdetail primary key ( verlie_uid )
        using index enable;

alter table am_main.hwas_lieferant_vertragsdetail
    add constraint uk_hlv_vd_lie unique ( vd_uid_fk,
                                          lie_uid_fk )
        using index enable;

