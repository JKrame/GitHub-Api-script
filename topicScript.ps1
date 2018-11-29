param(
#github organization
[string]$org,
# github username
[string]$username,
# github repo name
[string]$repo,
# personal access token
[string]$pat,
#topics, delimited by comma
[string]$topics_csv
)

# output topics from the variable
Write-Host "Github Org: $org  Repo: $repo"


# call GitHub API to remove gallery topic
$resp = 
    try
    {
        # split the input string topics_csv using comma as delimiter
        $topics = $topics_csv.Split(",")

        # cleanup the data: github only takes topic with lower case, allow hyphen not space
        $github_topics = New-Object System.Collections.Generic.List[System.String] 
        foreach ($element in $topics) {
            $github_topics.Add($element.ToString().ToLower().Replace(' ', '-'))
        }

        # do not add "gallery" topic here, this put will override all current topics so the 
        # project is not found by the gallery page.

        $body= @{
            "names" = $github_topics
            } | ConvertTo-Json

        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Accept", "application/vnd.github.mercy-preview+json")
        $headers.Add("content-type", "application/json")
        $headers.Add("Authorization", "token $pat")
        
        Invoke-WebRequest `
            -Uri https://api.github.com/repos/$org/$repo/topics `
            -Method Put `
            -Headers $headers `
            -Body $body
    }
    catch {
        Write-Error "Exception!! $_.Exception"
        $_.Exception.Response
    }

    Write-Host $resp.Content


}