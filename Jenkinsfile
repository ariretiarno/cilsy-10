pipeline {
    agent any
    stages {
        stage ('build socmed') {
            steps {
                sh '''
                    sudo docker build -t cilsyari/cilsy:socmed-$BUILD_ID -f socmed/ops/socmed.Dockerfile socmed/.
                    sudo docker login -u cilsyari -p$DOCKER_TOKEN
                    sudo docker push cilsyari/cilsy:socmed-$BUILD_ID
                '''
            }
        }
        stage ('build landingpage') {
            steps {
                sh '''
                    sudo docker build -t cilsyari/cilsy:landingpage-$BUILD_ID -f landingpage/landingpage.Dockerfile .
                    sudo docker login -u cilsyari -p$DOCKER_TOKEN
                    sudo docker push cilsyari/cilsy:landingpage-$BUILD_ID
                '''
            }
        }
    }
}
