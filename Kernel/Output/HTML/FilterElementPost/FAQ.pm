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

package Kernel::Output::HTML::FilterElementPost::FAQ;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Web::Request',
    'Kernel::System::Group',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    return if !$Param{Data};
    return if ref $Param{Data} ne 'SCALAR';
    return if !${ $Param{Data} };
    return if !$Param{TemplateFile};

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Config = $ConfigObject->Get('Frontend::Module')->{AgentFAQExplorer};

    my $GroupsRo = $Config->{GroupRo} || [];

    my $HasPermission = 1;

    # check permission
    if ( IsArrayRefWithData($GroupsRo) ) {

        $HasPermission = 0;

        # check read only groups
        ROGROUP:
        for my $RoGroup ( @{$GroupsRo} ) {

            $HasPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
                UserID    => $LayoutObject->{EnvRef}->{UserID},
                GroupName => $RoGroup,
                Type      => 'ro',
            );

            next ROGROUP if !$HasPermission;
            next ROGROUP if $HasPermission != 1;

            last ROGROUP;
        }
    }

    return if !$HasPermission;

    # get allowed template names
    my $ValidTemplates = $ConfigObject->Get('Frontend::Output::FilterElementPost')->{FAQ}->{Templates};

    # check template name
    return if !$ValidTemplates->{ $Param{TemplateFile} };

    # if no session cookies are used we attach the session as URL parameter
    my $SessionString = '';
    if ( !$ConfigObject->Get('SessionUseCookie') ) {
        my $SessionID = $Param{SessionID}
            || $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $ConfigObject->Get('SessionName') )
            || '';
        $SessionString = $ConfigObject->Get('SessionName') . '=' . $SessionID . ';';
    }

    my $StartPattern    = '<!-- [ ] OutputFilterHook_TicketOptionsEnd [ ] --> .+?';
    my $FAQTranslatable = $LayoutObject->{LanguageObject}->Translate('FAQ');

    # add FAQ link to an existing Options block
    #$FinishPattern will be replaced by $Replace
    if ( ${ $Param{Data} } =~ m{ $StartPattern }ixms ) {

        my $FinishPattern = '</div>';
        my $Replace       = <<"END";
                        <a  href=\"#\" id=\"OptionFAQ\">[ $FAQTranslatable ]</a>
                    </div>
END
        ${ $Param{Data} } =~ s{ ($StartPattern) $FinishPattern }{$1$Replace}ixms;

        # inject the necessary JS into the template
        $LayoutObject->AddJSOnDocumentComplete( Code => <<"EOF" );
/*global FAQ: true */
FAQ.Agent.TicketCompose.InitFAQTicketCompose(\$('#RichText'));
\$('#OptionFAQ').bind('click', function (event) {
    var FAQIFrame = '<iframe class=\"TextOption FAQ\" src=\"' + Core.Config.Get('CGIHandle') + '?' + '$SessionString' + 'Action=AgentFAQExplorer;Nav=None;Subject=;What=\"></iframe>';
    Core.UI.Dialog.ShowContentDialog(FAQIFrame, '', '10px', 'Center', true);
    return false;
});
EOF

        return 1;
    }

    # add FAQ link and its own block, if there no TicketOptions block was called
    $StartPattern = '<!-- [ ] OutputFilterHook_NoTicketOptionsFallback [ ] --> .+?';
    my $OptionsTranslatable = $LayoutObject->{LanguageObject}->Translate('Options');
    my $Replace             = <<"END";
<!-- OutputFilterHook_NoTicketOptionsFallback -->
                    <label>$OptionsTranslatable:</label>
                    <div class="Field">
                        <a  href=\"#\" id=\"OptionFAQ\">[ $FAQTranslatable ]</a>
                    </div>
                    <div class=\"Clear\"></div>
END
    ${ $Param{Data} } =~ s{ ($StartPattern) }{$Replace}ixms;

    $LayoutObject->AddJSOnDocumentComplete( Code => <<"EOF" );
/*global FAQ: true */
FAQ.Agent.TicketCompose.InitFAQTicketCompose(\$('#RichText'));
\$('#OptionFAQ').bind('click', function (event) {
    var FAQIFrame = '<iframe class="TextOption FAQ" src="' + Core.Config.Get('CGIHandle') + '?' + '$SessionString' + 'Action=AgentFAQExplorer;Nav=None;Subject=;What="></iframe>';
    Core.UI.Dialog.ShowContentDialog(FAQIFrame, '', '10px', 'Center', true);
    return false;
});
EOF

    return 1;
}

1;
