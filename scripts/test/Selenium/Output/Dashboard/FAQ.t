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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Set FAQ dashboard SysConfig param.
        my @FAQDashboard = (
            {
                Name => 'DashboardBackend###0398-FAQ-LastChange',
            },
            {
                Name => 'DashboardBackend###0399-FAQ-LastCreate',
            },
        );

        # Set FAQ dashboard modules on default settings.
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        for my $DefaultSysConfig (@FAQDashboard) {

            my %Setting = $SysConfigObject->SettingGet(
                Name    => $DefaultSysConfig->{Name},
                Default => 1,
            );

            $DefaultSysConfig->{Value} = $Setting{EffectiveValue};

            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => $DefaultSysConfig->{Name},
                Value => $DefaultSysConfig->{Value},
            );
        }

        # Create test FAQ.
        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');
        my $FAQTitle  = 'FAQ ' . $Helper->GetRandomID();
        my $ItemID    = $FAQObject->FAQAdd(
            Title       => $FAQTitle,
            CategoryID  => 1,
            StateID     => 2,
            LanguageID  => 1,
            ValidID     => 1,
            Approved    => 1,
            UserID      => 1,
            ContentType => 'text/html',
        );
        $Self->True(
            $ItemID,
            "Test FAQ item is created - ID $ItemID",
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
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');

        for my $Test (@FAQDashboard) {

            # Disable all dashboard plug-ins.
            my $Config = $ConfigObject->Get('DashboardBackend');
            $Helper->ConfigSettingChange(
                Valid => 0,
                Key   => 'DashboardBackend',
                Value => \%$Config,
            );

            # Enable FAQ dashboard.
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => $Test->{Name},
                Value => $Test->{Value},
            );

            # Navigate to dashboard screen.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

            # Check title for test created FAQ.
            $Self->True(
                index( $Selenium->get_page_source(), $FAQTitle ) > -1,
                "Test FAQ title is found",
            );

            # Check link for test created FAQ.
            $Self->True(
                index( $Selenium->get_page_source(), "${ScriptAlias}index.pl?Action=AgentFAQZoom;ItemID=$ItemID" ) > -1,
                "Test FAQ link is found",
            );
        }

        # Delete test created FAQ.
        my $Success = $FAQObject->FAQDelete(
            ItemID => $ItemID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Test FAQ item is deleted - ID $ItemID",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => "FAQ" );
    }
);

$Self->DoneTesting();
