use Module::Build;

print "\n";
print "After installation of CGI::TabPane, you must copy the 2 directories \n";
print "css/tabpane/, and js/tabpane/ from the distro to your web server's doc root. \n";
print "\n";

Module::Build -> new
(
	module_name		=> 'CGI::TabPane',
	license			=> 'artistic',
	dist_author		=> 'Ron Savage <ron@savage.net.au>',
	build_requires	=>
	{
		Test::More	=> 0,
		Test::Pod	=> 0,
	},
	requires		=>
	{
		Carp		=> 0,
	},
) -> create_build_script();