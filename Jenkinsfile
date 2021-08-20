pipeline {
    agent any
    stages {
        stage ('build socmed') {
            agent {
                kubernetes {
                    label 'jenkinsrun'
                    defaultContainer 'builder'
                    yaml """
                        apiVersion: v1
                        kind: Pod
                        metadata:
                          name: kaniko
                        spec:
                          containers:
                          - name: builder
                            image: gcr.io/kaniko-project/executor:latest
                            imagePullPolicy: Always
                            tty: true
                            volumeMounts:
                              - name: docker-config
                                mountPath: /kaniko/.docker/
                          restartPolicy: Never
                          volumes:
                            - name: docker-config
                              secret:
                              secretName: regcred
                              items:
                               - key: .dockerconfigjson
                                 path: config.json
                            
                    """
                }
            }
            steps {
                script {
                    sh "/kaniko/executor --dockerfile=socmed/ops/socmed.Dockerfile --context=dir://socmed/. --destination=cilsyari/socmed:$GIT_BRANCH-$BUILD_ID"
                }
            }
        }
        stage ('build landingpage') {
            steps {
                sh '''
                    sudo docker build -t cilsyari/landingpage:$GIT_BRANCH-$BUILD_ID -f landingpage/landingpage.Dockerfile .
                    sudo docker login -u cilsyari -p$DOCKER_TOKEN
                    sudo docker push cilsyari/landingpage:$GIT_BRANCH-$BUILD_ID
                '''
            }
        }
        stage ('change manifest file and send') {
            steps {
                sh '''
                    sed -i -e "s/branch/$GIT_BRANCH/" kube/landing.yml
                    sed -i -e "s/branch/$GIT_BRANCH/" kube/socmed.yml
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
                sshagent(credentials : ['k8s-master-ari']){
                    sh 'ssh -o StrictHostKeyChecking=no ubuntu@api.kubernetes.retiarno.my.id tar -xvzf jenkins/manifest.tar.gz'
                    sh 'ssh -o StrictHostKeyChecking=no ubuntu@api.kubernetes.retiarno.my.id kubectl apply -f kube'
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