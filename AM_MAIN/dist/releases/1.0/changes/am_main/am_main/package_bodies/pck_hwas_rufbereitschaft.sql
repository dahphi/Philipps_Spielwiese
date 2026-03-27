-- liquibase formatted sql
-- changeset AM_MAIN:1774600116205 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_rufbereitschaft.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_rufbereitschaft.sql:null:13c3254a67eb43274a3134c08d9e6a5cac59eab4:create

create or replace package body am_main.pck_hwas_rufbereitschaft as

    procedure merge_row (
        p_row  in hwas_rufbereitschaft%rowtype,
        p_user in varchar2
    ) is
    begin
        merge into hwas_rufbereitschaft t
        using (
            select
                nvl(p_row.ruf_uid, to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')) as ruf_uid,
                p_row.name                                                                          as name,
                p_row.telefon                                                                       as telefon,
                p_row.email                                                                         as email,
                p_row.ansprechpartner                                                               as ansprechpartner,
                p_row.ad_gruppe                                                                     as ad_gruppe,
                p_row.bemerkung                                                                     as bemerkung
            from
                dual
        ) s on ( t.ruf_uid = s.ruf_uid )
        when matched then update
        set t.name = s.name,
            t.telefon = s.telefon,
            t.email = s.email,
            t.ansprechpartner = s.ansprechpartner,
            t.ad_gruppe = s.ad_gruppe,
            t.bemerkung = s.bemerkung,
            t.updated = sysdate,
            t.updated_by = p_user
        when not matched then
        insert (
            ruf_uid,
            name,
            telefon,
            email,
            ansprechpartner,
            ad_gruppe,
            bemerkung,
            inserted,
            inserted_by )
        values
            ( s.ruf_uid,
              s.name,
              s.telefon,
              s.email,
              s.ansprechpartner,
              s.ad_gruppe,
              s.bemerkung,
              sysdate,
              p_user );

    end merge_row;

    procedure delete_row (
        p_ruf_uid in number
    ) is
    begin
        delete from hwas_rufbereitschaft
        where
            ruf_uid = p_ruf_uid;

    end delete_row;

end pck_hwas_rufbereitschaft;
/

