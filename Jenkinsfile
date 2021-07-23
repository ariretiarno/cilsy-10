pipeline {
    agent any
    stages {
        stage('preparation') {
            steps {
                sh 'sudo usermod -a -G docker ubuntu'
            }
        }
        stage('build') {
            agent { docker { image 'maven:3.3.3' } }
            steps {
                sh 'mvn --version'
            }
        }
    }
}