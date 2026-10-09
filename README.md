# hcdd412-w7-iac



\## What the Bicep Template Creates



The Bicep template creates a Linux App Service plan, an App Service web app, and an Azure AI Language resource for the development environment.



\## How to Deploy



Build and validate the Bicep template:



az bicep build --file main.bicep



Preview the deployment:



az deployment group what-if -g rg-hcdd412-w7 -f main.bicep -p appName=tzp54015



Deploy the resources:



az deployment group create -g rg-hcdd412-w7 -f main.bicep -p appName=tzp54015



After deployment, run the what-if command againto confirm that there are no additional changes.



az deployment group what-if -g rg-hcdd412-w7 -f main.bicep -p appName=tzp54015



The final what-if showed the Azure AI Language resource and the F1 App Service plan as unchanged. Additionally, it reported two App Service site configuration properties as predicted modifications



\## AI Call with Its Response



The Azure AI Language service was used to perform a live Sentiment Analysis API call.



The API request used the Azure AI Language endpoint and subscription key stored in environment variables so that no secret was committed to the repository.



curl.exe -s -X POST "$env:LANG\_ENDPOINT/language/:analyze-text?api-version=2023-04-01" `

&#x20; -H "Ocp-Apim-Subscription-Key: $env:LANG\_KEY" `

&#x20; -H "Content-Type: application/json" `

&#x20; -d '{"kind":"SentimentAnalysis","parameters":{"modelVersion":"latest"},"analysisInput":{"documents":\[{"id":"1","language":"en","text":"The deployment finished cleanly and the team is thrilled."}]}}'



The real response from the Azure AI Language service was:



{

&#x20; "kind": "SentimentAnalysisResults",

&#x20; "results": {

&#x20;   "documents": \[

&#x20;     {

&#x20;       "id": "1",

&#x20;       "sentiment": "positive",

&#x20;       "confidenceScores": {

&#x20;         "positive": 1.0,

&#x20;         "neutral": 0.0,

&#x20;         "negative": 0.0

&#x20;       },

&#x20;       "sentences": \[

&#x20;         {

&#x20;           "sentiment": "positive",

&#x20;           "confidenceScores": {

&#x20;             "positive": 1.0,

&#x20;             "neutral": 0.0,

&#x20;             "negative": 0.0

&#x20;           },

&#x20;           "offset": 0,

&#x20;           "length": 57,

&#x20;           "text": "The deployment finished cleanly and the team is thrilled."

&#x20;         }

&#x20;       ],

&#x20;       "warnings": \[]

&#x20;     }

&#x20;   ],

&#x20;   "errors": \[],

&#x20;   "modelVersion": "2025-01-01"

&#x20; }

}



This component would sit behind the Week 6 inference boundary, where the application sends inference requests to the Azure AI Language service instead of exposing the AI service directly to the user.



