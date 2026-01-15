-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991156 stripComments:false logicalFilePath:develop/roma_main/ref_constraints/ftth_glascontainer_produkte_folgeprodukt_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/ref_constraints/ftth_glascontainer_produkte_folgeprodukt_fk.sql:null:e8cdebe3878779ef8489ac0ec8353ff0d4201602:create

alter table roma_main.ftth_glascontainer_produkte
    add constraint ftth_glascontainer_produkte_folgeprodukt_fk
        foreign key ( folgeprodukt_template_id )
            references roma_main.ftth_glascontainer_produkte ( template_id )
        enable;

