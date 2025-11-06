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
                    sql apex_export_user/tiger@//localhost:8522/8522 <<EOF
                    SELECT 'Connected to DB' FROM dual;
                    EXIT;
                    EOF
                '''
            }
        }
    }
}