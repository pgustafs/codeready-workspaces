# Have OpenShift to build and push to quay.io
1.) Create a namespace for the builds:
```bash
oc create namespace builder
```
1.) Allow robot access to quay.io see https://docs.projectquay.io/use_quay.html#allow-robot-access-user-repo
2.) Copy the kubernetes secret for the robot account from quay.io to bastion host and create the secret:
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

