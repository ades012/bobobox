# BOBOBOX TAKE HOME ASSIGNMENT

# TASK 1 : Server health check automation

This repo contains `health_check.sh`, a Bash script designed to automate basic server health monitoring. [cite_start]It performs connectivity checks, verifies web service availability, and reports the root filesystem's disk usage[cite: 8, 11, 14, 16]. [cite_start]All results are logged with timestamps for auditing purposes[cite: 17].

## Prerequisites
Ensure the environment running this script has the following standard Linux utilities installed:
- `bash`
- `ping`
- `curl`
- `df`

## Usage
[cite_start]The script requires at least one argument (Target IP/Hostname)[cite: 9]. [cite_start]The port argument is optional and defaults to `80` if not provided[cite: 14].

**Syntax:**
`./health_check.sh <IP_or_Hostname> [port]`

**Make the script executable first:**
`chmod +x health_check.sh`

**Examples:**
1. Running with a specific port (Example output as requested):
   [cite_start]`./health_check.sh localhost 80` [cite: 19]
   
2. Running without a port (will default to port 80):
   `./health_check.sh 192.168.1.50`

3. Handling missing arguments:
   `./health_check.sh`
   [cite_start]*(Will output usage instructions and exit with status 1)* [cite: 17]

## Output & Logging
[cite_start]When executed, the script outputs the results to the standard output (console) and simultaneously appends the results with a timestamp to `health_check.log` in the same directory[cite: 17].

## Architecture & Reasoning Decisions
[cite_start]As part of the assignment requirements to provide reasoning, here are the key technical decisions made for this script:

1. [cite_start]**Local vs. Remote Disk Usage (`df -h /`):** While `ping` and `curl` test network availability remotely, the `df -h /` command inspects the local machine's filesystem[cite: 16]. I deliberately kept this as a local execution instead of wrapping it in an SSH command (`ssh user@target "df -h /"`). 
   [cite_start]*Reasoning:* The assignment does not provide SSH credentials or key paths, and the example execution uses `localhost`[cite: 19]. Therefore, the script is designed with the assumption that it will be executed *locally* on the target server (e.g., triggered by a cron job) or used locally by an agent before sending metrics to a centralized monitoring system like Zabbix or Prometheus.
   
2. **Error Handling & Exit Codes:**
   [cite_start]If the target is unreachable via `ping`, the script immediately logs the failure and exits with a non-zero status (`exit 1`)[cite: 11]. This ensures the script is CI/CD pipeline-friendly and can be easily caught by external automation tools.

3. **Port Variable Fallback:**
   Used the bash parameter expansion `PORT=${2:-80}` to cleanly assign a default value without requiring complex `if-else` blocks, keeping the script lightweight and readable.


