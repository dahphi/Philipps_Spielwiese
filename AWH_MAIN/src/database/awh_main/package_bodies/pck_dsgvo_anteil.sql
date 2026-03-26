create or replace package body awh_main.pck_dsgvo_anteil as
    -- Insert-Prozedur
    procedure prc_insert_awh_infocluster_persongrp (
        p_icbp_uid       out number,
        p_bpg_lfd_nr_fk  in number,
        p_sic_asy_icl_fk in number,
        p_icbp_user      in varchar2
    ) is
    begin
        insert into awh_infocluster_persongrp (
            icbp_uid,
            bpg_lfd_nr_fk,
            sic_asy_icl_fk,
            icbp_user,
            icbp_date
        ) values ( to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                   p_bpg_lfd_nr_fk,
                   p_sic_asy_icl_fk,
                   p_icbp_user,
                   sysdate ) returning icbp_uid into p_icbp_uid;

    end prc_insert_awh_infocluster_persongrp;

    -- Update-Prozedur
    procedure prc_update_awh_infocluster_persongrp (
        p_icbp_uid       in number,
        p_bpg_lfd_nr_fk  in number,
        p_sic_asy_icl_fk in number,
        p_icbp_user      in varchar2
    ) is
    begin
        update awh_infocluster_persongrp
        set
            bpg_lfd_nr_fk = p_bpg_lfd_nr_fk,
            sic_asy_icl_fk = p_sic_asy_icl_fk,
            icbp_user = p_icbp_user,
            icbp_date = sysdate
        where
            icbp_uid = p_icbp_uid;

        if sql%rowcount = 0 then
            raise_application_error(-20001, 'Kein Datensatz mit der angegebenen ICBP_UID gefunden.');
        end if;
    end prc_update_awh_infocluster_persongrp;

