#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';

my $template = 'template.svg';

sub xml_escape {
    my ($value) = @_;
    $value =~ s/&/&amp;/g;
    $value =~ s/</&lt;/g;
    $value =~ s/>/&gt;/g;
    $value =~ s/"/&quot;/g;
    $value =~ s/'/&apos;/g;
    return $value;
}

sub replace_element_text {
    my ($svg_ref, $element_id, $text) = @_;
    my $escaped_text = xml_escape($text) . '</tspan></text>';
    my $pattern = $element_id . '</tspan></text>';

    ## Debug:
    #print "Replacing text for element '$pattern' with '$escaped_text'\n";

    $$svg_ref =~ s/$pattern/$escaped_text/
        or die "Could not find text element '$element_id' and $pattern\n";
}

sub generate_svg {
    my ($input) = @_;
    my %args = %{$input};

    die "title is required\n" unless exists $args{title};
    die "text is required\n" unless exists $args{text};
    die "type is required\n" unless exists $args{type};

    ## TODO: implement templates for other types ( now only 'battle' works)
    my $is_battle = lc($args{type}) eq 'battle';
    ##

    open my $template_fh, '<:encoding(UTF-8)', $template
        or die "Cannot open '$template': $!\n";
    local $/;
    my $svg = <$template_fh>;
    close $template_fh;

    replace_element_text(\$svg, 'Card Title', $args{title});
    replace_element_text(\$svg, 'Caption text', $args{text});

    my $number;
    for my $candidate (1 .. 99) {
        $number = sprintf('%02d', $candidate);
        last unless -e "output$number.svg";
    }
    die "No available outputXX.svg name (output01.svg through output99.svg exist)\n"
        if -e "output$number.svg";

    my $output = "output$number.svg";
    open my $output_fh, '>:encoding(UTF-8)', $output
        or die "Cannot create '$output': $!\n";
    print {$output_fh} $svg;
    close $output_fh;

    return $output;
}

if (!caller) {
    my %args;
    while (@ARGV) {
        my $option = shift @ARGV;
        if ($option =~ /^--(title|text|type)$/) {
            die "Missing value for $option\n" unless @ARGV;
            my $key = $1 eq 'title' ? 'title' : $1;
            $args{$key} = shift @ARGV;
        } elsif (!exists $args{title}) {
            $args{title} = $option;
        } elsif (!exists $args{text}) {
            $args{text} = $option;
        } elsif (!exists $args{type}) {
            $args{type} = $option;
        } else {
            die "Unknown argument: $option\n";
        }
    }

    my $created = generate_svg(\%args);
    print "$created\n";
}

1;
