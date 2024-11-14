#
# Copyright (c) 2020-2021 IOTech Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
FROM golang:1.21-bookworm AS builder

ARG ADD_BUILD_TAGS=""

WORKDIR /device-modbus

ARG GO_PROXY="https://goproxy.cn,direct"
ENV GOPROXY=$GO_PROXY

COPY go.mod ./
RUN go mod download all

COPY . .
ARG MAKE="make -e ADD_BUILD_TAGS=$ADD_BUILD_TAGS build"
RUN ${MAKE}

#Next image - Copy built Go binary into new workspace
FROM debian:bookworm-slim

# 设置环境变量以避免交互式提示
ENV DEBIAN_FRONTEND=noninteractive
# Ensure using latest versions of all installed packages to avoid any recent CVEs
RUN apt update && \
    apt upgrade -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /device-modbus/cmd /
COPY --from=builder /device-modbus/LICENSE /
COPY --from=builder /device-modbus/Attribution.txt /

EXPOSE 59901

ENTRYPOINT ["/device-modbus"]
CMD ["--cp=consul://edgex-core-consul:8500", "--registry"]
