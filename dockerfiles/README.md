# Have OpenShift to build and push to quay.io
1.) Create a namespace for the builds:
```bash
oc create namespace builder
```
2.) Allow robot access to quay.io see https://docs.projectquay.io/use_quay.html#allow-robot-access-user-repo

3.) Copy the kubernetes secret for the robot account from quay.io to bastion host and create the secret:
```bash
oc create -n builder -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: pgustafs-ocp-builder-pull-push-secret
data:
  .dockerconfigjson: xxxxxx
type: kubernetes.io/dockerconfigjson
EOF
```
3.) Create the build config:
```bash
oc new-build -n builder \
https://github.com/pgustafs/codeready-workspaces.git \
--context-dir=dockerfiles/python-3.8-ansible-rhel8 \
--name=crw-python38-ansible-rhel8 \
--strategy=docker \
--push-secret=pgustafs-ocp-builder-pull-push-secret \
--to-docker=true \
--to=quay.io/pgustafs/crw-python38-ansible-rhel8:latest \
--docker-image=registry.redhat.io/ubi8/ubi-minimal:latest 
```
