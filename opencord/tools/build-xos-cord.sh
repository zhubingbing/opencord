#!/usr/bin/env bash

# Build images

CORDDIR="${CORDDIR:-/word/cord}"

docker run --rm -v $CORDDIR:/opt/cord -v $CORDDIR/orchestration/xos/containers/xos/BUILD:/opt/xos_corebuilder/BUILD xosproject/xos-corebuilder:candidate /opt/cord/orchestration/xos/xos/core/core-onboard.yaml /opt/cord/orchestration/xos_services/olt-service/xos/volt-onboard.yaml /opt/cord/orchestration/xos_services/vtn-service/xos/vtn-onboard.yaml /opt/cord/orchestration/xos_services/openstack/xos/openstack-onboard.yaml /opt/cord/orchestration/xos_services/onos-service/xos/onos-onboard.yaml /opt/cord/orchestration/xos_services/vrouter/xos/vrouter-onboard.yaml /opt/cord/orchestration/xos_services/addressmanager/xos/addressmanager-onboard.yaml /opt/cord/orchestration/xos_services/vsg/xos/vsg-onboard.yaml /opt/cord/orchestration/xos_services/vtr/xos/vtr-onboard.yaml /opt/cord/orchestration/xos_services/fabric/xos/fabric-onboard.yaml /opt/cord/orchestration/xos_services/exampleservice/xos/exampleservice-onboard.yaml /opt/cord/orchestration/profiles/rcord/xos/rcord-onboard.yaml


