# Taskify Serverless API

This project contains the all the code to serve the taskify-react in a serverless manner.


## Getting Started
This project was created to work on AWS, using DynamoDB, API Gateway and AWS Lambda as the serverless technology. This README assumes you are relatively familiar with these technologies and presents a rough guide to getting the Taskify React Application running with this serverless API.

### 1. Creating the Database
Create a DynamoDB database called Taskify.
- Partition key = 'id'
- Sort key = 'username'
- Fields:
  - string: 'id',
  - string: 'username',
  - bool: 'completed',
  - string: 'deadline',
  - string: 'notes'
- Global Secondary Index = string: 'username'

### 2. Creating the Lambdas
There are four Python files in this repository, each perform a separate operation of the CRUD operations.
```
taskify-create-item.py
taskify-delete-item.py
taskify-edit-item.py
taskify-get-all-items.py
```
Create a lambda with the same name as each python file in this repository. Select Python v3.6 as the version for each Lambda. You can simply replace all placeholder code in the Lambda with the code from each Python file.

### 3. Creating the API
Go to API Gateway and create a REST API.
- Create a resource named '/tasks'
- Under the tasks method:
  - Create a 'DELETE' method and attach your taskify-delete-item lambda to it.
  - Create a 'GET' method and attach your taskify-get-all-items lambda to it.
  - Create a 'PATCH' method and attach your taskify-edit-item lambda to it.
  - Create a 'POST' method and attach your taskify-create-item lambda to it.
- Deploy your API to a stage of your choice.
- Under the stages tab, locate your API and make a note of your invocation URL. This needs to be pasted into the Taskify React App's apis/tasks 'baseURL' section.

### 4. Google Auth
In order to get the app properly working, you will need to set up GoogleAuthentication. This is taken care of on the client side, so brief instructions on how to do this can be found in the taskify-react-app README.md.
