def projectName            = 'apex-operator'

node {
  properties([
    parameters([
      choice(name: 'OPERATION', choices: ['export', 'import','release'], description: 'Select the operation to perform'),
      string(name: 'TARGET_DATABASE', defaultValue: 'DEV', description: 'Enter a value for the Database'),
      string(name: 'APEX_APP_ID', defaultValue: '101', description: 'Enter a value for the APEX Application ID'),
      string(name: 'VERSION', defaultValue: '1_0', description: 'Enter a value for new Version'),
      string(name: 'BRANCH', defaultValue: 'develop', description: 'Enter a branch name (e.g. main, develop, feature/xyz)')
    ])
  ])
}

def credsMap = [
    'DEV'  : 'DEV',
    'PROD' : 'PROD'
]
def baseDirMap = [
    'DEV'  : 'APEX',
    'PROD' : 'APEX'
]
def dbCredsId = credsMap[params.TARGET_DATABASE.toUpperCase()] ?: 'DBUSER_SCDT_APEXLAB'
def baseDir = baseDirMap[params.TARGET_DATABASE.toUpperCase()] ?: params.TARGET_DATABASE

pipeline {
    agent any

    environment {
        PROJECT                = "${projectName}"
        BUILD_BRANCH           = "${env.BRANCH_NAME}"
        BUILD_TMP_DIR          = "${env.WORKSPACE}/tmp"
        DB_CONN_STR            = "oracle_apex_lb:1521/freepdb1"
        BASE_DIR               = "${baseDir}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out repository..."
                checkout scm
            }
        }
        stage('Pull Project') {
            steps {
                echo "Cloning project repository..."
                sh '''
                if [ -d "Philipps_Spielwiese" ]; then
                    rm -rf Philipps_Spielwiese
                fi
                git clone https://github.com/dahphi/Philipps_Spielwiese.git
                cd Philipps_Spielwiese
                git checkout ${BRANCH}
                git config --global user.email "philipp.dahlem@netcologne.com"
                git config --global user.name "Philipp"
                '''
            }
        }
        stage('Initialize Project') {
            when {
                expression { params.OPERATION == 'export' }
            }
            steps {
                echo "[DEBUG] Initialize Project ..."
                withCredentials([
                    usernamePassword(credentialsId: dbCredsId, usernameVariable: 'DBUSERNAME', passwordVariable: 'DBPASSWORD')
                ]) {sh '''
                    cd Philipps_Spielwiese
                    chmod 0755 ../scripts/shell/p1_initialize_project.sh
                    ../scripts/shell/p1_initialize_project.sh $DBUSERNAME $DBPASSWORD $DB_CONN_STR $APEX_APP_ID
                '''
                }
            }
        }
        stage('process db files') {
            steps {
                echo "Processing files created in previous stage"
                withCredentials([
                    usernamePassword(credentialsId: 'GITHUB_PUSH', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')
                ]) {
                    sh '''
                        cd Philipps_Spielwiese
                        chmod 0755 ./scripts/shell/p0_push_git.sh
                        ./scripts/shell/p0_push_git.sh "Initialize project for APEX App ID ${APEX_APP_ID}"
                    '''
                }
            }
        }
        stage('Export App') {
            when {
                expression { params.OPERATION == 'export' }
            }
            steps {
                echo "[DEBUG] Connect to Database ..."
                withCredentials([
                    usernamePassword(credentialsId: dbCredsId, usernameVariable: 'DBUSERNAME', passwordVariable: 'DBPASSWORD')
                ]) {sh '''
                    env
                    cd Philipps_Spielwiese
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
                withCredentials([
                    usernamePassword(credentialsId: 'GITHUB_PUSH', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')
                ]) {
                    sh '''
                        cd Philipps_Spielwiese
                        ./scripts/shell/p0_push_git.sh "Export APEX App ID ${APEX_APP_ID}"
                    '''
                }
            }
        }
    }
}