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

package Kernel::Modules::CustomerFAQSearch;

use strict;
use warnings;

use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get config for frontend
    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("FAQ::Frontend::$Self->{Action}");

    # get dynamic field config for frontend module
    my $DynamicFieldFilter = $Self->{Config}->{DynamicField};

    # get the dynamic fields for FAQ object
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => 'FAQ',
        FieldFilter => $DynamicFieldFilter || {},
    );

    # reduce the dynamic fields to only the ones that are designed for customer interface
    my @CustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CustomerDynamicFields, $DynamicFieldConfig;
    }
    $Self->{DynamicField} = \@CustomerDynamicFields;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # get config from constructor
    my $Config = $Self->{Config};

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get config data
    my $StartHit        = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );
    my $SearchLimit     = $Config->{SearchLimit}     || 200;
    my $SearchPageShown = $Config->{SearchPageShown} || 40;
    my $SortBy          = $ParamObject->GetParam( Param => 'SortBy' )
        || $Config->{'SortBy::Default'}
        || 'FAQID';
    my $OrderBy = $ParamObject->GetParam( Param => 'Order' )
        || $Config->{'Order::Default'}
        || 'Down';

    my $Profile        = $ParamObject->GetParam( Param => 'Profile' )        || '';
    my $SaveProfile    = $ParamObject->GetParam( Param => 'SaveProfile' )    || '';
    my $TakeLastSearch = $ParamObject->GetParam( Param => 'TakeLastSearch' ) || '';
    my $EraseTemplate  = $ParamObject->GetParam( Param => 'EraseTemplate' )  || '';

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # search with a saved template
    if ( $ParamObject->GetParam( Param => 'SearchTemplate' ) && $Profile ) {
        return $LayoutObject->Redirect(
            OP =>
                "Action=CustomerFAQSearch;Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=$Profile",
        );
    }

    # build output for open search description by FAQ number
    if ( $Self->{Subaction} eq 'OpenSearchDescriptionFAQNumber' ) {
        my $Output = $LayoutObject->Output(
            TemplateFile => 'CustomerFAQSearchOpenSearchDescriptionFAQNumber',
            Data         => \%Param,
        );
        return $LayoutObject->Attachment(
            Filename    => 'OpenSearchDescriptionFAQNumber.xml',
            ContentType => 'application/opensearchdescription+xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # build output for open search description by full-text
    if ( $Self->{Subaction} eq 'OpenSearchDescriptionFulltext' ) {
        my $Output = $LayoutObject->Output(
            TemplateFile => 'CustomerFAQSearchOpenSearchDescriptionFullText',
            Data         => \%Param,
        );
        return $LayoutObject->Attachment(
            Filename    => 'OpenSearchDescriptionFulltext.xml',
            ContentType => 'application/opensearchdescription+xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # remember exclude attributes
    my @Excludes = $ParamObject->GetArray( Param => 'Exclude' );

    # get single params
    my %GetParam;

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $SearchProfileObject       = $Kernel::OM->Get('Kernel::System::SearchProfile');

    # load profiles string params (press load profile)
    if ( ( $Self->{Subaction} eq 'LoadProfile' && $Profile ) || $TakeLastSearch ) {
        %GetParam = $SearchProfileObject->SearchProfileGet(
            Base      => 'CustomerFAQSearch',
            Name      => $Profile,
            UserLogin => $Self->{UserLogin},
        );
    }

    # get search string params (get submitted params)
    else {
        for my $ParamName (
            qw(Number Title Keyword Fulltext ResultForm TimeSearchType VoteSearch VoteSearchType
            VoteSearchOption RateSearch RateSearchType RateSearchOption
            ItemCreateTimePointFormat ItemCreateTimePoint
            ItemCreateTimePointStart
            ItemCreateTimeStart ItemCreateTimeStartDay ItemCreateTimeStartMonth
            ItemCreateTimeStartYear
            ItemCreateTimeStop ItemCreateTimeStopDay ItemCreateTimeStopMonth
            ItemCreateTimeStopYear
            )
            )
        {

            # get search string params (get submitted params)
            $GetParam{$ParamName} = $ParamObject->GetParam( Param => $ParamName );

            # remove whitespace on the start and end
            if ( $GetParam{$ParamName} ) {
                $GetParam{$ParamName} =~ s{ \A \s+ }{}xms;
                $GetParam{$ParamName} =~ s{ \s+ \z }{}xms;
            }
        }

        # get array params
        for my $ParamName (qw(CategoryIDs LanguageIDs )) {

            # get search array params (get submitted params)
            my @Array = $ParamObject->GetArray( Param => $ParamName );
            if (@Array) {
                $GetParam{$ParamName} = \@Array;
            }
        }

        # get Dynamic fields form param object
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # get search field preferences
            my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # extract the dynamic field value from the web request
                my $DynamicFieldValue = $DynamicFieldBackendObject->SearchFieldValueGet(
                    DynamicFieldConfig     => $DynamicFieldConfig,
                    ParamObject            => $ParamObject,
                    ReturnProfileStructure => 1,
                    LayoutObject           => $LayoutObject,
                    Type                   => $Preference->{Type},
                );

                # set the complete value structure in GetParam to store it later in the search
                # profile
                if ( IsHashRefWithData($DynamicFieldValue) ) {
                    %GetParam = ( %GetParam, %{$DynamicFieldValue} );
                }
            }
        }
    }

    # check if item need to get excluded
    for my $Exclude (@Excludes) {
        if ( $GetParam{$Exclude} ) {
            delete $GetParam{$Exclude};
        }
    }

    # get vote option
    if ( !$GetParam{VoteSearchOption} ) {
        $GetParam{'VoteSearchOption::None'} = 'checked="checked"';
    }
    elsif ( $GetParam{VoteSearchOption} eq 'VotePoint' ) {
        $GetParam{'VoteSearchOption::VotePoint'} = 'checked="checked"';
    }

    # get rate option
    if ( !$GetParam{RateSearchOption} ) {
        $GetParam{'RateSearchOption::None'} = 'checked="checked"';
    }
    elsif ( $GetParam{RateSearchOption} eq 'RatePoint' ) {
        $GetParam{'RateSearchOption::RatePoint'} = 'checked="checked"';
    }

    # get time option
    if ( !$GetParam{TimeSearchType} ) {
        $GetParam{'TimeSearchType::None'} = 'checked="checked"';
    }
    elsif ( $GetParam{TimeSearchType} eq 'TimePoint' ) {
        $GetParam{'TimeSearchType::TimePoint'} = 'checked="checked"';
    }
    elsif ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'TimeSearchType::TimeSlot'} = 'checked="checked"';
    }

    # set result form ENV
    if ( !$GetParam{ResultForm} ) {
        $GetParam{ResultForm} = '';
    }
    if ( $GetParam{ResultForm} eq 'Print' ) {
        $SearchPageShown = $SearchLimit;
    }

    # check request
    if ( $Self->{Subaction} eq 'OpenSearchDescription' ) {
        my $Output = $LayoutObject->Output(
            TemplateFile => 'CustomerFAQSearchOpenSearchDescription',
            Data         => {%Param},
        );
        return $LayoutObject->Attachment(
            Filename    => 'OpenSearchDescription.xml',
            ContentType => 'text/xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get default multi language option
    my $MultiLanguage = $ConfigObject->Get('FAQ::MultiLanguage');

    # show result page
    if ( $Self->{Subaction} eq 'Search' && !$EraseTemplate ) {

        # fill up profile name (e.g. with last-search)
        if ( !$Profile || !$SaveProfile ) {
            $Profile = 'last-search';
        }

        # store last overview screen
        my $URL = "Action=CustomerFAQSearch;Subaction=Search;Profile=$Profile"
            . ";SortBy=$SortBy;OrderBy=$OrderBy;TakeLastSearch=1"
            . ";StartHit=$StartHit";

        my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

        # store last screen
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $URL,
        );
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $URL,
        );

        # save search profile (under last-search or real profile name)
        $SaveProfile = 1;

        # remember last search values
        if ( $SaveProfile && $Profile ) {

            # remove old profile stuff
            $SearchProfileObject->SearchProfileDelete(
                Base      => 'CustomerFAQSearch',
                Name      => $Profile,
                UserLogin => $Self->{UserLogin},
            );

            # insert new profile params
            for my $ParamName ( sort keys %GetParam ) {
                if ( $GetParam{$ParamName} ) {
                    $SearchProfileObject->SearchProfileAdd(
                        Base      => 'CustomerFAQSearch',
                        Name      => $Profile,
                        Key       => $ParamName,
                        Value     => $GetParam{$ParamName},
                        UserLogin => $Self->{UserLogin},
                    );
                }
            }
        }

        # dynamic fields search parameters for FAQ search
        my %DynamicFieldSearchParameters;
        my %DynamicFieldSearchDisplay;

        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # get search field preferences
            my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                my $DynamicFieldValue = $DynamicFieldBackendObject->SearchFieldValueGet(
                    DynamicFieldConfig     => $DynamicFieldConfig,
                    ParamObject            => $ParamObject,
                    Type                   => $Preference->{Type},
                    ReturnProfileStructure => 1,
                );

                # set the complete value structure in %DynamicFieldValues to discard those where the
                # value will not be possible to get
                next PREFERENCE if !IsHashRefWithData($DynamicFieldValue);

                # extract the dynamic field value from the profile
                my $SearchParameter = $DynamicFieldBackendObject->SearchFieldParameterBuild(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Profile            => \%GetParam,
                    LayoutObject       => $LayoutObject,
                    Type               => $Preference->{Type},
                );

                # set search parameter
                if ( defined $SearchParameter ) {
                    $DynamicFieldSearchParameters{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                        = $SearchParameter->{Parameter};

                    # set value to display
                    $DynamicFieldSearchDisplay{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                        = $SearchParameter->{Display};
                }
            }
        }

        # prepare full-text search
        if ( $GetParam{Fulltext} ) {
            $GetParam{ContentSearch} = 'OR';
            $GetParam{What}          = $GetParam{Fulltext};
        }

        # prepare votes search
        if ( IsNumber( $GetParam{VoteSearch} ) && $GetParam{VoteSearchOption} ) {
            $GetParam{Votes} = {
                $GetParam{VoteSearchType} => $GetParam{VoteSearch}
            };
        }

        # prepare rate search
        if ( IsNumber( $GetParam{RateSearch} ) && $GetParam{RateSearchOption} ) {
            $GetParam{Rate} = {
                $GetParam{RateSearchType} => $GetParam{RateSearch}
            };
        }

        my %TimeMap = (
            ItemCreate => 'Time',
        );

        for my $TimeType ( sort keys %TimeMap ) {

            # get create time settings
            if ( !$GetParam{ $TimeMap{$TimeType} . 'SearchType' } ) {

                # do nothing with time stuff
            }
            elsif ( $GetParam{ $TimeMap{$TimeType} . 'SearchType' } eq 'TimeSlot' ) {
                for my $Key (qw(Month Day)) {
                    $GetParam{ $TimeType . 'TimeStart' . $Key }
                        = sprintf( "%02d", $GetParam{ $TimeType . 'TimeStart' . $Key } );
                    $GetParam{ $TimeType . 'TimeStop' . $Key }
                        = sprintf( "%02d", $GetParam{ $TimeType . 'TimeStop' . $Key } );
                }
                if (
                    $GetParam{ $TimeType . 'TimeStartDay' }
                    && $GetParam{ $TimeType . 'TimeStartMonth' }
                    && $GetParam{ $TimeType . 'TimeStartYear' }
                    )
                {
                    $GetParam{ $TimeType . 'TimeNewerDate' } = $GetParam{ $TimeType . 'TimeStartYear' } . '-'
                        . $GetParam{ $TimeType . 'TimeStartMonth' } . '-'
                        . $GetParam{ $TimeType . 'TimeStartDay' }
                        . ' 00:00:00';
                }
                if (
                    $GetParam{ $TimeType . 'TimeStopDay' }
                    && $GetParam{ $TimeType . 'TimeStopMonth' }
                    && $GetParam{ $TimeType . 'TimeStopYear' }
                    )
                {
                    $GetParam{ $TimeType . 'TimeOlderDate' } = $GetParam{ $TimeType . 'TimeStopYear' } . '-'
                        . $GetParam{ $TimeType . 'TimeStopMonth' } . '-'
                        . $GetParam{ $TimeType . 'TimeStopDay' }
                        . ' 23:59:59';
                }
            }
            elsif ( $GetParam{ $TimeMap{$TimeType} . 'SearchType' } eq 'TimePoint' ) {
                if (
                    $GetParam{ $TimeType . 'TimePoint' }
                    && $GetParam{ $TimeType . 'TimePointStart' }
                    && $GetParam{ $TimeType . 'TimePointFormat' }
                    )
                {
                    my $Time = 0;
                    if ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'minute' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' };
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'hour' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'day' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60 * 24;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'week' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60 * 24 * 7;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'month' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60 * 24 * 30;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'year' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60 * 24 * 365;
                    }
                    if ( $GetParam{ $TimeType . 'TimePointStart' } eq 'Before' ) {

                        # more than ... ago
                        $GetParam{ $TimeType . 'TimeOlderMinutes' } = $Time;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointStart' } eq 'Next' ) {

                        # within next
                        $GetParam{ $TimeType . 'TimeNewerMinutes' } = 0;
                        $GetParam{ $TimeType . 'TimeOlderMinutes' } = -$Time;
                    }
                    else {
                        # within last ...
                        $GetParam{ $TimeType . 'TimeOlderMinutes' } = 0;
                        $GetParam{ $TimeType . 'TimeNewerMinutes' } = $Time;
                    }
                }
            }
        }

        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

        # set default interface settings
        my $Interface = $FAQObject->StateTypeGet(
            Name   => 'external',
            UserID => $Self->{UserID},
        );
        my $InterfaceStates = $FAQObject->StateTypeList(
            Types  => $ConfigObject->Get('FAQ::Customer::StateTypes'),
            UserID => $Self->{UserID},
        );

        # Get UserCategoryGroup Hash.
        # This returns a Hash of the following sample data structure:
        #
        # $CustomerUserCatGroup = {
        #   '1' => {
        #          '3' => 'MiscSub'
        #        },
        #   '3' => {},
        #   '0' => {
        #            '1' => 'Misc',
        #            '2' => 'secret'
        #          },
        #   '2' => {}
        # };
        #
        # Keys of the outer hash inform about subcategories.
        #   0 Shows top level CategoryIDs.
        #   1 Shows the SubcategoryIDs of Category 1.
        #   2 and 3 are empty hashes because these categories don't have subcategories.
        #
        # Keys of the inner hashes are CategoryIDs a user is allowed to have ro access to.
        # Values are the Category names.

        my $CustomerUserCatGroup = $FAQObject->GetCustomerCategories(
            CustomerUser => $Self->{UserLogin},
            Type         => 'ro',
            UserID       => $Self->{UserID},
        );

        # Find CategoryIDs the current User is allowed to view.
        my %AllowedCategoryIDs = ();

        if ( $CustomerUserCatGroup && ref $CustomerUserCatGroup eq 'HASH' ) {

            # So now we have to extract all Category ID's of the "inner hashes"
            #   -> Loop through the outer category ID's.
            for my $Level ( sort keys %{$CustomerUserCatGroup} ) {

                # Check if the Value of the current hash key is a hash ref.
                if ( $CustomerUserCatGroup->{$Level} && ref $CustomerUserCatGroup->{$Level} eq 'HASH' ) {

                    # Map the keys of the inner hash to a TempIDs hash.
                    # Original Data structure:
                    #   {
                    #       '1' => 'Misc',
                    #       '2' => 'secret'
                    #   }
                    #
                    #   after mapping:
                    #
                    #   {
                    #       '1' => 1,
                    #       '2' => 1'
                    #   }

                    my %TempIDs = map { $_ => 1 } keys %{ $CustomerUserCatGroup->{$Level} };

                    # Put the TempIDs over the formally found AllowedCategorys to produce a hash
                    #   that holds all CategoryID as keys and the number 1 as values.
                    %AllowedCategoryIDs = (
                        %AllowedCategoryIDs,
                        %TempIDs
                    );
                }
            }
        }

        # For the database query it's necessary to have an array of CategoryIDs.
        my @CategoryIDs = ();

        if (%AllowedCategoryIDs) {
            @CategoryIDs = sort keys %AllowedCategoryIDs;
        }

        # Categories got from the web request could include a not allowed category if the user
        #    temper with the categories drop-box, a check is needed.
        #
        # "Map" copy from one array to another, while "grep" will only let pass the categories
        #    that are defined in the %AllowedCategoryIDs hash.
        if ( IsArrayRefWithData( $GetParam{CategoryIDs} ) ) {
            @{ $GetParam{CategoryIDs} } = map {$_} grep { $AllowedCategoryIDs{$_} } @{ $GetParam{CategoryIDs} };
        }

        # Just search if we do have categories, we have access to.
        # If we don't have access to any category, a search with no CategoryIDs
        #   would result in finding all categories.
        #
        # It is not possible to create FAQ's without categories
        #   so at least one category has to be present

        my @ViewableItemIDs = ();

        if (@CategoryIDs) {

            # perform FAQ search
            @ViewableItemIDs = $FAQObject->FAQSearch(
                OrderBy             => [$SortBy],
                OrderByDirection    => [$OrderBy],
                Limit               => $SearchLimit,
                UserID              => $Self->{UserID},
                States              => $InterfaceStates,
                Interface           => $Interface,
                ContentSearchPrefix => '*',
                ContentSearchSuffix => '*',
                CategoryIDs         => \@CategoryIDs,
                %GetParam,
                %DynamicFieldSearchParameters,
            );
        }

        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        # CSV output
        if ( $GetParam{ResultForm} eq 'CSV' ) {
            my @TmpCSVHead;
            my @CSVHead;
            my @CSVData;

            # get the FAQ dynamic fields for CSV display
            my $CSVDynamicField = $DynamicFieldObject->DynamicFieldListGet(
                Valid       => 1,
                ObjectType  => 'FAQ',
                FieldFilter => $Config->{SearchCSVDynamicField} || {},
            );

            # reduce the dynamic fields to only the ones that are designed for customer interface
            my @CSVCustomerDynamicFields;
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{$CSVDynamicField} ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                my $IsCustomerInterfaceCapable = $DynamicFieldBackendObject->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsCustomerInterfaceCapable',
                );
                next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

                push @CSVCustomerDynamicFields, $DynamicFieldConfig;
            }
            $CSVDynamicField = \@CSVCustomerDynamicFields;

            for my $ItemID (@ViewableItemIDs) {

                my %FAQData = $FAQObject->FAQGet(
                    ItemID        => $ItemID,
                    ItemFields    => 0,
                    DynamicFields => 1,
                    UserID        => $Self->{UserID},
                );

                # get info for CSV output
                my %CSVInfo = (%FAQData);

                # format the change time
                $CSVInfo{Changed} = $LayoutObject->{LanguageObject}->FormatTimeString(
                    $FAQData{Changed},
                    'DateFormat',
                );

                # CSV quote
                if ( !@CSVHead ) {
                    @TmpCSVHead = qw( FAQNumber Title Category);
                    @CSVHead    = qw( FAQNumber Title Category);

                    # insert language header
                    if ($MultiLanguage) {
                        push @TmpCSVHead, 'Language';
                        push @CSVHead,    'Language';
                    }

                    push @TmpCSVHead, qw(State Changed);
                    push @CSVHead,    qw(State Changed);

                    # include the selected dynamic fields on CVS results
                    DYNAMICFIELD:
                    for my $DynamicFieldConfig ( @{$CSVDynamicField} ) {
                        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
                        next DYNAMICFIELD if $DynamicFieldConfig->{Name} eq '';

                        push @TmpCSVHead, 'DynamicField_' . $DynamicFieldConfig->{Name};
                        push @CSVHead,    $DynamicFieldConfig->{Label};
                    }
                }
                my @Data;
                for my $Header (@TmpCSVHead) {

                    # check if header is a dynamic field and get the value from dynamic field
                    # backend
                    if ( $Header =~ m{\A DynamicField_ ( [a-zA-Z\d]+ ) \z}xms ) {

                        # loop over the dynamic fields configured for CSV output
                        DYNAMICFIELD:
                        for my $DynamicFieldConfig ( @{$CSVDynamicField} ) {
                            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                            next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

                            # skip all fields that does not match with current field name ($1)
                            # with out the 'DynamicField_' prefix
                            next DYNAMICFIELD if $DynamicFieldConfig->{Name} ne $1;

                            # get the value as for print (to correctly display)
                            my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
                                DynamicFieldConfig => $DynamicFieldConfig,
                                Value              => $CSVInfo{$Header},
                                HTMLOutput         => 0,
                                LayoutObject       => $LayoutObject,
                            );
                            push @Data, $ValueStrg->{Value};

                            # terminate the DYNAMICFIELD loop
                            last DYNAMICFIELD;
                        }
                    }

                    # otherwise retrieve data from FAQ item
                    else {
                        if ( $Header eq 'FAQNumber' ) {
                            push @Data, $CSVInfo{'Number'};
                        }
                        elsif ( $Header eq 'Category' ) {
                            push @Data, $CSVInfo{'CategoryName'};
                        }
                        else {
                            push @Data, $CSVInfo{$Header};
                        }
                    }
                }
                push @CSVData, \@Data;
            }

            # CSV quote
            # translate non existing header may result in a garbage file
            if ( !@CSVHead ) {
                @TmpCSVHead = qw(FAQNumber Title Category);
                @CSVHead    = qw(FAQNumber Title Category);

                # insert language header
                if ($MultiLanguage) {
                    push @TmpCSVHead, 'Language';
                    push @CSVHead,    'Language';
                }

                push @TmpCSVHead, qw(State Changed);
                push @CSVHead,    qw(State Changed);

                # include the selected dynamic fields on CVS results
                DYNAMICFIELD:
                for my $DynamicFieldConfig ( @{$CSVDynamicField} ) {
                    next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                    next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
                    next DYNAMICFIELD if $DynamicFieldConfig->{Name} eq '';

                    push @TmpCSVHead, 'DynamicField_' . $DynamicFieldConfig->{Name};
                    push @CSVHead,    $DynamicFieldConfig->{Label};
                }
            }

            # translate headers
            for my $Header (@CSVHead) {

                # replace FAQNumber header with the current FAQHook from config
                if ( $Header eq 'FAQNumber' ) {
                    $Header = $ConfigObject->Get('FAQ::FAQHook');
                }
                else {
                    $Header = $LayoutObject->{LanguageObject}->Translate($Header);
                }
            }

            # assemble CSV data
            my $CSV = $Kernel::OM->Get('Kernel::System::CSV')->Array2CSV(
                Head      => \@CSVHead,
                Data      => \@CSVData,
                Separator => $Self->{UserCSVSeparator},
            );

            # Return CSV to download.
            my $CSVFile = 'FAQ_search';

            my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
            my $DateTime       = $DateTimeObject->Get();
            my $Y              = $DateTime->{Year};
            my $M              = sprintf( "%02d", $DateTime->{Month} );
            my $D              = sprintf( "%02d", $DateTime->{Day} );
            my $h              = sprintf( "%02d", $DateTime->{Hour} );
            my $m              = sprintf( "%02d", $DateTime->{Minute} );

            return $LayoutObject->Attachment(
                Filename    => $CSVFile . "_" . "$Y-$M-$D" . "_" . "$h-$m.csv",
                ContentType => "text/csv; charset=" . $LayoutObject->{UserCharset},
                Content     => $CSV,
            );
        }
        elsif ( $GetParam{ResultForm} eq 'Print' ) {

            my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

            my @PDFData;
            for my $ItemID (@ViewableItemIDs) {

                my %FAQData = $FAQObject->FAQGet(
                    ItemID     => $ItemID,
                    ItemFields => 0,
                    UserID     => $Self->{UserID},
                );

                # set change date to long format
                my $Changed = $LayoutObject->{LanguageObject}->FormatTimeString(
                    $FAQData{Changed},
                    'DateFormatLong',
                );

                # create PDF Rows
                my @PDFRow;
                push @PDFRow, $FAQData{Number};
                push @PDFRow, $FAQData{Title};
                push @PDFRow, $FAQData{CategoryName};

                # create language row
                if ($MultiLanguage) {
                    push @PDFRow, $FAQData{Language};
                }

                push @PDFRow,  $FAQData{State};
                push @PDFRow,  $Changed;
                push @PDFData, \@PDFRow;
            }

            # PDF Output
            my $Title = $LayoutObject->{LanguageObject}->Translate('FAQ') . ' '
                . $LayoutObject->{LanguageObject}->Translate('Search');
            my $PrintedBy = $LayoutObject->{LanguageObject}->Translate('printed by');
            my $Page      = $LayoutObject->{LanguageObject}->Translate('Page');
            my $Time      = $LayoutObject->{Time};

            # get maximum number of pages
            my $MaxPages = $ConfigObject->Get('PDF::MaxPages');
            if ( !$MaxPages || $MaxPages < 1 || $MaxPages > 1000 ) {
                $MaxPages = 100;
            }

            my $CellData;

            # output 'No Result', if no content was given
            if (@PDFData) {

                # create the header
                $CellData->[0]->[0]->{Content} = $ConfigObject->Get('FAQ::FAQHook');
                $CellData->[0]->[0]->{Font}    = 'ProportionalBold';
                $CellData->[0]->[1]->{Content} = $LayoutObject->{LanguageObject}->Translate('Title');
                $CellData->[0]->[1]->{Font}    = 'ProportionalBold';
                $CellData->[0]->[2]->{Content} = $LayoutObject->{LanguageObject}->Translate('Category');
                $CellData->[0]->[2]->{Font}    = 'ProportionalBold';

                # store the correct header index
                my $NextHeaderIndex = 3;

                # add language header
                if ($MultiLanguage) {
                    $CellData->[0]->[3]->{Content} = $LayoutObject->{LanguageObject}->Translate('Language');
                    $CellData->[0]->[3]->{Font}    = 'ProportionalBold';
                    $NextHeaderIndex               = 4;
                }

                $CellData->[0]->[$NextHeaderIndex]->{Content} = $LayoutObject->{LanguageObject}->Translate('State');
                $CellData->[0]->[$NextHeaderIndex]->{Font}    = 'ProportionalBold';

                $CellData->[0]->[ $NextHeaderIndex + 1 ]->{Content}
                    = $LayoutObject->{LanguageObject}->Translate('Changed');
                $CellData->[0]->[ $NextHeaderIndex + 1 ]->{Font} = 'ProportionalBold';

                # create the content array
                my $CounterRow = 1;
                for my $Row (@PDFData) {
                    my $CounterColumn = 0;
                    for my $Content ( @{$Row} ) {
                        $CellData->[$CounterRow]->[$CounterColumn]->{Content} = $Content;
                        $CounterColumn++;
                    }
                    $CounterRow++;
                }
            }
            else {
                $CellData->[0]->[0]->{Content} = $LayoutObject->{LanguageObject}->Translate('No Result!');
            }

            # page params
            my %PageParam;
            $PageParam{PageOrientation} = 'landscape';
            $PageParam{MarginTop}       = 30;
            $PageParam{MarginRight}     = 40;
            $PageParam{MarginBottom}    = 40;
            $PageParam{MarginLeft}      = 40;
            $PageParam{HeaderRight}     = $Title;

            # table params
            my %TableParam;
            $TableParam{CellData}            = $CellData;
            $TableParam{Type}                = 'Cut';
            $TableParam{FontSize}            = 6;
            $TableParam{Border}              = 0;
            $TableParam{BackgroundColorEven} = '#DDDDDD';
            $TableParam{Padding}             = 1;
            $TableParam{PaddingTop}          = 3;
            $TableParam{PaddingBottom}       = 3;

            # create new PDF document
            $PDFObject->DocumentNew(
                Title  => $ConfigObject->Get('Product') . ': ' . $Title,
                Encode => $LayoutObject->{UserCharset},
            );

            # start table output
            $PDFObject->PageNew(
                %PageParam,
                FooterRight => $Page . ' 1',
            );

            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -6,
            );

            # output title
            $PDFObject->Text(
                Text     => $Title,
                FontSize => 13,
            );

            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -6,
            );

            # output "printed by"
            $PDFObject->Text(
                Text => $PrintedBy . ' '
                    . $Self->{UserFullname} . ' ('
                    . $Self->{UserEmail} . ')'
                    . ', ' . $Time,
                FontSize => 9,
            );

            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -14,
            );

            PAGE:
            for ( 2 .. $MaxPages ) {

                # output table (or a fragment of it)
                %TableParam = $PDFObject->Table( %TableParam, );

                # stop output or another page
                if ( $TableParam{State} ) {
                    last PAGE;
                }
                else {
                    $PDFObject->PageNew(
                        %PageParam,
                        FooterRight => $Page . ' ' . $_,
                    );
                }
            }

            # Return the PDF document.
            my $Filename = 'FAQ_search';

            my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
            my $DateTime       = $DateTimeObject->Get();
            my $Y              = $DateTime->{Year};
            my $M              = sprintf( "%02d", $DateTime->{Month} );
            my $D              = sprintf( "%02d", $DateTime->{Day} );
            my $h              = sprintf( "%02d", $DateTime->{Hour} );
            my $m              = sprintf( "%02d", $DateTime->{Minute} );

            my $PDFString = $PDFObject->DocumentOutput();
            return $LayoutObject->Attachment(
                Filename    => $Filename . "_" . "$Y-$M-$D" . "_" . "$h-$m.pdf",
                ContentType => "application/pdf",
                Content     => $PDFString,
                Type        => 'inline',
            );
        }

        my $Counter = 0;

        # if there are results to show
        if (@ViewableItemIDs) {

            my $OverviewConfig = $ConfigObject->Get("FAQ::Frontend::CustomerFAQOverview");

            # get the ticket dynamic fields for overview display
            my $OverviewDynamicField = $DynamicFieldObject->DynamicFieldListGet(
                Valid       => 1,
                ObjectType  => 'FAQ',
                FieldFilter => $OverviewConfig->{DynamicField} || {},
            );

            # reduce the dynamic fields to only the ones that are designed for customer interface
            my @OverviewCustomerDynamicFields;
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{$OverviewDynamicField} ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                my $IsCustomerInterfaceCapable = $DynamicFieldBackendObject->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsCustomerInterfaceCapable',
                );
                next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

                push @OverviewCustomerDynamicFields, $DynamicFieldConfig;
            }

            # Dynamic fields table headers
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{$OverviewDynamicField} ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                my $Label = $DynamicFieldConfig->{Label};

                # get field sortable condition
                my $IsSortable = $DynamicFieldBackendObject->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsSortable',
                );

                if ($IsSortable) {
                    my $CSS   = '';
                    my $Order = 'Down';
                    if (
                        $SortBy
                        && (
                            $SortBy eq
                            ( 'DynamicField_' . $DynamicFieldConfig->{Name} )
                        )
                        )
                    {
                        if ( $Self->{Order} && ( $Self->{Order} eq 'Up' ) ) {
                            $Order = 'Down';
                            $CSS .= ' SortAscending';
                        }
                        else {
                            $Order = 'Up';
                            $CSS .= ' SortDescending';
                        }
                    }

                    $LayoutObject->Block(
                        Name => 'HeaderDynamicField',
                        Data => {
                            %Param,
                            CSS => $CSS,
                        },
                    );

                    $LayoutObject->Block(
                        Name => 'HeaderDynamicFieldSortable',
                        Data => {
                            %Param,
                            Order            => $Order,
                            Label            => $Label,
                            DynamicFieldName => $DynamicFieldConfig->{Name},
                        },
                    );
                }
                else {

                    $LayoutObject->Block(
                        Name => 'HeaderDynamicField',
                        Data => {
                            %Param,
                        },
                    );

                    $LayoutObject->Block(
                        Name => 'HeaderDynamicFieldNotSortable',
                        Data => {
                            %Param,
                            Label => $Label,
                        },
                    );
                }
            }

            for my $ItemID (@ViewableItemIDs) {

                $Counter++;

                # build search result
                if (
                    $Counter >= $StartHit
                    && $Counter < ( $SearchPageShown + $StartHit )
                    )
                {

                    my %FAQData = $FAQObject->FAQGet(
                        ItemID        => $ItemID,
                        ItemFields    => 0,
                        DynamicFields => 1,
                        UserID        => $Self->{UserID},
                    );

                    $FAQData{CleanTitle} = $FAQObject->FAQArticleTitleClean(
                        Title => $FAQData{Title},
                        Size  => $Config->{TitleSize},
                    );

                    # add blocks to template
                    $LayoutObject->Block(
                        Name => 'Record',
                        Data => {
                            %FAQData,
                        },
                    );

                    # add language data
                    if ($MultiLanguage) {
                        $LayoutObject->Block(
                            Name => 'RecordLanguage',
                            Data => {%FAQData},
                        );
                    }

                    # Dynamic fields
                    DYNAMICFIELD:
                    for my $DynamicFieldConfig ( @{$OverviewDynamicField} ) {
                        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                        # get field value
                        my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
                            DynamicFieldConfig => $DynamicFieldConfig,
                            Value              => $FAQData{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
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
                    }
                }
            }
        }

        # otherwise show a no data found message
        else {
            $LayoutObject->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );
        }

        # create a lookup table for attribute settings
        my %AttributeMap = (
            Number => {
                Name         => $ConfigObject->Get('FAQ::FAQHook'),
                Translatable => 0,
            },
            Title => {
                Name         => 'Title',
                Translatable => 1,
            },
            Keyword => {
                Name         => 'Keyword',
                Translatable => 1,
            },
            Fulltext => {
                Name         => 'Fulltext',
                Translatable => 1,
            },
            CategoryIDs => {
                Name         => 'Category',
                Translatable => 1,
            },
            LanguageIDs => {
                Name         => 'Language',
                Translatable => 1,
            },
            TimeSearchType => {
                Name         => 'Create Time',
                Translatable => 1,
            },
            VoteSearchType => {
                Name         => 'Votes',
                Translatable => 1,
            },
            RateSearchType => {
                Name         => 'Rate',
                Translatable => 1,
            },
        );

        # print each attribute in search results area.
        ATTRIBUTE:
        for my $Attribute ( sort keys %AttributeMap ) {

            # check if the attribute was defined by the user
            if ( $GetParam{$Attribute} ) {

                # set attribute name and translate it if applies
                my $AttributeName = $AttributeMap{$Attribute}->{Name};
                if ( $AttributeMap{$Attribute}->{Translatable} ) {
                    $AttributeName = $LayoutObject->{LanguageObject}->Translate($AttributeName);
                }

                my $AttributeValue;

                # check if the values is an array to parse each value
                if ( ref $GetParam{$Attribute} eq 'ARRAY' ) {

                    # Category attribute
                    if ( $Attribute eq 'CategoryIDs' ) {

                        # get the long name for all customer categories
                        my $CategoryList = $FAQObject->GetCustomerCategoriesLongNames(
                            CustomerUser => $Self->{UserID},
                            Type         => 'rw',
                            UserID       => 1,
                        );

                        # convert each category id to category long name
                        my @CategoryNames;
                        CATEGORYID:
                        for my $CatedoryID ( @{ $GetParam{$Attribute} } ) {
                            next CATEGORYID if !$CategoryList->{$CatedoryID};
                            push @CategoryNames, $CategoryList->{$CatedoryID};
                        }

                        # create a string with all selected category names
                        $AttributeValue = join( " + ", @CategoryNames );
                    }

                    # LanguageIDs
                    elsif ( $Attribute eq 'LanguageIDs' ) {

                        # convert each language id to language name
                        my @LanguageNames;
                        LANGUAGEID:
                        for my $LanguageID ( @{ $GetParam{$Attribute} } ) {
                            my $LanguageName = $FAQObject->LanguageLookup(
                                LanguageID => $LanguageID,
                            );
                            next LANGUAGEID if !$LanguageName;
                            push @LanguageNames, $LanguageName;
                        }

                        # create a string with all selected language names
                        $AttributeValue = join( " + ", @LanguageNames );
                    }
                }

                # otherwise is an scalar and can be set directly
                else {
                    $AttributeValue = $GetParam{$Attribute};
                }
                if ( $Attribute eq 'TimeSearchType' ) {

                    if ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {

                        my $StartDate = $LayoutObject->{LanguageObject}->FormatTimeString(
                            $GetParam{ItemCreateTimeStartYear}
                                . '-' . $GetParam{ItemCreateTimeStartMonth}
                                . '-' . $GetParam{ItemCreateTimeStartDay}
                                . ' 00:00:00', 'DateFormatShort'
                        );

                        my $StopDate = $LayoutObject->{LanguageObject}->FormatTimeString(
                            $GetParam{ItemCreateTimeStopYear}
                                . '-' . $GetParam{ItemCreateTimeStopMonth}
                                . '-' . $GetParam{ItemCreateTimeStopDay}
                                . ' 00:00:00', 'DateFormatShort'
                        );

                        $Attribute      = Translatable('Created between');
                        $AttributeValue = $StartDate . ' '
                            . $LayoutObject->{LanguageObject}->Translate('and') . ' '
                            . $StopDate;
                    }
                    else {

                        my $Mapping = {
                            'Last'   => Translatable('Created within the last'),
                            'Before' => Translatable('Created more than ... ago'),
                        };

                        $Attribute      = $Mapping->{ $GetParam{ItemCreateTimePointStart} };
                        $AttributeValue = $GetParam{ItemCreateTimePoint} . ' '
                            . $LayoutObject->{LanguageObject}->Translate(
                                $GetParam{ItemCreateTimePointFormat} . '(s)'
                            );
                    }
                }
                elsif ( $Attribute eq 'VoteSearchType' ) {
                    next ATTRIBUTE if !$GetParam{VoteSearchOption};
                    $AttributeValue = $LayoutObject->{LanguageObject}->Translate( $GetParam{VoteSearchType} ) . ' '
                        . $GetParam{VoteSearch};
                }
                elsif ( $Attribute eq 'RateSearchType' ) {
                    next ATTRIBUTE if !$GetParam{RateSearchOption};
                    $AttributeValue = $LayoutObject->{LanguageObject}->Translate( $GetParam{RateSearchType} ) . ' '
                        . $GetParam{RateSearch} . '%';
                }

                $LayoutObject->Block(
                    Name => 'SearchTerms',
                    Data => {
                        Attribute => $AttributeName,
                        Value     => $AttributeValue,
                    },
                );
            }
        }

        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD
                if !$DynamicFieldSearchDisplay{ 'DynamicField_' . $DynamicFieldConfig->{Name} };

            $LayoutObject->Block(
                Name => 'SearchTerms',
                Data => {
                    Attribute => $DynamicFieldConfig->{Label},
                    Value     =>
                        $DynamicFieldSearchDisplay{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                },
            );
        }

        my $Link = 'Profile=' . $LayoutObject->LinkEncode($Profile) . ';';
        $Link .= 'SortBy=' . $LayoutObject->LinkEncode($SortBy) . ';';
        $Link .= 'Order=' . $LayoutObject->LinkEncode($OrderBy) . ';';
        $Link .= 'TakeLastSearch=1;';

        # build search navigation bar
        my %PageNav = $LayoutObject->PageNavBar(
            Limit     => $SearchLimit,
            StartHit  => $StartHit,
            PageShown => $SearchPageShown,
            AllHits   => $Counter,
            Action    => "Action=CustomerFAQSearch;Subaction=Search",
            Link      => $Link,
            IDPrefix  => "CustomerFAQSearch",
        );

        # show footer filter - show only if more the one page is available
        if ( defined $PageNav{TotalHits} && ( $PageNav{TotalHits} > $SearchPageShown ) ) {
            $LayoutObject->Block(
                Name => 'Pagination',
                Data => {
                    %Param,
                    %PageNav,
                },
            );
        }

        # start HTML page
        my $Output = $LayoutObject->CustomerHeader();
        $Output .= $LayoutObject->CustomerNavigationBar();

        # Set the SortBy Class
        my $SortClass;

        # this sets the opposite to the OrderBy parameter
        if ( $OrderBy eq 'Down' ) {
            $SortClass = 'SortAscending';
        }
        elsif ( $OrderBy eq 'Up' ) {
            $SortClass = 'SortDescending';
        }

        # set the SortBy Class to the correct field
        my %CSSSort;
        my $CSSSortBy = $SortBy . 'Sort';
        $CSSSort{$CSSSortBy} = $SortClass;

        my %NewOrder = (
            Down => Translatable('Up'),
            Up   => Translatable('Down'),
        );

        # show language header
        if ($MultiLanguage) {
            $LayoutObject->Block(
                Name => 'HeaderLanguage',
                Data => {
                    %Param,
                    %CSSSort,
                    Order => $NewOrder{$OrderBy},
                },
            );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'CustomerFAQSearchResultShort',
            Data         => {
                %Param,
                %PageNav,
                %CSSSort,
                Order   => $NewOrder{$OrderBy},
                Profile => $Profile,
            },
        );

        # build footer
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    # empty search site
    else {

        # delete profile
        if ( $EraseTemplate && $Profile ) {

            # remove old profile stuff
            $SearchProfileObject->SearchProfileDelete(
                Base      => 'CustomerFAQSearch',
                Name      => $Profile,
                UserLogin => $Self->{UserLogin},
            );
            %GetParam = ();
            $Profile  = '';
        }

        # create HTML strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # get search field preferences
            my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # get field HTML
                $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
                    = $DynamicFieldBackendObject->SearchFieldRender(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Profile            => \%GetParam,
                        DefaultValue       =>
                        $Config->{Defaults}->{DynamicField}
                        ->{ $DynamicFieldConfig->{Name} },
                        LayoutObject           => $LayoutObject,
                        ConfirmationCheckboxes => 1,
                        Type                   => $Preference->{Type},
                    );
            }
        }

        # generate search mask
        my $Output = $LayoutObject->CustomerHeader();
        $Output .= $LayoutObject->CustomerNavigationBar();
        $Output .= $Self->MaskForm(
            %GetParam,
            Profile          => $Profile,
            Area             => 'Customer',
            DynamicFieldHTML => \%DynamicFieldHTML
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }
}

