use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

print "\n";
print "After installation of CGI::TabPane, you must copy the 2 directories \n";
print "css/tabpane/, and js/tabpane/ from the distro to your web server's doc root. \n";
print "\n";

WriteMakefile
(
	($] ge '5.005') ?
	(
		'AUTHOR'	=> 'Ron Savage (ron@savage.net.au)',
		'ABSTRACT'	=> 'Support panes with clickable tabs',
    ) : (),
	clean			=>
	{
		FILES		=> 'blib/* Makefile MANIFEST CGI-TabPane-*'
	},
	dist			=>
	{
		COMPRESS	=> 'gzip',
		SUFFIX		=> 'gz'
	},
	DISTNAME		=> 'CGI-TabPane',
	NAME			=> 'CGI::TabPane',
	PL_FILES		=> {},
	PREREQ_PM		=>
	{
		Carp		=> 0,
		Test::More	=> 0,
		Test::Pod	=> 0,
	},
	VERSION_FROM	=> 'lib/CGI/TabPane.pm',
);
