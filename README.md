# lnx-graceful-shutdown
Graceful shutdown service for linux (debian based).

The service `remote_monitor` pings the first default network route, as soon as it is down, script initiates the shutdown of the system. 

## Usage

replace 5 by time in minutes to initiate shutdown (example: 5 or 10 or ...) 

```shell
./install.sh 5
```