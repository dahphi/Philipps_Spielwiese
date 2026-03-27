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

    procedure sync_asset_bausteine (
        p_ass_uid_fk    in number,
        p_asset_typ     in varchar2,
        p_shuttle_value in varchar2,
        p_inserted_by   in varchar2 default null
    );

end pck_bsi_grundschutz;
/


-- sqlcl_snapshot {"hash":"24b81ac16d96af7470e6cccabfb0cfca33e82547","type":"PACKAGE_SPEC","name":"PCK_BSI_GRUNDSCHUTZ","schemaName":"AM_MAIN","sxml":""}