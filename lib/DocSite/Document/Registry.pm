use v6;
use DocSite::Document;

class DocSite::Document::Registry {
    has @.documentables;
    has Bool $.composed = False;
    has %!cache;
    has %!grouped-by;
    has @!kinds;
    method add-new(*%args) {
        die "Cannot add something to a composed registry" if $.composed;
        @!documentables.append: my $d = DocSite::Document.new(|%args);
        $d;
    }
    method compose() {
        @!kinds = @.documentables>>.kind.unique;
        $!composed = True;
    }
    method grouped-by(Str $what) {
        die "You need to compose this registry first" unless $.composed;
        %!grouped-by{$what} ||= @!documentables.classify(*."$what"());
    }
    method lookup(Str $what, Str :$by!) {
        unless %!cache{$by}:exists {
            for @!documentables -> $d {
                %!cache{$by}{$d."$by"()}.append: $d;
            }
        }
        %!cache{$by}{$what};
    }

    method get-kinds() {
        die "You need to compose this registry first" unless $.composed;
        @!kinds;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
