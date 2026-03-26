-- liquibase formatted sql
-- changeset AM_MAIN:1774557121972 stripComments:false logicalFilePath:SCDP/am_main/tables/sap_lieferanten_kreditoren_nr.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/sap_lieferanten_kreditoren_nr.sql:null:cd1bf1404755207f82616ff468a5bf2006a68a4d:create

create table am_main.sap_lieferanten_kreditoren_nr (
    likr_uid       number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    lie_uid_fk     number not null enable,
    kred_nr_sap    number not null enable,
    inserted       date default sysdate not null enable,
    inserted_by    varchar2(128 byte) default user not null enable,
    kred_nr_sap_vc varchar2(10 byte)
)
no inmemory;

alter table am_main.sap_lieferanten_kreditoren_nr
    add constraint pk_sap_liefkred primary key ( likr_uid )
        using index enable;

alter table am_main.sap_lieferanten_kreditoren_nr
    add constraint uq_sap_liefkred_lie_kred unique ( lie_uid_fk,
                                                     kred_nr_sap )
        using index enable;

