-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991172 stripComments:false logicalFilePath:develop/roma_main/sequences/gc_task_seq.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/sequences/gc_task_seq.sql:null:d1c9b04f89265fc946fe96e21a43d9d8bcb92a8d:create

create sequence roma_main.gc_task_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 start with 2545 nocache noorder
nocycle nokeep noscale global;

