pipeline {
    agent any

    tools {
       terraform 'terraform'
    }

    parameters {
        choice(name: 'TF_VAR_environment', choices: ['dev', 'test', 'prod'], description: 'Select Environment')
        choice(name: 'TERRAFORM_OPERATION', choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform Operation')
    }

    // environment {
    //     // TF_VAR_environment = params.TF_VAR_environment
    //     AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
    //     AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    // }

    stages {
        stage('checkout from GIT'){
            steps{
                git branch: 'main', url: 'https://github.com/it-nuggets/Parameterized-Jenkins-CI-CD-Terraform-aws.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // withCredentials([string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_ACCESS_KEY_ID'),
                    //                  string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    //     sh 'terraform init'
                    // }
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Workspace') {
            steps {
                script {
                    // Check if the Terraform workspace exists, create if not
                    def workspaceExists = sh(script: 'terraform workspace select ${TF_VAR_environment} || true', returnStatus: true) == 0

                    if (!workspaceExists) {
                        sh "terraform workspace new ${TF_VAR_environment}"
                    }
                }
            }
        }

        stage('Terraform Operation') {
            steps {
                script {
                    // Run Terraform based on the selected operation
                    switch(params.TERRAFORM_OPERATION) {
                        case 'plan':
                            sh "terraform plan -var-file='${TF_VAR_environment}.tfvars' -out=tfplan"
                            break
                        case 'apply':
                            sh "terraform plan -var-file='${TF_VAR_environment}.tfvars' -out=tfplan"
                            sh 'terraform apply -auto-approve tfplan'
                            break
                        case 'destroy':
                            sh "terraform destroy -var-file='${TF_VAR_environment}.tfvars' -auto-approve"
                            break
                        default:
                            error "Invalid Terraform operation selected"
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up artifacts, e.g., the Terraform plan file
            deleteDir()
        }
    }
}