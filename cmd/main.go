// -*- Mode: Go; indent-tabs-mode: t -*-
//
// Copyright (C) 2018-2021 IOTech Ltd
//
// SPDX-License-Identifier: Apache-2.0

package main

import (
	"github.com/agile-edge/device-sdk-go/v3/pkg/startup"

	"github.com/agile-edge/device-modbus/internal/driver"
)

const (
	serviceName string = "device-modbus"
)

func main() {
	sd := driver.NewProtocolDriver()
	startup.Bootstrap(serviceName, device_modbus.Version, sd)
}
