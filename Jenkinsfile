pipeline {
    agent any

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