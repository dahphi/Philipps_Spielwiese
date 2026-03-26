-- liquibase formatted sql
-- changeset RK_MAIN:1774555712433 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/msm_utils.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/msm_utils.sql:null:9b6bc4c41e2ffb6b62741711b1048c6d7a9afd0d:create

create or replace package rk_main.msm_utils as
    function get_ldap_attribute (
        p_attribute in varchar2,
        p_user      in varchar2
    ) return varchar2;

    function html_encode_ger (
        p_string varchar2
    ) return varchar2;

    function is_test_environment return number;

    type ad_group_member_record is record (
            group_distinguishedname varchar2(4000),
            member_samaccountname   varchar2(16)
    );
    type holiday_record is record (
            h_start     date,
            h_end       date,
            h_year      number,
            h_statecode varchar2(2),
            h_name      varchar2(64),
            h_slug      varchar2(128)
    );
    type holiday_table is
        table of holiday_record;
    function holidays_from_string (
        p_holidays varchar2
    ) return holiday_table
        pipelined;

    type vc256_2_record is record (
            val1 varchar2(256),
            val2 varchar2(256)
    );
    type vc256_2_table is
        table of vc256_2_record;
    function all_ad_accounts return vc256_2_table
        pipelined;

/*
procedure datenpumpe_ad_accounts;
*/

end msm_utils;
/

