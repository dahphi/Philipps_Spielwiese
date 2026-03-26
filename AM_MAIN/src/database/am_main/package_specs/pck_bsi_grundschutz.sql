create or replace package am_main.pck_bsi_grundschutz as

  --Merge
    procedure merge_baustein (
        p_row  in bsi_grundschutzbausteine%rowtype,
        p_user in varchar2 default nvl(
            sys_context('APEX$SESSION', 'APP_USER'),
            user
        )
    );

  -- Löschen perBSI BAUSTEINE
    procedure delete_baustein (
        p_bsi_uid in number
    );

end pck_bsi_grundschutz;
/


-- sqlcl_snapshot {"hash":"697c91d30ce0ff9d90edc0da6e652a9465858fb7","type":"PACKAGE_SPEC","name":"PCK_BSI_GRUNDSCHUTZ","schemaName":"AM_MAIN","sxml":""}