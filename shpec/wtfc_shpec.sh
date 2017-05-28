# timeout error status differs based on distro (busybox/alpine=143, others=124)
timeout_err_code() {
    TIMEOUT_FLAG_TEST="$(timeout 1 sleep 0 2>&1)"
    case "${TIMEOUT_FLAG_TEST}" in
        timeout:\ can\'t\ execute\ \'1\':*) return 143 ;;
        *) return 124 ;;
    esac

}

describe "-V, --version argument"
    it "-V argument exit code is 0"
        $SHPEC_ROOT/../wtfc.sh -V >/dev/null 2>&1 
        assert equal "$?" "0"
    end

    it "--version argument exit code is 0"
        $SHPEC_ROOT/../wtfc.sh --version >/dev/null 2>&1 
        assert equal "$?" "0"
    end

    it "-V prints 'wtfc (WaiT For the Command) version: 0.0.1'"
        message="$($SHPEC_ROOT/../wtfc.sh -V 2>&1)"
        assert grep "${message}" "wtfc (WaiT For the Command) version: 0.0.1"
    end

    it "--version prints 'wtfc (WaiT For the Command) version: 0.0.1'"
        message="$($SHPEC_ROOT/../wtfc.sh --version 2>&1)"
        assert grep "${message}" "wtfc (WaiT For the Command) version: 0.0.1"
    end
end

describe "-H, --help argument"
    it "-H argument exit code is 0"
        $SHPEC_ROOT/../wtfc.sh -H >/dev/null 2>&1 
        assert equal "$?" "0"
    end

    it "--help argument exit code is 0"
        $SHPEC_ROOT/../wtfc.sh --help >/dev/null 2>&1 
        assert equal "$?" "0"
    end
end

describe "COMMAND missing"
    it "exit code is 1"
        $SHPEC_ROOT/../wtfc.sh >/dev/null 2>&1 
        assert equal "$?" "1"
    end
end

describe "COMMAND exit codes"
    it "returns 0 if expected as well as actual were 0"
        $SHPEC_ROOT/../wtfc.sh -s 0 ls >/dev/null 2>&1 
        assert equal "$?" "0"
    end

    it "returns 0 if expected (not provided => implicit = 0) as well as actual was 0"
        $SHPEC_ROOT/../wtfc.sh ls >/dev/null 2>&1 
        assert equal "$?" "0"
    end

    it "returns 1 if expected is 0, but actual was not 0"
        $SHPEC_ROOT/../wtfc.sh -s 0 ls /nonexistant/dir >/dev/null 2>&1 
        assert unequal "$?" "0"
    end

    it "returns 0 if expected as well as actual were non-zero but equal"
        timeout_err_code
        expected="$?"
        $SHPEC_ROOT/../wtfc.sh -s 2 ls /nonexistant/dir >/dev/null 2>&1 
        assert equal "$?" "${expected}"
    end

end

describe "Unknown argument"
    it "-Z argument exit code is 1"
        $SHPEC_ROOT/../wtfc.sh -Z >/dev/null 2>&1 
        assert equal "$?" "1"
    end

    it "--zzz argument exit code is 1"
        $SHPEC_ROOT/../wtfc.sh --zzz >/dev/null 2>&1 
        assert equal "$?" "1"
    end

    it "-Z argument prints 'Unknown argument: -Z'"
        message="$($SHPEC_ROOT/../wtfc.sh -Z 2>&1)"
        assert grep "$message" "Unknown argument: -Z"
    end
    
end