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
                p_row.url                                                                           as url,
                p_row.art                                                                           as art,
                p_row.iv_relevanz                                                                   as iv_relevanz,
                p_row.bemerkung                                                                     as bemerkung
            from
                dual
        ) s on ( t.bsi_uid = s.bsi_uid )
        when matched then update
        set t.name = s.name,
            t.bausteintyp = s.bausteintyp,
            t.url = s.url,
            t.updated = sysdate,
            t.updated_by = p_user,
            t.art = s.art,
            t.iv_relevanz = s.iv_relevanz,
            t.bemerkung = s.bemerkung
        when not matched then
        insert (
            bsi_uid,
            name,
            bausteintyp,
            url,
            inserted,
            inserted_by,
            art,
            iv_relevanz,
            bemerkung )
        values
            ( s.bsi_uid,
              s.name,
              s.bausteintyp,
              s.url,
              sysdate,
              p_user,
              s.art,
              s.iv_relevanz,
              s.bemerkung );

    end merge_baustein;

    procedure delete_baustein (
        p_bsi_uid in number
    ) is
    begin
        delete from bsi_grundschutzbausteine
        where
            bsi_uid = p_bsi_uid;

    end delete_baustein;

    procedure sync_asset_bausteine (
        p_ass_uid_fk    in number,
        p_asset_typ     in varchar2,
        p_shuttle_value in varchar2,
        p_inserted_by   in varchar2 default null
    ) is

        l_asset_typ   varchar2(50) := p_asset_typ;
        l_inserted_by varchar2(50) := nvl(p_inserted_by, user);
    begin
        if p_ass_uid_fk is null then
            raise_application_error(-20001, 'ASS_UID_FK darf nicht NULL sein.');
        end if;
        if l_asset_typ is null then
            raise_application_error(-20002, 'ASSET_TYP darf nicht NULL sein.');
        end if;
        if p_shuttle_value is not null then
            delete from bsi_asset_baustein bab
            where
                    bab.ass_uid_fk = p_ass_uid_fk
                and bab.asset_typ = l_asset_typ
                and bab.bsi_uid_fk not in (
                    select
                        to_number(column_value)
                    from
                        table ( apex_string.split(p_shuttle_value, ':') )
                    where
                        column_value is not null
                );

        else
            delete from bsi_asset_baustein bab
            where
                    bab.ass_uid_fk = p_ass_uid_fk
                and bab.asset_typ = l_asset_typ;

        end if;

        if p_shuttle_value is not null then
            insert into bsi_asset_baustein (
                bsi_uid_fk,
                ass_uid_fk,
                asset_typ,
                inserted,
                inserted_by
            )
                select
                    x.bsi_uid_fk,
                    p_ass_uid_fk,
                    l_asset_typ,
                    sysdate,
                    l_inserted_by
                from
                    (
                        select distinct
                            to_number(column_value) as bsi_uid_fk
                        from
                            table ( apex_string.split(p_shuttle_value, ':') )
                        where
                            column_value is not null
                    ) x
                where
                    not exists (
                        select
                            1
                        from
                            bsi_asset_baustein bab
                        where
                                bab.bsi_uid_fk = x.bsi_uid_fk
                            and bab.ass_uid_fk = p_ass_uid_fk
                            and bab.asset_typ = l_asset_typ
                    );

        end if;

    exception
        when value_error then
            raise_application_error(-20003, 'Ungültiger Wert im Shuttle. Es sind nur numerische IDs erlaubt.');
    end sync_asset_bausteine;

end pck_bsi_grundschutz;
/


-- sqlcl_snapshot {"hash":"4cefb8dbc2c59af8765db1f2c29f623e2de20577","type":"PACKAGE_BODY","name":"PCK_BSI_GRUNDSCHUTZ","schemaName":"AM_MAIN","sxml":""}