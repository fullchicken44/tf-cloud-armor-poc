pipeline {
    agent any
    
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-credential')
    }
    
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
        booleanParam(name: 'customPolicies', defaultValue: false, description: 'Choose to use Checkov custom policies or not')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/fullchicken44/tf-cloud-armor-poc.git'
            }
        }
        
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Plan') {
            steps {
                sh 'terraform plan -out tfplan'
                sh "terraform show -json tfplan | jq '.' > tfplan.json"
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    docker.image('bridgecrew/checkov:latest').inside('--entrypoint=""') {
                        if (params.customPolicies) {
                            sh 'checkov -f tfplan.json --external-checks-dir policies'
                        } else {
                            sh 'checkov -f tfplan.json'
                        }
                    }
                }
            }
        }

        stage('Apply / Destroy') {
            steps {
                script {
                    if (params.action == 'apply') {
                        if (params.autoApprove) {
                            def plan = readFile 'tfplan.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        } else {
                            sh 'terraform ${action} --auto-approve'
                        }
                    } else if (params.action == 'destroy') {
                        sh 'terraform ${action} --auto-approve'
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
                }
            }
        }
    }
}
