-- liquibase formatted sql
-- changeset AM_MAIN:1774556572276 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_hwas_pb_produkt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hwas_pb_produkt.sql:null:df248cbc01cd42f0f9dc99b02005f8ca6420696e:create

alter table am_main.hwas_produktbestandteil
    add constraint fk_hwas_pb_produkt
        foreign key ( prod_uid_fk )
            references am_main.hwas_produkt ( prod_uid )
        enable;

