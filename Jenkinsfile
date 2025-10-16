pipeline {
    agent any
    stages {
        stage('Build & Test in Docker') {
            steps {
                script {
                    // Build Docker image for Maven build
                    sh 'docker build -t cognix-build -f Dockerfile.build .'

                    // Run Maven inside Docker and mount a volume for test reports
                    sh '''
                        docker run --rm \
                        -v $PWD/target:/app/target \
                        cognix-build \
                        mvn clean test
                    '''
                }
            }
        }

        stage('Collect Test Results') {
            steps {
                // Jenkins looks for XML reports in target/surefire-reports
                junit 'target/surefire-reports/*.xml'
            }
        }

        stage('Build App Image') {
            steps {
                sh 'docker build -t cognix-app -f Dockerfile .'
            }
        }

        stage('Tag Image') {
            steps {
                script {
                    def shortHash = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    sh "docker tag cognix-app:latest cognix-app:${shortHash}"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up dangling images..."
            sh 'docker image prune -f'
        }
        success {
            echo "Build and tests succeeded!"
        }
        failure {
            echo "Check logs for errors or missing test reports!"
        }
    }
}
