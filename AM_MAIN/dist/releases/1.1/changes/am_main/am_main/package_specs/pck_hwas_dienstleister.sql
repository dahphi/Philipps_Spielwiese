-- liquibase formatted sql
-- changeset AM_MAIN:1774605608103 stripComments:false logicalFilePath:am_main/am_main/package_specs/pck_hwas_dienstleister.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_dienstleister.sql:a7804ee25a11daba0250cd6c8e4a8c7a9c88f889:c50ddc1f78360e75c972556fa40b4ad2a455beae:alter

create or replace package am_main.pck_hwas_dienstleister is
    procedure merge_dienstleister (
        p_rec in out hwas_dienstleister%rowtype
    );

    procedure merge_beauftragungen (
        p_rec              in out hwas_beauftragungen%rowtype,
        p_funktionsklassen in apex_application_global.vc_arr2
    );

    procedure delete_dienstleister (
        p_dtl_uid in number
    );

    procedure delete_beauftragungen (
        p_bean_uid in number
    );

    procedure merge_lieferanten (
        p_rec in out sap_lieferanten%rowtype
    );
  ---------------------------------NEW------------------------------------
  
  -- Insert via ROWTYPE
    procedure insert_row (
        p_rec              in out hwas_bean_funktionsklassen%rowtype,
        p_funktionsklassen in apex_application_global.vc_arr2
    );

  -- Delete via ROWTYPE 
    procedure delete_row (
        p_rec in hwas_bean_funktionsklassen%rowtype
    );

    procedure update_kostenstelle (
        p_saoko_uid        in number,
        p_zustaendige_pers in varchar2,
        p_user             in varchar2 default nvl(
            sys_context('APEX$SESSION', 'APP_USER'),
            user
        ),
        p_lebenszyklus     in number
    );

end pck_hwas_dienstleister;
/

