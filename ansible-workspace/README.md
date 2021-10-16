# codeready-workspaces
## Build the Ansible CRW Conatiner 
### Using buildah and push it to quay.io 
```
$ sudo dnf -y install podman buildah git
$ git clone https://github.com/pgustafs/codeready-workspaces.git
$ cd codeready-workspaces/ansible-workspace/Dockerfiles/
$ podman login registry.redhat.io
$ buildah bud -t quay.io/pgustafs/crw-python38-ansible-rhel8 .
$ buildah images
REPOSITORY                                    TAG      IMAGE ID       CREATED       SIZE
quay.io/pgustafs/crw-python38-ansible-rhel8   latest   073c6a1861d8   7 hours ago   442 MB
$ podman login quay.io
$ podman push quay.io/pgustafs/crw-python38-ansible-rhel8
```


