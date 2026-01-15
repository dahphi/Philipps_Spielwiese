-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991296 stripComments:false logicalFilePath:develop/roma_main/tables/ftth_webservice_aufrufe.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/tables/ftth_webservice_aufrufe.sql:null:9f3125c73e99cf2d22f08814d17cc6252fe2fb3f:create

create table roma_main.ftth_webservice_aufrufe (
    id                  number
        generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 start with 1 nocache noorder nocycle
        nokeep noscale
    not null enable,
    uhrzeit             timestamp(6) default systimestamp,
    application         varchar2(30 byte),
    scope               varchar2(100 byte),
    request_url         varchar2(1000 byte),
    method              varchar2(6 byte),
    parameters          varchar2(4000 byte),
    parameter_values    varchar2(4000 byte),
    body                varchar2(4000 byte),
    response_statuscode varchar2(6 byte),
    app_user            varchar2(30 byte),
    testmodus           varchar2(4 byte),
    errormessage        varchar2(255 byte),
    response_body       varchar2(4000 byte)
);

