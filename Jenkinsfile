pipeline {
    agent any

    tools {
        maven 'Maven-Homebrew' // The name you configured in Jenkins
    }

    environment {
        APP_ENV = "production"
        PATH = "/usr/local/bin:${env.PATH}"
        DOCKER_IMAGE = "cognix-app"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "📥 Checking out the code..."
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
                    echo "🧪 Publishing test results..."
                    junit '**/target/surefire-reports/*.xml'
                }
                failure {
                    echo "❌ Maven build or tests failed — skipping Docker image creation."
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
                echo "🐳 Building Docker image..."
                sh """
                    docker build --pull --no-cache -t ${DOCKER_IMAGE}:latest .
                """

                script {
                    def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    sh "docker tag ${DOCKER_IMAGE}:latest ${DOCKER_IMAGE}:${commitSha}"
                    env.DOCKER_TAG = commitSha
                }

                echo "✅ Docker image built successfully with tag: ${env.DOCKER_TAG}"
            }
        }

        stage('Verify Image Works') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                echo "🔍 Verifying Docker image..."
                sh "docker run --rm ${DOCKER_IMAGE}:latest sh -c 'java -version'"
            }
        }
    }

    stage('Push Docker image to ECR') {
            steps {
                echo "📤 Pushing image to ECR..."
                sh """
                    aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 463470986386.dkr.ecr.eu-north-1.amazonaws.com
                    docker push ${DOCKER_IMAGE}:${env.DOCKER_TAG}
                """
            }
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
