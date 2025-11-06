#!/usr/bin/env groovy

@Library('nc-base-lib@main') _

def projectName            = 'mis-apexlab-operator'
def csJenkinsRunnerImage  = 'nexus-docker.netcologne.intern/cubestack/cs-jenkins-runner:0.1.0-main'

node {
  properties([
    parameters([
      choice(name: 'OPERATION', choices: ['export', 'import','release'], description: 'Select the operation to perform'),
      string(name: 'TARGET_DATABASE', defaultValue: 'SCDP', description: 'Enter a value for the Database'),
      string(name: 'APEX_APP_ID', defaultValue: '110', description: 'Enter a value for the APEX Application ID'),
      string(name: 'VERSION', defaultValue: '1_0', description: 'Enter a value for new Version'),
      string(name: 'BRANCH', defaultValue: 'main', description: 'Enter a branch name (e.g. main, develop, feature/xyz)')
    ])
  ])
}

pipeline {
    agent { label 'ncvol7pci2' }            

    options {
        lock(resource: "mis-apexlab-operator-lock")
        buildDiscarder(
            logRotator(numToKeepStr: '5', artifactNumToKeepStr: '3')
        )
    }

    environment {
        PROJECT                = "${projectName}"
        BUILD_BRANCH           = ncGit.normalizeBranchName(env.BRANCH_NAME)
        BUILD_TMP_DIR          = "${env.WORKSPACE}/tmp"
        DB_CONN_STR            = "${params.TARGET_DATABASE}.ora.netcologne.intern/${params.TARGET_DATABASE}.netcologne.intern"
    }

    stages {
        stage('warm up') {
            steps {
                withEnv(["project_name=${projectName}"]){
                    echo "Running \${BUILD_NUMBER} ${env.BUILD_ID} on ${env.JENKINS_URL}"
                    sh '''
                        echo "Hostname: $HOSTNAME"
                        echo id: $(id)
                    '''
                }
            }
        }
        stage('connect db') {
            when {
                expression { params.OPERATION == 'import' }
            }
            agent {
                docker {
                    image 'container-registry.oracle.com/database/sqlcl:25.1.0'
                    label 'ncvol7pci2'
                    args '--entrypoint="" -u root'
                    reuseNode true
                }
            }
            steps {
                echo "[DEBUG] Connect to Database ..."
                withCredentials([
                    usernamePassword(credentialsId: "DBUSER_SCDT_APEXLAB", usernameVariable: 'DBUSERNAME', passwordVariable: 'DBPASSWORD')
                ]) {sh '''
                    echo "Database connection string: $DB_CONN_STR"
                    sql $DBUSERNAME/$DBPASSWORD@//$DB_CONN_STR @scripts/sqls/apexlab.sql
                    cat apexlab.log \
                        | egrep -vi "(errors:\\s*0|warnings:\\s*0)" \
                        | egrep -i "(ora-|warn|err|pls-)" | cat
                    cat apexlab.log \
                        | egrep -vi "(errors:\\s*0|warnings:\\s*0)" \
                        | egrep -ci "(ora-|warn|err|pls-)" \
                        | egrep -q '^0$' || { 
                            find . -user root | xargs -iXX chown 990016:990016 XX
                            exit 200
                        }
                    echo "done check deploy log"
                    find . -user root | xargs -iXX chown 990016:990016 XX
                   '''
               }
            }
        }
        stage('Pull Project') {
            when {
                expression { params.OPERATION == 'export' }
            }
            steps {
                echo "Cloning project repository..."
                sh '''
                if [ -d "mis-apexlab-core" ]; then
                    sudo rm -rf mis-apexlab-core
                fi
                git clone https://bitbucket.netcologne.intern/scm/mis/mis-apexlab-core.git
                cd mis-apexlab-core
                git checkout ${BRANCH}
                '''
            }
        }
        stage('Initialize Project') {
            when {
                expression { params.OPERATION == 'export' }
            }
            agent {
                docker {
                    image 'container-registry.oracle.com/database/sqlcl:25.1.0'
                    label 'ncvol7pci2'
                    args '--entrypoint="" -u root'
                    reuseNode true
                }
            }
            steps {
                echo "[DEBUG] Initialize Project ..."
                withCredentials([
                    usernamePassword(credentialsId: "DBUSER_SCDT_APEXLAB", usernameVariable: 'DBUSERNAME', passwordVariable: 'DBPASSWORD')
                ]) {sh '''
                    cd mis-apexlab-core
                    find . -name "history.log" | xargs -iXX rm -v XX
                    chmod 0755 ../scripts/shell/p1_initialize_project.sh
                    ../scripts/shell/p1_initialize_project.sh $DBUSERNAME $DBPASSWORD $DB_CONN_STR $APEX_APP_ID
                '''
                }
            }
        }
        stage('process db files') {
            steps {
                catchError(buildResult: 'UNSTABLE', stageResult: 'UNSTABLE') {
                echo "Processing files created in previous stage"
                sh '''
                    cd mis-apexlab-core
                    git checkout ${BRANCH}
                    git add .
                    git commit -a -m "Initialize project for APEX App ID ${APEX_APP_ID}"
                    git push
                    git status
                '''
                }
            }
        }
        stage('Export App') {
            when {
                expression { params.OPERATION == 'export' }
            }
            agent {
                docker {
                    image 'container-registry.oracle.com/database/sqlcl:25.1.0'
                    label 'ncvol7pci2'
                    args '--entrypoint="" -u root'
                    reuseNode true
                }
            }
            steps {
                echo "[DEBUG] Connect to Database ..."
                withCredentials([
                    usernamePassword(credentialsId: "DBUSER_SCDT_APEXLAB", usernameVariable: 'DBUSERNAME', passwordVariable: 'DBPASSWORD')
                ]) {sh '''
                    env
                    cd mis-apexlab-core
                    ../scripts/shell/p1_export_apex_app.sh $DBUSERNAME $DBPASSWORD $DB_CONN_STR ${APEX_APP_ID}
                    find . -user root | xargs -iXX chown 990016:990016 XX
                   '''
               }
            }
        }
        stage('process exported files') {
            when {
                expression { params.OPERATION == 'export' }
            }
            steps {
                echo "Processing files created in previous stage"
                sh '''
                    find . -type f
                    git --version
                    cd mis-apexlab-core
                    git checkout ${BRANCH}
                    # process apexlab.log or other files here
                    git add .
                    git commit -a -m "Export APEX App ID ${APEX_APP_ID}"
                    git push
                '''
            }
        }
        stage('Stage Project') {
            when {
                expression { params.OPERATION == 'release' }
            }
            agent {
                docker {
                    image 'container-registry.oracle.com/database/sqlcl:25.1.0'
                    label 'ncvol7pci2'
                    args '--entrypoint="" -u root'
                    reuseNode true
                }
            }
            steps {
                echo "[DEBUG] Connect to Database ..."
                withCredentials([
                    usernamePassword(credentialsId: "DBUSER_SCDT_APEXLAB", usernameVariable: 'DBUSERNAME', passwordVariable: 'DBPASSWORD')
                ]) {sh '''
                    env
                    cd mis-apexlab-core
                    chmod 0755 ../scripts/shell/p2_stage.sh
                    ../scripts/shell/p2_stage.sh $DBUSERNAME $DBPASSWORD $DB_CONN_STR ${APEX_APP_ID}
                    find . -user root | xargs -iXX chown 990016:990016 XX
                   '''
               }
            }
        }
        stage('process staged files') {
            when {
                expression { params.OPERATION == 'release' }
            }
            steps {
                echo "Processing files created in previous stage"
                sh '''
                    find . -type f
                    git --version
                    cd mis-apexlab-core
                    git checkout ${BRANCH}
                    # process apexlab.log or other files here
                    git add .
                    git commit -a -m "staging Apexfiles for App ID ${APEX_APP_ID}"
                    git push
                '''
            }
        }
        stage('release Version') {
            when {
                expression { params.OPERATION == 'release' }
            }
            agent {
                docker {
                    image 'container-registry.oracle.com/database/sqlcl:25.1.0'
                    label 'ncvol7pci2'
                    args '--entrypoint="" -u root'
                    reuseNode true
                }
            }
            steps {
                echo "[DEBUG] Connect to Database ..."
                withCredentials([
                    usernamePassword(credentialsId: "DBUSER_SCDT_APEXLAB", usernameVariable: 'DBUSERNAME', passwordVariable: 'DBPASSWORD')
                ]) {sh '''
                    env
                    cd mis-apexlab-core
                    chmod 0755 ../scripts/shell/p2_release_version.sh
                    ../scripts/shell/p2_release_version.sh $DBUSERNAME $DBPASSWORD $DB_CONN_STR ${APEX_APP_ID} ${VERSION}
                    find . -user root | xargs -iXX chown 990016:990016 XX
                   '''
               }
            }
        }
        stage('process released files') {
            when {
                expression { params.OPERATION == 'release' }
            }
            steps {
                echo "Processing files created in previous stage"
                sh '''
                    find . -type f
                    git --version
                    cd mis-apexlab-core
                    git checkout ${BRANCH}
                    # process apexlab.log or other files here
                    git add .
                    git commit -a -m "Releasing Version ${VERSION} for App ID ${APEX_APP_ID}"
                    git push
                '''
            }
        }
        stage('import release') {
            when {
                expression { params.OPERATION == 'import' }
            }
            agent {
                docker {
                    image 'container-registry.oracle.com/database/sqlcl:25.1.0'
                    label 'ncvol7pci2'
                    args '--entrypoint="" -u root'
                    reuseNode true
                }
            }
            steps {
                echo "Importing Application"
                withCredentials([
                    usernamePassword(credentialsId: "DBUSER_SCDT_APEXLAB", usernameVariable: 'DBUSERNAME', passwordVariable: 'DBPASSWORD')
                ]) {sh '''
                    chmod 0755 scripts/shell/p3_import_apex_application.sh
                    ./scripts/shell/p3_import_apex_application.sh $DBUSERNAME $DBPASSWORD $DB_CONN_STR $VERSION
                '''
                }
            }
        }
    }
}