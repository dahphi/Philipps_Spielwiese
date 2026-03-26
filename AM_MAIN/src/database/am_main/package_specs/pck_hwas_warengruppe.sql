create or replace package am_main.pck_hwas_warengruppe is
    procedure merge_warengruppe (
        p_row in sap_warengruppen%rowtype
    );

    procedure delete_warengruppe (
        p_war_uid in number
    );

end pck_hwas_warengruppe;
/


-- sqlcl_snapshot {"hash":"c757c2d99f0bfe94a8e662489dc7348bde438a92","type":"PACKAGE_SPEC","name":"PCK_HWAS_WARENGRUPPE","schemaName":"AM_MAIN","sxml":""}