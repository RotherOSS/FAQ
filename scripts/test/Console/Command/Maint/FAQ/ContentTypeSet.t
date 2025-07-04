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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::FAQ::ContentTypeSet');

my ( $Result, $ExitCode );
{
    local *STDOUT;                                 ## no critic qw(Variables::RequireInitializationForLocalVars)
    open STDOUT, '>:encoding(UTF-8)', \$Result;    ## no critic qw(OTOBO::ProhibitOpen)
    $ExitCode = $CommandObject->Execute();
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
}

$Self->Is(
    $ExitCode,
    0,
    "Kernel::System::Console::Command::Maint::FAQ::ContentTypeSet exit code",
);

1;
