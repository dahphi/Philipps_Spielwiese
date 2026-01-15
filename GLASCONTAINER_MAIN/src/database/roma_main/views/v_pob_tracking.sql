create or replace force editionable view v_pob_tracking (
    id,
    datum,
    app_page_id,
    app_session,
    task,
    scope,
    vkz,
    task_vkz,
    request,
    task_request,
    kundenstatus,
    first_kundenstatus,
    last_kundenstatus,
    dubletten_sie,
    last_dubletten_sie,
    dubletten_pob,
    last_dubletten_pob,
    kundendaten,
    last_kundendaten
) as
    select
        t.id,
        t.datum,
        t.app_page_id,
        t.app_session,
        t.task,
        to_number(t.scope default null on conversion error) as scope -- Die Nummer des Wizard-Steps von 1..7 sowie 99..100       
       -- VKZ:
        ,
        e.vkz -- nur gefüllt, wenn track_page das VKZ im piv_extra mitgibt
        ,
        max(e.vkz)
        over(partition by task)                             as task_vkz -- es genügt daher, wenn 1x pro Task die VKZ Angabe gemacht wird
       -- REQUEST:
        ,
        upper(t.request)                                    as request -- nur gefüllt, wenn die jeweilige Seite mit einem Request aufgerufen wird
       -- Beim Aufruf aus SIEBEL ist das VKZ noch nicht gefüllt, daher ermitteln wir hier im Nachhinein das VKZ 
       -- auch für den ersten Seitenaufruf. Dieser muss bei der Auswertung der Statistik anstelle t.request abgefragt werden:
        ,
        case
            when t.task is not null then
                upper(max(t.request)
                      over(partition by task))
        end                                                 as task_request
       --
        ,
        e.kundenstatus,
        first_value(e.kundenstatus ignore nulls)
        over(partition by t.task
             order by
                 t.id
            rows between unbounded preceding and unbounded following
        )                                                   as first_kundenstatus,
        last_value(e.kundenstatus)
        over(partition by t.task
             order by
                 t.id
            rows between unbounded preceding and unbounded following
        )                                                   as last_kundenstatus,
        e.dubletten_sie,
        last_value(e.dubletten_sie)
        over(partition by t.task
             order by
                 t.id
            rows between unbounded preceding and unbounded following
        )                                                   as last_dubletten_sie,
        e.dubletten_pob,
        last_value(e.dubletten_pob)
        over(partition by t.task
             order by
                 t.id
            rows between unbounded preceding and unbounded following
        )                                                   as last_dubletten_pob,
        e.kundendaten,
        last_value(e.kundendaten)
        over(partition by t.task
             order by
                 t.id
            rows between unbounded preceding and unbounded following
        )                                                   as last_kundendaten
    from
        pob_tracking       t
        left join pob_tracking_extra e on ( e.id = t.id )
    where
        request != 'SIEBEL GK';


-- sqlcl_snapshot {"hash":"a7dd7f850971537700f2e46672c7d92b399efd41","type":"VIEW","name":"V_POB_TRACKING","schemaName":"ROMA_MAIN","sxml":""}