pipeline {
    agent any

    environment {
        APP_ENV = "production"
        PATH = "/usr/local/bin:${env.PATH}" // Ensure docker is in PATH
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
                // Run the Maven build (this will fail the pipeline if build or tests fail)
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
                    // Only run if previous stages succeeded
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                echo "🐳 Building Docker image..."
                sh """
                    /usr/local/bin/docker build --pull --no-cache -t ${DOCKER_IMAGE}:latest .
                """

                script {
                    def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    sh "/usr/local/bin/docker tag ${DOCKER_IMAGE}:latest ${DOCKER_IMAGE}:${commitSha}"
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
                sh """
                    /usr/local/bin/docker run --rm ${DOCKER_IMAGE}:latest sh -c "java -version"
                """
            }
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
