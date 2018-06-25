node {
   stage('Build') {
      checkout scm
      sh 'ls -la'
      def image = docker.build("apavlov123/test-nginx")
      docker.withRegistry("https://index.docker.io/v1/", 'docker-hub'){
         image.push('latest')
      }
   }
   stage('Deploy') {
      docker.withServer('tcp://172.31.2.216:4243') {
            sh returnStatus: true, script: 'docker stop test-nginx'
            sh returnStatus: true, script: 'docker rm test-nginx'
            sh 'docker run -d --name test-nginx -p 80:80 apavlov123/test-nginx:latest'
      }
   }
}
