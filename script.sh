#!/bin/bash

echo "Repository: $REPO"

ENV_ARRAY=($(echo "$ENV_NAMES" | tr ',' ' '))
envCount=$(echo "${#ENV_ARRAY[@]}")

for ENV in "${ENV_ARRAY[@]}"; do
    echo "Environment Name: $ENV"
    ENV_VARS=$(gh variable list --json name,value -R $REPO -e $ENV) 
    echo "$ENV_VARS" >> "$ENV.json"
    var_count=$(cat "$ENV.json" | jq 'length')

    if [ -n "$var_count" ] && [ "$var_count" -gt 0 ]; then
        echo "Number of variables retrieved in $ENV: $var_count"
        echo "$ENV_VARS" | jq -r '.[]|"\(.name)=\(.value)"' >> $GITHUB_ENV  

        if [ $FILE_TYPE == "txt" ]; then
            echo "$ENV_VARS" | jq -r '.[]|"\(.name)=\(.value)"' > "$ENV.txt"
            echo "$ENV.txt file is created"
        fi

        if [ $FILE_TYPE == "csv" ]; then
            echo "Variables,Values" > $ENV.csv
            echo "$ENV_VARS" | jq -r '.[] | "\(.name),\(.value)"' >> "$ENV.csv"
            echo "$ENV.csv file is created"
        fi
    else
        echo "Zero variables retrieved in $ENV."
    fi
done
