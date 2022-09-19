#!/bin/bash

PROJECT_EXIST=$(aws codebuild list-projects --region us-east-1 --profile cor-cicd --query 'projects[?contains(@,`NONE_PROJECTS`) == `true`]' )
# echo "Project exist: "$PROJECT_EXIST
# echo "::set-output name=project_exist::$PROJECT_EXIST"
if [[ $PROJECT_EXIST != "[]" ]]; \
then \
  echo "::set-output name=new_stage::'false'"; \
elif [[ $PROJECT_EXIST == "[]" ]]; \
then \
  echo "::set-output name=new_stage::'true'"; \
fi

echo $?  
