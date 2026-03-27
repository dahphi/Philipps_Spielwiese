-- liquibase formatted sql
-- changeset AM_MAIN:1774600118934 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_warengruppe.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_warengruppe.sql:null:32d1ee965262f1bf61e14cc348f2055c8c207964:create

create or replace package body am_main.pck_hwas_warengruppe is

    procedure merge_warengruppe (
        p_row in sap_warengruppen%rowtype
    ) is
        v_count number;
    begin
        select
            count(*)
        into v_count
        from
            sap_warengruppen
        where
            war_uid = p_row.war_uid;

        if v_count > 0 then
      -- Update nur der bearbeitbaren Felder
            update sap_warengruppen
            set
                is_relevant = p_row.is_relevant,
                bemerkung = p_row.bemerkung,
                updated = sysdate,
                updated_by = p_row.updated_by,
                capex_opex = p_row.capex_opex
            where
                war_uid = p_row.war_uid;

        else
      -- Insert mit neu generierter WAR_UID
            insert into sap_warengruppen (
                war_uid,
                sap_id,
                warengruppenbezeichnung,
                warengruppenbezeichnung_2,
                is_relevant,
                bemerkung,
                inserted,
                inserted_by,
                capex_opex
            ) values ( to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                       p_row.sap_id,
                       p_row.warengruppenbezeichnung,
                       p_row.warengruppenbezeichnung_2,
                       p_row.is_relevant,
                       p_row.bemerkung,
                       sysdate,
                       p_row.inserted_by,
                       p_row.capex_opex );

        end if;

    end merge_warengruppe;

    procedure delete_warengruppe (
        p_war_uid in number
    ) is
    begin
        delete from sap_warengruppen
        where
            war_uid = p_war_uid;

    end delete_warengruppe;

end pck_hwas_warengruppe;
/

