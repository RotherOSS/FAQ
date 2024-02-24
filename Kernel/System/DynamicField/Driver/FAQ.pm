# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::System::DynamicField::Driver::FAQ;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::BaseReference);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::FAQ',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DynamicField::Driver::FAQ - backend for the Reference dynamic field

=head1 DESCRIPTION

FAQ plugin for the Reference dynamic field.

=head1 PUBLIC INTERFACE

=head2 new()

it is usually not necessary to explicitly create instances of dynamic field drivers.
Instances of the drivers are created in the constructor of the
dynamic field backend object C<Kernel::System::DynamicField::Backend>.

=cut

sub new {
    my ($Type) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # Some reference dynamic fields are stored in the database table attribute dynamic_field_value.value_int.
    $Self->{ValueType}      = 'Integer';
    $Self->{ValueKey}       = 'ValueInt';
    $Self->{TableAttribute} = 'value_int';

    # Used for declaring CSS classes
    $Self->{FieldCSSClass} = 'DynamicFieldReference';

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 0,
        'IsNotificationEventCondition' => 0,
        'IsSortable'                   => 1,
        'IsFiltrable'                  => 1,
        'IsStatsCondition'             => 0,
        'IsCustomerInterfaceCapable'   => 1,
        'IsHiddenInTicketInformation'  => 0,
        'IsReferenceField'             => 1,
        'IsSetCapable'                 => 1,
        'SetsDynamicContent'           => 1,
    };

    $Self->{ReferencedObjectType} = 'FAQ';

    return $Self;
}

=head2 GetFieldTypeSettings()

Get field type settings that are specific to the referenced object type FAQ.

=cut

sub GetFieldTypeSettings {
    my ( $Self, %Param ) = @_;

    my @FieldTypeSettings = $Self->SUPER::GetFieldTypeSettings(
        %Param,
    );

    # Support configurable search key
    push @FieldTypeSettings,
        {
            ConfigParamName => 'SearchAttribute',
            Label           => Translatable('Attribute which will be searched on autocomplete'),
            Explanation     => Translatable('Select the attribute which tickets will be searched by'),
            InputType       => 'Selection',
            SelectionData   => {
                'Number' => 'Number',
                'Title'  => 'Title',
            },
            PossibleNone => 1,
            Multiple     => 0,
        };

    # Support various display options
    push @FieldTypeSettings,
        {
            ConfigParamName => 'DisplayType',
            Label           => Translatable('Attribute which is displayed for values'),
            Explanation     => Translatable('Select the type of display'),
            InputType       => 'Selection',
            SelectionData   => {
                'NumberTitle'   => 'FAQ Number#<FAQ Title>',
                'CategoryTitle' => '<Category Name> - <FAQ Title>',
                'TitleNumber'   => '<FAQ Title> (<FAQ Number>)',
            },
            PossibleNone => 1,
            Multiple     => 0,
        };

    # Support reference filters
    push @FieldTypeSettings,
        {
            ConfigParamName => 'ReferenceFilterList',
        };

    return @FieldTypeSettings;
}

=head2 ObjectPermission()

checks read permission for a given object and UserID.

    $Permission = $BackendObject->ObjectPermission(
        Key     => 123,
        UserID  => 1,
    );

=cut

sub ObjectPermission {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    return $Kernel::OM->Get('Kernel::System::FAQ')->FAQPermission(
        FAQID  => $Param{Key},
        UserID => $Param{UserID},
        Type   => 'ro',
    );
}

=head2 ObjectDescriptionGet()

return a hash of object descriptions.

    my %Description = $BackendObject->ObjectDescriptionGet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => 123,
        UserID             => 1,
    );

Return

    %Description = (
        Normal => "FAQ# 1234455",
        Long   => "FAQ# 1234455: Need a sample ticket title",
    );

=cut

sub ObjectDescriptionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ObjectID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # TODO: Discuss security considerations - not much is shown though
    my $UserID = 1;

    # get ticket
    my %FAQ = $Kernel::OM->Get('Kernel::System::FAQ')->FAQGet(
        FAQID         => $Param{ObjectID},
        UserID        => $UserID,
        DynamicFields => 0,
    );

    return unless %FAQ;

    my %Descriptions;
    if ( $Param{DynamicFieldConfig} && $Param{DynamicFieldConfig}{Config}{DisplayType} ) {

        # prepare string as configured
        my $DisplayType = $Param{DynamicFieldConfig}{Config}{DisplayType};
        if ( $DisplayType eq 'CategoryTitle' ) {
            $Descriptions{Normal} = "$FAQ{CategoryShortName} - $FAQ{Title}";
            $Descriptions{Long}   = "$FAQ{CategoryName} - $FAQ{Title}";
        }
        elsif ( $DisplayType eq 'NumberTitle' ) {
            $Descriptions{Normal} = "$FAQ{Number}#$FAQ{Title}";
            $Descriptions{Long}   = "$FAQ{Number}#$FAQ{Title}";
        }
        elsif ( $DisplayType eq 'TitleNumber' ) {
            $Descriptions{Normal} = "$FAQ{Title} ($FAQ{Number})";
            $Descriptions{Long}   = "$FAQ{Title} ($FAQ{Number})";
        }
    }
    else {

        $Descriptions{Normal} = "$FAQ{Title} ($FAQ{Number})";
        $Descriptions{Long}   = "$FAQ{Title} ($FAQ{Number})";
    }

    my $Link;
    if ( $Param{Link} && $Param{LayoutObject}{SessionSource} ) {
        if ( $Param{LayoutObject}{SessionSource} eq 'AgentInterface' ) {

            # TODO: only show the link if the user $Param{UserID} has permissions
            $Link = $Param{LayoutObject}{Baselink} . "Action=AgentFAQZoom;ItemID=$Param{ObjectID}";
        }
    }

    # create description
    return (
        %Descriptions,
        Link => $Link,
    );
}

