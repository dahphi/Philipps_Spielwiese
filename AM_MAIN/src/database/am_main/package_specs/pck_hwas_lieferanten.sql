create or replace package am_main.pck_hwas_lieferanten is
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

end pck_hwas_lieferanten;
/


-- sqlcl_snapshot {"hash":"1bc16b3ddb0ea1ef898896fa27daa78564c88029","type":"PACKAGE_SPEC","name":"PCK_HWAS_LIEFERANTEN","schemaName":"AM_MAIN","sxml":""}