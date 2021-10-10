# codeready-workspaces
## Build the Ansible CRW Conatiner 
### Using buildah and push it to quay.io 
```
$ sudo dnf -y install podman buildah git
$ git clone https://github.com/pgustafs/codeready-workspaces.git
$ cd codeready-workspaces/ansible/Dockerfiles/
$ podman login registry.redhat.io
$ buildah bud -t quay.io/pgustafs/crw-python38-ansible-rhel8 .
$ buildah images
```


