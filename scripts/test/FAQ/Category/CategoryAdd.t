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
use utf8;

our $Self;

# get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

my $RandomID = $Helper->GetRandomID();
my @Tests    = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'No Name',
        Config => {
            Comment  => 'Some Comment',
            ParentID => 0,
            ValidID  => 1,
            UserID   => 1,
        },
        Success => 0,
    },
    {
        Name   => 'No ParentID',
        Config => {
            Name    => "TestCategory$RandomID",
            Comment => 'Some Comment',
            ValidID => 1,
            UserID  => 1,
        },
        Success => 0,
    },
    {
        Name   => 'No ValidID',
        Config => {
            Name     => "TestCategory$RandomID",
            Comment  => 'Some Comment',
            ParentID => 0,
            UserID   => 1,
        },
        Success => 0,
    },
    {
        Name   => 'No UserID',
        Config => {
            Name     => "TestCategory$RandomID",
            Comment  => 'Some Comment',
            ParentID => 0,
            ValidID  => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Correct No Comment',
        Config => {
            Name     => "TestCategory1$RandomID",
            ParentID => 0,
            ValidID  => 1,
            UserID   => 1,
        },
        Success => 1,
    },
    {
        Name   => 'Correct ASCII',
        Config => {
            Name     => "TestCategory2$RandomID",
            Comment  => 'Some Comment',
            ParentID => 0,
            ValidID  => 1,
            UserID   => 1,
        },
        Success => 1,
    },
    {
        Name   => 'Correct Unicode',
        Config => {
            Name     => "TestCategory3äüßÄÖÜ€исáéíúúÁÉÍÚñÑ$RandomID",
            Comment  => 'Some Comment äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            ParentID => 0,
            ValidID  => 1,
            UserID   => 1,
        },
        Success => 1,
    },
);

my %AddedCategoryIDs;

TEST:
for my $Test (@Tests) {

    my $CategoryID = $FAQObject->CategoryAdd( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $CategoryID // 0,
            "$Test->{Name} CategoryADD() - With False",
        );
        next TEST;
    }

    $Self->True(
        $CategoryID,
        "$Test->{Name} CategoryAdd() - With True",
    );

    $Self->IsNot(
        $AddedCategoryIDs{$CategoryID},
        1,
        "$Test->{Name} CategoryAdd() CategoryID was not used returned before",
    );

    $AddedCategoryIDs{$CategoryID} = 1;
}

# Test for bug#11889 - CategoryAdd returns wrong CategoryID if subcategory name already exists.
# The idea is to create several parents and for each create a child category, all children has the
#   same name.
for my $ParentCount ( 1 .. 10 ) {

    my $ParentCategoryID = $FAQObject->CategoryAdd(
        Name     => "TestParent$ParentCount$RandomID",
        Comment  => 'Some Comment',
        ParentID => 0,
        ValidID  => 1,
        UserID   => 1,
    );

    $Self->True(
        $ParentCategoryID,
        "Parent $ParentCount CategoryAdd() - With True",
    );

    $Self->IsNot(
        $AddedCategoryIDs{$ParentCategoryID},
        1,
        "Parent $ParentCount CategoryAdd() CategoryID was not used returned before",
    );

    $AddedCategoryIDs{$ParentCategoryID} = 1;

    my $CategoryID = $FAQObject->CategoryAdd(
        Name     => "TestChild$RandomID",
        Comment  => 'Some Comment',
        ParentID => $ParentCategoryID,
        ValidID  => 1,
        UserID   => 1,
    );

    $Self->True(
        $CategoryID,
        "Child for Parent $ParentCount CategoryAdd() - With True",
    );

    $Self->IsNot(
        $AddedCategoryIDs{$CategoryID},
        1,
        "Child for Parent $ParentCount CategoryAdd() CategoryID was not used returned before",
    );

    $AddedCategoryIDs{$CategoryID} = 1;
}

1;
