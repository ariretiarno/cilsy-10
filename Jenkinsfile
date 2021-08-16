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
        stage ('change manifest file and send') {
            steps {
                sh '''
                    sed -i -e "s/appversion/$BUILD_ID/" kube/landing.yml
                    sed -i -e "s/appversion/$BUILD_ID/" kube/socmed.yml
                    tar -czvf manifest.tar.gz kube/landing.yml kube/socmed.yml

                '''
                sshPublisher(
                    continueOnError: false, 
                    failOnError: true,
                    publishers: [
                        sshPublisherDesc(
                            configName: "k8s-master",
                            transfers: [sshTransfer(sourceFiles: 'manifest.tar.gz', remoteDirectory: 'jenkins/')],
                            verbose: true
                        )
                    ]
                )
            }
        }
        stage ('deploy to k8s cluster') {
            steps {
                sshagent(credentials : ['jenkins-deploy-vunite']){
                    sh 'ssh -o StrictHostKeyChecking=no ubuntu@api.kubernetes.retiarno.my.id touch /home/ubuntu/masuk'
                }
            }
        }
        /*stage ('deploy to k8s') {
            steps {
                sh '''
                    sed -i -e "s/appversion/$BUILD_ID/" kube/landing.yml
                    sed -i -e "s/appversion/$BUILD_ID/" kube/socmed.yml
                    cat kube/landing.yml && cat kube/socmed.yml
                '''
                script {
                    kubernetesDeploy(kubeconfigId: 'kube-ari', configs: 'landing.yml' )
                }
                script {
                    kubernetesDeploy(configs: "kube/socmed.yml", kubeconfigId: "kube-ari")
                }
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
        }*/
    }
}
