#!/usr/bin/env bash

# install one by one to see the error in time
echo "---- install build-essential" && sudo apt install -y build-essential && \
echo "---- install gcc" && sudo apt install -y gcc && \
echo "---- install curl" && sudo apt install -y curl && \
echo "---- install wget" && sudo apt install -y wget && \
echo "---- install net-tools" && sudo apt install -y net-tools && \
echo "---- install rsync" && sudo apt install -y rsync && \
echo "---- install jq" && sudo apt install -y jq && \
echo "---- install git" && sudo apt install -y git
