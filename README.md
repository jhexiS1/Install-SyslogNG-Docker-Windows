# SentinelOne Syslog-NG Docker Forwarder

This project deploys a `syslog-ng` server inside a Docker container, configured to receive logs via UDP (port 514)
and forward them to the [SentinelOne AI SIEM (SDL)](https://www.sentinelone.com/) using the HTTP Event Collector (HEC) endpoint.

## 📦 Features

- Receives syslog messages via UDP/514
- Forwards logs securely to SentinelOne SDL
- TLS-encrypted communication using HEC API key
- Uses the `syslog` sourcetype (recommended for generic syslog data)
- Lightweight and customizable

## 🧰 Requirements

- Docker
- PowerShell (for setup script)
- SentinelOne API Token with log write access
- Host IP reachable by NetApp/EMS sources

## 🚀 Getting Started

### 1. Clone the repo and run the setup script:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
./setup_syslogng_docker.ps1
```

### 2. When prompted, paste your SentinelOne API token.

### 3. Send test traffic:

```bash
echo "<13>Test from host" | nc -u 127.0.0.1 514
```

Or from NetApp:

```shell
event notification destination create -name sentinelone-docker -syslog <host_ip>
event filter create -filter-name all_events
event filter rule add -filter-name all_events -type include -message-name *
event notification create -filter-name all_events -destinations sentinelone-docker
```

## 🔐 Security

- Uses TLS v1.3 to communicate with `ingest.us1.sentinelone.net`
- Requires no ports exposed beyond 514/udp on the host
- Logs are not stored locally unless you modify the syslog-ng config

## 📁 Files

- `Dockerfile`: Builds the syslog-ng image
- `sentinelone.conf`: syslog-ng destination config
- `setup_syslogng_docker.ps1`: Interactive PowerShell script to build and run the container
