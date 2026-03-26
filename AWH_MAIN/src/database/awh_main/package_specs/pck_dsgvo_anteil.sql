create or replace package awh_main.pck_dsgvo_anteil as
    -- Prozeduren-Deklaration
    procedure prc_insert_awh_infocluster_persongrp (
        p_icbp_uid       out number,
        p_bpg_lfd_nr_fk  in number,
        p_sic_asy_icl_fk in number,
        p_icbp_user      in varchar2
    );

    procedure prc_update_awh_infocluster_persongrp (
        p_icbp_uid       in number,
        p_bpg_lfd_nr_fk  in number,
        p_sic_asy_icl_fk in number,
        p_icbp_user      in varchar2
    );

    procedure prc_delete_awh_infocluster_persongrp (
        p_icbp_uid in number
    );

    -- Prozedur zum Aktualisieren (Update) von BPG_LFD_NR_FK
    procedure update_bpg_lfd_nr_fk (
        p_sic_asy_icl_fk in awh_infocluster_persongrp.sic_asy_icl_fk%type,
        p_bpg_lfd_nr_fk  in varchar2, -- Multivalue LOV als : getrennte Werte
        p_icbp_user      in awh_infocluster_persongrp.icbp_user%type
    );

    procedure update_bpg_lfd_nr_fk1 (
        p_sic_asy_icl_fk in number,
        p_bpg_lfd_nr_fk  in number
    );

   -- Prozedur zum Löschen von BPG_LFD_NR_FK
    procedure delete_bpg_lfd_nr_fk (
        p_sic_asy_icl in awh_main.awh_mtn_sys_icl.sic_asy_icl%type
    );

    procedure insert_gesellschaft (
        p_ges_uid in number,
        p_name    in varchar2,
        p_adresse in varchar2,
        p_email   in varchar2,
        p_tel     in varchar2
    );

    procedure update_gesellschaft (
        p_ges_uid in number,
        p_name    in varchar2,
        p_adresse in varchar2,
        p_email   in varchar2,
        p_tel     in varchar2
    );

    procedure delete_gesellschaft (
        p_ges_uid in number
    );

end pck_dsgvo_anteil;
/


-- sqlcl_snapshot {"hash":"255dbe808e6ff5c25da567898f5ab7af13d661d8","type":"PACKAGE_SPEC","name":"PCK_DSGVO_ANTEIL","schemaName":"AWH_MAIN","sxml":""}