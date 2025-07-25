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

package Kernel::Output::HTML::FAQOverview::Small;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::FAQ',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(PageShown StartHit)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( !$Param{FAQIDs} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need the FAQIDs!',
        );
        return;
    }

    # store the FAQIDs
    my @IDs;
    if ( $Param{FAQIDs} && ref $Param{FAQIDs} eq 'ARRAY' ) {
        @IDs = @{ $Param{FAQIDs} };
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $MultiLanguage = $ConfigObject->Get('FAQ::MultiLanguage');

    # get dynamic field config for frontend module
    my $DynamicFieldFilter = $ConfigObject->Get("FAQ::Frontend::OverviewSmall")->{DynamicField};

    # get the dynamic fields for this screen
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['FAQ'],
        FieldFilter => $DynamicFieldFilter || {},
    );

    my @ShowColumns;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if (@IDs) {

        # check ShowColumns parameter
        if ( $Param{ShowColumns} && ref $Param{ShowColumns} eq 'ARRAY' ) {
            @ShowColumns = @{ $Param{ShowColumns} };
        }

        # get dynamic field backend object
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # build column header blocks
        if (@ShowColumns) {

            # call main block
            $LayoutObject->Block( Name => 'RecordForm' );

            COLUMN:
            for my $Column (@ShowColumns) {

                next COLUMN if ( $Column eq 'Language' && !$MultiLanguage );

                # create needed variables
                my $CSS = 'OverviewHeader';
                my $OrderBy;

                # remove ID if necessary
                if ( $Param{SortBy} ) {
                    $Param{SortBy} = $Param{SortBy} eq 'PriorityID'
                        ? 'Priority'
                        : $Param{SortBy} eq 'CategoryID' ? 'Category'
                        : $Param{SortBy} eq 'LanguageID' ? 'Language'
                        : $Param{SortBy} eq 'StateID'    ? 'State'
                        : $Param{SortBy} eq 'FAQID'      ? 'Number'
                        :                                  $Param{SortBy};
                }

                # set the correct Set CSS class and order by link
                if ( $Param{SortBy} && ( $Param{SortBy} eq $Column ) ) {
                    if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                        $OrderBy = 'Down';
                        $CSS .= ' SortDescendingLarge';
                    }
                    else {
                        $OrderBy = 'Up';
                        $CSS .= ' SortAscendingLarge';
                    }
                }
                else {
                    $OrderBy = 'Up';
                }

                $LayoutObject->Block(
                    Name => 'Record' . $Column . 'Header',
                    Data => {
                        %Param,
                        CSS     => $CSS,
                        OrderBy => $OrderBy,
                    },
                );
            }

            # Dynamic fields
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{$DynamicField} ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                my $Label = $DynamicFieldConfig->{Label};

                # get field sortable condition
                my $IsSortable = $DynamicFieldBackendObject->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsSortable',
                );

                if ($IsSortable) {
                    my $CSS = 'OverviewHeader';
                    my $OrderBy;
                    if (
                        $Param{SortBy}
                        && ( $Param{SortBy} eq ( 'DynamicField_' . $DynamicFieldConfig->{Name} ) )
                        )
                    {
                        if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                            $OrderBy = 'Down';
                            $CSS .= ' SortDescendingLarge';
                        }
                        else {
                            $OrderBy = 'Up';
                            $CSS .= ' SortAscendingLarge';
                        }
                    }
                    else {
                        $OrderBy = 'Up';
                    }

                    $LayoutObject->Block(
                        Name => 'RecordDynamicFieldHeader',
                        Data => {
                            %Param,
                            CSS => $CSS,
                        },
                    );

                    $LayoutObject->Block(
                        Name => 'RecordDynamicFieldHeaderSortable',
                        Data => {
                            %Param,
                            OrderBy          => $OrderBy,
                            Label            => $Label,
                            DynamicFieldName => $DynamicFieldConfig->{Name},
                        },
                    );

                    # example of dynamic fields order customization
                    $LayoutObject->Block(
                        Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name} . 'Header',
                        Data => {
                            %Param,
                            CSS => $CSS,
                        },
                    );

                    $LayoutObject->Block(
                        Name => 'RecordDynamicField_'
                            . $DynamicFieldConfig->{Name}
                            . 'HeaderSortable',
                        Data => {
                            %Param,
                            OrderBy          => $OrderBy,
                            Label            => $Label,
                            DynamicFieldName => $DynamicFieldConfig->{Name},
                        },
                    );
                }
                else {

                    $LayoutObject->Block(
                        Name => 'RecordDynamicFieldHeader',
                        Data => {
                            %Param,
                        },
                    );

                    $LayoutObject->Block(
                        Name => 'RecordDynamicFieldHeaderNotSortable',
                        Data => {
                            %Param,
                            Label => $Label,
                        },
                    );

                    # example of dynamic fields order customization
                    $LayoutObject->Block(
                        Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name} . 'Header',
                        Data => {
                            %Param,
                        },
                    );

                    $LayoutObject->Block(
                        Name => 'RecordDynamicField_'
                            . $DynamicFieldConfig->{Name}
                            . 'HeaderNotSortable',
                        Data => {
                            %Param,
                            Label => $Label,
                        },
                    );
                }
            }
        }

        my $Counter = 0;

        ID:
        for my $ID (@IDs) {
            $Counter++;
            if (
                $Counter >= $Param{StartHit}
                && $Counter < ( $Param{PageShown} + $Param{StartHit} )
                )
            {

                # to store all data
                my %Data;

                my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

                my %FAQ = $FAQObject->FAQGet(
                    ItemID     => $ID,
                    ItemFields => 0,
                    UserID     => $Self->{UserID},
                );

                $FAQ{CleanTitle} = $FAQObject->FAQArticleTitleClean(
                    Title => $FAQ{Title},
                    Size  => $Param{TitleSize},
                );

                next ID if !%FAQ;

                # add FAQ data
                %Data = ( %Data, %FAQ );

                # build record block
                $LayoutObject->Block(
                    Name => 'Record',
                    Data => {
                        %Param,
                        %Data,
                    },
                );

                # build column record blocks
                if (@ShowColumns) {
                    COLUMN:
                    for my $Column (@ShowColumns) {

                        # do not show language column if FAQ does not support multiple languages
                        next COLUMN if ( $Column eq 'Language' && !$MultiLanguage );

                        $LayoutObject->Block(
                            Name => 'Record' . $Column,
                            Data => {
                                %Param,
                                %Data,
                            },
                        );

                        # do not display columns as links in the customer frontend
                        next COLUMN if $Param{Frontend} eq 'Customer';

                        # show links if available
                        $LayoutObject->Block(
                            Name => 'Record' . $Column . 'LinkStart',
                            Data => {
                                %Param,
                                %Data,
                            },
                        );
                        $LayoutObject->Block(
                            Name => 'Record' . $Column . 'LinkEnd',
                            Data => {
                                %Param,
                                %Data,
                            },
                        );
                    }
                }

                # Dynamic fields
                DYNAMICFIELD:
                for my $DynamicFieldConfig ( @{$DynamicField} ) {
                    next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                    # get field value
                    my $Value = $DynamicFieldBackendObject->ValueGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectID           => $ID,
                    );

                    my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Value              => $Value,
                        ValueMaxChars      => 20,
                        LayoutObject       => $LayoutObject,
                    );

                    $LayoutObject->Block(
                        Name => 'RecordDynamicField',
                        Data => {
                            Value => $ValueStrg->{Value},
                            Title => $ValueStrg->{Title},
                        },
                    );

                    if ( $ValueStrg->{Link} ) {
                        $LayoutObject->Block(
                            Name => 'RecordDynamicFieldLink',
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
                            Name => 'RecordDynamicFieldPlain',
                            Data => {
                                Value => $ValueStrg->{Value},
                                Title => $ValueStrg->{Title},
                            },
                        );
                    }

                    # example of dynamic fields order customization
                    $LayoutObject->Block(
                        Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name},
                        Data => {
                            Value => $ValueStrg->{Value},
                            Title => $ValueStrg->{Title},
                        },
                    );

                    if ( $ValueStrg->{Link} ) {
                        $LayoutObject->Block(
                            Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name} . '_Link',
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
                            Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name} . '_Plain',
                            Data => {
                                Value => $ValueStrg->{Value},
                                Title => $ValueStrg->{Title},
                            },
                        );
                    }
                }
            }
        }
    }
    else {
        $LayoutObject->Block( Name => 'NoFAQFound' );
    }

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentFAQOverviewSmall',
        Data         => {
            %Param,
            Type        => $Self->{ViewType},
            ColumnCount => scalar @ShowColumns,
        },
    );

    return $Output;
}

1;