=head2 SearchObjects()

This is used in auto completion when searching for possible object IDs.

    my @ObjectIDs = $BackendObject->SearchObjects(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $ObjectID,                # (optional) if given, takes precedence over Term
        Term               => $Term,                    # (optional) defaults to wildcard search with empty string
        MaxResults         => $MaxResults,
        UserID             => 1,
        Object             => {
            %Data,
        },
        ParamObject        => $ParamObject,
    );

=cut

sub SearchObjects {
    my ( $Self, %Param ) = @_;

    $Param{Term} //= '';

    my $DynamicFieldConfig = $Param{DynamicFieldConfig};

    my %SearchParams;

    if ( $Param{ObjectID} ) {
        $SearchParams{Number} = $Param{ObjectID};
    }
    else {

        # include configured search param if present
        my $SearchAttribute = $DynamicFieldConfig->{Config}{SearchAttribute} || 'What';

        $SearchParams{$SearchAttribute} = "*$Param{Term}*";
    }

    # incorporate referencefilterlist into search params
    if ( $DynamicFieldConfig->{Config}{ReferenceFilterList} ) {
        FILTERITEM:
        for my $FilterItem ( $DynamicFieldConfig->{Config}{ReferenceFilterList}->@* ) {

            # check filter config
            next FILTERITEM unless $FilterItem->{ReferenceObjectAttribute};
            next FILTERITEM unless ( $FilterItem->{EqualsObjectAttribute} || $FilterItem->{EqualsString} );

            if ( $FilterItem->{EqualsObjectAttribute} ) {

                # don't perform search if object attribute to search for is empty
                my $EqualsObjectAttribute;
                if ( IsHashRefWithData( $Param{Object} ) ) {
                    $EqualsObjectAttribute = $Param{Object}{DynamicField}{ $FilterItem->{EqualsObjectAttribute} } // $Param{Object}{ $FilterItem->{EqualsObjectAttribute} };
                }
                elsif ( defined $Param{ParamObject} ) {
                    if ( $FilterItem->{EqualsObjectAttribute} =~ /^DynamicField_(?<DFName>\S+)/ ) {
                        my $FilterItemDFConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                            Name => $+{DFName},
                        );
                        next FILTERITEM unless IsHashRefWithData($FilterItemDFConfig);
                        $EqualsObjectAttribute = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->EditFieldValueGet(
                            ParamObject        => $Param{ParamObject},
                            DynamicFieldConfig => $FilterItemDFConfig,
                            TransformDates     => 0,
                        );
                    }
                    else {
                        $EqualsObjectAttribute = $Param{ParamObject}->GetParam( Param => $FilterItem->{EqualsObjectAttribute} );
                    }
                }
                return unless $EqualsObjectAttribute;
                return if ( ref $EqualsObjectAttribute eq 'ARRAY' && !$EqualsObjectAttribute->@* );

                # config item attribute
                if ( $FilterItem->{ReferenceObjectAttribute} =~ m{^Con}i ) {
                    $SearchParams{ $FilterItem->{ReferenceObjectAttribute} } = $EqualsObjectAttribute;
                }

                # dynamic field attribute
                elsif ( $FilterItem->{ReferenceObjectAttribute} =~ m{^Dyn}i ) {
                    $SearchParams{ $FilterItem->{ReferenceObjectAttribute} } = {
                        Equals => $EqualsObjectAttribute,
                    };
                }

                # array attribute
                else {
                    $SearchParams{ $FilterItem->{ReferenceObjectAttribute} } = [$EqualsObjectAttribute];
                }
            }
            elsif ( $FilterItem->{EqualsString} ) {

                # config item attribute
                # TODO check if this has to be adapted for ticket search
                if ( $FilterItem->{ReferenceObjectAttribute} =~ m{^Con}i ) {
                    $SearchParams{ $FilterItem->{ReferenceObjectAttribute} } = $FilterItem->{EqualsString};
                }

                # dynamic field attribute
                elsif ( $FilterItem->{ReferenceObjectAttribute} =~ m{^Dyn}i ) {
                    $SearchParams{ $FilterItem->{ReferenceObjectAttribute} } = {
                        Equals => $FilterItem->{EqualsString},
                    };
                }

                # array attribute
                else {
                    $SearchParams{ $FilterItem->{ReferenceObjectAttribute} } = [ $FilterItem->{EqualsString} ];
                }
            }
        }
    }

    # return a list of ticket IDs
    return $Kernel::OM->Get('Kernel::System::FAQ')->FAQSearch(
        Limit            => $Param{MaxResults},
        Result           => 'ARRAY',
        UserID           => $Param{UserID} // 1,
        OrderBy          => ['Number'],
        OrderByDirection => ['Down'],
        %SearchParams,
    );
}

1;
