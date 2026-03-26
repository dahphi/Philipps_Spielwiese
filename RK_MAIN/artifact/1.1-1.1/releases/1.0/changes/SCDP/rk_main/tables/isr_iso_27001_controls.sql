-- liquibase formatted sql
-- changeset RK_MAIN:1774554921294 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_iso_27001_controls.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_iso_27001_controls.sql:null:daf028964c34deaa00da5aca15b76056a2333466:create

create table rk_main.isr_iso_27001_controls (
    i2c_uid               number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    i2c_control           varchar2(200 byte) not null enable,
    i2c_control_objective varchar2(4000 byte),
    inserted              date default sysdate not null enable,
    updated               date,
    inserted_by           varchar2(100 char),
    updated_by            varchar2(100 char),
    control_jahr          number,
    kap_uid_fk            number,
    umsetzungshinweis     varchar2(4000 byte),
    bemerkung             varchar2(4000 byte),
    grund_ga              number,
    grund_vv              number,
    grund_ba              number,
    grund_bp              number,
    grund_ra              number,
    anwendbarkeit         varchar2(200 byte)
)
no inmemory;

create unique index rk_main.isr_iso_27001_controls_pk on
    rk_main.isr_iso_27001_controls (
        i2c_uid
    );

create unique index rk_main.isr_iso_27001_controls_uk1 on
    rk_main.isr_iso_27001_controls (
        i2c_control
    );

alter table rk_main.isr_iso_27001_controls
    add constraint isr_iso_27001_controls_pk
        primary key ( i2c_uid )
            using index rk_main.isr_iso_27001_controls_pk enable;

alter table rk_main.isr_iso_27001_controls
    add constraint isr_iso_27001_controls_uk1 unique ( i2c_control )
        using index rk_main.isr_iso_27001_controls_uk1 enable;