sub MaskForm {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # set output formats list
    my %ResultForm = (
        Normal => Translatable('Normal'),
        Print  => Translatable('Print'),
        CSV    => Translatable('CSV'),
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # build output formats list
    $Param{ResultFormStrg} = $LayoutObject->BuildSelection(
        Data       => {%ResultForm},
        Name       => 'ResultForm',
        SelectedID => $Param{ResultForm} || 'Normal',
        Class      => 'Modernize',
    );

    my %Profiles = $Kernel::OM->Get('Kernel::System::SearchProfile')->SearchProfileList(
        Base      => 'CustomerFAQSearch',
        UserLogin => $Self->{UserLogin},
    );

    # build profiles output list
    $Param{ProfilesStrg} = $LayoutObject->BuildSelection(
        Data         => {%Profiles},
        PossibleNone => 1,
        Name         => 'Profile',
        SelectedID   => $Param{Profile},
        Class        => 'Modernize',
    );

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    my %Languages = $FAQObject->LanguageList(
        UserID => $Self->{UserID},
    );

    # build languages output list
    $Param{LanguagesStrg} = $LayoutObject->BuildSelection(
        Data       => {%Languages},
        Name       => 'LanguageIDs',
        Size       => 5,
        Multiple   => 1,
        SelectedID => $Param{LanguageIDs},
        Class      => 'Modernize',
    );

    my $Categories = $FAQObject->GetCustomerCategoriesLongNames(
        CustomerUser => $Self->{UserLogin},
        Type         => 'rw',
        UserID       => $Self->{UserID},
    );

    # build categories output list
    $Param{CategoriesStrg} = $LayoutObject->BuildSelection(
        Data       => $Categories,
        Name       => 'CategoryIDs',
        Size       => 5,
        Multiple   => 1,
        SelectedID => $Param{CategoryIDs},
        TreeView   => $TreeView,
        Class      => 'Modernize',
    );

    my %VotingOperators = (
        Equals            => Translatable('Equals'),
        GreaterThan       => Translatable('Greater than'),
        GreaterThanEquals => Translatable('Greater than equals'),
        SmallerThan       => Translatable('Smaller than'),
        SmallerThanEquals => Translatable('Smaller than equals'),
    );

    $Param{VoteSearchTypeSelectionString} = $LayoutObject->BuildSelection(
        Data        => \%VotingOperators,
        Name        => 'VoteSearchType',
        Size        => 1,
        SelectedID  => $Param{VoteSearchType} || '',
        Translation => 1,
        Multiple    => 0,
        Class       => 'Modernize',
    );

    $Param{RateSearchTypeSelectionString} = $LayoutObject->BuildSelection(
        Data        => \%VotingOperators,
        Name        => 'RateSearchType',
        Size        => 1,
        SelectedID  => $Param{RateSearchType} || '',
        Translation => 1,
        Multiple    => 0,
        Class       => 'Modernize',
    );
    $Param{RateSearchSelectionString} = $LayoutObject->BuildSelection(
        Data => {
            0   => '0%',
            25  => '25%',
            50  => '50%',
            75  => '75%',
            100 => '100%',
        },
        Sort        => 'NumericKey',
        Name        => 'RateSearch',
        Size        => 1,
        SelectedID  => $Param{RateSearch} || '',
        Translation => 0,
        Multiple    => 0,
        Class       => 'Modernize',
    );

    $Param{ItemCreateTimePoint} = $LayoutObject->BuildSelection(
        Data        => [ 1 .. 59 ],
        Translation => 0,
        Name        => 'ItemCreateTimePoint',
        SelectedID  => $Param{ItemCreateTimePoint},
    );
    $Param{ItemCreateTimePointStart} = $LayoutObject->BuildSelection(
        Data => {
            Last   => Translatable('within the last ...'),
            Before => Translatable('more than ... ago'),
        },
        Translation => 1,
        Name        => 'ItemCreateTimePointStart',
        SelectedID  => $Param{ItemCreateTimePointStart} || 'Last',
    );
    $Param{ItemCreateTimePointFormat} = $LayoutObject->BuildSelection(
        Data => {
            minute => Translatable('minute(s)'),
            hour   => Translatable('hour(s)'),
            day    => Translatable('day(s)'),
            week   => Translatable('week(s)'),
            month  => Translatable('month(s)'),
            year   => Translatable('year(s)'),
        },
        Translation => 1,
        Name        => 'ItemCreateTimePointFormat',
        SelectedID  => $Param{ItemCreateTimePointFormat},
    );
    $Param{ItemCreateTimeStart} = $LayoutObject->BuildDateSelection(
        %Param,
        Prefix   => 'ItemCreateTimeStart',
        Format   => 'DateInputFormat',
        DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
    );
    $Param{ItemCreateTimeStop} = $LayoutObject->BuildDateSelection(
        %Param,
        Prefix => 'ItemCreateTimeStop',
        Format => 'DateInputFormat',
    );

    # HTML search mask output
    $LayoutObject->Block(
        Name => 'Search',
        Data => {%Param},
    );

    # output Dynamic fields blocks
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # get search field preferences
        my $SearchFieldPreferences = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->SearchFieldPreferences(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

        PREFERENCE:
        for my $Preference ( @{$SearchFieldPreferences} ) {

            # skip fields that HTML could not be retrieved
            next PREFERENCE if !IsHashRefWithData(
                $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
            );

            $LayoutObject->Block(
                Name => 'DynamicField',
                Data => {
                    Label => $Param{DynamicFieldHTML}
                        ->{ $DynamicFieldConfig->{Name} . $Preference->{Type} }->{Label},
                    Field => $Param{DynamicFieldHTML}
                        ->{ $DynamicFieldConfig->{Name} . $Preference->{Type} }->{Field},
                },
            );
        }
    }

    # get default multi language option
    my $MultiLanguage = $ConfigObject->Get('FAQ::MultiLanguage');

    # show languages select
    if ($MultiLanguage) {
        $LayoutObject->Block(
            Name => 'Language',
            Data => {%Param},
        );
    }

    # HTML search mask output
    return $LayoutObject->Output(
        TemplateFile => 'CustomerFAQSearch',
        Data         => {%Param},
    );
}

1;