-- Delete-Prozedur
    procedure prc_delete_awh_infocluster_persongrp (
        p_icbp_uid in number
    ) is
    begin
        delete from awh_infocluster_persongrp
        where
            icbp_uid = p_icbp_uid;

        if sql%rowcount = 0 then
            raise_application_error(-20002, 'Kein Datensatz mit der angegebenen ICBP_UID gefunden.');
        end if;
    end prc_delete_awh_infocluster_persongrp;

  -- Prozedur zum Aktualisieren
    procedure update_bpg_lfd_nr_fk (
        p_sic_asy_icl_fk in awh_infocluster_persongrp.sic_asy_icl_fk%type,
        p_bpg_lfd_nr_fk  in varchar2, -- Multivalue LOV als : getrennte Werte
        p_icbp_user      in awh_infocluster_persongrp.icbp_user%type
    ) is
        l_values    apex_t_varchar2; -- Apex Hilfstyp für Splitting der LOV-Werte
        l_bpg_value number;
    begin
    -- Splitte die : getrennten Werte der Spalte BPG_LFD_NR_FK
        dbms_output.put_line('p_sic_asy_icl_fk  ' || p_sic_asy_icl_fk);
        dbms_output.put_line('p_bpg_lfd_nr_fk  ' || p_bpg_lfd_nr_fk);
        dbms_output.put_line('p_icbp_user  ' || p_icbp_user);
        l_values := apex_string.split(p_bpg_lfd_nr_fk, ':');

    -- Lösche vorherige Einträge für den spezifischen ICBP_UID
        delete from awh_infocluster_persongrp
        where
            sic_asy_icl_fk = p_sic_asy_icl_fk;

    -- Iteriere durch die einzelnen Werte der LOV
        for i in 1..l_values.count loop
            dbms_output.put_line('Ungültiger Wert: '
                                 || l_values(i)
                                 || ' - wird übersprungen.');
            l_bpg_value := to_number ( l_values(i) );

        -- Einfügen der Daten in die Tabelle
            insert into awh_infocluster_persongrp (
                icbp_uid,
                bpg_lfd_nr_fk,
                sic_asy_icl_fk,
                icbp_user,
                icbp_date
            ) values ( to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                       l_bpg_value,
                       p_sic_asy_icl_fk,
                       p_icbp_user,
                       sysdate );

        end loop;

        commit;
    exception
        when others then
            rollback;
            raise;
    end update_bpg_lfd_nr_fk;

    procedure update_bpg_lfd_nr_fk1 (
        p_sic_asy_icl_fk in number,
        p_bpg_lfd_nr_fk  in number
    ) is
        v_conter number := 0;
    begin
        select
            count(*)
        into v_conter
        from
            awh_infocluster_persongrp
        where
                bpg_lfd_nr_fk = p_bpg_lfd_nr_fk
            and sic_asy_icl_fk = p_sic_asy_icl_fk;

        if v_conter = 0 then

	--v_sequence := MASSNAHME_KONTEXT_SEQ.NEXTVAL;
            insert into awh_infocluster_persongrp (
        --MK_ID,
                bpg_lfd_nr_fk,
                sic_asy_icl_fk,
                icbp_user,
                icbp_date
            ) values (
          --v_sequence,
             p_bpg_lfd_nr_fk,
                       p_sic_asy_icl_fk,
                       v('APP_USER'),
                       sysdate );

        end if;

    end update_bpg_lfd_nr_fk1;


   -- Prozedur zum Löschen
    procedure delete_bpg_lfd_nr_fk (
        p_sic_asy_icl in awh_main.awh_mtn_sys_icl.sic_asy_icl%type
    ) is
    begin
        delete from awh_main.awh_infocluster_persongrp
        where
            sic_asy_icl_fk = p_sic_asy_icl;

        commit;
    end delete_bpg_lfd_nr_fk;

    -- Insert-Prozedur
    procedure insert_gesellschaft (
        p_ges_uid in number,
        p_name    in varchar2,
        p_adresse in varchar2,
        p_email   in varchar2,
        p_tel     in varchar2
    ) is
    begin
        insert into t_awh_gesellschaften (
            ges_uid,
            name,
            adresse,
            email,
            tel
        ) values ( p_ges_uid,
                   p_name,
                   p_adresse,
                   p_email,
                   p_tel );

        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20001, 'Fehler beim Einfügen: ' || sqlerrm);
    end insert_gesellschaft;

    -- Update-Prozedur
    procedure update_gesellschaft (
        p_ges_uid in number,
        p_name    in varchar2,
        p_adresse in varchar2,
        p_email   in varchar2,
        p_tel     in varchar2
    ) is
    begin
        update t_awh_gesellschaften
        set
            name = p_name,
            adresse = p_adresse,
            email = p_email,
            tel = p_tel
        where
            ges_uid = p_ges_uid;

        if sql%rowcount = 0 then
            raise_application_error(-20002, 'Keine Zeile mit der angegebenen GES_UID gefunden.');
        end if;
        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20003, 'Fehler beim Aktualisieren: ' || sqlerrm);
    end update_gesellschaft;

    -- Delete-Prozedur
    procedure delete_gesellschaft (
        p_ges_uid in number
    ) is
    begin
        delete from t_awh_gesellschaften
        where
            ges_uid = p_ges_uid;

        if sql%rowcount = 0 then
            raise_application_error(-20004, 'Keine Zeile mit der angegebenen GES_UID gefunden.');
        end if;
        commit;
    exception
        when others then
            rollback;
            raise_application_error(-20005, 'Fehler beim Löschen: ' || sqlerrm);
    end delete_gesellschaft;

end pck_dsgvo_anteil;
/


-- sqlcl_snapshot {"hash":"e0c7c96148e21fc5015b013f8529a4a20f77d4b3","type":"PACKAGE_BODY","name":"PCK_DSGVO_ANTEIL","schemaName":"AWH_MAIN","sxml":""}