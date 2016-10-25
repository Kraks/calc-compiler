#!/usr/bin/perl -w

use strict;

my $CALCC = $ENV{"CALCC"};
if (!defined($CALCC)) {
    $CALCC = "../build/calcc";
}

die "cannot find compiler!" unless
  -e $CALCC;

sub runit ($) {
    (my $cmd) = @_;
    system "$cmd";
    return $? >> 8;
}

sub test($) {
    (my $f) = @_;
    print "================================================\n";
    print "running test '$f'\n";
    open INF, "<$f" or die "OOPS: cannot open '$f'";
    my $result;
    my $args;
    while (my $line = <INF>) {
        chomp $line;
	if ($line =~ /RESULT (.*)$/) {
            die "BUGGY TESTCASE: more than one RESULT line"
                if defined $result;
	    $result = $1;
	}
        if ($line =~ /ARGS\s*([0-9\ \-]*)\s*$/) {
            die "BUGGY TESTCASE: more than one ARG line"
                if defined $args;
            $args = $1;
        }
    }
    close INF;
    die "BUGGY TESTCASE: cannot find RESULT line in '$f'" unless
      defined $result;
    die "BUGGY TESTCASE: cannot find ARGS line in '$f'" unless
      defined $args;
    my @arglist = split / /, $args;
    die "BUGGY TESTCASE: too many args in '$f'" if
        scalar(@arglist) > 6;
    die "BUGGY TESTCASE: unexpected RESULT '$result'" unless
      ($result eq "ERROR" ||
       $result =~ /^-?[0-9]+$/);
    my $res = runit("$CALCC < $f > /dev/null 2> out.ll");
    if ($result eq "ERROR") {
	if ($res == 1) {
	    print "compiler correctly detected erroneous input\n";
	    goto done;
	}
	print "COMPILER BUG: failed to correctly give exit code 1\n";
        return 0;
    }
    if ($res != 0) {
        print "COMPILER BUG: failed to correctly give exit code 0\n";
        return 0;
    }
    runit("../../llvm-build/bin/clang out.ll driver.c");
    if (!(-f "a.out")) {
        print "COMPILER BUG: executable could not be generated\n";
        return 0;
    }
    my $argstr = "";
    foreach my $arg (@arglist) {
        $argstr .= "$arg ";
    }
    $res = runit("./a.out $argstr > output.txt");
    if ($res != 0) {
        print "COMPILER BUG: executable did not run successfully\n";
        return 0;
    }
    open INF, "<output.txt" or
        die "OOPS: cannot read output generated by executable";
    my $prog_result;
    while (my $line = <INF>) {
	chomp $line;
	if ($line =~ /result = (-?[0-9]+)$/) {
	    $prog_result = $1;
	}
    }
    close INF;
    if (!defined($prog_result)) {
        print "COMPILER BUG: output from executable does not contain 'result = ...'\n";
        return 0;
    }
    print "expected output = $result\n";
    print "actual output = $prog_result\n";
    if ($result ne $prog_result) {
        print "COMPILER BUG: output disagreement\n";
        return 0;
    }
  done:
    print "TEST SUCCESSFUL\n";
    return 1;
}

my $pass = 0;
my $fail = 0;
foreach my $f (@ARGV) {
    if (test($f)) {
        $pass++;
    } else {
        $fail++;
    }
    print "\n";
}

print "\n";
print "================================================\n";
print "SUMMARY: $pass tests passed, $fail tests failed\n";
print "================================================\n";
