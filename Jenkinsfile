pipeline {
  agent any

  stages {
    stage('Build image') {
      steps {
        sh '''
          printf '{\n    "experimental": true\n}' \
          | sudo tee /etc/docker/daemon.json >/dev/null
          sudo systemctl restart docker
          sleep 10
        '''
        sh 'cd tests && ./ci.sh -b -c restart'
      }

    }

    stage('Run image') {
      steps {
        sh 'cd tests && ./ci.sh -r'
      }
    }
  }
