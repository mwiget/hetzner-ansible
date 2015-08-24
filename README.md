## Hetzner Ansible roles/scripts

### Overview

My first attempt using ansible to manage, install and setup ubuntu 14.04 on a rented Root Server from [hetzner.de](http://hetzner.de) using their [API](http://wiki.hetzner.de/index.php/Robot_Webservice/en). 

3 roles are defined and present:

- hetzner-boot-rescue: Reboot server into recovery mode
- hetzner-install-ubuntu: Run installimage
- provision-ubuntu: Setup iptables, install some stuff

The playbook prepare-server.yml calls all 3 roles in sequence and requires 2 files to be created first, using the templates with suffix .sample. Copy them and fill them with relevant data:

```
cp hosts.sample hosts
cp secrets.yml.sample secrets.yml
```

### list tasks in the playbook

```
$ ansible-playbook --list-tasks prepare-server.yml

playbook: prepare-server.yml

  play #1 (reboot server into rescue image):	TAGS: []
    retrieve first public key fingerprint	TAGS: []
    Store ssh key fingerprint in authorized_key	TAGS: []
    check rescue mode	TAGS: []
    activate rescue mode	TAGS: []
    Execute hardware reset	TAGS: []
    remove server from local known_hosts file	TAGS: []
    waiting for server to come back	TAGS: []

  play #2 (install ubuntu 14.04 minimal):	TAGS: []
    copy my public key into tempfile	TAGS: []
    run installimage	TAGS: []
    reboot server	TAGS: []
    remove server from local known_hosts file	TAGS: []
    waiting for server to come back	TAGS: []

  play #3 (provision fresh server):	TAGS: []
    hostname name={{ hostname }}	TAGS: []
    mount /backup	TAGS: []
    Fix hostname in /etc/hosts	TAGS: []
    disabling LANG_ALL in sshd_config	TAGS: []
    check if ClientAliveInterval is present in sshd_config	TAGS: []
    set ClientAliveInterval in sshd_config to 30 seconds	TAGS: []
    restart service ssh	TAGS: []
    create user mwiget	TAGS: []
    add id_dsa.pub to user mwiget	TAGS: []
    install ufw	TAGS: []
    allow rate limited ssh access, deny anything else	TAGS: []
    run apt-get update	TAGS: []
    install development tools	TAGS: []
    install qemu build dependencies	TAGS: []
```

Run the playbook:

```
$ ansible-playbook prepare-server.yml

PLAY [reboot server into rescue image] ****************************************

GATHERING FACTS ***************************************************************
ok: [178.63.32.178]

TASK: [hetzner-boot-rescue | retrieve first public key fingerprint] ***********
ok: [178.63.32.178]

TASK: [hetzner-boot-rescue | Store ssh key fingerprint in authorized_key] *****
ok: [178.63.32.178]

TASK: [hetzner-boot-rescue | check rescue mode] *******************************
ok: [178.63.32.178]

TASK: [hetzner-boot-rescue | activate rescue mode] ****************************
ok: [178.63.32.178]

TASK: [hetzner-boot-rescue | Execute hardware reset] **************************
ok: [178.63.32.178]

TASK: [hetzner-boot-rescue | remove server from local known_hosts file] *******
changed: [178.63.32.178]

TASK: [hetzner-boot-rescue | waiting for server to come back] *****************
ok: [178.63.32.178 -> 127.0.0.1]

PLAY [install ubuntu 14.04 minimal] *******************************************

GATHERING FACTS ***************************************************************
ok: [178.63.32.178]

TASK: [hetzner-install-ubuntu | copy my public key into tempfile] *************
changed: [178.63.32.178]

TASK: [hetzner-install-ubuntu | run installimage] *****************************
changed: [178.63.32.178]

TASK: [hetzner-install-ubuntu | reboot server] ********************************
changed: [178.63.32.178]

TASK: [hetzner-install-ubuntu | remove server from local known_hosts file] ****
changed: [178.63.32.178 -> 127.0.0.1]

TASK: [hetzner-install-ubuntu | waiting for server to come back] **************
ok: [178.63.32.178 -> 127.0.0.1]

PLAY RECAP ********************************************************************
178.63.32.178              : ok=14   changed=5    unreachable=0    failed=0
```

The output shown above was taken from a run without the final role provision-ubuntu  executed.


