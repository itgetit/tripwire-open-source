
use twtools;

package crypto;

######################################################################
# One time module initialization goes in here...
#
BEGIN {
    $description = "file crypto test";
}


######################################################################
# PolicyFileString -- return the policy text as a string
#
sub PolicyFileString
{
    return <<POLICY_END;
    # Policy file generated by file crypto test
    /etc -> +M; #read only plus MD5  

POLICY_END

}


######################################################################
#
# Initialize, get ready to run this test...
#
sub initialize() {
    
  my $twstr = PolicyFileString();
  twtools::GeneratePolicyFile($twstr);

}


######################################################################
#
# Run the test.
#
sub run() {

  my $twpassed = 1;
  my $testpath = "$twtools::twrootdir/$twtools::twpolfileloc";
  
  twtools::logStatus("*** Beginning $description\n");
  printf("%-30s", "-- $description");

  if ( ! twtools::ExamineEncryption("$testpath"))
  {
      twtools::logStatus("first examine encryption failed\n");
      $twpassed = 0;
  }

  twtools::logStatus("testing file crypto removal...\n");
  if ( !twtools::RemoveEncryption("$testpath"))
  {
      twtools::logStatus("remove encryption failed\n");
      $twpassed = 0;
  }

  if ( ! twtools::ExamineEncryption("$testpath"))
  {
      twtools::logStatus("second examine encryption failed\n");
      $twpassed = 0;
  }

  twtools::logStatus("testing file crypto...\n"); 
  if ( ! twtools::AddEncryption("$testpath")) 
  {
      twtools::logStatus("add encryption failed\n");
      $twpassed = 0;
  }

  if ( ! twtools::ExamineEncryption("$testpath"))
  {
      twtools::logStatus("third examine encryption failed\n");
      $twpassed = 0;
  }

  #########################################################
  #
  # See if the tests all succeeded...
  #
  if ($twpassed) {
      ++$twtools::twpassedtests;
      print "PASSED\n";
      return 1;
  }
  else {
      ++$twtools::twfailedtests;
      print "*FAILED*\n";
      return 0;
  }
}



######################################################################
# One time module cleanup goes in here...
#
END {
}

1;