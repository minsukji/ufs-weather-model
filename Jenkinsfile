pipeline {
  agent any

  stages {
    stage('Build image') {
      steps {
        sh 'cd tests && ./ci.sh -b -c restart'
      }

    }

    stage('Run image') {
      steps {
        sh 'cd tests && ./ci.sh -r'
      }
    }
  }
}
