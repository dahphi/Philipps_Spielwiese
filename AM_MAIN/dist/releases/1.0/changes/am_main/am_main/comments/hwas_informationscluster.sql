-- liquibase formatted sql
-- changeset am_main:1774600098311 stripComments:false logicalFilePath:am_main/am_main/comments/hwas_informationscluster.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_informationscluster.sql:null:8cc79b04a8c9d51ee6501a20a448fd3d4e8b2a31:create

comment on column am_main.hwas_informationscluster.aut_lfd_nr is
    'Fremdschlüssel Schutzbedarf Authentizität';

comment on column am_main.hwas_informationscluster.data_owner is
    'Data ower des Informationsclusters';

comment on column am_main.hwas_informationscluster.dom_uid_fk is
    'Kommentar für das Informationscluster';

comment on column am_main.hwas_informationscluster.incl_bezeichnung is
    'Clusterbezeichnung';

comment on column am_main.hwas_informationscluster.incl_typ is
    'TYP der Informationsclusters bspw. DSGVO';

comment on column am_main.hwas_informationscluster.incl_uid is
    'Primärschlüssel';

comment on column am_main.hwas_informationscluster.inserted is
    'Insert Datum';

comment on column am_main.hwas_informationscluster.inserted_by is
    'Insert User';

comment on column am_main.hwas_informationscluster.int_lfd_nr is
    'Fremdschlüssel Schutzbedarf Integrität';

comment on column am_main.hwas_informationscluster.updated is
    'Update Datum';

comment on column am_main.hwas_informationscluster.updated_by is
    'Update User';

comment on column am_main.hwas_informationscluster.vef_lfd_nr is
    'Fremdschlüssel Schutzbedarf Verfügbarkeit';

comment on column am_main.hwas_informationscluster.vet_lfd_nr is
    'Fremdschlüssel Schutzbedarf Vertraulichkeit';

