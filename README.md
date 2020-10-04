# Taskify Serverless API

This project contains the code to create the serverless backend that powers the frontend 
[taskify-react-app](https://github.com/rchauhan9/taskify-react-app). The python files are all serverless lambda
 functions which interact with AWS' DynamoDB service in order to store a users' tasks.

## Getting Started

### Account Setup and Software Installations.
This project uses infrastructure powered by Amazon Web Services. You will need a valid AWS Account to run this
 application. This project also uses Terraform to provision and control the AWS infrastructure used to power this
  application. Please ensure you have Terraform installed and that Terraform has the appropriate permissions to make
   changes to your AWS infrastructure on your account. The Terraform state will be stored locally.
   

### 1. Zipping up the python files for AWS Lambda
From the projects' root directory run
```
chmod 777 zip_python_files.sh

./zip_python_files.sh
```

### 2. Deploying the Infrastructure
Assumming you are in the projects' root directory, from your terminal run the following commands.
```
cd terraform

terraform init

terraform apply
```

### 3. That's it!
Your infrastructure should be successfully deployed and your API deployed on a 'dev' stage, ready to be tested and
 used. You can execute some test commands via the AWS Console.


