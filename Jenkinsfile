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

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image and running Maven tests inside..."
                sh """
                    /usr/local/bin/docker build --pull --no-cache -t ${DOCKER_IMAGE}:latest .
                """
                script {
                    def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    sh "/usr/local/bin/docker tag ${DOCKER_IMAGE}:latest ${DOCKER_IMAGE}:${commitSha}"
                    env.DOCKER_TAG = commitSha
                }
            }
        }

        stage('Run Tests (from build reports)') {
            steps {
                echo "🧪 Collecting test results from build..."
                junit '**/target/surefire-reports/*.xml'
            }
        }

        stage('Verify Image Works') {
            steps {
                echo "✅ Verifying the image starts and exits properly..."
                sh """
                    /usr/local/bin/docker run --rm ${DOCKER_IMAGE}:latest sh -c "java -version"
                """
            }
        }

    }

    post {
        success {
            echo "🎉 Pipeline completed successfully — image built and tested locally!"
        }
        failure {
            echo "❌ Build or tests failed. Check the logs."
        }
        always {
            echo "🧹 Cleaning up dangling images..."
            sh 'docker image prune -f || true'
        }
    }
}
