-- liquibase formatted sql
-- changeset DEMO:b6b5b2431d22c362a005cc3da0e674f13306d5d0 stripComments:false logicalFilePath:Development/demo/table/test.sql
-- sqlcl_snapshot src/database/demo/tables/test.sql:null:b6b5b2431d22c362a005cc3da0e674f13306d5d0:create

create table demo.test (
    test_1 number,
    test_2 number
);