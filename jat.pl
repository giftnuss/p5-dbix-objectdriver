#!/bin/perl
; package jat
; $jat::VERSION = 1
; $jat::MEANING = "http://de.wikipedia.org/wiki/Jat"
; use strict; use warnings

; $jat::DEFAULT_CLEANUP_PATTERN = "(\\.(bak)|~)\$"

; sub usage
    { warn "$_[0]\n" if defined($_[0])
	; print <<__HELP__
$0 ACTION [OPTIONS] -- where ACTION is\n"
  cleanup -- remove backup and temporary files from dirtree
    -p PATTERN -- matching files, default is $jat::DEFAULT_CLEANUP_PATTERN
    -d DIR -- directory, default is current working dir
__HELP__
    }
	
; sub need ($)
; sub need ($)
    { # TOKNOW: eval with use can't check reliable the return value!
	; eval("use $_[0]"); 
	; $@ ? do { require Carp && Carp::croak("Can't load module '$_[0]'.") }
	     : return 1
	}
	
; my $action = shift @ARGV

; my %actions =
    ( 'cleanup' => sub
        { need "File::Next"
	; need "Getopt::Std::Strict 'd:p:'"
	; need "Cwd()"
	; need "Perl6::Junction qw(any)"
	; my $workdir = Cwd::getcwd()
		
	; defined($jat::opt_p) &&
	    (local $jat::DEFAULT_CLEANUP_PATTERN = $jat::opt_p)
	; defined($jat::opt_d) && ($workdir = $jat::opt_d)

	; my $iter = File::Next::files
	   ({ file_filter => sub { /${jat::DEFAULT_CLEANUP_PATTERN}/ }
	    , descend_filter => sub { any(qw/.svn .git CVS/) ne $_ }
            }, $workdir 
	   )
	; while(defined(my $file = $iter->()))
	    { unlink($file) || warn "Can't delete '$file'.\n"
            }
	}
    )

; exists($actions{$action}) ? $actions{$action}->() 
    : usage("Unknown action '$action'.")
