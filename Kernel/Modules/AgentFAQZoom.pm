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

package Kernel::Modules::AgentFAQZoom;

use strict;
use warnings;

use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    if ( !defined $Self->{DoNotShowBrowserLinkMessage} ) {
        if ( $UserPreferences{UserAgentDoNotShowBrowserLinkMessage} ) {
            $Self->{DoNotShowBrowserLinkMessage} = 1;
        }
        else {
            $Self->{DoNotShowBrowserLinkMessage} = 0;
        }
    }

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

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Get parameters from web request.
    my %GetParam;
    $GetParam{ItemID} = $ParamObject->GetParam( Param => 'ItemID' );
    $GetParam{Rate}   = $ParamObject->GetParam( Param => 'Rate' );

    # Get navigation bar option.
    my $Nav = $ParamObject->GetParam( Param => 'Nav' ) || '';

    if ( !$GetParam{ItemID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No ItemID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    my %FAQData = $FAQObject->FAQGet(
        ItemID        => $GetParam{ItemID},
        ItemFields    => 1,
        UserID        => $Self->{UserID},
        DynamicFields => 1,
    );
    if ( !%FAQData ) {
        return $LayoutObject->ErrorScreen();
    }

    # Check user permission.
    my $Permission = $FAQObject->CheckCategoryUserPermission(
        UserID     => $Self->{UserID},
        CategoryID => $FAQData{CategoryID},
        Type       => 'ro',
    );
    if ( !$Permission ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable('You have no permission for this category!'),
            WithHeader => 'yes',
        );
    }

    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

    # ---------------------------------------------------------- #
    # HTMLView Subaction
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'HTMLView' ) {

        # get params
        my $Field = $ParamObject->GetParam( Param => "Field" );

        for my $Needed (qw( ItemID Field )) {
            if ( !$Needed ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Needed Param: $Needed!",
                );
                return;
            }
        }

        # get the Field content
        my $FieldContent = $FAQObject->ItemFieldGet(
            ItemID => $GetParam{ItemID},
            Field  => $Field,
            UserID => $Self->{UserID},
        );

        # Rewrite handle and action, take care of old style before FAQ 2.0.x.
        $FieldContent =~ s{
            Action=AgentFAQ [&](amp;)? Subaction=Download [&](amp;)?
        }{Action=AgentFAQZoom;Subaction=DownloadAttachment;}gxms;

        # build base URL for inline images
        my $SessionID = '';
        if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
            $SessionID = ';' . $Self->{SessionName} . '=' . $Self->{SessionID};
            $FieldContent =~ s{
                (Action=AgentFAQZoom;Subaction=DownloadAttachment;ItemID=\d+;FileID=\d+)
            }{$1$SessionID}gmsx;
        }

        # Convert content to HTML if needed.
        if (
            $Kernel::OM->Get('Kernel::Config')->Get('FAQ::Item::HTML')
            && $LayoutObject->{BrowserRichText}
            && $FAQData{ContentType} ne 'text/html'
            )
        {
            $FieldContent = $HTMLUtilsObject->ToHTML(
                String => $FieldContent,
            ) || '';
        }

        # Detect all plain text links and put them into an HTML <a> tag.
        $FieldContent = $HTMLUtilsObject->LinkQuote(
            String => $FieldContent,
        );

        # Set target="_blank" attribute to all HTML <a> tags the LinkQuote function needs to be
        #   called again
        $FieldContent = $HTMLUtilsObject->LinkQuote(
            String    => $FieldContent,
            TargetAdd => 1,
        );

        # add needed HTML headers
        $FieldContent = $HTMLUtilsObject->DocumentComplete(
            String  => $FieldContent,
            Charset => 'utf-8',
        );

        # return complete HTML as an attachment
        return $LayoutObject->Attachment(
            Type        => 'inline',
            ContentType => 'text/html',
            Content     => $FieldContent,
        );
    }

    # ---------------------------------------------------------- #
    # DownloadAttachment Sub-action
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'DownloadAttachment' ) {

        $GetParam{FileID} = $ParamObject->GetParam( Param => 'FileID' );

        if ( !defined $GetParam{FileID} ) {
            return $LayoutObject->FatalError(
                Message => Translatable('Need FileID!'),
            );
        }

        # Get attachments.
        my %File = $FAQObject->AttachmentGet(
            ItemID => $GetParam{ItemID},
            FileID => $GetParam{FileID},
            UserID => $Self->{UserID},
        );
        if (%File) {
            return $LayoutObject->Attachment(%File);
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "No such attachment ($GetParam{FileID})! May be an attack!!!",
                Priority => 'error',
            );
            return $LayoutObject->ErrorScreen();
        }
    }

    # ---------------------------------------------------------- #
    # Other sub-actions continues here
    # ---------------------------------------------------------- #
    my $Output;
    if ( $Nav eq 'None' ) {
        $Output = $LayoutObject->Header( Type => 'Small' );
    }
    else {
        $Output = $LayoutObject->Header(
            Value => $FAQData{Title},
        );
        $Output .= $LayoutObject->NavigationBar();
    }

    # Define different notifications.
    my %Notifications = (
        Thanks => {
            Priority => 'Info',
            Info     => Translatable('Thanks for your vote!'),
        },
        AlreadyVoted => {
            Priority => 'Error',
            Info     => Translatable('You have already voted!'),
        },
        NoRate => {
            Priority => 'Error',
            Info     => Translatable('No rate selected!'),
        },
    );

    # Output notifications if any.
    my $Notify = $ParamObject->GetParam( Param => 'Notify' ) || '';
    if ( $Notify && IsHashRefWithData( $Notifications{$Notify} ) ) {
        $Output .= $LayoutObject->Notify(
            %{ $Notifications{$Notify} },
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Get default options.
    my $MultiLanguage = $ConfigObject->Get('FAQ::MultiLanguage');
    my $Voting        = $ConfigObject->Get('FAQ::Voting');

    # Set default interface settings.
    my $Interface = $FAQObject->StateTypeGet(
        Name   => 'internal',
        UserID => $Self->{UserID},
    );
    my $InterfaceStates = $FAQObject->StateTypeList(
        Types  => $ConfigObject->Get('FAQ::Agent::StateTypes'),
        UserID => $Self->{UserID},
    );

    # Get FAQ vote information.
    my $VoteData;
    if ($Voting) {
        $VoteData = $FAQObject->VoteGet(
            CreateBy  => $Self->{UserID},
            ItemID    => $FAQData{ItemID},
            Interface => $Interface->{StateID},
            IP        => $ParamObject->RemoteAddr(),
            UserID    => $Self->{UserID},
        );
    }

    # Check if user already voted this FAQ item.
    my $AlreadyVoted;
    if ($VoteData) {

        my $ItemChangedSystemTime = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $FAQData{Changed} || '',
            }
        )->ToEpoch();

        my $VoteCreatedSystemTime = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $VoteData->{Created} || '',
            }
        )->ToEpoch();

        if ( $ItemChangedSystemTime <= $VoteCreatedSystemTime ) {
            $AlreadyVoted = 1;
        }
    }

    # ---------------------------------------------------------- #
    # Vote Sub-action
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Vote' ) {

        # User can't use this sub-action if is not enabled.
        if ( !$Voting ) {
            $LayoutObject->FatalError(
                Message => Translatable('The voting mechanism is not enabled!'),
            );
        }

        # User can vote only once per FAQ revision.
        if ($AlreadyVoted) {

            # Redirect to FAQ zoom.
            return $LayoutObject->Redirect(
                OP => 'Action=AgentFAQZoom;ItemID='
                    . $GetParam{ItemID}
                    . ';Nav=$Nav;Notify=AlreadyVoted'
            );
        }

        # Set the vote if any.
        elsif ( defined $GetParam{Rate} ) {

            # Get rates config.
            my $VotingRates = $ConfigObject->Get('FAQ::Item::Voting::Rates');
            my $Rate        = $GetParam{Rate};

            # Send error if rate is not defined in config.
            if ( !$VotingRates->{$Rate} ) {
                $LayoutObject->FatalError(
                    Message => Translatable('The vote rate is not defined!'),
                );
            }

            # Otherwise add the vote.
            else {
                $FAQObject->VoteAdd(
                    CreatedBy => $Self->{UserID},
                    ItemID    => $GetParam{ItemID},
                    IP        => $ParamObject->RemoteAddr(),
                    Interface => $Interface->{StateID},
                    Rate      => $GetParam{Rate},
                    UserID    => $Self->{UserID},
                );

                # Do not show the voting form.
                $AlreadyVoted = 1;

                # Refresh FAQ item data.
                %FAQData = $FAQObject->FAQGet(
                    ItemID        => $GetParam{ItemID},
                    ItemFields    => 1,
                    UserID        => $Self->{UserID},
                    DynamicFields => 1,
                );
                if ( !%FAQData ) {
                    return $LayoutObject->ErrorScreen();
                }

                # Redirect to FAQ zoom.
                return $LayoutObject->Redirect(
                    OP => 'Action=AgentFAQZoom;ItemID='
                        . $GetParam{ItemID}
                        . ';Nav=$Nav;Notify=Thanks'
                );
            }
        }

        # User is able to vote but no rate has been selected.
        else {

            # Redirect to FAQ zoom
            return $LayoutObject->Redirect(
                OP => 'Action=AgentFAQZoom;ItemID=' . $GetParam{ItemID} . ';Nav=$Nav;Notify=NoRate'
            );
        }
    }

    # Prepare fields data (Still needed for PlainText).
    FIELD:
    for my $Field (qw(Field1 Field2 Field3 Field4 Field5 Field6)) {
        next FIELD if !$FAQData{$Field};

        # Rewrite handle and action, take care of old style before FAQ 2.0.x.
        $FAQData{$Field} =~ s{
            Action=AgentFAQ [&](amp;)? Subaction=Download [&](amp;)?
        }{Action=AgentFAQZoom;Subaction=DownloadAttachment;}gxms;

        # No quoting if HTML view is enabled.
        next FIELD if $ConfigObject->Get('FAQ::Item::HTML');

        # HTML quoting.
        $FAQData{$Field} = $LayoutObject->Ascii2Html(
            NewLine        => 0,
            Text           => $FAQData{$Field},
            VMax           => 5000,
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );
    }

    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # Get user info (CreatedBy).
    my %UserInfo = $UserObject->GetUserData(
        UserID => $FAQData{CreatedBy}
    );
    $Param{CreatedByUser} = "$UserInfo{UserFullname}";

    # Get user info (ChangedBy).
    %UserInfo = $UserObject->GetUserData(
        UserID => $FAQData{ChangedBy}
    );
    $Param{ChangedByUser} = "$UserInfo{UserFullname}";

    # Set voting results.
    $Param{VotingResultColor} = $LayoutObject->GetFAQItemVotingRateColor(
        Rate => $FAQData{VoteResult},
    );

    if ( !$Param{VotingResultColor} || $FAQData{Votes} eq '0' ) {
        $Param{VotingResultColor} = 'Gray';
    }

    if ( $Nav ne 'None' ) {

        # Run FAQ menu modules.
        if ( ref $ConfigObject->Get('FAQ::Frontend::MenuModule') eq 'HASH' ) {
            my %Menus   = %{ $ConfigObject->Get('FAQ::Frontend::MenuModule') };
            my $Counter = 0;
            for my $Menu ( sort keys %Menus ) {

                # Load module.
                if ( $Kernel::OM->Get('Kernel::System::Main')->Require( $Menus{$Menu}->{Module} ) ) {
                    my $Object = $Menus{$Menu}->{Module}->new(
                        %{$Self},
                        ItemID => $FAQData{ItemID},
                    );

                    # Set CSS classes.
                    if ( $Menus{$Menu}->{Target} ) {

                        if ( $Menus{$Menu}->{Target} eq 'PopUp' ) {
                            $Menus{$Menu}->{Class} = 'AsPopup';
                        }
                        elsif ( $Menus{$Menu}->{Target} eq 'Back' ) {
                            $Menus{$Menu}->{Class} = 'HistoryBack';
                        }
                        elsif ( $Menus{$Menu}->{Target} eq 'ConfirmationDialog' ) {
                            $Menus{$Menu}->{Class} = 'AsConfirmationDialog';
                        }

                    }

                    # Run module.
                    $Counter = $Object->Run(
                        %Param,
                        FAQItem => {%FAQData},
                        Counter => $Counter,
                        Config  => $Menus{$Menu},
                        MenuID  => 'Menu' . $Menu,
                    );
                }
                else {
                    return $LayoutObject->FatalError();
                }
            }
        }
    }

    # Output approval state.
    if ( $ConfigObject->Get('FAQ::ApprovalRequired') ) {
        $Param{Approval} = $FAQData{Approved} ? 'Yes' : 'No';
        $LayoutObject->Block(
            Name => 'ViewApproval',
            Data => {%Param},
        );
    }

    if ($Voting) {

        # Output votes number if any.
        if ( $FAQData{Votes} ) {
            $LayoutObject->Block(
                Name => 'ViewVotes',
                Data => {%FAQData},
            );
        }

        # Otherwise display a No Votes found message.
        else {
            $LayoutObject->Block( Name => 'ViewNoVotes' );
        }
    }

    my $ShowFAQPath = $LayoutObject->FAQPathShow(
        FAQObject   => $FAQObject,
        CategoryID  => $FAQData{CategoryID},
        UserID      => $Self->{UserID},
        PathForItem => 1,
        Nav         => $Nav,
    );
    if ($ShowFAQPath) {
        $LayoutObject->Block(
            Name => 'FAQPathItemElement',
            Data => {%FAQData},
            Nav  => $Nav,
        );
    }

    # Show keywords as search links.
    if ( $FAQData{Keywords} ) {

        # Replace commas and semicolons.
        $FAQData{Keywords} =~ s/,/ /g;
        $FAQData{Keywords} =~ s/;/ /g;

        my @Keywords = split /\s+/, $FAQData{Keywords};
        for my $Keyword (@Keywords) {
            $LayoutObject->Block(
                Name => 'Keywords',
                Data => {
                    Keyword => $Keyword,
                },
            );
        }
    }

    # Show languages.
    if ($MultiLanguage) {
        $LayoutObject->Block(
            Name => 'Language',
            Data => {
                %FAQData,
            },
        );
    }

    # Output rating stars.
    if ($Voting) {
        $LayoutObject->FAQRatingStarsShow(
            VoteResult => $FAQData{VoteResult},
            Votes      => $FAQData{Votes},
        );
    }
    if ( $Nav ne 'None' ) {

        # Output existing attachments.
        my @AttachmentIndex = $FAQObject->AttachmentIndex(
            ItemID     => $GetParam{ItemID},
            ShowInline => 0,
            UserID     => $Self->{UserID},
        );

        # Output header and all attachments.
        if (@AttachmentIndex) {
            $LayoutObject->Block(
                Name => 'AttachmentHeader',
            );
            for my $Attachment (@AttachmentIndex) {
                $LayoutObject->Block(
                    Name => 'AttachmentRow',
                    Data => {
                        %FAQData,
                        %{$Attachment},
                    },
                );
            }
        }
    }

    # Show message about links in iframes, if user didn't close it already.
    if ( !$Self->{DoNotShowBrowserLinkMessage} ) {
        $LayoutObject->Block(
            Name => 'BrowserLinkMessage',
        );
    }

    # Show FAQ Content.
    my $FAQBody = $LayoutObject->FAQContentShow(
        FAQObject       => $FAQObject,
        InterfaceStates => $InterfaceStates,
        FAQData         => {%FAQData},
        UserID          => $Self->{UserID},
        ReturnContent   => 1,
    );

    # Get config of frontend module.
    my $Config = $ConfigObject->Get("FAQ::Frontend::$Self->{Action}");

    # Get the dynamic fields for this screen.
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => 'FAQ',
        FieldFilter => $Config->{DynamicField} || {},
    );

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # Get print string for this dynamic field.
        my $ValueStrg = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $FAQData{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
            ValueMaxChars      => 250,
            LayoutObject       => $LayoutObject,
        );

        my $Label = $DynamicFieldConfig->{Label};

        $LayoutObject->Block(
            Name => 'FAQDynamicField',
            Data => {
                Label => $Label,
            },
        );

        if ( $ValueStrg->{Link} ) {
            $LayoutObject->Block(
                Name => 'FAQDynamicFieldLink',
                Data => {
                    Value                       => $ValueStrg->{Value},
                    Title                       => $ValueStrg->{Title},
                    Link                        => $ValueStrg->{Link},
                    $DynamicFieldConfig->{Name} => $ValueStrg->{Title},
                },
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'FAQDynamicFieldPlain',
                Data => {
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );
        }

        # Example of dynamic fields order customization.
        $LayoutObject->Block(
            Name => 'FAQDynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Label => $Label,
            },
        );

        $LayoutObject->Block(
            Name => 'FAQDynamicField_' . $DynamicFieldConfig->{Name} . '_Plain',
            Data => {
                Value => $ValueStrg->{Value},
                Title => $ValueStrg->{Title},
            },
        );
    }

    if ( $Nav ne 'None' ) {

        # Show FAQ Voting.
        if ($Voting) {

            # Get voting config.
            my $ShowVotingConfig = $ConfigObject->Get('FAQ::Item::Voting::Show');
            if ( $ShowVotingConfig->{ $Interface->{Name} } ) {

                # Check if the user already voted after last change.
                if ( !$AlreadyVoted ) {
                    $Self->_FAQVoting( FAQData => {%FAQData} );
                }
            }
        }

        # Get linked objects.
        my $LinkListWithData = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkListWithData(
            Object => 'FAQ',
            Key    => $GetParam{ItemID},
            State  => 'Valid',
            UserID => $Self->{UserID},
        );

        my $LinkTableViewMode = $ConfigObject->Get('LinkObject::ViewMode');

        # Create the link table.
        my $LinkTableStrg = $LayoutObject->LinkObjectTableCreate(
            LinkListWithData => $LinkListWithData,
            ViewMode         => $LinkTableViewMode,
            Object           => 'FAQ',
            Key              => $GetParam{ItemID},
        );

        # Output the link table.
        if ($LinkTableStrg) {
            $LayoutObject->Block(
                Name => 'LinkTable' . $LinkTableViewMode,
                Data => {
                    LinkTableStrg => $LinkTableStrg,
                },
            );
        }
    }

    # Log access to this FAQ item.
    $FAQObject->FAQLogAdd(
        ItemID    => $ParamObject->GetParam( Param => 'ItemID' ),
        Interface => $Interface->{Name},
        UserID    => $Self->{UserID},
    );

    # Start template output.
    if ( $Nav && $Nav eq 'None' ) {

        # Only convert HTML to plain text if rich text editor is not used.
        if ( $ConfigObject->Get('Frontend::RichText') ) {
            $FAQData{FullBody} = $FAQBody;
        }
        else {
            $FAQData{FullBody} = $HTMLUtilsObject->ToAscii(
                String => $FAQBody,
            );
        }

        # Get the public state type.
        my $PublicStateType = $FAQObject->StateTypeGet(
            Name   => 'public',
            UserID => $Self->{UserID},
        );

        # Remove in-line image links to FAQ images.
        $FAQData{FullBody}
            =~ s{ <img [^<>]+ Action=(Agent|Customer|Public)FAQ [^<>]+ > }{}gxms;

        # Get configuration options for Ticket Compose.
        my $TicketComposeConfig = $ConfigObject->Get('FAQ::TicketCompose');

        $Param{UpdateArticleSubject} = $TicketComposeConfig->{UpdateArticleSubject} || 0;
        if ( $Param{UpdateArticleSubject} ) {
            $LayoutObject->Block(
                Name => 'UpdateArticleSubject',
                Data => {},
            );
        }

        # Send data to JS.
        $LayoutObject->AddJSData(
            Key   => 'TicketCompose.UpdateArticleSubject',
            Value => $Param{UpdateArticleSubject},
        );

        my $ShowOrBlock;

        # Show "Insert Text" button.
        if ( $TicketComposeConfig->{ShowInsertTextButton} ) {
            if (
                defined $TicketComposeConfig->{InsertMethod}
                && $TicketComposeConfig->{InsertMethod} eq 'Full'
                )
            {
                $LayoutObject->Block(
                    Name => 'InsertFull',
                    Data => {},
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'InsertText',
                    Data => {},
                );
            }

            $ShowOrBlock = 1;
        }

        # Check if FAQ article is public.
        if ( $FAQData{StateTypeID} == $PublicStateType->{StateID} ) {

            my $HTTPType = $ConfigObject->Get('HttpType');
            my $FQDN     = $ConfigObject->Get('FQDN');
            my $Baselink = $LayoutObject->{Baselink};

            # Rewrite handle.
            $Baselink
                =~ s{ index[.]pl [?] }{public.pl?}gxms;

            $FAQData{Publiclink} = $HTTPType . '://' . $FQDN . $Baselink
                . "Action=PublicFAQZoom;ItemID=$FAQData{ItemID}";

            #Sshow "Insert Link" button.
            if ( $TicketComposeConfig->{ShowInsertLinkButton} ) {
                $LayoutObject->Block(
                    Name => 'InsertLink',
                    Data => {},
                );
                $ShowOrBlock = 1;
            }

            # Show "Insert Text and Link" button.
            if ( $TicketComposeConfig->{ShowInsertTextAndLinkButton} ) {
                if (
                    defined $TicketComposeConfig->{InsertMethod}
                    && $TicketComposeConfig->{InsertMethod} eq 'Full'
                    )
                {
                    $LayoutObject->Block(
                        Name => 'InsertFullAndLink',
                        Data => {},
                    );
                }
                else {
                    $LayoutObject->Block(
                        Name => 'InsertTextAndLink',
                        Data => {},
                    );
                }
                $ShowOrBlock = 1;
            }
        }

        my $CancelButtonClass = 'ZoomSmallButton';

        # Show the "Or" block between the buttons and the Cancel & close window label.
        if ($ShowOrBlock) {
            $LayoutObject->Block(
                Name => 'Or',
                Data => {},
            );

            # Set the $CancelButtonClass to ''.
            $CancelButtonClass = '';
        }

        # Send data to JS.
        $LayoutObject->AddJSData(
            Key   => 'AgentFAQZoomSmall',
            Value => 1,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentFAQZoomSmall',
            Data         => {
                %FAQData,
                %GetParam,
                %Param,
                CancelButtonClass => $CancelButtonClass || '',
            },
        );
    }
    else {
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentFAQZoom',
            Data         => {
                %FAQData,
                %GetParam,
                %Param,
            },
        );
    }
    if ( $Nav && $Nav eq 'None' ) {
        $Output .= $LayoutObject->Footer( Type => 'Small' );
    }
    else {
        $Output .= $LayoutObject->Footer();
    }

    return $Output;
}

sub _FAQVoting {
    my ( $Self, %Param ) = @_;

    my %FAQData = %{ $Param{FAQData} };

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'FAQVoting',
        Data => {%FAQData},
    );

    # Get Voting rates setting.
    my $VotingRates = $Kernel::OM->Get('Kernel::Config')->Get('FAQ::Item::Voting::Rates');
    for my $RateValue ( sort { $a <=> $b } keys %{$VotingRates} ) {

        # Create data structure for output.
        my %Data = (
            Value => $RateValue,
            Title => $VotingRates->{$RateValue},
        );

        $LayoutObject->Block(
            Name => 'FAQVotingRateRow',
            Data => {%Data},
        );
    }

    return 1;
}

1;
