#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation
#

set -e
set -x

USER_ID=$(id -u)
export USER_ID
GROUP_ID=$(id -g)
export GROUP_ID

if ! whoami >/dev/null 2>&1; then
    echo "${USER_NAME:-user}:x:${USER_ID}:0:${USER_NAME:-user} user:${HOME}:/bin/bash" >> /etc/passwd
fi

# Grant access to projects volume in case of non root user with sudo rights
if [ "${USER_ID}" -ne 0 ] && command -v sudo >/dev/null 2>&1 && sudo -n true > /dev/null 2>&1; then
    sudo chown "${USER_ID}:${GROUP_ID}" /projects
fi

# Setup .venv in the 'venv' volume that should be mounted in HOME/.venv
mkdir -p "${HOME}"/.venv
if [ ! -f "${HOME}"/.venv/bin/activate ]; then
  echo "${HOME}"/.venv is empty, moving files from "${HOME}"/.venv-tmp/
  mv "${HOME}"/.venv-tmp/* "${HOME}"/.venv
fi

# shellcheck source=/dev/null
source "${HOME}"/.venv/bin/activate
exec "$@"
