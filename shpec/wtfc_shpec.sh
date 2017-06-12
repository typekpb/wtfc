# timeout error status differs based on distro (busybox/alpine=143, others=124)
timeout_err_status() {
    TIMEOUT_FLAG_TEST="$(timeout 1 sleep 0 2>&1)"
    case "${TIMEOUT_FLAG_TEST}" in
        timeout:\ can\'t\ execute\ \'1\':*) return 143 ;;
        *) return 124 ;;
    esac

}

describe "-P, --progress argument"
    it "-P argument prints '.' on each interval expiry"
        message="$($SHPEC_ROOT/../wtfc.sh -P -T 2 -S 2 ls 2>&1)"
        assert grep "$message" ".."
    end

    it "--progress argument prints '.' on each interval expiry"
        message="$($SHPEC_ROOT/../wtfc.sh --progress -T 2 -S 2 ls 2>&1)"
        assert grep "$message" ".."
    end
end

describe "-Q, --quiet argument"
    it "-Q argument prevents printing to stdout"
        message="$($SHPEC_ROOT/../wtfc.sh -Q ls)"
        assert grep "$message" ""
    end

    it "--quiet argument prevents printing to stdout"
        message="$($SHPEC_ROOT/../wtfc.sh --quiet ls)"
        assert grep "$message" ""
    end

    it "-Q argument doesn't prevent printing to stderr"
        message="$($SHPEC_ROOT/../wtfc.sh -Q -zzz "" 2>&1 > /dev/null)"
        assert grep "$message" "Unknown argument: -zzz"
    end

    it "--quiet argument doesn't prevent printing to stderr"
        message="$($SHPEC_ROOT/../wtfc.sh --quiet -zzz 2>&1 > /dev/null)"
        assert grep "$message" "Unknown argument: -zzz"
    end
end

describe "-V, --version argument"
    it "-V argument exit status is 0"
        $SHPEC_ROOT/../wtfc.sh -V >/dev/null 2>&1 
        assert equal "$?" "0"
    end

    it "--version argument exit status is 0"
        $SHPEC_ROOT/../wtfc.sh --version >/dev/null 2>&1 
        assert equal "$?" "0"
    end

    it "-V prints 'wtfc (WaiT For the Command) version: 0.0.2'"
        message="$($SHPEC_ROOT/../wtfc.sh -V 2>&1)"
        assert grep "${message}" "wtfc (WaiT For the Command) version: 0.0.2"
    end

    it "--version prints 'wtfc (WaiT For the Command) version: 0.0.2'"
        message="$($SHPEC_ROOT/../wtfc.sh --version 2>&1)"
        assert grep "${message}" "wtfc (WaiT For the Command) version: 0.0.2"
    end
end

describe "-H, --help argument"
    it "-H argument exit status is 0"
        $SHPEC_ROOT/../wtfc.sh -H >/dev/null 2>&1 
        assert equal "$?" "0"
    end

    it "--help argument exit status is 0"
        $SHPEC_ROOT/../wtfc.sh --help >/dev/null 2>&1 
        assert equal "$?" "0"
    end
end

describe "-T, --timeout argument"
    it "'-T 3' with command taking 2 seconds, exit status is 0"
        $SHPEC_ROOT/../wtfc.sh -T 3 sleep 2 >/dev/null 2>&1 
        assert equal "$?" "0"
    end

    it "'-timeout=3' with command taking 2 seconds, exit status is 0"
        $SHPEC_ROOT/../wtfc.sh --timeout=3 sleep 2 >/dev/null 2>&1 
        assert equal "$?" "0"
    end

    it "'-T 1' with command taking 2 seconds, exit status is not 0"
        $SHPEC_ROOT/../wtfc.sh -T 1 sleep 2 >/dev/null 2>&1 
        assert unequal "$?" "0"
    end

    it "'--timeout=1' with command taking 2 seconds, exit status is not 0"
        $SHPEC_ROOT/../wtfc.sh --timeout=1 sleep 2 >/dev/null 2>&1 
        assert unequal "$?" "0"
    end
end

describe "COMMAND read from stdin"
    it "exit status 1 is evaluated as 1"
        echo 'echo aaa | grep -q zzz' | $SHPEC_ROOT/../wtfc.sh >/dev/null 2>&1 
        assert equal "$?" "1"
    end
    it "exit status 0 is evaluated as 0"
        echo 'echo aaa | grep -q aaa' | $SHPEC_ROOT/../wtfc.sh >/dev/null 2>&1 
        assert equal "$?" "0"
    end
end

describe "COMMAND with pipe"
    it "exit status 1 is evaluated as 1"
        $SHPEC_ROOT/../wtfc.sh 'echo aaa | grep -q zzz' >/dev/null 2>&1 
        assert equal "$?" "1"
    end

    it "exit status 0 is evaluated as 0"
        $SHPEC_ROOT/../wtfc.sh 'echo aaa | grep -q aaa' >/dev/null 2>&1 
        assert equal "$?" "0"
    end
end

describe "COMMAND exit status"
    it "returns 0 if expected as well as actual were 0"
        $SHPEC_ROOT/../wtfc.sh -S 0 ls >/dev/null 2>&1 
        assert equal "$?" "0"
    end

    it "returns 0 if expected (not provided => implicit = 0) as well as actual was 0"
        $SHPEC_ROOT/../wtfc.sh ls >/dev/null 2>&1 
        assert equal "$?" "0"
    end

    it "returns 123/143 if expected is 0, but actual was not 0"
        timeout_err_status
        timeout_status="$?"
        $SHPEC_ROOT/../wtfc.sh -S 0 ls /nonexistant/dir >/dev/null 2>&1 
        assert equal "$?" "${timeout_status}"
    end

    it "returns 123/143 if expected is not 0, but actual was 0"
        $SHPEC_ROOT/../wtfc.sh -S 2 ls >/dev/null 2>&1 
        assert equal "$?" "${timeout_status}"
    end
    
    it "returns 0 if expected as well as actual were non-zero but equal"
        timeout_err_status
        timeout_status="$?"
        $SHPEC_ROOT/../wtfc.sh -S ${timeout_status} ls /nonexistant/dir >/dev/null 2>&1 
        assert equal "$?" "0"
    end
end

describe "Unknown argument"
    it "-Z argument exit status is 1"
        $SHPEC_ROOT/../wtfc.sh -Z >/dev/null 2>&1 
        assert equal "$?" "1"
    end

    it "--zzz argument exit status is 1"
        $SHPEC_ROOT/../wtfc.sh --zzz >/dev/null 2>&1 
        assert equal "$?" "1"
    end

    it "-Z argument prints 'Unknown argument: -Z' to stderr"
        message="$($SHPEC_ROOT/../wtfc.sh -Z 2>&1 > /dev/null)"
        assert grep "$message" "Unknown argument: -Z"
    end
    
    it "-Z argument prints nothing to stdout"
        message="$($SHPEC_ROOT/../wtfc.sh -Z 2>/dev/null)"
        assert grep "$message" ""
    end
end