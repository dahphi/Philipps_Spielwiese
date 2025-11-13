def projectName            = 'apex-operator'

node {
  properties([
    parameters([
      choice(name: 'OPERATION', choices: ['export', 'import','release'], description: 'Select the operation to perform'),
      string(name: 'TARGET_DATABASE', defaultValue: 'DEV', description: 'Enter a value for the Database'),
      string(name: 'APEX_APP_ID', defaultValue: '110', description: 'Enter a value for the APEX Application ID'),
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
        BUILD_BRANCH           = env.BRANCH_NAME
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
        stage('Show Latest Commit') {
            steps {
                sh 'git log -1'
            }
        }
        stage('Connect to DB') {
            steps {
                echo "Connecting to Oracle DB..."
                sh '''
                    sql apex_export_user/tiger@oracle_apex_lb:1521/freepdb1 <<EOF
                    SELECT 'Connected to DB' FROM dual;
                    EXIT;
                    EOF
                '''
            }
        }
    }
}