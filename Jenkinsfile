pipeline {
    
    agent any
    
    tools {
        maven "MAVEN"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: '2015f835-5756-4d8f-86c2-c468cc526883', url: 'https://github.com/aryandvn/New.git']])
                echo "Checked Out the Repository."
            }
        }
        stage('Static Testing') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    withSonarQubeEnv('sq1') {
                    sh """mvn clean verify sonar:sonar -Dsonar.projectKey=test -Dsonar.host.url=http://10.12.124.93:9000 -Dsonar.login=sqp_b10c735aa24cd6c8d9198164501ee1a05b12ced7"""
                    echo "Testing was a success."
                    }
                }
            }
        }
        stage('Build') {
            steps {
                sh "mvn clean package"
                echo "Building Package"
            }
        }
        stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: 'nexus3',
                            protocol: 'http',
                            nexusUrl: '10.12.124.93:8081',
                            groupId: 'pom.com.mycompany.app',
                            version: 'pom.1.0-SNAPSHOT',
                            repository: 'test',
                            credentialsId: 'NEXUS',
                            artifacts: [
                                [artifactId: 'pom.my-app',
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: 'pom.my-app',
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
        }
        stage('Build::Docker Image') {
            steps {
                script {
                    sh "docker build -t JavaApp/my-app-1.0-SNAPSHOT:1"
                }
            }
        }
    }
}
