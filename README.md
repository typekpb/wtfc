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
    wtfc (WaiT For The Command) waits for the COMMAND provided as the last argument or via standard input to return within timeout with expected exit status.
    
    Functional arguments:
      -I, --interval=SECONDS   set the check interval to SECONDS (default is 1)
      -S, --status=NUMBER      set the expected COMMAND exit status to NUMBER (default is 0)
      -T, --timeout=SECONDS    set the timeout to SECONDS (0 for no timeout, default is 1)
    
    Logging and info arguments:
      -Q, --quiet              be quiet
      -H, --help               print this help and exit
      -V, --version            display the version of wtfc and exit.
    
    Examples:
      ./wtfc.sh -T 1 -S 0 ls /tmp                   Waits for 1 second for 'ls /tmp' to execute with exit status 0
      echo "ls /foo/bar" | ./wtfc.sh -T 2 -S 2      Waits for 2 seconds for 'ls /foo/bar' to execute with exit status 2

Inspiration
===

Inspired by [wait-for-it](https://github.com/vishnubob/wait-for-it) as well as [wait-for-command](https://github.com/ettore26/wait-for-command).