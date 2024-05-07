pipeline {
    agent any; 
    environment {
       MY_CRED = credentials('ayushi')
    } 
    stages {
        stage('Git checkout'){
            steps {
                git 'https://github.com/krupasuhagiya/Terraform_JK.git'
            }
        }
        stage('azurelogin') {
            steps {
                sh 'az login --service-principal -u $MY_CRED_CLIENT_ID -p $MY_CRED_CLIENT_SECRET -t $MY_CRED_TENANT_ID'
            }
        }
        stage('Terraform Init'){
            steps{
                    sh """                    
                    echo "Initialising Terraform"
                    terraform init
                    """
            }
        }
        stage('Terraform Validate'){
            steps {
                    sh """   
                    echo "validating Terraform Code"
                    terraform validate
                    """
            }
        }
        stage('Terraform Plan'){
            steps {
                    withCredentials([azureServicePrincipal(
                    credentialsId: 'ayushi',
                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                    clientIdVariable: 'ARM_CLIENT_ID',
                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                    tenantIdVariable: 'ARM_TENANT_ID'
                )]) {
                        sh """                    
                        echo "Plan Terraform"
                        terraform plan
                        """
                           }
                 }
        }
        stage('Terraform apply') {
            steps {
                withCredentials([azureServicePrincipal(
                credentialsId: 'ayushi',
                subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                clientIdVariable: 'ARM_CLIENT_ID',
                clientSecretVariable: 'ARM_CLIENT_SECRET',
                tenantIdVariable: 'ARM_TENANT_ID')]){
                    sh """                    
                        echo "Apply Terraform"
                        terraform apply -lock=false -auto-approve
                        """
                }
            }
        }
    }
post {
    failure {
                echo "Jenkins Build Failed"
            }
    
    success {
                echo "Jenkins Build Success"
            }
    always {
        cleanWs()
           }
    }
}