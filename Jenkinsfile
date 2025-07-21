pipeline {
    agent {
        docker {
            reuseNode 'true'
            image 'mingc/android-build-box:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker'
        }
    }
    stages {
        stage('checkout') {
            steps {
                checkout scm
            }
        }

        stage('build') {
            steps {
                sh 'flutter pub get'
                sh 'flutter build apk --release --target-platform=android-arm64'
                sh 'flutter build web --base-href /web/'
            }
        }

        stage('deployWeb') {
            steps {
                script {
                    imageName = "one-zero-sky-success-docker.pkg.coding.net/${env.DEPOT_NAME}/docker/${env.DEPOT_NAME}:${env.GIT_COMMIT}"
                    docker.build(imageName)
                    docker.withRegistry("https://one-zero-sky-success-docker.pkg.coding.net", CODING_ARTIFACTS_CREDENTIALS_ID) {
                        docker.image(imageName).push()
                    }
                }
            }
        }

        stage('deployApk') {
            steps {
                sh 'curl -F "file=@build/app/outputs/apk/app.apk" -F "uKey=dc20f84f14da682859d70787907cc9c2" -F "_api_key=a3b05d978e859d327713c8354e02b024" https://qiniu-storage.pgyer.com/apiv1/app/upload'
                archiveArtifacts artifacts: 'build/app/outputs/apk/*.apk', fingerprint: true // 收集构建产物
            }
        }
    }
}