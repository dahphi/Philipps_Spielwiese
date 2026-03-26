create or replace package am_main.pck_hwas_rufbereitschaft as
  -- Merge eines einzelnen Datensatzes
    procedure merge_row (
        p_row  in hwas_rufbereitschaft%rowtype,
        p_user in varchar2 default nvl(
            sys_context('APEX$SESSION', 'APP_USER'),
            user
        )
    );

  -- Löschen per Primärschlüssel
    procedure delete_row (
        p_ruf_uid in number
    );

end pck_hwas_rufbereitschaft;
/


-- sqlcl_snapshot {"hash":"590abc6997e26716a9382816d3347b3ff642965b","type":"PACKAGE_SPEC","name":"PCK_HWAS_RUFBEREITSCHAFT","schemaName":"AM_MAIN","sxml":""}