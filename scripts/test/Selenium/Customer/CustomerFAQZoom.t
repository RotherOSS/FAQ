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

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

        # Create test FAQ.
        my $FAQTitle    = 'FAQ ' . $Helper->GetRandomID();
        my $FAQSymptom  = 'Selenium Symptom';
        my $FAQProblem  = 'Selenium Problem';
        my $FAQSolution = 'Selenium Solution';

        my $ItemID = $FAQObject->FAQAdd(
            Title       => $FAQTitle,
            CategoryID  => 1,
            StateID     => 1,
            LanguageID  => 1,
            Keywords    => 'SeleniumKeywords',
            Field1      => $FAQSymptom,
            Field2      => $FAQProblem,
            Field3      => $FAQSolution,
            Approved    => 1,
            ValidID     => 1,
            UserID      => 1,
            ContentType => 'text/html',
        );
        $Self->True(
            $ItemID,
            "FAQ is created - ID $ItemID",
        );

        # Create and login test customer.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to CustomerFAQZoom screen of created test FAQ.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerFAQZoom;ItemID=$ItemID");

        # Check page.
        $Self->True(
            index( $Selenium->get_page_source(), 'FAQ Information' ) > -1,
            "FAQ data is found on screen - FAQ Information",
        );

        # Verify test FAQ is created.
        $Self->True(
            index( $Selenium->get_page_source(), $FAQTitle ) > -1,
            "$FAQTitle is found",
        );

        my @Tests = (
            {
                Iframe  => 'IframeFAQField1',
                FAQData => $FAQSymptom,
            },
            {
                Iframe  => 'IframeFAQField2',
                FAQData => $FAQProblem,
            },
            {
                Iframe  => 'IframeFAQField3',
                FAQData => $FAQSolution,
            },
        );

        # Check test created FAQ values.
        for my $Test (@Tests) {

            # Switch to FAQ symptom iframe and verify its values.
            $Selenium->SwitchToFrame(
                FrameSelector => "#$Test->{Iframe}",
            );

            # Wait to switch on iframe.
            sleep 2;

            $Self->True(
                index( $Selenium->get_page_source(), $Test->{FAQData} ) > -1,
                "$Test->{FAQData} is found",
            );
            $Selenium->switch_to_frame();
        }

        $Self->True(
            index( $Selenium->get_page_source(), 'SeleniumKeywords' ) > -1,
            "FAQ 'SeleniumKeywords' value is found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), 'external (customer)' ) > -1,
            "FAQ state value is found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), '0 out of 5' ) > -1,
            "FAQ default vote value is found",
        );

        # Vote 5 stars for FAQ.
        my $VoteElement = $Selenium->find_element( "#RateButton100", 'css' );
        $Selenium->find_child_element( $VoteElement, ".RateButton", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('.RateButton.RateChecked').length === 5" );

        $Selenium->find_element("//button[\@id='RateSubmitButton'][\@type='submit']")->VerifiedClick();

        # Check vote message.
        $Self->True(
            index( $Selenium->get_page_source(), 'Thanks for your vote!' ) > -1,
            "FAQ vote message is found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), '5 out of 5' ) > -1,
            "FAQ vote value is found",
        );

        # Delete test created FAQ.
        my $Success = $FAQObject->FAQDelete(
            ItemID => $ItemID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "FAQ is deleted - ID $ItemID",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

$Self->DoneTesting();
