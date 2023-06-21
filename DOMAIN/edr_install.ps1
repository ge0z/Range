# DL de l'agent
Invoke-WebRequest -Uri https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.8.1-windows-x86_64.zip -OutFile elastic-agent-8.8.1-windows-x86_64.zip
Expand-Archive .\elastic-agent-8.8.1-windows-x86_64.zip -DestinationPath .
cd elastic-agent-8.8.1-windows-x86_64

# adresse du serveur fleet
$gateway=Get-NetRoute |where {$_.DestinationPrefix -eq '0.0.0.0/0'}
$address=$gateway.NextHop.Substring(0, $gateway.NextHop.LastIndexOf("."))+".1"
Add-Content  C:\windows\system32\drivers\etc\hosts "`n$address   fleet-server"
Add-Content  C:\windows\system32\drivers\etc\hosts "`n$address   elasticsearch"


# Creation token
$url="http://fleet-server:5601/api/fleet/enrollment_api_keys"
$reponse=Invoke-RestMethod -Uri $url -Headers @{ Authorization = "Basic "+ [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("elastic:changeme")) } -UseBasicParsing -Method GET
foreach ($elt in $reponse.list)
{
    if ($elt.policy_id = "agent-policy-apm-server")
    {
        $api_key=$elt.api_key
    }
}

# Enrolement
.\elastic-agent.exe install --url=https://fleet-server:8220 --enrollment-token=$api_key -n --insecure
