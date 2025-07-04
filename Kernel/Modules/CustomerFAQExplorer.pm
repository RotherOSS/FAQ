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

package Kernel::Modules::CustomerFAQExplorer;

use strict;
use warnings;
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get config of frontend module
    my $Config = $ConfigObject->Get("FAQ::Frontend::$Self->{Action}");

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get config data
    my $StartHit        = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );
    my $SearchLimit     = $Config->{SearchLimit}     || 200;
    my $SearchPageShown = $Config->{SearchPageShown} || 3;
    my $SortBy          = $ParamObject->GetParam( Param => 'SortBy' )
        || $Config->{'SortBy::Default'}
        || 'FAQID';
    my $OrderBy = $ParamObject->GetParam( Param => 'Order' )
        || $Config->{'Order::Default'}
        || 'Down';

    my $CategoryID = $ParamObject->GetParam( Param => 'CategoryID' ) || 0;

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    # check for non numeric CategoryID
    if ( $CategoryID !~ /\d+/ ) {
        $CategoryID = 0;
    }

    # get category by name
    my $Category = $ParamObject->GetParam( Param => 'Category' ) || '';

    # try to get the Category ID from category name if no Category ID
    if ( $Category && !$CategoryID ) {

        # get the category tree
        my $CategoryTree = $FAQObject->CategoryTreeList(
            UserID => $Self->{UserID},
        );

        # reverse the has for easy lookup
        my %ReverseCategoryTree = reverse %{$CategoryTree};

        $CategoryID = $ReverseCategoryTree{$Category} || 0;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # try to get the category data
    my %CategoryData;
    if ($CategoryID) {

        # get category data
        %CategoryData = $FAQObject->CategoryGet(
            CategoryID => $CategoryID,
            UserID     => $Self->{UserID},
        );
        if ( !%CategoryData ) {
            return $LayoutObject->CustomerNoPermission(
                WithHeader => 'yes',
            );
        }

        # check user permission
        my $Permission = $FAQObject->CheckCategoryCustomerPermission(
            CustomerUser => $Self->{UserLogin},
            CategoryID   => $CategoryID,
            UserID       => $Self->{UserID},
        );
        if ( !$Permission ) {
            return $LayoutObject->CustomerNoPermission(
                WithHeader => 'yes',
            );
        }
    }

    # store the last screen overview in session
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    my $Output = $LayoutObject->CustomerHeader(
        Value => '',
    );

    # AddJSData for ES
    my $ESActive = $ConfigObject->Get('Elasticsearch::Active');

    $LayoutObject->AddJSData(
        Key   => 'ESActive',
        Value => $ESActive,
    );

    $Output .= $LayoutObject->CustomerNavigationBar();

    my $CategoryIDsRef;
    my %Search;
    my %FAQSearch;

    # show search results
    if ( $Self->{Subaction} && $Self->{Subaction} eq 'Search' ) {
        my $SearchName = Translatable("Search") . ":";
        for my $Mode (qw/Keyword What/) {
            my $String = $ParamObject->GetParam( Param => $Mode );
            if ($String) {
                $Search{$Mode}    = $String;
                $FAQSearch{$Mode} = "*$String*";
                my $ModeName = $Mode eq 'What' ? 'Fulltext' : $Mode;
                $SearchName .= " " . Translatable($ModeName) . " \"$String\";";
            }
        }

        # output category root ( done in LayoutObject for non searches )
        $LayoutObject->Block(
            Name => 'FAQPathCategoryElement',
            Data => {
                Name       => $ConfigObject->Get('FAQ::Default::RootCategoryName'),
                CategoryID => 0,
            },
        );

        # output search information
        $LayoutObject->Block(
            Name => 'FAQPathCategoryElementNoLink',
            Data => {
                Name => $SearchName,
            },
        );

        # disable category specific stuff
        $CategoryID = -1;
    }

    # no search ( standard mode )
    else {
        # show FAQ path
        $LayoutObject->FAQPathShow(
            FAQObject  => $FAQObject,
            CategoryID => $CategoryID,
            UserID     => $Self->{UserID},
        );

        # get all direct subcategories of the selected category
        $CategoryIDsRef = $FAQObject->CustomerCategorySearch(
            ParentID     => $CategoryID,
            CustomerUser => $Self->{UserLogin},
            Mode         => 'Customer',
            UserID       => $Self->{UserID},
        );
    }

    # get interface states list
    my $InterfaceStates = $FAQObject->StateTypeList(
        Types  => $ConfigObject->Get('FAQ::Customer::StateTypes'),
        UserID => $Self->{UserID},
    );

    # check if there are subcategories
    if ( $CategoryIDsRef && ref $CategoryIDsRef eq 'ARRAY' && @{$CategoryIDsRef} ) {

        # show subcategories list
        $LayoutObject->Block(
            Name => 'Subcategories',
            Data => {},
        );
        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => {},
        );

        # show data for each subcategory
        for my $SubCategoryID ( @{$CategoryIDsRef} ) {

            my %SubCategoryData = $FAQObject->CategoryGet(
                CategoryID => $SubCategoryID,
                UserID     => $Self->{UserID},
            );

            # get the number of subcategories of this subcategory
            $SubCategoryData{SubCategoryCount} = $FAQObject->CategoryCount(
                ParentIDs => [$SubCategoryID],
                UserID    => $Self->{UserID},
            );

            # get the number of FAQ articles in this category
            $SubCategoryData{ArticleCount} = $FAQObject->FAQCount(
                CategoryIDs  => [$SubCategoryID],
                ItemStates   => $InterfaceStates,
                OnlyApproved => 1,
                Valid        => 1,
                UserID       => $Self->{UserID},
            );

            # output the category data
            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {%SubCategoryData},
            );
        }
    }

    # set default interface settings
    my $Interface = $FAQObject->StateTypeGet(
        Name   => 'external',
        UserID => $Self->{UserID},
    );

    # include Category if not in base Category (0), or search mode
    if ( $CategoryID > 0 ) {
        $FAQSearch{CategoryIDs} = [$CategoryID];
    }

    # get the latest articles for the root category (else empty)
    elsif ( !%Search ) {
        $SortBy      = 'Changed';
        $OrderBy     = 'Down';
        $SearchLimit = 10;
    }

    # search all FAQ articles within the given category
    my @ViewableItemIDs = $FAQObject->FAQSearch(
        OrderBy          => [$SortBy],
        OrderByDirection => [$OrderBy],
        Limit            => $SearchLimit,
        UserID           => $Self->{UserID},
        States           => $InterfaceStates,
        Interface        => $Interface,
        %FAQSearch,
    );

    # set the SortBy Class
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
        Down => 'Up',
        Up   => 'Down',
    );

    # show the FAQ article list
    $LayoutObject->Block(
        Name => 'FAQItemList',
        Data => {
            CategoryID => $CategoryID,
            %CSSSort,
            Order => $NewOrder{$OrderBy},
        },
    );

    my $MultiLanguage = $ConfigObject->Get('FAQ::MultiLanguage');

    # show language header
    if ($MultiLanguage) {
        $LayoutObject->Block(
            Name => 'HeaderLanguage',
            Data => {
                CategoryID => $CategoryID,
                %CSSSort,
                Order => $NewOrder{$OrderBy},
            },
        );
    }

    my $Counter = 0;
    if (@ViewableItemIDs) {

        for my $ItemID (@ViewableItemIDs) {

            $Counter++;

            # build search result
            if (
                $Counter >= $StartHit
                && $Counter < ( $SearchPageShown + $StartHit )
                )
            {

                my %FAQData = $FAQObject->FAQGet(
                    ItemID     => $ItemID,
                    ItemFields => 0,
                    UserID     => $Self->{UserID},
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
                        Data => {
                            %FAQData,
                        },
                    );
                }
            }
        }
    }

    # otherwise a no data found message is displayed
    else {
        $LayoutObject->Block(
            Name => 'NoFAQDataFoundMsg',
        );
    }

    my $Link = 'SortBy=' . $LayoutObject->LinkEncode($SortBy) . ';';
    $Link .= 'Order=' . $LayoutObject->LinkEncode($OrderBy) . ';';

    my $ActionString;
    if (%Search) {
        $ActionString = "Action=CustomerFAQExplorer;Subaction=Search;";
        if ( $FAQSearch{CategoryIDs} ) {
            $ActionString .= "CategoryID=$CategoryID;";
        }
        for my $Mode ( keys %Search ) {
            $ActionString .= "$Mode=$Search{ $Mode };";
        }
    }
    else {
        $ActionString = "Action=CustomerFAQExplorer;CategoryID=$CategoryID";
    }

    # build search navigation bar
    my %PageNav = $LayoutObject->PageNavBar(
        Limit     => $SearchLimit,
        StartHit  => $StartHit,
        PageShown => $SearchPageShown,
        AllHits   => $Counter,
        Action    => $ActionString,
        Link      => $Link,
        IDPrefix  => "CustomerFAQExplorer",
    );

    if ( $PageNav{TotalHits} =~ m/<span\sclass="PaginationLimit">(\d.*)<\/span>/g ) {
        $PageNav{TotalHits} = $1;
    }

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

    # show QuickSearch
    $LayoutObject->FAQShowQuickSearch(
        Mode            => 'Customer',
        CustomerUser    => $Self->{UserLogin},
        Interface       => $Interface,
        InterfaceStates => $InterfaceStates,
        UserID          => $Self->{UserID},
    );

    # show last added and last updated articles
    for my $Type (qw(LastCreate LastChange)) {

        my $ShowOk = $LayoutObject->FAQShowLatestNewsBox(
            FAQObject       => $FAQObject,
            Type            => $Type,
            Mode            => 'Customer',
            CustomerUser    => $Self->{UserLogin},
            CategoryID      => $CategoryID,
            Interface       => $Interface,
            InterfaceStates => $InterfaceStates,
            UserID          => $Self->{UserID},
        );
        if ( !$ShowOk ) {
            return $LayoutObject->ErrorScreen();
        }
    }

    # show top ten articles
    my $ShowOk = $LayoutObject->FAQShowTop10(
        FAQObject       => $FAQObject,
        Mode            => 'Customer',
        CustomerUser    => $Self->{UserLogin},
        CategoryID      => $CategoryID,
        Interface       => $Interface,
        InterfaceStates => $InterfaceStates,
        UserID          => $Self->{UserID},
    );
    if ( !$ShowOk ) {
        return $LayoutObject->ErrorScreen();
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'CustomerFAQExplorer',
        Data         => {
            %Param,
            CategoryID => $CategoryID,
            %CategoryData,
        },
    );
    $Output .= $LayoutObject->CustomerFooter();

    return $Output;
}

1;
