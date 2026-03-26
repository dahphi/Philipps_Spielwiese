-- liquibase formatted sql
-- changeset AM_MAIN:1774557121720 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_vertrag_produkt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_vertrag_produkt.sql:null:f2c1320ea616fc8af1ec740627ef879dda7deb63:create

create table am_main.hwas_vertrag_produkt (
    ver_prod_uid number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    vert_uid_fk  number not null enable,
    prod_uid_fk  number not null enable,
    inserted     date default sysdate not null enable,
    inserted_by  varchar2(100 byte) default user not null enable,
    updated      date,
    updated_by   varchar2(100 byte)
)
no inmemory;

alter table am_main.hwas_vertrag_produkt
    add constraint pk_hwas_vertrag_produkt primary key ( ver_prod_uid )
        using index enable;

alter table am_main.hwas_vertrag_produkt
    add constraint uk_hvp_vertrag_produkt unique ( vert_uid_fk,
                                                   prod_uid_fk )
        using index enable;

