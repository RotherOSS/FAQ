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

package Kernel::System::FAQ::Vote;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::FAQ::Vote - sub module of Kernel::System::FAQ

=head1 DESCRIPTION

All FAQ vote functions.

=head1 PUBLIC INTERFACE

=head2 VoteAdd()

add a vote

    my $Success = $FAQObject->VoteAdd(
        CreatedBy => 'Some Text',
        ItemID    => '123456',
        IP        => '54.43.30.1',
        Interface => 'Some Text',
        Rate      => 100,
        UserID    => 1,
    );

Returns:

    $Success = 1;              # or undef if vote could not be added

=cut

sub VoteAdd {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(CreatedBy ItemID IP Interface UserID)) {
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
            INSERT INTO faq_voting (created_by, item_id, ip, interface, rate, created )
            VALUES ( ?, ?, ?, ?, ?, current_timestamp )',
        Bind => [
            \$Param{CreatedBy}, \$Param{ItemID}, \$Param{IP}, \$Param{Interface},
            \$Param{Rate},
        ],
    );

    # delete cache
    my $CacheKey = 'ItemVoteDataGet::' . $Param{ItemID};
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'FAQ',
        Key  => $CacheKey,
    );

    return 1;
}

=head2 VoteDelete()

delete a vote

    my $DeleteSuccess = $FAQObject->VoteDelete(
        VoteID => 1,
        UserID => 1,
    );

Returns:

    $DeleteSuccess = 1;              # or undef if vote could not be deleted

=cut

sub VoteDelete {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(VoteID UserID)) {
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
            DELETE FROM faq_voting
            WHERE id = ?',
        Bind => [ \$Param{VoteID} ],
    );

    return 1;
}

=head2 VoteGet()

get a vote information

    my %VoteData = $FAQObject->VoteGet(
        CreateBy  => 'Some Text',
        ItemID    => '123456',
        IP        => '127.0.0.1',
        Interface => 'Some Text',
        UserID    => 1,
    );

Returns:

    %VoteData = (
        ItemID    => 23,
        Rate      => 50,                            # or 0 or 25 or 75 or 100
        IP        => '192.168.0.1',
        Interface => 1,                             # interface ID
        CreatedBy => 1,
        Created   => '2011-06-14 12:32:03',
    );

=cut

sub VoteGet {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(CreateBy ItemID Interface IP UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    my @Values;
    my $SQL = '
        SELECT created_by, item_id, interface, ip, created, rate
        FROM faq_voting
        WHERE';

    # public
    if ( $Param{Interface} eq '3' ) {
        $SQL .= '
            ip = ?
            AND item_id = ?';
        push @Values, ( \$Param{IP}, \$Param{ItemID} );
    }

    # customer
    elsif ( $Param{Interface} eq '2' || $Param{Interface} eq '1' ) {
        $SQL .= '
            created_by = ?
            AND item_id = ?';
        push @Values, ( \$Param{CreateBy}, \$Param{ItemID} );
    }

    # leave a space between AND condition and ORDER BY statement
    $SQL .= '
        ORDER BY created DESC';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Values,
        Limit => 1,
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        %Data = (
            CreatedBy => $Row[0],
            ItemID    => $Row[1],
            Interface => $Row[2],
            IP        => $Row[3],
            Created   => $Row[4],
            Rate      => $Row[5],
        );
    }

    return if !%Data;
    return \%Data;
}

=head2 VoteSearch()

returns an array with VoteIDs

    my $VoteIDArrayref = $FAQObject->VoteSearch(
        ItemID => 1,
        UserID => 1,
    );

Returns:

    $VoteIDArrayref = [
        23,
        45,
    ];

=cut

sub VoteSearch {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(ItemID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => '
            SELECT id
            FROM faq_voting
            WHERE item_id = ?',
        Bind  => [ \$Param{ItemID} ],
        Limit => 1,
    );

    my @VoteIDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @VoteIDs, $Row[0];
    }

    return \@VoteIDs;
}

=head2 ItemVoteDataGet()

Returns a hash reference with the number of votes and the vote result.

    my $VoteDataHashRef = $FAQObject->ItemVoteDataGet(
        ItemID => 123,
        UserID => 1,
    );

Returns:

    $VoteDataHashRef = {
        Result => 75.0000,
        Votes  => 5
    };

=cut

sub ItemVoteDataGet {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(ItemID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $CacheKey = 'ItemVoteDataGet::' . $Param{ItemID};
    my $Cache    = $CacheObject->Get(
        Type => 'FAQ',
        Key  => $CacheKey,
    );

    return $Cache if $Cache;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get vote from db
    return if !$DBObject->Prepare(
        SQL => '
            SELECT count(*), avg(rate)
            FROM faq_voting
            WHERE item_id = ?',
        Bind  => [ \$Param{ItemID} ],
        Limit => 1,
    );

    # fetch the result
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{Votes}  = $Row[0];
        $Data{Result} = $Row[1];
    }

    # cache result
    $CacheObject->Set(
        Type  => 'FAQ',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => 60 * 60 * 24 * 2,
    );

    return \%Data;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
