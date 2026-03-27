-- liquibase formatted sql
-- changeset am_main:1774600099201 stripComments:false logicalFilePath:am_main/am_main/comments/hwas_virtuelle_maschinen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_virtuelle_maschinen.sql:null:20c2c4c60f7e37f9cffc42283da21d042ee697c8:create

comment on column am_main.hwas_virtuelle_maschinen.inserted is
    'Insert Datum';

comment on column am_main.hwas_virtuelle_maschinen.inserted_by is
    'Insert User';

comment on column am_main.hwas_virtuelle_maschinen.lz_id_fk is
    'Lebenszyklus ID(sowas wie Status). Fremdschlüssell';

comment on column am_main.hwas_virtuelle_maschinen.nzone_uid is
    'Fremdschlüssel Netzwerkzone';

comment on column am_main.hwas_virtuelle_maschinen.ruf_uid_fk is
    'Fremdschlüssel zur Rufbereitschaft';

comment on column am_main.hwas_virtuelle_maschinen.umgebung is
    'Test/Produktion/Entwicklung';

comment on column am_main.hwas_virtuelle_maschinen.updated is
    'Update Datum';

comment on column am_main.hwas_virtuelle_maschinen.updated_by is
    'Update User';

comment on column am_main.hwas_virtuelle_maschinen.vm_beschreibung is
    'Beschreibung der VM';

comment on column am_main.hwas_virtuelle_maschinen.vm_bezeichnung is
    'Fully Qualified Device Name';

comment on column am_main.hwas_virtuelle_maschinen.vm_host is
    'Fremdschlüssel hostendes Gerät/VM-Cluster/Geräteverbund';

comment on column am_main.hwas_virtuelle_maschinen.vm_link_wiki is
    'Link zum Wiki';

comment on column am_main.hwas_virtuelle_maschinen.vm_san is
    'Data Custodian (AD SAN)';

comment on column am_main.hwas_virtuelle_maschinen.vm_uid is
    'Primärschlüssel';

