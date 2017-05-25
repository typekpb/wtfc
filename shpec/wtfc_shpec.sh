# describe "output"
#     it "outputs passing tests to STDOUT"
#       message="$(. $SHPEC_ROOT/../wtfc.sh -c)"
#       assert grep "$message" "a passing test"
#     end
# end

describe "exit codes"
    it "returns 0 if expected as well as actual were 0"
      $SHPEC_ROOT/../wtfc.sh -s 0 -c ls 
      assert equal "$?" "0"
    end

    it "returns 0 if expected as well as actual were non-zero but equal"
      $SHPEC_ROOT/../wtfc.sh -s 2 -c ls /nonexistant 
      assert equal "$?" "0"
    end

end