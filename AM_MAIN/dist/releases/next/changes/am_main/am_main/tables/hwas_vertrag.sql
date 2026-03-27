-- liquibase formatted sql
-- changeset AM_MAIN:1774600126924 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_vertrag.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_vertrag.sql:null:e5390bf2716abc9354acb0d861c4f0ad6c74082d:create

create table am_main.hwas_vertrag (
    vert_uid             number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    vertragsname         varchar2(4000 char),
    gesku_uid_fk         number not null enable,
    gueltig_bis          date,
    vertragsstatus       number,
    vertragstyp          number,
    vertragsdokument_url varchar2(400 byte),
    vertragsname_kurz    varchar2(50 byte)
)
no inmemory;

alter table am_main.hwas_vertrag
    add constraint pk_hwas_vertrag primary key ( vert_uid )
        using index enable;

alter table am_main.hwas_vertrag
    add constraint uc_hwas_vertrag_name_ab unique ( vertragsname,
                                                    vertragsname_kurz )
        using index enable;

