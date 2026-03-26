-- liquibase formatted sql
-- changeset AM_MAIN:1774557120420 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_hwas_produkt_promotion.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hwas_produkt_promotion.sql:null:9260d5f18c138b3de012e33ec7158ba209e658e7:create

alter table am_main.hwas_produkt
    add constraint fk_hwas_produkt_promotion
        foreign key ( prom_uid_fk )
            references am_main.hwas_promotion ( prom_uid )
        enable;

