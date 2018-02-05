#!/usr/bin/env bash

Work="/word/cord/onos-apps/apps"


function bootstrap_onos_app() {
   cd $Work
   
   for name in aaa config igmp mcast olt vtn; do
       git clone https://github.com/opencord/$name.git -b $name-1.3
   done
   
   for name in dhcpl2relay igmpproxy sadis; do
       git clone https://github.com/opencord/$name.git -b $name-1.1
   done 

   mvn install 
}

