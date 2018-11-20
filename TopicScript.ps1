$user="<username Here>"
$repo="<Repo Here>"
#TODO: Insert keyvault PAT
$token="<Insert Token Here>"
$Url = "https://api.github.com/repos/$user/$repo/topics"
$Header=@{ `
    'Accept' = 'application/vnd.github.mercy-preview+json'; `
    'Authorization' = "token $token"; `
    }


# Retrieve current list of topics
$response = Invoke-RestMethod -Uri $Url -Method GET -Headers $Header
[System.Collections.ArrayList]$topics = $response.names
$topics.Remove("gallery")

[hashtable]$Body=@{
        'names' = $topics
    }
$json = $Body | convertto-json

#Push list without Gallery
$Put = Invoke-RestMethod -Uri $Url -Method PUT -ContentType 'application/json' -Headers $Header -Body $json
echo $Put