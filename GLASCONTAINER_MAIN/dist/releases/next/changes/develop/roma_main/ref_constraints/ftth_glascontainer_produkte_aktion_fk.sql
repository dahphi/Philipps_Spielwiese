-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991149 stripComments:false logicalFilePath:develop/roma_main/ref_constraints/ftth_glascontainer_produkte_aktion_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/ref_constraints/ftth_glascontainer_produkte_aktion_fk.sql:null:546f9abe241170403c2cef65c2454952948fed7c:create

alter table roma_main.ftth_glascontainer_produkte
    add constraint ftth_glascontainer_produkte_aktion_fk
        foreign key ( aktion )
            references roma_main.ftth_glascontainer_aktionen ( code )
        enable;

