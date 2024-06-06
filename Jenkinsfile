pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'dockerartisan/my-django-app'
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials-id'
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig-credentials-id'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/ab-hakim-ayman/DevOps.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_HUB_REPO}:${env.BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withKubeConfig([credentialsId: KUBECONFIG_CREDENTIALS_ID]) {
                        sh 'kubectl apply -f k8s/k8s-deployment.yaml'
                        sh 'kubectl apply -f k8s/k8s-service.yaml'
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
