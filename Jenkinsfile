pipeline {
    agent any
    stages {
        stage ('build socmed') {
            steps {
                sh '''
                    sudo docker build -t ariretiarno/cilsy:socmed-$BUILD_ID -f socmed/ops/socmed.Dockerfile socmed/.
                '''
            }
        }
    }
}
