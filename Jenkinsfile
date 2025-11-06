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
    }
}