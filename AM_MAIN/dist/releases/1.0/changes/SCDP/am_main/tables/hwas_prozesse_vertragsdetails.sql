-- liquibase formatted sql
-- changeset AM_MAIN:1774556573298 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_prozesse_vertragsdetails.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_prozesse_vertragsdetails.sql:null:5c4d289c39bf9df27fdf8649b5bb4eb3f1d54566:create

create table am_main.hwas_prozesse_vertragsdetails (
    verprzp_uid number not null enable,
    vd_uid_fk   number not null enable,
    przp_uid_fk number not null enable,
    inserted    date default sysdate not null enable,
    inserted_by varchar2(100 byte) not null enable,
    updated     date,
    updated_by  varchar2(100 byte)
)
no inmemory;

alter table am_main.hwas_prozesse_vertragsdetails
    add constraint pk_hwas_przp_vd primary key ( verprzp_uid )
        using index enable;

alter table am_main.hwas_prozesse_vertragsdetails
    add constraint uk_przp_vd unique ( vd_uid_fk,
                                       przp_uid_fk )
        using index enable;

