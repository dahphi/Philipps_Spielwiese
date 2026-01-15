-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991422 stripComments:false logicalFilePath:develop/roma_main/tables/pob_adressen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/tables/pob_adressen.sql:null:10490c9a12bbfebed3a6e156bc850ab13529ad30:create

create table roma_main.pob_adressen (
    haus_lfd_nr         number not null enable,
    str                 varchar2(255 byte),
    hnr_kompl           varchar2(255 byte),
    gebaeudeteil_name   varchar2(255 byte),
    plz                 varchar2(5 byte),
    ort_kompl           varchar2(255 byte),
    adresse_kompl       varchar2(1000 byte),
    aktualisiert        date,
    ausbaugebiete       varchar2(500 byte),
    ausbaugebietstypen  varchar2(500 byte),
    erschliessungen     varchar2(500 byte),
    status_ausbaugebiet varchar2(500 byte),
    projekte            varchar2(500 byte),
    projektnamen        varchar2(500 byte)
);

alter table roma_main.pob_adressen
    add constraint pob_adressen_pk primary key ( haus_lfd_nr )
        using index enable;

