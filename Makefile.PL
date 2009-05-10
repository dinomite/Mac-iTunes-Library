# $Revision$
# $Date$
# $Author$
use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME			=> 'Mac::iTunes::Library',
    ABSTRACT        => 'Interact with iTunes libraries in Perl',
    VERSION_FROM	=> 'lib/Mac/iTunes/Library.pm',
    LICENSE         => "perl",
    AUTHOR			=> 'Drew Stephens <drew@dinomite.net>',
    PREREQ_PM		=> {
				'XML::Parser'	=> '2.36',
				},
);
