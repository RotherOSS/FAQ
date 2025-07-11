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

use strict;
use warnings;

our $Self;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# set config options
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'FAQ::ApprovalRequired',
    Value => 0,
);

# generate a random string to help searches
my $RandomID = $Helper->GetRandomID();

# create different users for CreatedUserIDs search
my @AddedUsers;
for my $Counter ( 1 .. 4 ) {
    my $TestUserLogin = $Helper->TestUserCreate(
        Groups => [ 'admin', 'users' ],
    );
    my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
        UserLogin => $TestUserLogin,
    );
    push @AddedUsers, $UserID;
}

my @AddedFAQs;

# add some FAQs
my %FAQAddTemplate = (
    Title       => "Some Text $RandomID",
    CategoryID  => 1,
    StateID     => 1,
    LanguageID  => 1,
    Keywords    => $RandomID,
    Field1      => 'Problem...',
    Field2      => 'Solution...',
    UserID      => 1,
    ContentType => 'text/html',
);

# freeze time
$Helper->FixedTimeSet();

# get FAQ object
my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

for my $Counter ( 1 .. 2 ) {
    my $ItemID = $FAQObject->FAQAdd(
        %FAQAddTemplate,
        UserID => $AddedUsers[ $Counter - 1 ],
    );

    $Self->IsNot(
        undef,
        $ItemID,
        "FAQAdd() ItemID:'$ItemID' for FAQSearch()",
    );

    push @AddedFAQs, $ItemID;

    # add 1 minute to frozen time
    $Helper->FixedTimeAddSeconds(60);
}

# add some votes
my @VotesToAdd = (
    {
        CreatedBy => 'Some Text',
        ItemID    => $AddedFAQs[0],
        IP        => '54.43.30.1',
        Interface => '2',
        Rate      => 100,
        UserID    => 1,
    },
    {
        CreatedBy => 'Some Text',
        ItemID    => $AddedFAQs[0],
        IP        => '54.43.30.2',
        Interface => '2',
        Rate      => 50,
        UserID    => 1,
    },
    {
        CreatedBy => 'Some Text',
        ItemID    => $AddedFAQs[0],
        IP        => '54.43.30.3',
        Interface => '2',
        Rate      => 50,
        UserID    => 1,
    },
    {
        CreatedBy => 'Some Text',
        ItemID    => $AddedFAQs[1],
        IP        => '54.43.30.1',
        Interface => '2',
        Rate      => 50,
        UserID    => 1,
    },
    {
        CreatedBy => 'Some Text',
        ItemID    => $AddedFAQs[1],
        IP        => '54.43.30.2',
        Interface => '2',
        Rate      => 50,
        UserID    => 1,
    },

);
for my $Vote (@VotesToAdd) {
    my $Success = $FAQObject->VoteAdd( %{$Vote} );

    $Self->True(
        $Success,
        "VoteAdd(): ItemID:'$Vote->{ItemID}' IP:'$Vote->{IP}' Rate:'$Vote->{Rate}' with true",
    );
}

