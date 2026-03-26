-- liquibase formatted sql
-- changeset AM_MAIN:1774556572153 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwas_warengruppe.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_warengruppe.sql:null:c757c2d99f0bfe94a8e662489dc7348bde438a92:create

create or replace package am_main.pck_hwas_warengruppe is
    procedure merge_warengruppe (
        p_row in sap_warengruppen%rowtype
    );

    procedure delete_warengruppe (
        p_war_uid in number
    );

end pck_hwas_warengruppe;
/

