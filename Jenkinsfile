pipeline {
  agent any
  stages {
    stage('Docker Build') {
      steps {
        sh "ls"
        sh "docker build -t nishit2408/wordpress:${env.BUILD_NUMBER} ."
      }
    }
}
}