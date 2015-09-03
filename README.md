## Simple Hetzner API Ansible roles and scripts

### Overview

My first attempt using ansible to manage, install and setup ubuntu 14.04 on a rented Root Server from [http://hetzner.de](http://hetzner.de) using their [API](http://wiki.hetzner.de/index.php/Robot_Webservice/en). 
There are other playbooks stored here to install and provision various applications, like qemu, dnsmasq etc. 

### Shell scripts

3 very simple shell scripts show the use the API via curl and how to create a password hash. They read the web API username/password from secrets.yml:

- showmykeys.sh - shows the stored public ssh key on [https://robot.your-server.de](https://robot.your-server.de)
- listmyservers.sh - lists all rented root servers
- create-password-hash.sh - asks for a clear text password and displays the hash that can be used in secrets.yml as password (for a user account to be created in role provision-ubuntu).


### Ansible roles

- hetzner-boot-rescue: Reboot server into recovery mode
- hetzner-install-ubuntu: Run installimage
- provision-ubuntu: Setup iptables, install some stuff

The playbook initialize-server.yml calls all 3 roles in sequence and requires 2 files to be created first, using the templates with suffix .sample. Copy them and fill them with relevant data:

```
cp hosts.sample hosts
cp secrets.yml.sample secrets.yml
```

### List tasks in the playbook

```
$ ansible-playbook --list-tasks initialize-server.yml

playbook: initialize-server.yml

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

### Run the playbook:

```
$ ansible-playbook initialize-server.yml

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

PLAY [install docker] *********************************************************

GATHERING FACTS ***************************************************************
ok: [178.63.32.178]

TASK: [install-docker | hostname name={{ hostname }}] *************************
changed: [178.63.32.178]

TASK: [install-docker | mount /backup] ****************************************
changed: [178.63.32.178]

TASK: [install-docker | Fix hostname in /etc/hosts] ***************************
changed: [178.63.32.178]

TASK: [install-docker | disabling LANG_ALL in sshd_config] ********************
changed: [178.63.32.178]

TASK: [install-docker | check if ClientAliveInterval is present in sshd_config] ***
failed: [178.63.32.178] => {"changed": true, "cmd": "grep ^ClientAliveInterval /etc/ssh/sshd_config", "delta": "0:00:00.001605", "end": "2015-09-03 17:04:09.923680", "rc": 1, "start": "2015-09-03 17:04:09.922075", "warnings": []}
...ignoring

TASK: [install-docker | set ClientAliveInterval in sshd_config to 30 seconds] ***
changed: [178.63.32.178]

TASK: [install-docker | restart service ssh] **********************************
changed: [178.63.32.178]

TASK: [install-docker | install ufw] ******************************************
ok: [178.63.32.178]

TASK: [install-docker | allow rate limited ssh access, deny anything else] ****
changed: [178.63.32.178]

TASK: [install-docker | run apt-get update] ***********************************
ok: [178.63.32.178]

TASK: [install-docker | install development tools] ****************************
changed: [178.63.32.178] => (item=git,bridge-utils,htop,tcpdump,telnet,curl)

TASK: [install-docker | install docker] ***************************************
changed: [178.63.32.178]

TASK: [install-docker | create user mwiget] ***********************************
changed: [178.63.32.178]

TASK: [install-docker | add id_dsa.pub to user mwiget] ************************
changed: [178.63.32.178]

TASK: [install-docker | run docker hello] *************************************
changed: [178.63.32.178]

TASK: [install-docker | debug var=result] *************************************
ok: [178.63.32.178] => {
    "var": {
        "result": {
            "changed": true,
            "cmd": "docker run hello-world",
            "delta": "0:00:04.712482",
            "end": "2015-09-03 17:05:45.865855",
            "invocation": {
                "module_args": "docker run hello-world",
                "module_name": "shell"
            },
            "rc": 0,
            "start": "2015-09-03 17:05:41.153373",
            "stderr": "Unable to find image 'hello-world:latest' locally\nlatest: Pulling from library/hello-world\n535020c3e8ad: Pulling fs layer\naf340544ed62: Pulling fs layer\naf340544ed62: Verifying Checksum\naf340544ed62: Download complete\n535020c3e8ad: Verifying Checksum\n535020c3e8ad: Download complete\n535020c3e8ad: Pull complete\naf340544ed62: Pull complete\nDigest: sha256:a68868bfe696c00866942e8f5ca39e3e31b79c1e50feaee4ce5e28df2f051d5c\nStatus: Downloaded newer image for hello-world:latest",
            "stdout": "\nHello from Docker.\nThis message shows that your installation appears to be working correctly.\n\nTo generate this message, Docker took the following steps:\n 1. The Docker client contacted the Docker daemon.\n 2. The Docker daemon pulled the \"hello-world\" image from the Docker Hub.\n 3. The Docker daemon created a new container from that image which runs the\n    executable that produces the output you are currently reading.\n 4. The Docker daemon streamed that output to the Docker client, which sent it\n    to your terminal.\n\nTo try something more ambitious, you can run an Ubuntu container with:\n $ docker run -it ubuntu bash\n\nShare images, automate workflows, and more with a free Docker Hub account:\n https://hub.docker.com\n\nFor more examples and ideas, visit:\n https://docs.docker.com/userguide/",
            "stdout_lines": [
                "",
                "Hello from Docker.",
                "This message shows that your installation appears to be working correctly.",
                "",
                "To generate this message, Docker took the following steps:",
                " 1. The Docker client contacted the Docker daemon.",
                " 2. The Docker daemon pulled the \"hello-world\" image from the Docker Hub.",
                " 3. The Docker daemon created a new container from that image which runs the",
                "    executable that produces the output you are currently reading.",
                " 4. The Docker daemon streamed that output to the Docker client, which sent it",
                "    to your terminal.",
                "",
                "To try something more ambitious, you can run an Ubuntu container with:",
                " $ docker run -it ubuntu bash",
                "",
                "Share images, automate workflows, and more with a free Docker Hub account:",
                " https://hub.docker.com",
                "",
                "For more examples and ideas, visit:",
                " https://docs.docker.com/userguide/"
            ],
            "warnings": []
        }
    }
}

PLAY RECAP ********************************************************************
178.63.32.178              : ok=31   changed=18   unreachable=0    failed=0

```

The output shown above was taken from a run without the final role provision-ubuntu  executed.

