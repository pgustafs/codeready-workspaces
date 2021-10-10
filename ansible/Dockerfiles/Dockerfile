# Copyright (c) 2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation
#
FROM registry.redhat.io/ubi8/ubi-minimal:latest

USER root

ENV HOME=/home/jboss \
    PATH=/usr/bin:$PATH \
    PYTHON_VERSION="3.8" \
    MANPATH="/usr/share/man:${MANPATH}" \
    XDG_CONFIG_DIRS="/etc/xdg:${XDG_CONFIG_DIRS:-/etc/xdg}" \
    XDG_DATA_DIRS="/usr/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" 

RUN microdnf install -y yum && \
    microdnf clean all && \
    INSTALL_PKGS="bash tar gzip unzip which shadow-utils findutils wget curl \
    sudo git procps-ng bzip2" && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    PYTHON_PKGS="python38 python38-devel python3-virtualenv python38-setuptools python38-setuptools-wheel" && \
    yum -y module reset python38 && \
    yum -y module enable python38:3.8 && \
    yum -y --setopt=tsflags=nodocs install $PYTHON_PKGS && \
    yum -y update && \
    yum -y -q clean all && rm -rf /var/cache/yum && \
    # TODO: why do we need this jboss user?
    useradd -u 1000 -G wheel,root -d ${HOME} --shell /bin/bash -m jboss && \
    mkdir -p ${HOME}/che /projects && \
    chown 1000 ${HOME} && \
    for f in "${HOME}" "/etc/passwd" "/etc/group" "/projects"; do \
        chgrp -R 0 ${f} && \
        chmod -R g+rwX ${f}; \
    done && \
    # Generate passwd.template \
    cat /etc/passwd | \
    sed s#jboss:x.*#jboss:x:\${USER_ID}:\${GROUP_ID}::\${HOME}:/bin/bash#g \
    > ${HOME}/passwd.template && \
    # Generate group.template \
    cat /etc/group | \
    sed s#root:x:0:#root:x:0:0,\${USER_ID}:#g \
    > ${HOME}/group.template && \
    echo "jboss	ALL=(ALL)	NOPASSWD: ALL" >> /etc/sudoers  \

RUN \
    echo "updates pip" && \
    python3.8 -m pip install -U pip && \
    python3.8 -m pip install -U virtualenv && \
    ln -s /usr/bin/python3.8 /usr/bin/python && \
    ln -s /usr/bin/pip3.8 /usr/bin/pip 
    
RUN \
    # cleanup and summaries
    echo "Installed Packages" && rpm -qa | sort -V && echo "End Of Installed Packages" && \
    echo "========" && \
    python -V && \
    pip -V && \
    echo "========"

ADD entrypoint.sh ${HOME}/
ADD requirements.txt ${HOME}/
RUN chmod +x ${HOME}/*.sh

USER jboss
WORKDIR /projects
RUN \
python -m virtualenv ${HOME}/ansible2.9 && \
source ${HOME}/ansible2.9/bin/activate && \
python -m pip install "ansible == 2.9.21" && \
python -m pip install ansible-lint && \
python -m pip install -r ${HOME}/requirements.txt && \
chgrp -R 0 ${HOME}/ansible2.9 && \
chmod -R g+rwX ${HOME}/ansible2.9 && \
deactivate && \
python -m virtualenv ${HOME}/ansible2.10 && \
source ${HOME}/ansible2.10/bin/activate && \
python -m pip install "ansible == 2.10.7" && \
python -m pip install ansible-lint && \
python -m pip install -r ${HOME}/requirements.txt && \
chgrp -R 0 ${HOME}/ansible2.10 && \
chmod -R g+rwX ${HOME}/ansible2.10 && \
deactivate 
ENTRYPOINT ["/home/jboss/entrypoint.sh"]
CMD tail -f /dev/null

# append metadata here
ENV SUMMARY="Red Hat CodeReady Workspaces - RHEL 8 + Python 3.8 + Ansible container" \
    DESCRIPTION="Red Hat CodeReady Workspaces - RHEL 8 + Python 3.8 + Ansible container" \
    PRODNAME="codeready-workspaces" \
    COMPNAME="crw-python38-ansible-rhel8"

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="$DESCRIPTION" \
      io.openshift.tags="$PRODNAME,$COMPNAME" \
      com.redhat.component="$PRODNAME-$COMPNAME-container" \
      name="$PRODNAME/$COMPNAME" \
      version="2.5" \
      license="EPLv2" \
      maintainer="Peter Gustafsson <pgustafs@redhat.com>" \
      io.openshift.expose-services="" \
      usage=""
