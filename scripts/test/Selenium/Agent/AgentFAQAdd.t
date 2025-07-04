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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Modify "FAQ::Agent::StateTypes" to only show 'internal' and 'public' FAQ state types in agent interface.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'FAQ::Agent::StateTypes',
            Value => [ 'internal', 'public' ],
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentFAQAdd.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentFAQAdd");

        # Check page.
        for my $ID (
            qw(Title Keywords CategoryID StateID ValidID LanguageID FileUpload
            Field1 Field2 Field3 Field6 FAQSubmit)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Verify only 'internal (agent)' and 'public (all)' FAQ state types are available.
        # There is no 'external (customer)' FAQ state option. See bug#14515.
        $Self->True(
            $Selenium->execute_script(
                "return \$('#StateID option[Value=2]').length;"
            ),
            "FAQ state 'internal (agent)' is available as option."
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('#StateID option[Value=3]').length;"
            ),
            "FAQ state 'public (all)' is available as option."
        );
        $Self->False(
            $Selenium->execute_script(
                "return \$('#StateID option[Value=1]').length;"
            ),
            "FAQ state 'external (customer)' is not available as option."
        );

        # Test params.
        my $FAQTitle    = 'FAQ ' . $Helper->GetRandomID();
        my $FAQSymptom  = 'Selenium Symptom';
        my $FAQProblem  = 'Selenium Problem';
        my $FAQSolution = 'Selenium Solution';
        my $FAQComment  = 'Selenium Comment';

        # Create test FAQ.
        $Selenium->find_element( "#Title",    'css' )->send_keys($FAQTitle);
        $Selenium->find_element( "#Keywords", 'css' )->send_keys('Selenium');
        $Selenium->execute_script("\$('#CategoryID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#StateID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#LanguageID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Field1",    'css' )->send_keys($FAQSymptom);
        $Selenium->find_element( "#Field2",    'css' )->send_keys($FAQProblem);
        $Selenium->find_element( "#Field3",    'css' )->send_keys($FAQSolution);
        $Selenium->find_element( "#Field6",    'css' )->send_keys($FAQComment);
        $Selenium->find_element( "#FAQSubmit", 'css' )->VerifiedClick();

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#FAQBody").length' );

        # Verify test FAQ is created.
        $Self->True(
            index( $Selenium->get_page_source(), $FAQTitle ) > -1,
            "$FAQTitle is found",
        );

        for my $Test ( $FAQSymptom, $FAQProblem, $FAQSolution, $FAQComment ) {
            $Self->True(
                index( $Selenium->get_page_source(), $Test ) > -1,
                "$Test is found",
            );
        }

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Get test created FAQ ID.
        my $FAQItem = $DBObject->Quote($FAQTitle);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM faq_item WHERE f_subject = ?",
            Bind => [ \$FAQTitle ]
        );
        my $ItemID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ItemID = $Row[0];
        }

        # Delete test created FAQ.
        my $Success = $Kernel::OM->Get('Kernel::System::FAQ')->FAQDelete(
            ItemID => $ItemID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "$ItemID is deleted - ID $ItemID",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

$Self->DoneTesting();
