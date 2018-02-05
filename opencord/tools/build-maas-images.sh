#!/usr/bin/env bash

# Build images

Registry_Url="172.16.130.11:4000"
CORDDIR="${CORDDIR:-/word/cord}"


function build_maas_images() {
  cd $CORDDIR/build/maas
  make MAKE_CONFIG=../../genconfig/config.mk CONFIG= -C provisioner build
  make MAKE_CONFIG=../../genconfig/config.mk CONFIG= -C switchq publish
  make MAKE_CONFIG=../../genconfig/config.mk CONFIG= -C provisioner build  
  make MAKE_CONFIG=../../genconfig/config.mk CONFIG= -C automation build  
  make MAKE_CONFIG=../../genconfig/config.mk CONFIG= -C config-generator build
  make MAKE_CONFIG=../../genconfig/config.mk CONFIG= -C ip-allocator build

}

function build_maven_images()
{
    cd $CORDDIR/onos-apps
    make MAKE_CONFIG=../build/genconfig/config.mk build
    make MAKE_CONFIG=../build/genconfig/config.mk publish
    ## build onos images
    cd $CORDDIR/onos-apps/apps
    mvn install
    ## bug: Some apps versions do not correspond.
    cd $CORDDIR/onos-apps
    make MAKE_CONFIG=../build/genconfig/config.mk onos

}


function push_maas_images() {
  cd $CORDDIR/build/maas 
  make MAKE_CONFIG=../../genconfig/config.mk CONFIG= -C automation publish
  make MAKE_CONFIG=../../genconfig/config.mk CONFIG= -C config-generator publish
  make MAKE_CONFIG=../../genconfig/config.mk CONFIG= -C ip-allocator publish
  make MAKE_CONFIG=../../genconfig/config.mk CONFIG= -C provisioner publish
  make MAKE_CONFIG=../../genconfig/config.mk CONFIG= -C switchq publish
  make MAKE_CONFIG=../../genconfig/config.mk CONFIG= -C harvester publish
}


function build_xos_images() {
 cd $CORDDIR/orchestration/xos/containers/xos
 make base
 docker tag xosproject/xos-base:latest xosproject/xos-base:candidate
  
 cp -r $CORDDIR/component/chameleon $CORDDIR/orchestration/xos/containers/chameleon/tmp.chameleon
 cd $CORDDIR/orchestration/xos/containers/chameleon
 docker build --no-cache=false --rm \
              -f Dockerfile.chameleon -t xosproject/chameleon:candidate  . 

 cd $CORDDIR/orchestration/xos/containers/postgresql
 make build
 docker tag xosproject/xos-postgres:latest xosproject/xos-postgres:candidate
 
 cd $CORDDIR/orchestration/xos/containers/

 docker build --no-cache=false --rm \
              -f containers/xos/Dockerfile.libraries -t xosproject/xos-libraries:candidate .

 docker build --no-cache=false --rm \ 
              -f  containers/xos/Dockerfile.client  -t xosproject/xos-client:candidate .
 
 docker build --no-cache=false --rm \
              -f containers/xos/Dockerfile.xos -t xosproject/xos:candidate .

 docker build --no-cache=false --rm \
              -f containers/xos/Dockerfile.corebuilder -t xosproject/xos-corebuilder:candidate . 
  
 docker build --no-cache=false --rm \
              -f containers/xos/Dockerfile.synchronizer-base -t xosproject/xos-corebuilder:candidate .

 bash build-xos-cord.sh 


 docker build --no-cache=false --rm \
              -f  containers/xos/Dockerfile.UI -t xosproject/xos-ui:candidate .
 
}

function pull_common_images() {
  docker pull gliderlabs/consul-server:0.6
  docker pull gliderlabs/registrator:v7
  docker pull nginx:1.13
  docker pull redis:3.2
  docker pull node:7.9.0
  docker pull sebp/elk:564
}

build_maas_images
push_maas_images
build_xos_images

