
use strict;
use Pod::Simple::Search;
use Test;
BEGIN { plan tests => 4 }

print "# ", __FILE__,
 ": Testing limit_glob ...\n";

my $x = Pod::Simple::Search->new;
die "Couldn't make an object!?" unless ok defined $x;

$x->inc(0);
$x->shadows(1);

use File::Spec;
use Cwd;
my $cwd = cwd();
print "# CWD: $cwd\n";

my($here1, $here2, $here3);

if(        -e ($here1 = File::Spec->catdir($cwd,      'test^lib'      ))) {
  die "But where's $here2?"
    unless -e ($here2 = File::Spec->catdir($cwd,      'other^test^lib'));
  die "But where's $here3?"
    unless -e ($here3 = File::Spec->catdir($cwd,      'yet^another^test^lib'));

} elsif(   -e ($here1 = File::Spec->catdir($cwd, 't', 'test^lib'      ))) {
  die "But where's $here2?"
    unless -e ($here2 = File::Spec->catdir($cwd, 't', 'other^test^lib'));
  die "But where's $here3?"
    unless -e ($here3 = File::Spec->catdir($cwd, 't', 'yet^another^test^lib'));

} else {
  die "Can't find the test corpora";
}
print "# OK, found the test corpora\n#  as $here1\n# and $here2\n# and $here3\n#\n";
ok 1;

print $x->_state_as_string;
#$x->verbose(12);

use Pod::Simple;
*pretty = \&Pod::Simple::BlackBox::pretty;

my $glob = '*z*k*';
print "# Limiting to $glob\n";
$x->limit_glob($glob);

my($name2where, $where2name) = $x->survey($here1, $here2, $here3);

my $p = pretty( $where2name, $name2where )."\n";
$p =~ s/, +/,\n/g;
$p =~ s/^/#  /mg;
print $p;

{
my $names = join "|", sort values %$where2name;
ok $names, "Zonk::Pronk|perlzuk|zikzik";
}


print "# OK, bye from ", __FILE__, "\n";
ok 1;

__END__

