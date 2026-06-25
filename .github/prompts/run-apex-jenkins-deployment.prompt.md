---
mode: "agent"
description: "Run Jenkins APEX deployment pipeline with Export, Release, and Import in sequence"
---

Run the Jenkins pipeline:

- `https://jenkins.netcologne.intern/view/MISC/job/MISC-BUILD/job/mis-apexlab-operator/job/main/`

Use these inputs:

1. `Apex_APP_ID`
2. `Target_Databaase` for Export/Release
3. `Target_Databaase` (import target) for Import
4. `Version`
5. `branch` (default `develop`)

Execution order is mandatory and sequential:

1. `OPERATION=Export`
2. `OPERATION=Release`
3. `OPERATION=Import`

Wait for each run to complete before starting the next one.
Return build URL and status for each stage.
