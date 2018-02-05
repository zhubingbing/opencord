```
kolla-ansible deploy -i all-in-one -p opencord.yml
ansible-playbook -i inventory/all-in-one -e action=deploy genconfig.yml

ansible-playbook -i inventory/all-in-one -e @/work/cord/build/genconfig/config.yml -e @~/work/opencord/etc/global.yml -e action=deploy test.yml


## deploy cord

ansible-playbook -i inventory/all-in-one -e @../etc/global.yml -e action=deploy site.yml

## post-config xos

ansible-playbook -i inventory/all-in-one -e @../etc/global.yml -e action=deploy xos-config.yaml

```
