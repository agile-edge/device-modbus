# Device Modbus Go
[![Build Status](https://jenkins.agile-edgex.org/view/EdgeX%20Foundry%20Project/job/agile-edgex/job/device-modbus/job/main/badge/icon)](https://jenkins.agile-edgex.org/view/EdgeX%20Foundry%20Project/job/agile-edgex/job/device-modbus/job/main/) [![Code Coverage](https://codecov.io/gh/agile-edgex/device-modbus/branch/main/graph/badge.svg?token=tgWsR3KWGX)](https://codecov.io/gh/agile-edgex/device-modbus) [![Go Report Card](https://goreportcard.com/badge/github.com/agile-edgex/device-modbus)](https://goreportcard.com/report/github.com/agile-edgex/device-modbus) [![GitHub Latest Dev Tag)](https://img.shields.io/github/v/tag/agile-edgex/device-modbus?include_prereleases&sort=semver&label=latest-dev)](https://github.com/agile-edgex/device-modbus/tags) ![GitHub Latest Stable Tag)](https://img.shields.io/github/v/tag/agile-edgex/device-modbus?sort=semver&label=latest-stable) [![GitHub License](https://img.shields.io/github/license/agile-edgex/device-modbus)](https://choosealicense.com/licenses/apache-2.0/) ![GitHub go.mod Go version](https://img.shields.io/github/go-mod/go-version/agile-edgex/device-modbus) [![GitHub Pull Requests](https://img.shields.io/github/issues-pr-raw/agile-edgex/device-modbus)](https://github.com/agile-edgex/device-modbus/pulls) [![GitHub Contributors](https://img.shields.io/github/contributors/agile-edgex/device-modbus)](https://github.com/agile-edgex/device-modbus/contributors) [![GitHub Committers](https://img.shields.io/badge/team-committers-green)](https://github.com/orgs/agile-edgex/teams/device-modbus-committers/members) [![GitHub Commit Activity](https://img.shields.io/github/commit-activity/m/agile-edgex/device-modbus)](https://github.com/agile-edgex/device-modbus/commits)


> **Warning**  
> The **main** branch of this repository contains work-in-progress development code for the upcoming release, and is **not guaranteed to be stable or working**.
> It is only compatible with the [main branch of edgex-compose](https://github.com/agile-edgex/edgex-compose) which uses the Docker images built from the **main** branch of this repo and other repos.
>
> **The source for the latest release can be found at [Releases](https://github.com/agile-edgex/device-modbus/releases).**

## Overview
Modbus Micro Service - device service for connecting Modbus devices to EdgeX.
## Build with NATS Messaging
Currently, the NATS Messaging capability (NATS MessageBus) is opt-in at build time.
This means that the published Docker images do not include the NATS messaging capability.

The following make commands will build the local binary or local Docker image with NATS messaging
capability included.
```makefile
make build-nats
make docker-nats
```

The locally built Docker image can then be used in place of the published Docker image in your compose file.
See [Compose Builder](https://github.com/agile-edgex/edgex-compose/tree/main/compose-builder#gen) `nat-bus` option to generate compose file for NATS and local dev images.

## Usage
Users can refer to [the document](https://docs.agile-edgex.org/2.0/examples/Ch-ExamplesAddingModbusDevice) to learn how to use this device service.
## Example Profile and Device
The `ProfilesDir` and `DevicesDir` in the configuration.yaml are empty string by default.
To use the example Profile and Device in this repository, please fill './res/profiles' and './res/devices'
to `ProfilesDir` and `DevicesDir` respectively.
`modbus.test.device.profile.yml` and `modbus.test.devices.yaml` will be loaded and created when the Device Service starts up.
Users can modify those files or add additional Profile YAML to meet their needs.
## Modbus Simulator
Build and run the Modbus simulator
```
$ cd simulator
$ go build
$ ./simulator 
Modbus TCP address: 0.0.0.0:1502 
Start up a Modbus TCP simulator.
```
## Packaging

For docker, please refer to the [Dockerfile](Dockerfile) and [Docker Compose Builder] scripts.

## Modbus RTU Usage
Users can refer to [the document](https://docs.agile-edgex.org/2.0/examples/Ch-ExamplesAddingModbusDevice/#set-up-the-modbus-rtu-device) to set up the Modbus RTU device.

## Community
- Discussion: https://github.com/orgs/agile-edgex/discussions
- Mailing lists: https://lists.agile-edgex.org/mailman/listinfo

## License
[Apache-2.0](LICENSE)

[Docker Compose Builder]: https://github.com/agile-edgex/edgex-compose/tree/main/compose-builder
