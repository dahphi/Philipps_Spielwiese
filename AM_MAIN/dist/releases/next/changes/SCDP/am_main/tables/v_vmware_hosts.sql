-- liquibase formatted sql
-- changeset AM_MAIN:1774557122012 stripComments:false logicalFilePath:SCDP/am_main/tables/v_vmware_hosts.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/v_vmware_hosts.sql:null:c1e4bb5bb27e3f6d030821dbb6c3e94b3f6a2ae0:create

create table am_main.v_vmware_hosts (
    ts          date,
    name        varchar2(4000 byte),
    vm          varchar2(4000 byte),
    uuid        varchar2(4000 byte),
    vmcluster   varchar2(4000 byte),
    options     varchar2(4000 byte),
    block       varchar2(4000 byte),
    host        varchar2(4000 byte),
    numcpu      varchar2(4000 byte),
    numcpucores varchar2(4000 byte),
    cpumhz      varchar2(4000 byte)
)
no inmemory;

