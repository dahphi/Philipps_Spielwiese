create or replace package body am_main.pck_bsi_grundschutz as

    procedure merge_baustein (
        p_row  in bsi_grundschutzbausteine%rowtype,
        p_user in varchar2
    ) is
    begin
        merge into bsi_grundschutzbausteine t
        using (
            select
                nvl(p_row.bsi_uid, to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')) as bsi_uid,
                p_row.name                                                                          as name,
                p_row.bausteintyp                                                                   as bausteintyp,
                p_row.url                                                                           as url
            from
                dual
        ) s on ( t.bsi_uid = s.bsi_uid )
        when matched then update
        set t.name = s.name,
            t.bausteintyp = s.bausteintyp,
            t.url = s.url,
            t.updated = sysdate,
            t.updated_by = p_user
        when not matched then
        insert (
            bsi_uid,
            name,
            bausteintyp,
            url,
            inserted,
            inserted_by )
        values
            ( s.bsi_uid,
              s.name,
              s.bausteintyp,
              s.url,
              sysdate,
              p_user );

    end merge_baustein;

    procedure delete_baustein (
        p_bsi_uid in number
    ) is
    begin
        delete from bsi_grundschutzbausteine
        where
            bsi_uid = p_bsi_uid;

    end delete_baustein;

end pck_bsi_grundschutz;
/


-- sqlcl_snapshot {"hash":"8f37b370117ceb2004f74eda1b2e1ef5021533a5","type":"PACKAGE_BODY","name":"PCK_BSI_GRUNDSCHUTZ","schemaName":"AM_MAIN","sxml":""}