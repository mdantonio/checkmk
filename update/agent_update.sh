#!/bin/bash

# Install with:
# cd /usr/local/bin/
# vi / wget -> check_mk_upgrade
# sudo chmod 770 check_mk_upgrade 
# usage:
# (sudo) bash update_check_mk_agent.sh -h myservername -i/s myinstance/mysite [-d /usr/lib/check_mk_agent/plugins]

CHECK_MK_HOST=
CHECK_MK_INSTANCE="cmk"
CHECK_MK_PLUGIN_DIR="/usr/lib/check_mk_agent/plugins"

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root. Try again using sudo or log in as root user."
    exit 1
fi

while getopts "h:i:p:d:s:" opt; do
    case ${opt} in
    h)
        CHECK_MK_HOST=$OPTARG
        ;;
    i)
        CHECK_MK_INSTANCE=$OPTARG
        ;;
    d)
        CHECK_MK_PLUGIN_DIR=$OPTARG
        ;;
    *)
        echo "Usage: cmd -h -i [-p] [-d]"
        ;;
    esac
done

if [[ -z $CHECK_MK_HOST ]]; then
	echo "Please specify the hostname with -h https(s)://hostname"
	exit 1
fi

if [[ ! -d $CHECK_MK_PLUGIN_DIR ]]; then
    echo "Plugin folder is missing: ${CHECK_MK_PLUGIN_DIR}"
    exit 1
fi

OS=

if grep 'Debian' /etc/issue >/dev/null 2>&1; then
    OS=debian
fi

if grep 'Debian' /etc/os-release >/dev/null 2>&1; then
    OS=debian
fi

if grep 'Ubuntu' /etc/issue >/dev/null 2>&1; then
    OS=debian
fi

if grep 'ubuntu' /etc/os-release >/dev/null 2>&1; then
    OS=debian
fi

if grep 'CentOS' /etc/issue >/dev/null 2>&1; then
    OS=rhel
fi

if grep 'CentOS' /etc/os-release >/dev/null 2>&1; then
    OS=rhel
fi

if grep 'Red' /etc/issue >/dev/null 2>&1; then
    OS=rhel
fi

if [ ! $OS ]; then
    echo "Could not detect OS"
    exit 1
fi
echo "OS: $OS"

echo "Downloading Agent Package..."
AGENTS_URL=${CHECK_MK_HOST}/${CHECK_MK_INSTANCE}/check_mk/agents/
FILENAME=$(curl -s ${AGENTS_URL} | grep -oP "check-mk-agent\w[a-z\-\_0-9\.]+" | head -1)

if [[ -z $FILENAME ]]; then
    echo ""
    echo "Agent file not found from ${AGENTS_URL}:"
    echo ""
    echo $(curl -s ${AGENTS_URL})
    exit 1
fi

echo "Agent found = ${FILENAME}"
URL=${CHECK_MK_HOST}/${CHECK_MK_INSTANCE}/check_mk/agents/${FILENAME}
curl -Os "$URL"

if [ "$OS" == "debian" ]; then
    dpkg -i "$FILENAME"
fi

if [ "$OS" == "rhel" ]; then
    rpm --install --quiet --replacefiles "$FILENAME"
fi

rm "${FILENAME}"

cd "${CHECK_MK_PLUGIN_DIR}" || exit 1

echo "Updating plugins..."
for filename in $(find . -type f | grep -v ".bak$" | cut -c 3-); do

    if [[ "${filename}" == *"/"* ]]; then
        tokens=(${filename//// })
        filename=${tokens[1]}
        cd ${tokens[0]}
    else
        cd "${CHECK_MK_PLUGIN_DIR}"
    fi

    echo "Downloading ${filename} into $(pwd)"
    cp $filename $filename.bak
    chmod -x "$filename.bak"
    curl -sO "${CHECK_MK_HOST}/${CHECK_MK_INSTANCE}/check_mk/agents/plugins/${filename}"
    chmod +x "$filename"
    cd -
done

echo 'Completed'
