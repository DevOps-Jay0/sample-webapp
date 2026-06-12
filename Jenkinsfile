pipeline {
    agent any

    environment {
        IMAGE_NAME = "devopsjay0/sample-webapp"
        IMAGE_TAG  = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/DevOps-Jay0/sample-webapp.git'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build \
                -t ${IMAGE_NAME}:${IMAGE_TAG} \
                -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {

                    sh '''
                    echo "$DOCKER_PASS" | docker login \
                    -u "$DOCKER_USER" \
                    --password-stdin

                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    docker push ${IMAGE_NAME}:latest

                    docker logout
                    '''
                }
            }
        }

        stage('Deploy to Docker Server') {
            steps {

                sh '''
                ssh ec2-user@52.88.200.182"

                    docker pull ${IMAGE_NAME}:latest &&

                    docker stop sample-webapp || true &&
                    docker rm sample-webapp || true &&

                    docker run -d \
                        --name sample-webapp \
                        -p 8080:8080 \
                        ${IMAGE_NAME}:latest
                "
                '''
            }
        }
    }
}
