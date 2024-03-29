#!/usr/bin/perl
#
# Name:
#	test-cgi-tabpane.cgi.

use strict;
use warnings;

use CGI;
use CGI::TabPane;

# -----------------------------------------------

sub init
{
	my($pane_1_tab_0)	= <<EOS;
General: This is text of tab 1. This is text of tab 1. This is text of tab 1.
<br />
General: This is text of tab 1. This is text of tab 1. This is text of tab 1.
<br />
General: This is text of tab 1. This is text of tab 1. This is text of tab 1.
EOS
	my($pane_1_tab_1)	= <<EOS;
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
<br />
<br />
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
<br />
<br />
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
<br />
<br />
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
<br />
<br />
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Security: This is text of tab 2. This is text of tab 2. This is text of tab 2.
EOS
	my($pane_1_tab_2)	= <<EOS;
Privacy: This is text of tab 3. This is text of tab 3. This is text of tab 3.
<br />
<br />
Privacy: This is text of tab 3. This is text of tab 3. This is text of tab 3.
Privacy: This is text of tab 3. This is text of tab 3. This is text of tab 3.
EOS
	my($pane_1_tab_3)	= <<EOS;
Content: This is text of tab 4. This is text of tab 4. This is text of tab 4.
Content: This is text of tab 4. This is text of tab 4. This is text of tab 4.
<br />
<br />
Content: This is text of tab 4. This is text of tab 4. This is text of tab 4.
EOS
	my($pane_2_tab_0)	= <<EOS;
Options: This is text of tab 1. This is text of tab 1. This is text of tab 1.
<br />
Options: This is text of tab 1. This is text of tab 1. This is text of tab 1.
<br />
Options: This is text of tab 1. This is text of tab 1. This is text of tab 1.
EOS
	my($pane_2_tab_1)	= <<EOS;
Results: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Results: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Results: This is text of tab 2. This is text of tab 2. This is text of tab 2.
<br />
<br />
Results: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Results: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Results: This is text of tab 2. This is text of tab 2. This is text of tab 2.
EOS
	my($pane_2_tab_2_0)	= <<EOS;
Actions: This is text of tab 1. This is text of tab 1. This is text of tab 1.
<br />
Actions: This is text of tab 1. This is text of tab 1. This is text of tab 1.
<br />
Actions: This is text of tab 1. This is text of tab 1. This is text of tab 1.
EOS
	my($pane_2_tab_2_1)	= <<EOS;
Sites: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Sites: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Sites: This is text of tab 2. This is text of tab 2. This is text of tab 2.
<br />
Sites: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Sites: This is text of tab 2. This is text of tab 2. This is text of tab 2.
Sites: This is text of tab 2. This is text of tab 2. This is text of tab 2.
EOS
	my($pane_1) =
	[
		{General	=> $pane_1_tab_0},
		{Security	=> $pane_1_tab_1},
		{Privacy	=> $pane_1_tab_2},
		{Content	=> {Kontent => $pane_1_tab_3} },
	];
	my($pane_2)	=
	[
		{Options	=> $pane_2_tab_0},
		{Results	=> $pane_2_tab_1},
		{Nested		=>
		[
			{Actions	=> $pane_2_tab_2_0},
			{Sites		=> $pane_2_tab_2_1},
		]},
	];

	[$pane_1, $pane_2];

}	# End of init.

# -----------------------------------------------

my($title)	= 'Tab Pane Demo (WebFX)';
my($q)		= CGI -> new();
my($spacer)	= '<p>&nbsp;</p>';
my($pane)	= CGI::TabPane -> new
(
	current_tab	=> 'Privacy',
	data		=> init(),
	infix_html	=> $spacer,
	prefix_html	=> $spacer,
	style_css	=> '/css/tabpane/luna.css',
	use_cookie	=> 0,
);
my($final)			= $pane -> get('final_css');
my($html)			= $pane -> get('html');
my($style)			= $pane -> get('style_css');
my($tabpane)		= $pane -> get('tabpane_js');
my($webfxlayout)	= $pane -> get('webfxlayout_js');

print $q -> header({type => 'text/html;charset=ISO-8859-1'}), <<EOS;
<html>
	<head>
		<title>$title</title>
		<link type = "text/css" rel = "stylesheet" href = "$style" /> <!-- Any 1 of those shipped.         -->
		<link type = "text/css" rel = "stylesheet" href = "$final" /> <!-- Must follow the previous link.  -->
		<script type = "text/javascript" src = "$tabpane"></script>
		<script type = "text/javascript" src = "$webfxlayout"></script>
	</head>
	<body>
		$html
	</body>
</html>
EOS