# do vote search tests
my %SearchConfigTemplate = (
    Keyword          => "$RandomID",
    States           => [ 'public', 'internal' ],
    OrderBy          => ['FAQID'],
    OrderByDirection => ['Up'],
    Limit            => 150,
    UserID           => 1,

);
my @Tests = (

    # votes tests
    {
        Name   => 'Votes, Simple Equals Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                Equals => 3,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'Votes, Simple GreaterThan Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                GreaterThan => 2,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'Votes, Simple GreaterThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                GreaterThanEquals => 2,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Simple SmallerThan Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                SmallerThan => 3,
            },
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Simple SmallerThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                SmallerThanEquals => 3,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Multiple Equals Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                Equals => [ 2, 3 ],
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Multiple GreaterThan Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                GreaterThan => [ 1, 2 ],
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Multiple GreaterThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                GreaterThanEquals => [ 2, 3 ]
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Multiple SmallerThan Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                SmallerThan => [ 3, 2 ]
            },
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Multiple SmallerThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                SmallerThanEquals => [ 2, 3 ]
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Wrong Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                LessThanEquals => [4]
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Complex Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                GreaterThan       => 2,
                SmallerThanEquals => 3,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },

    {
        Name   => 'Rate, Simple Equals Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                Equals => 50,
            },
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },

    # Rate tests
    {
        Name   => 'Rate, Simple GreaterThan Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                GreaterThan => 50,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'Rate, Simple GreaterThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                GreaterThanEquals => 50,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Simple SmallerThan Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                SmallerThan => 66,
            },
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Simple SmallerThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                SmallerThanEquals => 67,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Multiple Equals Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                Equals => [ 50, 66.67 ],
            },
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Multiple GreaterThan Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                GreaterThan => [ 20, 40 ],
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Multiple GreaterThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                GreaterThanEquals => [ 50, 66 ]
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Multiple SmallerThan Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                SmallerThan => [ 66, 60 ]
            },
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Multiple SmallerThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                SmallerThanEquals => [ 50, 67 ]
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Wrong Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                LessThanEquals => [10]
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Complex Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                GreaterThan       => [ 50, 60 ],
                SmallerThanEquals => 67,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },

    # complex tests
    {
        Name   => 'Votes, Rate, Complex + Wrong Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                Equals            => [ 2, 3, 4 ],
                GreaterThanEquals => [3],
            },
            Rate => {
                GreaterThan => [ 20,  50 ],
                SmallerThan => [ 100, 120 ],
                LowerThan   => [99],
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
);

# execute the tests
for my $Test (@Tests) {
    my @ItemIDs = $FAQObject->FAQSearch( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \@ItemIDs,
        $Test->{ExpectedResults},
        "$Test->{Name} FAQSearch()",
    );
}

# other tests
@Tests = (
    {
        Name   => 'States Hash Correct IDs',
        Config => {
            %SearchConfigTemplate,
            States => {
                1 => 'Internal',
                2 => 'External',
                3 => 'Public',
            },
        },
        ExpectedResults => [ $AddedFAQs[0], $AddedFAQs[1] ],
    },
    {
        Name   => 'States Hash Incorrect IDs (Float)',
        Config => {
            %SearchConfigTemplate,
            States => {
                1.1 => 'Internal',
                2.2 => 'External',
                3.3 => 'Public',
            },
        },
        ExpectedResults => [],
    },
    {
        Name   => 'States Hash Incorrect IDs (String)',
        Config => {
            %SearchConfigTemplate,
            States => {
                'Internal' => 'Internal',
                'External' => 'External',
                'Public'   => 'Public',
            },
        },
        ExpectedResults => [],
    },

);

# execute the tests
for my $Test (@Tests) {
    my @ItemIDs = $FAQObject->FAQSearch( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \@ItemIDs,
        $Test->{ExpectedResults},
        "$Test->{Name} FAQSearch()",
    );
}

# time based tests

# update FAQs
my %FAQUpdateTemplate = (
    Title       => "New Text $RandomID",
    CategoryID  => 1,
    StateID     => 1,
    LanguageID  => 1,
    Keywords    => $RandomID,
    Field1      => 'Problem...',
    Field2      => 'Solution...',
    UserID      => 1,
    ContentType => 'text/html',
);

# add 1 minute to frozen time
$Helper->FixedTimeAddSeconds(60);

my $Success = $FAQObject->FAQUpdate(
    %FAQUpdateTemplate,
    ItemID => $AddedFAQs[0],
    UserID => $AddedUsers[2],
);

$Self->True(
    $Success,
    "FAQUpdate() ItemID:'$AddedFAQs[0]' for FAQSearch()",
);

$Helper->FixedTimeAddSeconds(60);

$Success = $FAQObject->FAQUpdate(
    %FAQUpdateTemplate,
    ItemID => $AddedFAQs[1],
    UserID => $AddedUsers[3],
);

$Self->True(
    $Success,
    "FAQUpdate() ItemID:'$AddedFAQs[1]' for FAQSearch()",
);

# add 2 minutes to frozen time
$Helper->FixedTimeAddSeconds(120);

my $DateTime = $Kernel::OM->Create('Kernel::System::DateTime');

# Subtract 2 minutes.
$DateTime->Subtract( Seconds => 121 );
my $DateMinus2Mins = $DateTime->ToString();

