# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get FAQ object
        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

        # create test FAQs
        my @ItemIDs;
        for ( 1 .. 5 ) {
            my $FAQTitle = 'FAQ ' . $Helper->GetRandomID();
            my $ItemID   = $FAQObject->FAQAdd(
                Title       => $FAQTitle,
                CategoryID  => 1,
                StateID     => 3,
                LanguageID  => 1,
                Approved    => 1,
                ValidID     => 1,
                UserID      => 1,
                ContentType => 'text/html',
            );

            $Self->True(
                $ItemID,
                "FAQ is created - $ItemID",
            );

            my %FAQ = (
                ItemID   => $ItemID,
                FAQTitle => $FAQTitle,
            );

            push @ItemIDs, \%FAQ;
        }

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to PublicFAQExplorer screen
        $Selenium->VerifiedGet("${ScriptAlias}public.pl?Action=PublicFAQExplorer");

        # check PublicFAQExplorer screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # test data for explorer screen
        my @Tests = (
            {
                ScreenData => 'FAQ Explorer',
            },
            {
                ScreenData => 'Latest created FAQ articles',
            },
            {
                ScreenData => 'Latest updated FAQ articles',
            },
        );

        for my $Test (@Tests) {
            $Self->True(
                index( $Selenium->get_page_source(), $Test->{ScreenData} ) > -1,
                "$Test->{ScreenData} - found",
            );
        }

        # click on 'Misc', go on subcategory screen
        $Selenium->find_element( 'Misc', 'link_text' )->VerifiedClick();

        # order FAQ item per FAQID by Down
        $Selenium->VerifiedGet(
            "${ScriptAlias}public.pl?Action=PublicFAQExplorer;CategoryID=1;SortBy=FAQID;OrderBy=Down"
        );

        # check and delete test created FAQs
        for my $FAQ (@ItemIDs) {

            # check if there is test FAQ on screen
            $Self->True(
                index( $Selenium->get_page_source(), $FAQ->{FAQTitle} ) > -1,
                "$FAQ->{FAQTitle} - found",
            );

            my $Success = $FAQObject->FAQDelete(
                ItemID => $FAQ->{ItemID},
                UserID => 1,
            );
            $Self->True(
                $Success,
                "FAQ is deleted - $FAQ->{FAQTitle}",
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

$Self->DoneTesting();
