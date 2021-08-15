pipeline {
    agent any
    stages {
        stage ('build socmed') {
            steps {
                sh '''
                    printenv
                    sudo docker build -t cilsyari/cilsy:socmed-$BUILD_ID -f socmed/ops/socmed.Dockerfile socmed/.
                    sudo docker login -u cilsyari -p$DOCKER_TOKEN
                    sudo docker push cilsyari/cilsy:socmed-$BUILD_ID
                '''
            }
        }
    }
}
