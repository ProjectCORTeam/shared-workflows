#!/bin/bash

PROJECT_EXIST=$(aws codebuild list-projects --region us-east-1 --profile cor-cicd --query 'projects[?contains(@,`NONE_PROJECTS`) == `true`]' | jq -e 'length > 0')
echo "Project exist: "$PROJECT_EXIST
echo "::set-output name=project_exist::$PROJECT_EXIST"
if [[ $PROJECT_EXIST == "true" ]]; \
then \
  echo "::set-output name=new_stage::'false'"; \
elif [[ $PROJECT_EXIST == "false" ]]; \
then \
  echo "::set-output name=new_stage::'true'"; \
fi

echo $?  
