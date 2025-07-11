# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

package Kernel::System::FAQ::Language;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::FAQ::Language - sub module of Kernel::System::FAQ

=head1 DESCRIPTION

All FAQ language functions.

=head1 PUBLIC INTERFACE

=head2 LanguageAdd()

add a language

    my $Success = $FAQObject->LanguageAdd(
        Name   => 'Some Language',
        UserID => 1,
    );

Returns:

    $Success = 1;               # or undef if language could not be added

=cut

sub LanguageAdd {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(Name UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            INSERT INTO faq_language (name)
            VALUES (?)',
        Bind => [ \$Param{Name} ],
    );

    return 1;
}

=head2 LanguageDelete()

Delete a language.

    my $DeleteSuccess = $FAQObject->LanguageDelete(
        LanguageID => 123,
        UserID      => 1,
    );

Returns

    $DeleteSuccess = 1;             # or undef if language could not be deleted

=cut

sub LanguageDelete {
    my ( $Self, %Param ) = @_;

    for my $Attribute (qw(LanguageID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );

            return;
        }
    }

    # delete the language
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            DELETE FROM faq_language
            WHERE id = ?',
        Bind => [ \$Param{LanguageID} ],
    );

    return 1;
}

=head2 LanguageDuplicateCheck()

check a language

    my $Exists = $FAQObject->LanguageDuplicateCheck(
        Name       => 'Some Name',
        LanguageID => 1,        # for update
        UserID     => 1,
    );

Returns:

    $Exists = 1;                # if language already exists, or 0 if does not exist

=cut

sub LanguageDuplicateCheck {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );

        return;
    }

    # build SQL
    my @Bind = ( \$Param{Name} );
    my $SQL  = '
        SELECT id
        FROM faq_language
        WHERE name = ?';
    if ( defined $Param{LanguageID} ) {
        push @Bind, \$Param{LanguageID};
        $SQL .= " AND id != ?";
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # prepare SQL statement
    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
        Bind  => \@Bind,
    );

    # fetch the result
    my $Exists;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Exists = 1;
    }

    return $Exists;
}

=head2 LanguageGet()

get a language details as a hash

    my %Language = $FAQObject->LanguageGet(
        LanguageID => 1,
        UserID     => 1,
    );

Returns:

    %Language = (
        LanguageID => '1',
        Name       => 'en',
    );

=cut

sub LanguageGet {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(LanguageID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # SQL
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, name
            FROM faq_language
            WHERE id = ?',
        Bind  => [ \$Param{LanguageID} ],
        Limit => 1,
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        %Data = (
            LanguageID => $Row[0],
            Name       => $Row[1],
        );
    }

    return %Data;
}

=head2 LanguageList()

get the language list as a hash

    my %Languages = $FAQObject->LanguageList(
        UserID => 1,
    );

Returns:

    %Languages = (
        1 => 'en',
        2 => 'de',
        3 => 'es',
    );

=cut

sub LanguageList {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );

        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # build SQL
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, name
            FROM faq_language',
    );

    # fetch the result
    my %List;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $List{ $Row[0] } = $Row[1];
    }

    return %List;
}

=head2 LanguageLookup()

This method does a lookup for a FAQ language.
If a language id is given, it returns the name of the language.
If the name of the language is given, the language id is returned.

    my $LanguageName = $FAQObject->LanguageLookup(
        LanguageID => 1,
    );

    my $LanguageID = $FAQObject->LanguageLookup(
        Name => 'en',
    );

Returns:

    $LanguageName = 'en';

    $LanguageID = 1;

=cut

sub LanguageLookup {
    my ( $Self, %Param ) = @_;

    # check if both parameters are given
    if ( $Param{LanguageID} && $Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need LanguageID or Name - not both!',
        );

        return;
    }

    # check if both parameters are not given
    if ( !$Param{LanguageID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need LanguageID or Name - none is given!',
        );

        return;
    }

    # check if LanguageID is a number
    if ( $Param{LanguageID} && $Param{LanguageID} !~ m{ \A \d+ \z }xms ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "LanguageID must be a number! (LanguageID: $Param{LanguageID})",
        );

        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # prepare SQL statements
    if ( $Param{LanguageID} ) {

        return if !$DBObject->Prepare(
            SQL => '
                SELECT name
                FROM faq_language
                WHERE id = ?',
            Bind  => [ \$Param{LanguageID} ],
            Limit => 1,
        );
    }
    elsif ( $Param{Name} ) {

        return if !$DBObject->Prepare(
            SQL => '
                SELECT id
                FROM faq_language
                WHERE name = ?',
            Bind  => [ \$Param{Name} ],
            Limit => 1,
        );
    }

    # fetch the result
    my $Lookup;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Lookup = $Row[0];
    }

    return $Lookup;
}

=head2 LanguageUpdate()

update a language

    my $Success = $FAQObject->LanguageUpdate(
        LanguageID => 1,
        Name       => 'de',
        UserID     => 1,
    );

Returns:

    $Success = 1;               # or undef if language could not be updated

=cut

sub LanguageUpdate {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(LanguageID Name UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # build SQL
    return if !$DBObject->Do(
        SQL => '
            UPDATE faq_language
            SET name = ?
            WHERE id = ?',
        Bind => [ \$Param{Name}, \$Param{LanguageID} ],
    );

    # delete all cache, as FAQGet() will be also affected.
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'FAQ',
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
