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
        stage ('deploy to k8s') {
            steps ('change image tag') {
                sh '''
                    sed -i -e "s/appversion/$BUILD_ID/" kube/landing.yml
                    sed -i -e "s/appversion/$BUILD_ID/" kube/socmed.yml
                '''
            }
            steps ('landing') {
                script {
                    kubernetesDeploy(configs: "kube/landing.yml", kubeconfigId: "kube-ari")
                }
            }
            steps ('socmed') {
                script {
                    kubernetesDeploy(configs: "kube/socmed.yml", kubeconfigId: "kube-ari")
                }
            }
        }
    }
}
