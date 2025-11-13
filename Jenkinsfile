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
                    sudo rm -rf Philipps_Spielwiese
                fi
                git clone https://github.com/dahphi/Philipps_Spielwiese.git
                cd philipps_spielwiese
                git checkout ${BRANCH}
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
                    find . -name "history.log" | xargs -iXX rm -v XX
                    chmod 0755 ../scripts/shell/p1_initialize_project.sh
                    ../scripts/shell/p1_initialize_project.sh $DBUSERNAME $DBPASSWORD $DB_CONN_STR $BASE_DIR $APEX_APP_ID
                '''
                }
            }
        }
        stage('process db files') {
            steps {
                echo "Processing files created in previous stage"
                sh '''
                    cd Philipps_Spielwiese
                    git checkout ${BRANCH}
                    if [ -n "$(git status --porcelain)" ]; then
                        echo "Changes detected. Committing."
                        git add .
                        git commit -m "Initialize project for APEX App ID ${APEX_APP_ID}"
                        git push
                    else
                        echo "No changes detected. Skipping commit."
                    fi
                    git status
                '''
            }
        }
        stage('Connect to DB') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: dbCredsId, usernameVariable: 'DBUSERNAME', passwordVariable: 'DBPASSWORD')
                ]) {
                echo "Connecting to Oracle DB..."
                sh '''
                    sql $DBUSERNAME/$DBPASSWORD@//$DB_CONN_STR <<EOF
                    SELECT 'Connected to DB' FROM dual;
                    EXIT;
                    EOF
                '''
                }
            }
        }
    }
}