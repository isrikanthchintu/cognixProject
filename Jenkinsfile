pipeline {
    agent any

    environment {
        APP_ENV = "production"
    }

    stages {

        stage('Checkout') {
            steps {
                // Pull code from GitHub
                git branch: 'main',
                    url: 'https://github.com/isrikanthchintu/cognixProject.git',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the application...'
                // Maven clean and package
                sh './mvnw clean package'
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests...'
                // Maven test
                sh './mvnw test'
            }
            post {
                always {
                    // If you use Surefire or JUnit reports
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying to ${env.APP_ENV} environment..."
                // Example: copy JAR to server
                sh 'scp target/*.jar user@server:/path/to/deploy/'
                // Or run locally: sh 'java -jar target/*.jar &'
            }
        }
    }

    post {
        success {
            echo '✅ Build, Test and Deployment completed successfully!'
        }
        failure {
            echo '❌ Build failed. Check logs in Jenkins.'
        }
    }
}
