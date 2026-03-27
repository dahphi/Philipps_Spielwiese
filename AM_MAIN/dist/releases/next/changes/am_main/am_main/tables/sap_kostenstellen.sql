-- liquibase formatted sql
-- changeset AM_MAIN:1774600127670 stripComments:false logicalFilePath:am_main/am_main/tables/sap_kostenstellen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/sap_kostenstellen.sql:null:06862f0987fc8de00d4cfe6448f1f21b52635334:create

create table am_main.sap_kostenstellen (
    saoko_uid                    number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    kontierungsobjekt            varchar2(200 char) not null enable,
    verantwortliche_kostenstelle varchar2(4000 char),
    zustaendige_person           varchar2(200 char),
    inserted                     date default sysdate,
    inserted_by                  varchar2(100 char),
    updated                      date,
    updated_by                   varchar2(100 char),
    lebenszyklus                 number
)
no inmemory;

alter table am_main.sap_kostenstellen
    add constraint pk_sap_kostenstellen primary key ( saoko_uid )
        using index enable;

alter table am_main.sap_kostenstellen add constraint uq_sap_kostenstellen_kontierung unique ( kontierungsobjekt )
    using index enable;

