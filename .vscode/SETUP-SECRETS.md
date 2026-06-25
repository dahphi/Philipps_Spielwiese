# User settings setup

This repository is configured to use VS Code User Settings only for Confluence/Jira/Jenkins configuration.

## Scope

- Configure tokens and defaults in VS Code User Settings, not in workspace files.
- Do not store API tokens in repository files.

## Open User Settings JSON

1. Open Command Palette.
2. Run: Preferences: Open User Settings (JSON)

## Required keys

Add or update these keys in User Settings:

- confluence.api.baseUrl
- confluence.api.authType
- confluence.api.token
- jira.api.baseUrl
- jira.api.authType
- jira.api.token
- jira.defaults.projectKey
- jira.defaults.projectId
- jira.defaults.componentName
- jira.defaults.componentId
- jenkins.api.baseUrl
- jenkins.api.token
- jenkins.defaults.pipelineUrl
- jenkins.defaults.pipelinePath
- jenkins.defaults.branch
- jenkins.defaults.paramNames.targetDatabase
- jenkins.defaults.paramNames.appId
- jenkins.defaults.paramNames.operation
- jenkins.defaults.paramNames.version
- confluence.defaults.spaceKey
- confluence.defaults.meetingNotesParentId
- confluence.defaults.templatePageId

After saving User Settings, reload the VS Code window.
