$ErrorActionPreference = 'Stop'

if (-not $env:S1_API_KEY) {
    $api_key = Read-Host -Prompt 'Enter your SentinelOne API Key'
} else {
    $api_key = $env:S1_API_KEY
}

if (-not $api_key) {
    Write-Error "API Key is required."
    exit 1
}

$workingDir = "$PSScriptRoot"
Set-Content -Path "$workingDir\sentinelone.conf" -Value ((Get-Content "$workingDir\sentinelone.conf") -replace "\$\{API_KEY\}", $api_key)

docker build -t syslog-ng-sentinelone .\
docker rm -f syslog-ng-s1 -ErrorAction SilentlyContinue
docker run -d --name syslog-ng-s1 -p 514:514/udp syslog-ng-sentinelone

Write-Host "✅ Docker container 'syslog-ng-s1' is now running and listening on UDP port 514."
