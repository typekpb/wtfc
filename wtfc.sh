#!/bin/sh

cmdname="${0##*/}"

VERSION=0.0.1

echoerr() { 
    #if [ "${QUIET}" -ne 1 ]; then 
    echo "$@";
    # fi
}

usage() {
    cat << USAGE >&2
Usage: $cmdname [OPTION]... [COMMAND]

Functional arguments:
  -i, --interval=SECONDS   set the check interval to SECONDS (default is 1)
  -s, --status=NUMBER      set the expected COMMAND exit status to NUMBER (defualt is 0)
  -t, --timeout=SECONDS    set the timeout to SECONDS (zero for no timeout)
  
Logging and info arguments:
  -h, --help               print this help and exit
  -q, --quiet              be quiet
  -v, --verbose            be verbose
  -V, --version            display the version of wtfc and exit.
USAGE
    exit $1
}

version() {
    cat "wtfc (WaiT For the Command) version: ${VERSION}"
    exit 0
}

wait_for()
{
    if [ "${TIMEOUT}" -gt 0 ]; then
        echoerr "$cmdname: waiting $TIMEOUT seconds for $CMD"
    else
        echoerr "$cmdname: waiting without a timeout for $CMD"
    fi
    start_ts=$(date +%s)
    while :
    do
        ($CMD) >/dev/null 2>&1
        result=$?

        if ([ "${result}" -eq "${STATUS}" ]); then
            end_ts=$(date +%s)
            echoerr "$cmdname: $CMD finished with expected status $result after $((end_ts - start_ts)) seconds"
            break
        fi
        sleep $INTERVAL
    done
    return $result
}

wait_for_wrapper()
{
    # In order to support SIGINT during timeout: http://unix.stackexchange.com/a/57692
    if [ "${QUIET}" -eq 1 ]; then
        timeout $TIMEOUT_FLAG $TIMEOUT $0 --quiet --child --timeout=$TIMEOUT $CMD &
    else
        timeout $TIMEOUT_FLAG $TIMEOUT $0 --child --timeout=$TIMEOUT $CMD &
    fi
    PID=$!
    trap "kill -INT -$PID" INT
    wait $PID
    RESULT=$?
    return $RESULT
}

# process arguments
while [ $# -gt 0 ]
do
    case "$1" in
        --child)
        CHILD=1
        shift 1
        ;;
        -H | --help)
        usage 0
        ;;
        -q | --quiet)
        QUIET=1
        shift 1
        ;;
        -v | --verbose)
        QUIET=1
        shift 1
        ;;
        -V | --version)
        version
        ;;
        -i)
        INTERVAL="$2"
        if [ -z "${INTERVAL}" ]; then break; fi
        shift 2
        ;;
        --interval=*)
        INTERVAL="${1#*=}"
        shift 1
        ;;
        -s)
        STATUS="$2"
        if [ -z "${STATUS}" ]; then break; fi
        shift 2
        ;;
        --status=*)
        TIMEOUT="${1#*=}"
        shift 1
        ;;
        -t)
        TIMEOUT="$2"
        if [ -z "${TIMEOUT}" ]; then break; fi
        shift 2
        ;;
        --timeout=*)
        TIMEOUT="${1#*=}"
        shift 1
        ;;
        -*)
        echoerr "Unknown argument: $1"
        usage 1
        ;;
        *)
        CMD="$@"
        break
        ;;
    esac
done

if [ -z "${CMD}" ]; then
    echoerr "Error: you need to provide a COMMAND to test."
    usage 1
fi

CHILD=${CHILD:-0}

QUIET=${QUIET:-0}
VERBOSE=${VERBOSE:-0}

INTERVAL=${INTERVAL:-1}
STATUS=${STATUS:-0}
TIMEOUT=${TIMEOUT:-1}

# check to see if timeout is from busybox/alpine => '-t' switch is required or not
TIMEOUT_FLAG_TEST="$(timeout 1 sleep 0 2>&1)"
case "${TIMEOUT_FLAG_TEST}" in
    timeout:\ can\'t\ execute\ \'1\':*) TIMEOUT_FLAG="-t" ;;
    *) TIMEOUT_FLAG="" ;;
esac

if [ "${CHILD}" -eq 1 ]; then
    wait_for
    RESULT=$?
    exit $RESULT
else
    if [ "${TIMEOUT}" -gt 0 ]; then
        wait_for_wrapper
        RESULT=$?
    else
        wait_for
        RESULT=$?
    fi
fi

if [ "${RESULT}" -ne "${STATUS}" ]; then
    echoerr "$cmdname: timeout occurred after waiting $TIMEOUT seconds for $CMD to return status: $STATUS (was status: $RESULT)"
fi

exit $RESULT
