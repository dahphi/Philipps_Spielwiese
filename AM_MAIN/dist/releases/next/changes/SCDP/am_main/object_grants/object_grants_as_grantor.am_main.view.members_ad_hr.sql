-- liquibase formatted sql
-- changeset AM_MAIN:1774557116099 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.view.members_ad_hr.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.view.members_ad_hr.sql:null:acd4a2c066a935a19c00320469203cdc7cf2eacf:create

grant select on am_main.members_ad_hr to am_apex;

grant read on am_main.members_ad_hr to am_apex;

grant read on am_main.members_ad_hr to awh_read_jira;

