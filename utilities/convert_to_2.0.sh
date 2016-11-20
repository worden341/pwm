#!/bin/bash
#Convert pre-2.0 password database (encrypted with openssl) to 2.0 format (encrypted with GPG).
#It leaves the existing database alone, but copies the files and re-encrypts them to the new TMPDIR.
#Edit the variables below to your preferences.
set -e

dbdir=~/.pwmdb
cipher=-aes256
TMPDIR=/run/user/1000/pwm
GPG_RECIPIENT="--recipient=C55A76B1"

read_masterpw() {
    [ -z "$masterpw" ] || return 0
    stty -echo
    prompt="$1"
    [ -n "$prompt" ] || prompt="master password"
    read -p "${prompt}: "  masterpw; echo
    stty echo
    export masterpw
}

read_masterpw

for key in $(ls -1 $dbdir) ; do
    echo $key
    < "${dbdir}/${key}" openssl enc "$cipher" -d -a -pass env:masterpw | gpg --encrypt $GPG_RECIPIENT > $TMPDIR/${key}
done
