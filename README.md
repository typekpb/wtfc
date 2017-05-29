WaiT For the Command (wtfc)
===
[![Build Status](https://secure.travis-ci.org/typekpb/wtfc.png?branch=master)](http://travis-ci.org/typekpb/wtfc)

Shell script capable of waiting for command execution exit status for specified timeout.

Works well with:
* various OSes: Busybox, Alpine Linux, Debian Linux and OSX
* as well as various shells: ash, bash, dash, ksh and zsh

Usage
===

    Usage: wtfc.sh [OPTION]... [COMMAND]

    Functional arguments:
    -i, --interval=SECONDS   set the check interval to SECONDS (default is 1)
    -s, --status=NUMBER      set the expected COMMAND exit status to NUMBER (default is 0)
    -t, --timeout=SECONDS    set the timeout to SECONDS (zero for no timeout)
    
    Logging and info arguments:
    -h, --help               print this help and exit
    -V, --version            display the version of wtfc and exit.

Inspiration
===

Inspired by [wait-for-it](https://github.com/vishnubob/wait-for-it) as well as [wait-for-command](https://github.com/ettore26/wait-for-command).