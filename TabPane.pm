package CGI::TabPane;

# Name:
#	CGI::TabPane.
#
# Documentation:
#	POD-style documentation is at the end. Extract it with pod2html.*.
#
# Reference:
#	Object Oriented Perl
#	Damian Conway
#	Manning
#	1-884777-79-1
#	P 114
#
# Note:
#	o Tab = 4 spaces || die.
#
# Author:
#	Ron Savage <ron@savage.net.au>
#	Home page: http://savage.net.au/index.html
#
# Licence:
#	Australian copyright (c) 2004 Ron Savage.
#
#	All Programs of mine are 'OSI Certified Open Source Software';
#	you can redistribute them and/or modify them under the terms of
#	The Artistic License, a copy of which is available at:
#	http://www.opensource.org/licenses/index.html

use strict;
use warnings;
no warnings 'redefine';

use Carp;

require 5.005_62;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use CGI::TabPane ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(

) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(

);
our $VERSION = '1.02';

# -----------------------------------------------

# Preloaded methods go here.

# -----------------------------------------------

# Encapsulated class data.

{
	my(%_attr_data) =
	(	# Alphabetical order.
		_current_tab	=> '',
		_data			=> '',
		_final_css		=> '/css/tabpane/final.css',
		_html			=> '',
		_infix_html		=> '',
		_prefix_html	=> '',
		_style_css		=> '/css/tabpane/luna.css',
		_suffix_html	=> '',
		_tabpane_js		=> '/js/tabpane/tabpane.js',
		_use_cookie		=> 1,
		_webfxlayout_js	=> '/js/tabpane/webfxlayout.js',
	);

	sub _build
	{
		my($self, $pane_id, $pane, $nested) = @_;
		my($html)	= qq|<div class = "tab-pane" id = "tabPane$pane_id">\n|;
		$html		.= qq|<script type = "text/javascript">tp1 = new WebFXTabPane(document.getElementById("tabPane$pane_id"), $$self{'_use_cookie'});</script>\n| if ($pane_id == 0);

		my($tab_index);

		for my $tab (0 .. $#$pane)
		{
			# Arbitrarily limit the number of tabs per pane to 66, even though I hate to do this.
			# This $page_id is the HTML id (name) of the tab within the page.

			my($page_id)	= 66 * $nested + $tab;
			my(@key)		= keys %{$$pane[$tab]};
			$tab_index		= $tab if (! $nested && ($key[0] eq $$self{'_current_tab'}) );
			$html			.= ($pane_id == 0) ? qq|<div class = "tab-page" id = "tabPage$page_id">\n| : qq|<div class = "tab-page">\n|;
			$html			.= qq|<h2 class = "tab">$key[0]</h2>\n|;
			$html			.= qq|<script type = "text/javascript">tp1.addTabPage(document.getElementById("tabPage$page_id") );</script>\n| if ($pane_id == 0);

			if (ref($$pane[$tab]{$key[0]}) eq 'HASH')
			{
				my(@legend)	= keys %{$$pane[$tab]{$key[0]} };
				$html		.=	qq|<fieldset>\n| .
								qq|<legend>$legend[0]</legend>\n| .
								qq|$$pane[$tab]{$key[0]}{$legend[0]}\n| .
								qq|</fieldset>|;
			}
			elsif (ref($$pane[$tab]{$key[0]}) eq 'ARRAY')
			{
				# Arbitrarity limit the number of non-nested panes to 100, even though I hate to do this.
				# This (99 + $pane_id) is the id (name) of the first nested pane.

				$html .= $self -> _build( (99 + $pane_id), $$pane[$tab]{$key[0]}, 1);
			}
			else
			{
				$html .= qq|$$pane[$tab]{$key[0]}\n|;
			}

			$html .= qq|</div>\n|;
		}

		$html .= qq|<script type = "text/javascript">tp1.setSelectedIndex($tab_index);</script>\n| if (! $nested && $tab_index);
		$html .= qq|</div>\n|;

	}	# End of _build.

	sub _default_for
	{
		my($self, $attr_name) = @_;

		$_attr_data{$attr_name};
	}

	sub _standard_keys
	{
		keys %_attr_data;
	}

}	# End of encapsulated class data.

# -----------------------------------------------

sub get
{
	my($self, $arg) = @_;

	my($result);

	for my $attr_name ($self -> _standard_keys() )
	{
		my($arg_name) = $attr_name =~ /^_(.*)/;

		if (exists($$self{$attr_name}) && ($arg eq $arg_name) )
		{
			$result = $$self{$attr_name};
		}
	}

	$result;

}	# End of get.

# -----------------------------------------------

sub new
{
	my($caller, %arg)	= @_;
	my($caller_is_obj)	= ref($caller);
	my($class)			= $caller_is_obj || $caller;
	my($self)			= bless({}, $class);

	for my $attr_name ($self -> _standard_keys() )
	{
		my($arg_name) = $attr_name =~ /^_(.*)/;

		if (exists($arg{$arg_name}) )
		{
			$$self{$attr_name} = $arg{$arg_name};
		}
		elsif ($caller_is_obj)
		{
			$$self{$attr_name} = $$caller{$attr_name};
		}
		else
		{
			$$self{$attr_name} = $self -> _default_for($attr_name);
		}
	}

	croak(__PACKAGE__ . ". You must supply a value for the 'data' parameter") if (! $$self{'_data'});

	$$self{'_html'} .= $$self{'_prefix_html'};

	for my $p (0 .. $#{$$self{'_data'} })
	{
		$$self{'_html'} .= $self -> _build($p, $$self{'_data'}[$p], 0) . $$self{'_infix_html'};
	}

	$$self{'_html'} .= $$self{'_suffix_html'};

	return $self;

}	# End of new.

# -----------------------------------------------

sub set
{
	my($self, %arg) = @_;

	for my $attr_name ($self -> _standard_keys() )
	{
		my($arg_name) = $attr_name =~ /^_(.*)/;

		if (exists($arg{$arg_name}) )
		{
			$$self{$attr_name} = $arg{$arg_name};
		}
	}

}	# End of set.

# -----------------------------------------------

1;

__END__

=head1 NAME

C<CGI::TabPane> - Support panes with clickable tabs

=head1 Synopsis

	use CGI::TabPane;

	CGI::TabPane -> new(data => [...]) -> get('html');

=head1 Description

C<CGI::TabPane> is a pure Perl module.

It is a wrapper around the superb JavaScript package 'Tab Pane' by Erik Arvidsson.

Erik's article on Tab Pane is here: http://webfx.eae.net/dhtml/tabpane/tabpane.html

I have simplified some of Erik's files, and renamed some, to make shipping and installing easier.

=head1 Installation

The makefile will install /perl/site/lib/CGI/TabPane.pm.

You must manually install <Document Root>/css/tabpane/*.[css|png] and <Document Root>/js/tabpane/*.js.

If you choose to put the CSS elsewhere, you'll need to call new(final_css => '/new/path/final.css').
Similarly for style_css.

Note: If you put webfxlayout.css elsewhere, you'll have to edit webfxlayout.js.

If you choose to put the JavaScript elsewhere, you'll need to call new(tabpane_js => '/new/path/tabpane.css').
Similarly for webfxlayout_js.

These options can be used together, and can be passed into C<set()> rather than C<new()>.

=head1 Distributions

This module is available both as a Unix-style distro (*.tgz) and an
ActiveState-style distro (*.ppd). The latter is shipped in a *.zip file.

See http://savage.net.au/Perl-modules.html for details.

See http://savage.net.au/Perl-modules/html/installing-a-module.html for
help on unpacking and installing each type of distro.

=head1 Constructor and initialization

new(...) returns a C<CGI::TabPane> object.

This is the class's contructor.

Usage: CGI::TabPane -> new().

This method takes a set of parameters. Only the data parameter is mandatory.

For each parameter you wish to use, call new as new(param_1 => value_1, ...).

=over 4

=item current_tab

This value is a string, the name of tab, used to specify which tab on the first pane is to be the current tab
when that pane is displayed.

For example, tab 'Search' could contain a CGI form, with that tab being the default or current tab the first time the
CGI script is called to generate output. Then, when the submit button on that form is clicked, the CGI script could
generate the next lot of output with a different tab, e.g. tab 'Results', being the current tab.

There is no provision for controlling which tab is the current tab on any pane after the first pane.

The default value is ''.

This parameter is optional.

Note: In the JavaScript, the tabs are numbered left to right, starting at 0.

=item data

This value holds all the information required to build the panes and tabs per pane.

See the sections below called 'Terminology' and 'The Structure of the Data' for details.

The default value is '' (the empty string), which will die because you must pass in an array ref.

This parameter is mandatory.

=item final_css

This value is the name of a CSS file. The module ships with a suitable file called final.css.

Warning: Do not edit final.css. Even tiny changes will have horrible effects on the output.

The default value is '/css/tabpane/final.css'.

This parameter is optional.

=item html

Normally you would not do this, but if you want, you can pass in a value for the C<html> parameter, and the
HTML generated by this module will be appended to your initial value.

The default value is ''.

This parameter is optional.

=item infix_html

This value is a string of HTML to be inserted between panes, to separate them vertically.

A typical value might be: '<p>&nbsp;</p><p>&nbsp;</p>'.

The default value is '' (the empty string).

This parameter is optional.

=item prefix_html

This value is a string of HTML to be inserted before the first pane.

A typical value might be: '<p>&nbsp;</p><p>&nbsp;</p>'.

The default value is '' (the empty string).

This parameter is optional.

=item style_css

This value is the name of a CSS file which determines the overall style of the output. The module ships with
three suitable files:

=over 4

=item luna.css

=item webfx.css

=item winclassic.css

=back

The default value is '/css/tabpane/luna.css'.

This parameter is optional.

=item suffix_html

This value is a string of HTML to be inserted after the last pane.

A typical value might be: '<p>&nbsp;</p><p>&nbsp;</p>'.

The default value is '' (the empty string).

This parameter is optional.

=item tabpane_js

This value is the name of a JavaScript file. The module ships with a suitable file called tabpane.js.

Warning: Do not edit tabpane.js. Even tiny changes will have horrible effects on the output.

The default value is '/js/tabpane/tabpane.js'.

This parameter is optional.

=item use_cookie

This value is a Boolean, 0 or 1, which respectively deactivates or activates the persistance option of the WebFXTabPane
class in tabpane.js. Activation means the JavaScript uses a cookie to save the state of which tab on the first pane is
the current tab.

The default value is 1, since that's the default in the WebFXTabPane class, and so that's what will have been used in
the past when this module was run without this parameter.

There is no provision for saving the state of which tab is the current tab on any pane after the first pane, because
the name of the cookie does not include any indicator as to which pane the current tab belongs to.

This parameter is optional.

Historical note: The word Boolean must have a capital B because it's based on the name of a person - George Boole.

=item webfxlayout_js

This value is the name of a JavaScript file. The module ships with a suitable file called webfxlayout.js.

Warning: Do not edit webfxlayout.js. Even tiny changes will have horrible effects on the output.

The default value is '/js/tabpane/webfxlayout.js'.

This parameter is optional.

=back

=head1 Terminology

The comments below this diagram define a few terms.

The example shipped with this module will make things much clearer. See the examples/ directory.

Alternately, go straight to Erik's demo at: http://webfx.eae.net/dhtml/tabpane/demo.html

	[Tab 1-1] [Tab 1-2] [TAB 1-3] [Tab 1-4]
	[===============================================]
	[ Text for tab 1-3                              ]
	[===============================================]

	[TAB 2-1] [Tab 2-2]
	[==============================]
	[ +Legend--------------------+ ]
	[ |Text for tab 2-1          | ]
	[ +--------------------------+ ]
	[==============================]

=over 4

=item Pane

We have 2 'panes', one on top of the other.

Panes are tiled vertically.

Use the C<infix_html> parameter to C<new()> or C<set()> to change the vertical separation of the panes.

=item Tab

The top pane has 4 'tabs' side-by-side. The bottom pane has 2 tabs.

Tabs are tiled horizontally.

=item Current tab

The current tab within a pane is the tab most-recently clicked.

Tab 3 in the 1st pane and tab 1 in the 2nd pane are in upper case in the diagram to indicate they are the
'current tab' in each pane. The upper case above is just something I made up for the purposes of writing this
document. Of course, text is not converted to upper case by this module.

	Note: Tabs can be clicked with a mouse, and they can be clicked by executing code.

=item Current text

The text associated with the current tab is called the 'current text'.

=item Body

When a tab is clicked it becomes the current tab, and its text becomes the current text, and this text is displayed
in the 'body' of the pane, completely replacing any existing text being displayed in the body.

=item Legend

It is possible to use the HTML tag 'legend' to cause a box to be drawn by the web client (browser) around the current
text.

Further, it is possible to get the web client to write a string of text on top of the upper left part of this box.

Such a string is called the 'legend'. See above for an example. See the examples/ directory for a better example.

=back

=head1 The Structure of the Data

Our first problem is to define a data structure which allows us to neatly supply our own data to populate a set
of panes and each set of tabs per pane.

=over 4

=item Data for a set of panes

The data structure defining the panes is an array ref. Each element of the array provides data for 1 pane.

So, the above diagram will be something like:

	[<Data for 1st pane>, <Data for 2nd pane>].

=item Data for a set of tabs

The data structure defining the tabs for 1 pane is an array ref. Each element of the array provides data for 1 tab.

So, the above diagram will be something like:

	<Data for 1st pane>:

	[<Data for 1st tab of 1st pane>, <Data for 2nd tab of 1st pane>, ...].

	<Data for 2nd pane>:

	[<Data for 1st tab of 2nd pane>, <Data for 2nd tab of 2nd pane>].

=item Data for 1 tab without a legend

In the absence of a legend, the data for 1 tab is a hash ref:

	<Data for any tab (without a legend) of any pane>:

	{'Text for tab' => 'Text for body of pane'}

Recall from the discussion of 'body' above: 'Text for body of pane' means the text which is to be displayed when
this particular tab if clicked.

In the diagram, then, the data for the 3rd tab of the 1st pane is:

	{'Tab 1-3' => 'Text for tab 1-3'}

=item Data for 1 tab with a legend

In the presence of a legend, the data for 1 tab is a hash ref within a hash ref:

	<Data for any tab (with a legend) of any pane>:

	{'Text for tab' => {'Text for legend' => 'Text for body of pane'} }

In the diagram, then, the data for the 1st tab of the 2nd pane is:

	{'Tab 2-1' => {'Legend' => 'Text for tab 2-1'} }

=item Data for nested panes and tabs

In the presence of nested panes, the data for 1 tab is an array ref within a hash ref:

	<Data for a nested pane>:

	{'Text for tab' => [<Data for 1st nested tab>, <Data for 2nd nested tab>, ...]}

Warning: This module will only handle 2 levels in this hierarchy of nesting, since it uses hard-coded CSS tokens for
the classes of the <div>s involved. By '2 levels' I mean 1 outer pane and 1 inner pane.

Warning: To have one nested pane, with its own set of tabs, makes sense. To add more complexity than that surely
means your design is too complex. By 'more complexity' I mean 2 panes displayed vertically within 1 pane.
So don't do that.

=back

Lastly, the entire data structure for the diagram could be:

	[      # All panes
	    [  # 1st pane
	        {'Tab 1-1' => 'Text for tab 1-1'},
	        {'Tab 1-2' => 'Text for tab 1-2'},
	        {'Tab 1-3' => 'Text for tab 1-3'},
	        {'Tab 1-4' => 'Text for tab 1-4'},
	    ],
	    [  # 2nd pane
	        {'Tab 2-1' => {'Legend' => 'Text for tab 2-1'} },
	        {'Tab 2-2' => 'Text for tab 2-2'},
	    ],
	]

You are strongly urged to examine the demo examples/test-cgi-tabpane.cgi to get an understanding of how to construct
the required data structure.

=head1 Limitations

The numbers of the panes, 0 .. N, and the numbers of tabs per pane, 0 .. N, are used to generate strings which in turn
as used as names of things in the JavaScript and HTML.

The non-Perl code will only work if these names are unique. So, you are limited to 99 panes and 66 tabs per pane.

The Perl code does not check to ensure you are within in these limits.

=head1 Method: get($name_of_thing_to_get)

Returns a string.

The 'name of the thing to get' is any of the parameters which can be passed in to C<new()>:

=over 4

=item data

=item final_css

=item html

This is the one which you absolutely must call.

=item infix_html

=item prefix_html

=item style_css

=item suffix_html

=item tabpane_js

=item webfxlayout_js

=back

In each case, the current value of the parameter held within the C<CGI::TabPane> object is returned.

See the demo examples/test-cgi-tabpane.cgi for an example.

=head1 Example code

See the examples/ directory in the distro.

=head1 Required Modules

Carp.

=head1 Changes

See Changes.txt.

=head1 Related Modules

CGI::Explorer, also one of my modules, is a pure Perl wrapper around another superb package from the House of EAE,
this time 'XTree' by Emil A Eklund.

Emil and Erik share the web site http://webfx.eae.net/ - please drop in there and express your thanx.

=head1 Author

C<CGI::TabPane> was written by Ron Savage I<E<lt>ron@savage.net.auE<gt>> in 2004.

Home page: http://savage.net.au/index.html

=head1 Copyright

Australian copyright (c) 2004, Ron Savage. All rights reserved.

	All Programs of mine are 'OSI Certified Open Source Software';
	you can redistribute them and/or modify them under the terms of
	The Artistic License, a copy of which is available at:
	http://www.opensource.org/licenses/index.html

=cut
