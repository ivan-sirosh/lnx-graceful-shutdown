# lnx-graceful-shutdown
Graceful shutdown service for Linux (Debian-based). 
The main purpose is to use it as a strategy to shut down the server if a power outage occurs, 
but the UPS does not support any known protocol of the current system. 

The `remote_monitor` service pings the first default network route, and as soon as it is down,
the script initiates the shutdown of the system.

## Usage

replace 5 by time in minutes to initiate shutdown (example: 5 or 10 or ...) 

```shell
./install.sh 5
```