# Subtract totaly 5 minutes.
$DateTime->Subtract( Seconds => 180 );
my $DateMinus5Mins = $DateTime->ToString();

# Subtract totaly 6 minutes.
$DateTime->Subtract( Seconds => 60 );
my $DateMinus6Mins = $DateTime->ToString();

@Tests = (
    {
        Name   => 'CreateTimeOlderMinutes 3 min',
        Config => {
            %SearchConfigTemplate,
            ItemCreateTimeOlderMinutes => 3,
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'CreateTimeOlderMinutes 6 min',
        Config => {
            %SearchConfigTemplate,
            ItemCreateTimeOlderMinutes => 6,
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'CreateTimeNewerMinutes 6 min',
        Config => {
            %SearchConfigTemplate,
            ItemCreateTimeNewerMinutes => 6,
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'CreateTimeNewerMinutes 5 min',
        Config => {
            %SearchConfigTemplate,
            ItemCreateTimeNewerMinutes => 5,
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'CreateTimeOlderDate 5 min',
        Config => {
            %SearchConfigTemplate,
            ItemCreateTimeOlderDate => $DateMinus5Mins,
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'CreateTimeNewerDate 5 min',
        Config => {
            %SearchConfigTemplate,
            ItemCreateTimeNewerDate => $DateMinus5Mins,
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'CreateTimeOlderDate CreateTimeNewerDate',
        Config => {
            %SearchConfigTemplate,
            ItemCreateTimeNewerDate => $DateMinus6Mins,
            ItemCreateTimeOlderDate => $DateMinus5Mins,
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'ChangeTimeOlderMinutes 3 min',
        Config => {
            %SearchConfigTemplate,
            ItemChangeTimeOlderMinutes => 3,
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'ChangeTimeNewerMinutes 2 min',
        Config => {
            %SearchConfigTemplate,
            ItemChangeTimeNewerMinutes => 2,
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'ChangeTimeOlderDate 2 Min',
        Config => {
            %SearchConfigTemplate,
            ItemChangeTimeOlderDate => $DateMinus2Mins,
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'ChangeTimeNewerDate 2 Min',
        Config => {
            %SearchConfigTemplate,
            ItemChangeTimeNewerDate => $DateMinus2Mins,
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    }
);

# execute the tests
for my $Test (@Tests) {

    my @ItemIDs = $FAQObject->FAQSearch( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \@ItemIDs,
        $Test->{ExpectedResults},
        "$Test->{Name} FAQSearch()",
    );
}

# created user tests
@Tests = (
    {
        Name   => 'CreatedUserIDs 1',
        Config => {
            %SearchConfigTemplate,
            CreatedUserIDs => [ $AddedUsers[0] ],
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'CreatedUserIDs 2',
        Config => {
            %SearchConfigTemplate,
            CreatedUserIDs => [ $AddedUsers[1] ],
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'CreatedUserIDs 1 and 2',
        Config => {
            %SearchConfigTemplate,
            CreatedUserIDs => [ $AddedUsers[0], $AddedUsers[1] ],
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Wrong CreatedUserIDs Format',
        Config => {
            %SearchConfigTemplate,
            CreatedUserIDs => $AddedUsers[0],
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
);

# last changed user tests
@Tests = (
    {
        Name   => 'LastChangedUserIDs 3',
        Config => {
            %SearchConfigTemplate,
            LastChangedUserIDs => [ $AddedUsers[2] ],
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'LastChangedUserIDs 4',
        Config => {
            %SearchConfigTemplate,
            LastChangedUserIDs => [ $AddedUsers[3] ],
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'LastChangedUserIDs 3 and 4',
        Config => {
            %SearchConfigTemplate,
            LastChangedUserIDs => [ $AddedUsers[2], $AddedUsers[3] ],
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Wrong LastChangedUserIDs Format',
        Config => {
            %SearchConfigTemplate,
            LastChangedUserIDs => $AddedUsers[2],
        },
        ExpectedResults => [],
    },
);

# execute the tests
for my $Test (@Tests) {

    my @ItemIDs = $FAQObject->FAQSearch( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \@ItemIDs,
        $Test->{ExpectedResults},
        "$Test->{Name} FAQSearch()",
    );
}

# approval tests
# update database to prevent generation of approval ticket
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => '
        UPDATE faq_item
        SET approved = ?
        WHERE id = ?',
    Bind => [
        \0,
        \$AddedFAQs[1],
    ],
);

@Tests = (
    {
        Name   => 'Approved 1',
        Config => {
            %SearchConfigTemplate,
            Approved => 1,
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'Approved 0',
        Config => {
            %SearchConfigTemplate,
            Approved => 0,
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
);

# execute the tests
for my $Test (@Tests) {

    my @ItemIDs = $FAQObject->FAQSearch( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \@ItemIDs,
        $Test->{ExpectedResults},
        "$Test->{Name} FAQSearch()",
    );
}

# execute old tests
$Self->True(
    1,
    "--Execute Former Tests--",
);
{
    my $ItemID1 = $FAQObject->FAQAdd(
        CategoryID  => 1,
        StateID     => 2,
        LanguageID  => 2,
        Approved    => 1,
        Title       => 'Some Text2',
        Keywords    => "some$RandomID keywords2",
        Field1      => 'Problem...2',
        Field2      => 'Solution found...2',
        UserID      => 1,
        ContentType => 'text/html',
    );
    $Self->True(
        $ItemID1,
        "FAQAdd() - 1",
    );

    # add 1 minute to frozen time
    $Helper->FixedTimeAddSeconds(60);

    my $ItemID2 = $FAQObject->FAQAdd(
        Title       => 'Title' . $RandomID,
        CategoryID  => 1,
        StateID     => 1,
        LanguageID  => 1,
        Keywords    => '',
        Field1      => 'Problem Description 1...',
        Field2      => 'Solution not found1...',
        UserID      => 1,
        ContentType => 'text/html',
    );
    $Self->True(
        $ItemID2,
        "FAQAdd() - 2",
    );

    # add 1 minute to frozen time
    $Helper->FixedTimeAddSeconds(60);

    my %Keywords = (
        Keyword1 => "some1$RandomID",
        Keyword2 => "some2$RandomID",
        Keyword3 => "some3$RandomID",
        Keyword4 => "some4$RandomID",
        Keyword5 => "some5$RandomID",
    );

    my $ItemID3 = $FAQObject->FAQAdd(
        Title       => 'Test FAQ-3',
        CategoryID  => 1,
        StateID     => 1,
        LanguageID  => 1,
        Keywords    => "$Keywords{Keyword1} $Keywords{Keyword2} $Keywords{Keyword3} $Keywords{Keyword5}",
        UserID      => 1,
        ContentType => 'text/html',
    );
    $Self->True(
        $ItemID3,
        "FAQAdd() - 3",
    );

    # add 1 minute to frozen time
    $Helper->FixedTimeAddSeconds(60);

    my $ItemID4 = $FAQObject->FAQAdd(
        Title      => 'Test FAQ-4',
        CategoryID => 1,
        StateID    => 1,
        LanguageID => 1,
        Keywords   => "$Keywords{Keyword1},$Keywords{Keyword2},$Keywords{Keyword3},$Keywords{Keyword4}",

        UserID      => 1,
        ContentType => 'text/html',
    );

    $Self->True(
        $ItemID4,
        "FAQAdd() - 4",
    );

    # add 1 minute to frozen time
    $Helper->FixedTimeAddSeconds(60);

    my $ItemID5 = $FAQObject->FAQAdd(
        Title      => 'Test FAQ-5',
        CategoryID => 1,
        StateID    => 1,
        LanguageID => 1,
        Keywords   => "$Keywords{Keyword1};$Keywords{Keyword2};$Keywords{Keyword3};$Keywords{Keyword4}",

        UserID      => 1,
        ContentType => 'text/html',
    );

    $Self->True(
        $ItemID5,
        "FAQAdd() - 4",
    );

    # restore time
    $Helper->FixedTimeUnset();

    @Tests = (
        {
            Name   => 'Keywords',
            Config => {
                What    => '*s*',
                Keyword => "some$RandomID*",
                OrderBy => ['Votes'],
            },
            ExpectedResults => [
                $ItemID1,
            ],
        },
        {
            Name   => 'Keywords with spaces - all',
            Config => {
                Keyword => "$Keywords{Keyword1} $Keywords{Keyword2}",
            },
            ExpectedResults => [
                $ItemID3,
                $ItemID4,
                $ItemID5,
            ],
        },
        {
            Name   => 'Keywords with comma - all',
            Config => {
                Keyword => "$Keywords{Keyword2},$Keywords{Keyword1}",
            },
            ExpectedResults => [
                $ItemID3,
                $ItemID4,
                $ItemID5,
            ],
        },
        {
            Name   => 'Keywords with semicolon - all',
            Config => {
                Keyword => "$Keywords{Keyword1};$Keywords{Keyword2}",
            },
            ExpectedResults => [
                $ItemID3,
                $ItemID4,
                $ItemID5,
            ],
        },
        {
            Name   => 'Keywords1 Keywords3  with spaces - all',
            Config => {
                Keyword => "$Keywords{Keyword1} $Keywords{Keyword3}",
            },
            ExpectedResults => [
                $ItemID3,
                $ItemID4,
                $ItemID5,
            ],
        },
        {
            Name   => 'Keywords1 Keywords3 with comma - all',
            Config => {
                Keyword => "$Keywords{Keyword1},$Keywords{Keyword3}",
            },
            ExpectedResults => [
                $ItemID3,
                $ItemID4,
                $ItemID5,
            ],
        },
        {
            Name   => 'Keywords1 Keywords3 with semicolon - all',
            Config => {
                Keyword => "$Keywords{Keyword1};$Keywords{Keyword3}",
            },
            ExpectedResults => [
                $ItemID3,
                $ItemID4,
                $ItemID5,
            ],
        },
        {
            Name   => 'Keywords common keyword',
            Config => {
                Keyword => $Keywords{Keyword3},
            },
            ExpectedResults => [
                $ItemID3,
                $ItemID4,
                $ItemID5,
            ],
        },
        {
            Name   => 'Keywords common keyword with wildcards',
            Config => {
                Keyword => '*' . $Keywords{Keyword3} . '*',
            },
            ExpectedResults => [
                $ItemID3,
                $ItemID4,
                $ItemID5,
            ],
        },
        {
            Name   => 'Keywords only Keyword5',
            Config => {
                Keyword => $Keywords{Keyword5},
            },
            ExpectedResults => [
                $ItemID3,
            ],
        },
        {
            Name   => 'Keywords only Keyword4',
            Config => {
                Keyword => $Keywords{Keyword4},
            },
            ExpectedResults => [
                $ItemID4,
                $ItemID5,
            ],
        },
        {
            Name   => 'Keywords only Keyword5 - uppercase string',
            Config => {
                Keyword => uc $Keywords{Keyword5},
            },
            ExpectedResults => [
                $ItemID3,
            ],
        },
        {
            Name   => 'Keywords only Keyword4 - first character uppercase',
            Config => {
                Keyword => ucfirst $Keywords{Keyword4},
            },
            ExpectedResults => [
                $ItemID4,
                $ItemID5,
            ],
        },
        {
            Name   => 'Title',
            Config => {
                Title => 'tITLe' . $RandomID,

                What    => 'l',
                OrderBy => ['Created'],
            },
            ExpectedResults => [
                $ItemID2,
            ],
        },
        {
            Name   => 'What (Literal)',
            Config => {
                Title   => '',
                What    => 'solution found',
                OrderBy => ['Created'],
            },
            ExpectedResults => [
                $ItemID1,
            ],
        },
        {
            Name   => 'What (AND)',
            Config => {
                Title   => '',
                What    => 'solution+found',
                OrderBy => ['Created'],
            },
            ExpectedResults => [
                $ItemID1,
                $ItemID2,
            ],
        },
    );

    for my $Test (@Tests) {

        my @ItemIDs = $FAQObject->FAQSearch(
            Number           => '*',
            States           => [ 'public', 'internal' ],
            OrderByDirection => ['Up'],
            Limit            => 150,
            UserID           => 1,
            %{ $Test->{Config} },
        );

        $Self->IsDeeply(
            \@ItemIDs,
            $Test->{ExpectedResults},
            "$Test->{Name}, FAQSearch()",
        );
    }
}

# cleanup is done by restore database

1;
