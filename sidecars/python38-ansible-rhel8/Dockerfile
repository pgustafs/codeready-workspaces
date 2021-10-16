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

ENV HOME=/home/user \
    PATH=/usr/bin:$PATH \
    PYTHON_VERSION="3.8" \
    MANPATH="/usr/share/man:${MANPATH}"

RUN microdnf install -y yum && \
    microdnf clean all && \
    INSTALL_PKGS="bash tar gzip unzip which shadow-utils findutils wget curl \
    sudo git procps-ng bzip2" && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    PYTHON_PKGS="python38 python38-devel python3-virtualenv python38-setuptools python38-setuptools-wheel" && \
    yum -y module reset python38 && \
    yum -y module enable python38:${PYTHON_VERSION} && \
    yum -y --setopt=tsflags=nodocs install $PYTHON_PKGS && \
    yum -y update && \
    yum -y -q clean all && rm -rf /var/cache/yum

RUN \
    echo "updates pip" && \
    python3.8 -m pip install -U pip && \
    python3.8 -m pip install -U virtualenv && \
    ln -s /usr/bin/python3.8 /usr/bin/python && \
    ln -s /usr/bin/pip3.8 /usr/bin/pip && \
    pip install python-language-server[all] ptvsd jedi ipykernel jupyter

SHELL ["/bin/bash", "-c"]
RUN command -v source || (echo "ERROR: Could not find 'source' command. SHELL may not supported. If you are using podman, try again with the '--format docker' flag." && exit 126)

RUN \
    # cleanup and summaries
    echo "Installed Packages" && rpm -qa | sort -V && echo "End Of Installed Packages" && \
    echo "========" && \
    python -V && \
    pip -V && \
    echo "========"

RUN mkdir -p "${HOME}" && cd "${HOME}" && \
    python -m venv .venv && \
    source .venv/bin/activate && \
    pip install -U pylint ipykernel jupyter ansible ansible-lint && \
    python -m ipykernel install --name=.venv && \
    mv "${HOME}"/.venv "${HOME}"/.venv-tmp

RUN mkdir /projects && \
    # Change permissions to let any arbitrary user
    for f in "${HOME}" "/etc/passwd" "/projects"; do \
      echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
      chmod -R g+rwX ${f}; \
    done

ADD etc/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ${PLUGIN_REMOTE_ENDPOINT_EXECUTABLE}

# append metadata here
ENV SUMMARY="Red Hat CodeReady Workspaces - RHEL 8 + Python 3.8 + Ansible sidecar container" \
    DESCRIPTION="Red Hat CodeReady Workspaces - RHEL 8 + Python 3.8 + Ansible sidecar container" \
    PRODNAME="codeready-workspaces" \
    COMPNAME="sidecar-python38-ansible-rhel8"

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
