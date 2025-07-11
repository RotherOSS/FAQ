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

package Kernel::Modules::AgentFAQDelete;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Permission check.
    if ( !$Self->{AccessRo} ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable('You need ro permission!'),
            WithHeader => 'yes',
        );
    }

    my %GetParam;

    # Get needed ItemID
    $GetParam{ItemID} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ItemID' );

    if ( !$GetParam{ItemID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No ItemID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    my %FAQData = $FAQObject->FAQGet(
        ItemID     => $GetParam{ItemID},
        ItemFields => 0,
        UserID     => $Self->{UserID},
    );
    if ( !%FAQData ) {
        return $LayoutObject->ErrorScreen();
    }

    # Check user permission.
    my $Permission = $FAQObject->CheckCategoryUserPermission(
        UserID     => $Self->{UserID},
        CategoryID => $FAQData{CategoryID},
        Type       => 'rw',
    );
    if ( !$Permission ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable('You have no permission for this category!'),
            WithHeader => 'yes',
        );
    }

    if ( $Self->{Subaction} eq 'Delete' ) {

        # Delete the FAQ article.
        my $CouldDeleteItem = $FAQObject->FAQDelete(
            ItemID => $FAQData{ItemID},
            UserID => $Self->{UserID},
        );

        if ($CouldDeleteItem) {

            # Redirect to explorer, when the deletion was successful.
            return $LayoutObject->Redirect(
                OP => "Action=AgentFAQExplorer;CategoryID=$FAQData{CategoryID}",
            );
        }
        else {

            # Show error message, when delete failed.
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate(
                    'Was not able to delete the FAQ article %s!',
                    $FAQData{ItemID},
                ),
                Comment => Translatable('Please contact the administrator.'),
            );
        }
    }

    # Set the dialog type. As default, the dialog will have 2 buttons: Yes and No.
    my $DialogType = 'Confirmation';

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentFAQDelete',
        Data         => {
            %Param,
            %FAQData,
        },
    );

    # Build the returned data structure.
    my %Data = (
        HTML       => $Output,
        DialogType => $DialogType,
    );

    # Return JSON-String because of AJAX-Mode.
    my $OutputJSON = $LayoutObject->JSONEncode( Data => \%Data );

    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $OutputJSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
