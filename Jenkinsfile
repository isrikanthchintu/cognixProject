pipeline {
    agent any

    tools {
        maven 'Maven-Homebrew' // The name you configured in Jenkins
    }

    environment {
        APP_ENV = "production"
        PATH = "/usr/local/bin:${env.PATH}"
        DOCKER_IMAGE = "cognix-app"
        AWS_REGION = 'eu-north-1'
        AWS_ACCOUNT_ID = '463470986386'
        ECR_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${DOCKER_IMAGE}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out the code..."
                git branch: 'main',
                    url: 'https://github.com/isrikanthchintu/cognixProject.git',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build and Test with Maven') {
            steps {
                echo "🛠️ Running Maven build and tests..."
                sh 'mvn clean verify'
            }

            post {
                always {
                    echo " Publishing test results..."
                    junit '**/target/surefire-reports/*.xml'
                }
                failure {
                    echo " Maven build or tests failed — skipping Docker image creation."
                }
            }
        }

        stage('Build Docker Image') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                echo "Building Docker image..."
                sh """
                    docker build --pull --no-cache -t ${DOCKER_IMAGE}:latest .
                """

                script {
                    def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    sh "docker tag ${DOCKER_IMAGE}:latest ${DOCKER_IMAGE}:${commitSha}"
                    env.DOCKER_TAG = commitSha
                }

                echo " Docker image built successfully with tag: ${env.DOCKER_TAG}"
            }
        }

        stage('Verify Image Works') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                echo " Verifying Docker image..."
                sh "docker run --rm ${DOCKER_IMAGE}:latest sh -c 'java -version'"
            }
        }

        // stage('Push Docker image to ECR') {
        //     steps {
        //         echo " Pushing image to ECR..."
        //         script {
        //             sh """
        //                 echo "🔹 Logging into AWS ECR..."
        //                 aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
        
        //                 echo "🔹 Tagging image..."
        //                 docker tag ${DOCKER_IMAGE}:${env.DOCKER_TAG} ${ECR_REPO}:${env.DOCKER_TAG}
        //                 docker tag ${DOCKER_IMAGE}:${env.DOCKER_TAG} ${ECR_REPO}:latest
        
        //                 echo " Pushing image to ECR..."
        //                 docker push ${ECR_REPO}:${env.DOCKER_TAG}
        //                 docker push ${ECR_REPO}:latest
        //             """
        //         }
        //     }
        // }
    }

    

    post {
        success {
            echo "🎉 Pipeline completed successfully — image built and verified!"
        }
        failure {
            echo "❌ Build or tests failed. Docker image was not created."
        }
        always {
            echo "🧹 Cleaning up dangling images..."
            sh 'docker image prune -f || true'
        }
    }
}
