# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Language::de_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'FAQ Artikel hinzufügen';
    $Self->{Translation}->{'Keywords'} = 'Schlagwörter';
    $Self->{Translation}->{'A category is required.'} = 'Eine Kategorie ist erforderlich.';
    $Self->{Translation}->{'Approval'} = 'Genehmigung';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'FAQ Kategorieverwaltung';
    $Self->{Translation}->{'Add FAQ Category'} = 'FAQ-Kategorie hinzufügen';
    $Self->{Translation}->{'Edit FAQ Category'} = 'FAQ-Kategorie bearbeiten';
    $Self->{Translation}->{'Add category'} = 'Kategorie hinzufügen';
    $Self->{Translation}->{'Add Category'} = 'Kategorie hinzufügen';
    $Self->{Translation}->{'Edit Category'} = 'Kategorie bearbeiten';
    $Self->{Translation}->{'Subcategory of'} = 'Unterkategorie von';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Bitte wählen Sie mindestens eine Berechtigungsgruppe aus.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Agentengruppen, die auf Artikel in dieser Kategorie zugreifen können.';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Wird im Explorer als Kommentar angezeigt.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Wollen Sie diese Kategorie wirklich löschen?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'Sie können diese Kategorie nicht löschen. Sie wird in mindestens einem FAQ-Artikel verwendet und/oder ist Überkategorie von mindestens einer anderen Kategorie';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Diese Kategorie wird in den folgenden FAQ-Artikeln verwendet';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Diese Kategorie ist die Überkategorie der folgenden Unterkategorien';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Wollen Sie diesen FAQ-Artikel wirklich löschen?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ Explorer';
    $Self->{Translation}->{'Quick Search'} = 'Schnelle Suche';
    $Self->{Translation}->{'Wildcards are allowed.'} = 'Wildcards sind erlaubt.';
    $Self->{Translation}->{'Advanced Search'} = 'Erweiterte Suche';
    $Self->{Translation}->{'Subcategories'} = 'Unterkategorien';
    $Self->{Translation}->{'FAQ Articles'} = 'FAQ-Artikel';
    $Self->{Translation}->{'No subcategories found.'} = 'Keine Unterkategorien gefunden.';

    # Template: AgentFAQHistory
    $Self->{Translation}->{'History of'} = 'Änderungsverlauf von';
    $Self->{Translation}->{'History Content'} = 'Änderungsverlauf';
    $Self->{Translation}->{'Createtime'} = 'Erstellt';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Keine FAQ-Journal-Daten gefunden.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'FAQ Sprachmanagement';
    $Self->{Translation}->{'Add FAQ Language'} = 'FAQ-Sprache hinzufügen';
    $Self->{Translation}->{'Edit FAQ Language'} = 'FAQ-Sprache bearbeiten';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languages.'} =
        'Verwenden Sie diese Funktion, wenn Sie mit mehreren Sprachen arbeiten möchten.';
    $Self->{Translation}->{'Add language'} = 'Sprache hinzufügen';
    $Self->{Translation}->{'Add Language'} = 'Sprache hinzufügen';
    $Self->{Translation}->{'Edit Language'} = 'Sprache bearbeiten';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Möchten Sie diese Sprache wirklich löschen?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'Sie können diese Sprache nicht löschen. Sie wird in mindestens einem FAQ-Artikel verwendet!';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Diese Sprache wird in den folgenden FAQ-Artikeln verwendet';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Kontext-Einstellungen';
    $Self->{Translation}->{'FAQ articles per page'} = 'FAQ-Artikel pro Seite';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Keine FAQ-Daten gefunden.';

    # Template: AgentFAQRelatedArticles
    $Self->{Translation}->{'out of 5'} = 'von 5';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'Schlüsselwort';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = 'Vote (z.B. gleich 10 oder größer als 60)';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = 'Satz (z.B. gleich 25% oder größer als 75%)';
    $Self->{Translation}->{'Approved'} = 'Genehmigt';
    $Self->{Translation}->{'Last changed by'} = 'Zuletzt geändert von';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = 'FAQ-Artikel-Erstellungszeit (vorher/nachher)';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = 'FAQ-Artikel-Erstellungszeit (zwischen)';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = 'FAQ-Artikel-Änderungszeitpunkt (vorher/nachher)';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = 'FAQ-Artikel-Änderungszeitpunkt (zwischen)';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQVolltext';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'FAQ-Suche';
    $Self->{Translation}->{'Profile Selection'} = 'Profilauswahl';
    $Self->{Translation}->{'Vote'} = 'Abstimmen';
    $Self->{Translation}->{'No vote settings'} = 'Keine Abstimmungseinstellungen';
    $Self->{Translation}->{'Specific votes'} = 'Besondere Abstimmungen';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = 'z.B. gleich 10 oder größer als 60';
    $Self->{Translation}->{'Rate'} = 'Bewerten';
    $Self->{Translation}->{'No rate settings'} = 'Keine Bewertungseinstellungen';
    $Self->{Translation}->{'Specific rate'} = 'Spezifische Bewertung';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = 'z.B. gleich 25% oder größer als 75%';
    $Self->{Translation}->{'FAQ Article Create Time'} = 'FAQ-Artikel-Erstellungszeit';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'FAQ-Artikel-Änderungszeitpunkt';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'FAQ-Informationen';
    $Self->{Translation}->{'Rating'} = 'Bewertung';
    $Self->{Translation}->{'Votes'} = 'Abstimmungen';
    $Self->{Translation}->{'No votes found!'} = 'Keine Abstimmungen gefunden!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Keine Abstimmung gefunden! Seien Sie der Erste, der diesen FAQ-Artikel bewertet.';
    $Self->{Translation}->{'Download Attachment'} = 'Anhang herunterladen';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Um die Links im folgenden Beitrag zu öffnen, kann es notwendig sein Strg oder Shift zu drücken, während auf den Link geklickt wird (abhängig vom verwendeten Browser und Betriebssystem).';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Wie hilfreich war dieser Artikel? Bitte geben Sie uns Ihre Bewertung und helfen Sie uns, die FAQ zu verbessern. Wir danken Ihnen!';
    $Self->{Translation}->{'not helpful'} = 'nicht hilfreich';
    $Self->{Translation}->{'very helpful'} = 'sehr hilfreich';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = 'FAQ-Titel zum Betreff des Artikels hinzufügen';
    $Self->{Translation}->{'Insert FAQ Text'} = 'FAQ-Text einfügen';
    $Self->{Translation}->{'Insert Full FAQ'} = 'Vollständige FAQ einfügen';
    $Self->{Translation}->{'Insert FAQ Link'} = 'FAQ-Link einfügen';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'FAQ-Text und Link einfügen';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = 'Vollständige FAQ & Link einfügen';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Letzte aktualisierte FAQ-Artikel';
    $Self->{Translation}->{'No FAQ articles found.'} = 'Keine FAQ-Artikel gefunden.';

    # Template: CustomerFAQRelatedArticles
    $Self->{Translation}->{'This might be helpful'} = 'Dies könnte hilfreich sein';
    $Self->{Translation}->{'Found no helpful resources for the subject and text.'} = 'Keine hilfreichen FAQ-Artikel für das Thema und den Text gefunden.';
    $Self->{Translation}->{'Type a subject or text to get a list of helpful resources.'} = 'Geben Sie ein Thema oder einen Text ein, um eine Liste mit hilfreichen FAQ-Artikeln zu erhalten.';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Volltextsuche in FAQ-Artikeln (z. B. "John*n" oder "Will*")';
    $Self->{Translation}->{'Vote restrictions'} = 'Stimmrechtsbeschränkungen';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = 'Nur FAQ-Artikel mit Stimmen...';
    $Self->{Translation}->{'Rate restrictions'} = 'Abstimmungseinschränkungen';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = 'Nur FAQ-Artikel mit Bewertung...';
    $Self->{Translation}->{'Time restrictions'} = 'Zeitbeschränkungen';
    $Self->{Translation}->{'Only FAQ articles created'} = 'Nur FAQ-Artikel erstellt';
    $Self->{Translation}->{'Only FAQ articles created between'} = 'Nur FAQ-Artikel, die zwischen';
    $Self->{Translation}->{'Search-Profile as Template?'} = 'Suchprofil als Vorlage?';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = 'Artikelnummer';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Suche nach Artikeln mit Stichwort';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Öffentlich';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = 'Zurück zum FAQ Explorer';

    # Perl Module: Kernel/Modules/AgentFAQAdd.pm
    $Self->{Translation}->{'You need rw permission!'} = 'Sie brauchen Lese-/Schreibrechte!';
    $Self->{Translation}->{'No categories found where user has read/write permissions!'} = 'Keine Kategorien gefunden, für die der Benutzer Lese-/Schreibrechte hat!';
    $Self->{Translation}->{'No default language found and can\'t create a new one.'} = 'Es wurde keine Standardsprache gefunden und es kann keine neue Sprache erstellt werden.';

    # Perl Module: Kernel/Modules/AgentFAQCategory.pm
    $Self->{Translation}->{'Need CategoryID!'} = 'Benötige CategoryID!';
    $Self->{Translation}->{'A category should have a name!'} = 'Eine Kategorie sollte einen Namen haben!';
    $Self->{Translation}->{'This category already exists'} = 'Diese Kategorie existiert bereits';
    $Self->{Translation}->{'This category already exists!'} = 'Diese Kategorie existiert bereits!';
    $Self->{Translation}->{'No CategoryID is given!'} = 'Keine CategoryID übergeben!';
    $Self->{Translation}->{'Was not able to delete the category %s!'} = 'Konnte die Kategorie %s nicht löschen!';
    $Self->{Translation}->{'FAQ category updated!'} = 'FAQ-Kategorie aktualisiert!';
    $Self->{Translation}->{'FAQ category added!'} = 'FAQ-Kategorie hinzugefügt!';
    $Self->{Translation}->{'Delete Category'} = 'FAQ-Kategorie löschen';

    # Perl Module: Kernel/Modules/AgentFAQDelete.pm
    $Self->{Translation}->{'No ItemID is given!'} = 'Keine ItemID übergeben!';
    $Self->{Translation}->{'You have no permission for this category!'} = 'Sie haben keine Berechtigung für diese Kategorie!';
    $Self->{Translation}->{'Was not able to delete the FAQ article %s!'} = 'Konnte den FAQ-Artikel %s nicht löschen!';

    # Perl Module: Kernel/Modules/AgentFAQExplorer.pm
    $Self->{Translation}->{'The CategoryID %s is invalid.'} = 'Die CategoryID %s ist ungültig.';

    # Perl Module: Kernel/Modules/AgentFAQHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ItemID is given!'} = 'Kann den Verlauf nicht anzeigen, da keine ItemID angegeben ist!';
    $Self->{Translation}->{'FAQ History'} = 'FAQ Historie';

    # Perl Module: Kernel/Modules/AgentFAQJournal.pm
    $Self->{Translation}->{'FAQ Journal'} = 'FAQ-Journal';
    $Self->{Translation}->{'Need config option FAQ::Frontend::Overview'} = 'Benötige Konfigurationsoption FAQ::Frontend::Overview';
    $Self->{Translation}->{'Config option FAQ::Frontend::Overview needs to be a HASH ref!'} =
        'Die Konfigurationsoption FAQ::Frontend::Overview muss eine HASH-Referenz sein!';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = 'Keine Konfigurationsoption für die Ansicht "%s" gefunden!';

    # Perl Module: Kernel/Modules/AgentFAQLanguage.pm
    $Self->{Translation}->{'No LanguageID is given!'} = 'Keine LanguageID übergeben!';
    $Self->{Translation}->{'The name is required!'} = 'Der Name ist erforderlich!';
    $Self->{Translation}->{'This language already exists!'} = 'Diese Sprache existiert bereits!';
    $Self->{Translation}->{'Was not able to delete the language %s!'} = 'Es war nicht möglich, die Sprache %s zu löschen!';
    $Self->{Translation}->{'FAQ language updated!'} = 'FAQ-Sprache aktualisiert!';
    $Self->{Translation}->{'FAQ language added!'} = 'FAQ-Sprache hinzugefügt!';
    $Self->{Translation}->{'Delete Language %s'} = 'Sprache %s löschen';

    # Perl Module: Kernel/Modules/AgentFAQPrint.pm
    $Self->{Translation}->{'Result'} = 'Ergebnis';
    $Self->{Translation}->{'Last update'} = 'Letzte Aktualisierung';
    $Self->{Translation}->{'FAQ Dynamic Fields'} = 'FAQ Dynamische Felder';

    # Perl Module: Kernel/Modules/AgentFAQRichText.pm
    $Self->{Translation}->{'No %s is given!'} = 'Kein(e) %s übermittelt!';
    $Self->{Translation}->{'Can\'t load LanguageObject!'} = 'LanguageObject kann nicht geladen werden!';

    # Perl Module: Kernel/Modules/AgentFAQSearch.pm
    $Self->{Translation}->{'No Result!'} = 'Kein Ergebnis!';
    $Self->{Translation}->{'FAQ Number'} = 'FAQ-Nummer';
    $Self->{Translation}->{'Last Changed by'} = 'Zuletzt geändert von';
    $Self->{Translation}->{'FAQ Item Create Time (before/after)'} = 'FAQ-Artikel Erstellungszeit (vorher/nachher)';
    $Self->{Translation}->{'FAQ Item Create Time (between)'} = 'FAQ-Artikel Erstellungszeit (zwischen)';
    $Self->{Translation}->{'FAQ Item Change Time (before/after)'} = 'FAQ-Artikel Änderungszeit (vorher/nachher)';
    $Self->{Translation}->{'FAQ Item Change Time (between)'} = 'FAQ-Artikel Änderungszeit (zwischen)';
    $Self->{Translation}->{'Equals'} = '';
    $Self->{Translation}->{'Greater than'} = '';
    $Self->{Translation}->{'Greater than equals'} = '';
    $Self->{Translation}->{'Smaller than'} = '';
    $Self->{Translation}->{'Smaller than equals'} = '';

    # Perl Module: Kernel/Modules/AgentFAQZoom.pm
    $Self->{Translation}->{'Need FileID!'} = '';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Vielen Dank für Ihre Stimme!';
    $Self->{Translation}->{'You have already voted!'} = 'Sie haben bereits abgestimmt!';
    $Self->{Translation}->{'No rate selected!'} = 'Keine Bewertung ausgewählt!';
    $Self->{Translation}->{'The voting mechanism is not enabled!'} = 'Der Abstimmungsmechanismus ist nicht aktiviert!';
    $Self->{Translation}->{'The vote rate is not defined!'} = '';

    # Perl Module: Kernel/Modules/CustomerFAQPrint.pm
    $Self->{Translation}->{'FAQ Article Print'} = 'FAQ Artikel Drucken';

    # Perl Module: Kernel/Modules/CustomerFAQSearch.pm
    $Self->{Translation}->{'Created between'} = 'Erstellt zwischen';

    # Perl Module: Kernel/Modules/CustomerFAQZoom.pm
    $Self->{Translation}->{'Need ItemID!'} = 'Benötige ItemID!';

    # Perl Module: Kernel/Modules/PublicFAQExplorer.pm
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'FAQ-Artikel (neu erstellt)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'FAQ-Artikel (kürzlich geändert)';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'FAQ-Artikel (Top 10)';

    # Perl Module: Kernel/Modules/PublicFAQRSS.pm
    $Self->{Translation}->{'No Type is given!'} = 'Es ist kein Typ angegeben!';
    $Self->{Translation}->{'Type must be either LastCreate or LastChange or Top10!'} = 'Typ muss entweder LastCreate oder LastChange oder Top10 sein!';
    $Self->{Translation}->{'Can\'t create RSS file!'} = 'RSS-Datei kann nicht erstellt werden!';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/AgentFAQSearch.pm
    $Self->{Translation}->{'%s (FAQFulltext)'} = '%s (FAQVolltext)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/CustomerFAQSearch.pm
    $Self->{Translation}->{'%s - Customer (%s)'} = '%s - Kunde (%s)';
    $Self->{Translation}->{'%s - Customer (FAQFulltext)'} = '%s - Kunde (FAQFulltext)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/PublicFAQSearch.pm
    $Self->{Translation}->{'%s - Public (%s)'} = '%s - Öffentlich (%s)';
    $Self->{Translation}->{'%s - Public (FAQFulltext)'} = '%s - Öffentlich (FAQFulltext)';

    # Perl Module: Kernel/Output/HTML/Layout/FAQ.pm
    $Self->{Translation}->{'Need rate!'} = 'Benötige Bewertung!';
    $Self->{Translation}->{'This article is empty!'} = 'Dieser Artikel ist leer!';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Zuletzt erstellte FAQ-Artikel';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Die 10 wichtigsten FAQ-Artikel';

    # Perl Module: Kernel/Output/HTML/LinkObject/FAQ.pm
    $Self->{Translation}->{'Content Type'} = 'Inhalts-Typ';

    # Perl Module: Kernel/System/DynamicField/Driver/FAQ.pm
    $Self->{Translation}->{'Attribute which will be searched on autocomplete'} = 'Beim Autocomplete durchsuchtes Attribut';
    $Self->{Translation}->{'Select the attribute which tickets will be searched by'} = 'Wählen Sie aus, nach welchem Attribut die Tickets gesucht werden sollen';
    $Self->{Translation}->{'Attribute which is displayed for values'} = 'Für die Werte angezeigtes Attribut';
    $Self->{Translation}->{'Select the type of display'} = 'Wählen Sie die Anzeigeart aus';

    # Database XML Definition: FAQ.sopm
    $Self->{Translation}->{'internal'} = 'intern';
    $Self->{Translation}->{'external'} = 'extern';
    $Self->{Translation}->{'public'} = 'öffentlich';

    # JS File: FAQ.Agent.ConfirmationDialog
    $Self->{Translation}->{'Ok'} = 'Ok';

    # SysConfig
    $Self->{Translation}->{'A precentage value of the minimal translation progress per language, to be usable for documentations.'} =
        'Ein prozentualer Wert des minimalen Übersetzungsfortschritts pro Sprache, der für Dokumentationen verwendet werden kann.';
    $Self->{Translation}->{'Access repos via http or https.'} = 'Zugriff auf die Repositories über http oder https.';
    $Self->{Translation}->{'Autoloading of Znuny4OTRSRepo extensions.'} = 'Autoloading von Znuny4OTRSRepo-Erweiterungen.';
    $Self->{Translation}->{'Backend module registration for the config conflict check module.'} =
        'Registrierung des Backend-Moduls für das Modul zur Prüfung von Konfigurationskonflikten.';
    $Self->{Translation}->{'Backend module registration for the file conflict check module.'} =
        'Registrierung des Backend-Moduls für das Modul zur Prüfung von Dateikonflikten.';
    $Self->{Translation}->{'Backend module registration for the function redefine check module.'} =
        'Registrierung des Backend-Moduls für die Funktion "redefine check module".';
    $Self->{Translation}->{'Backend module registration for the manual set module.'} = 'Backend-Modulregistrierung für das Modul "manual set module".';
    $Self->{Translation}->{'Block hooks to be created for BS ad removal.'} = 'Block hooks für die Entfernung von BS ad erstellen.';
    $Self->{Translation}->{'Block hooks to be created for package manager output filter.'} =
        '';
    $Self->{Translation}->{'Branch View commit limit'} = 'Commit-Limit der Zweigansicht';
    $Self->{Translation}->{'CodePolicy'} = '';
    $Self->{Translation}->{'Commit limit per page for Branch view screen'} = 'Commit-Limit pro Seite für die Zweigansicht';
    $Self->{Translation}->{'Create analysis file'} = 'Erstelle Analysedatei';
    $Self->{Translation}->{'Creates a analysis file from this ticket and sends to Znuny.'} =
        'Erstellt einen Analysedatei von diesem Ticket und sendet ihn an Znuny.';
    $Self->{Translation}->{'Creates a analysis file from this ticket.'} = 'Erstellt einen Analysedatei von diesem Ticket.';
    $Self->{Translation}->{'Define private addon repos.'} = '';
    $Self->{Translation}->{'Defines the filter that processes the HTML templates.'} = '';
    $Self->{Translation}->{'Defines the test module for checking code policy.'} = '';
    $Self->{Translation}->{'Definition of GIT clone/push URL Prefix.'} = 'Definition des GIT clone/push URL Präfix.';
    $Self->{Translation}->{'Definition of a Dynamic Field: Group => Group with access to the Dynamic Fields; AlwaysVisible => Field can be removed (0|1); InformationAreaName => Name of the Widgets; InformationAreaSize => Size and position of the widgets (Large|Small); Name => Name of the Dynamic Field which should be used; Priority => Order of the Dynamic Fields; State => State of the Fields (0 = disabled, 1 = active, 2 = mandatory), FilterRelease => Regex which the repository name has to match to be displayed, FilterPackage => Regex which the package name has to match to be displayed, FilterBranch => Regex which the branch name has to match to be displayed, FilterRelease => Regex which the repelase version string has to match to be displayed.'} =
        'Definition eines dynamischen Feldes: Group => Gruppe mit Zugriff zu den dynamischen Feldern; AlwaysVisible => Feld kann entfernt werden (0|1); InformationAreaName => Name des Widgets; InformationAreaSize => Größe und Position des Widgets (Large|Small); Name => Der Name des zu benutzenden dynamischen Feldes; Priority => Sortierung des dynamischen Feldes; State => Status des Feldes (0 = deaktiviert, 1 = aktiviert, 2 = zwingend erforderlich), FilterRelease => Regulärer Ausdruck welcher den Repository Namen beschreibt, der angezeigt werden soll; FilterPackage => Regulärer Ausdruck welcher den Paketnamen beschreibt das angezeigt werden soll; FilterBranch => Regulärer Ausdruck welcher den Namen des Zweigs (Branch) beschreibt, der angezeigt werden soll; FilterRelease => Regulärer Ausdruck den Versions-String eines Releases beschreibt, das angezeigt werden soll.';
    $Self->{Translation}->{'Definition of a Dynamic Field: Group => Group with access to the Dynamic Fields; AlwaysVisible => Field can be removed (0|1); InformationAreaName => Name of the Widgets; InformationAreaSize => Size and position of the widgets (Large|Small); Name => Name of the Dynamic Field which should be used; Priority => Order of the Dynamic Fields; State => State of the Fields (0 = disabled, 1 = active, 2 = mandatory), FilterRepository => Regex which the repository name has to match to be displayed, FilterPackage => Regex which the package name has to match to be displayed, FilterBranch => Regex which the branch name has to match to be displayed, FilterRelease => Regex which the repelase version string has to match to be displayed.'} =
        'Definition eines dynamischen Felds: Group => Gruppe mit Zugriff auf das dynamische Feld; AlwaysVisible => Feld kann entfernt werden (0|1); InformationAreaName => Name des Widgets (Informationsbereich); InformationAreaSize => Größe und Position des Widgets (Large|Small); Name => Name des zu verwendeten dynamischen Feldes; Priority => Anordnung der dynamischen Felder; State => Status der dynamischen Felder (0 = deaktiviert, 1 = aktiviert, 2 = Pflichtfeld), FilterRepository => Regex der den Repository-Namen matchen muss um angezeigt zu werden, FilterPackage => Regex der den Packen-Namen matchen muss um angezeigt zu werden, FilterBranch => Regex der den Branch-Namen matchen muss um angezeigt zu werden, FilterRelease => Regex der den Release Version-String matchen muss um angezeigt zu werden.';
    $Self->{Translation}->{'Definition of external MD5 sums (key => MD5, Value => Vendor, PackageName, Version, Date).'} =
        'Definition externer MD5 Summen (key => MD5, Value => Hersteller, Paketname, Version, Datum).';
    $Self->{Translation}->{'Definition of mappings between public repository requests and internal OPMS repositories.'} =
        'Definition von Mappings zwischen öffentlichen Repository Anfragen und internen OPMS Repositories.';
    $Self->{Translation}->{'Definition of package states.'} = 'Definition der Paket Status.';
    $Self->{Translation}->{'Definition of renamed OPMS packages.'} = 'Definition umbenannter OPMS Pakete.';
    $Self->{Translation}->{'Directory, which is used by Git to cache repositories.'} = 'Verzeichnis, das von Git zum Zwischenspeichern von Repositories verwendet wird.';
    $Self->{Translation}->{'Directory, which is used by Git to store temporary data.'} = 'Verzeichnis, das von Git zum Speichern temporärer Daten verwendet wird.';
    $Self->{Translation}->{'Directory, which is used by Git to store working copies.'} = 'Verzeichnis, das von Git zum Speichern von Arbeitskopien verwendet wird.';
    $Self->{Translation}->{'Disable online repositories.'} = '';
    $Self->{Translation}->{'Do not log git ssh connection authorization results for these users. Useful for automated stuff.'} =
        'Für diese Benutzer werden keine Authorisierungen von Verbindungen geloggt. Nützlich für automatisierte Anfragen.';
    $Self->{Translation}->{'Dynamic Fields Screens'} = 'Dynamische Felder Oberflächen';
    $Self->{Translation}->{'DynamicFieldScreen'} = '';
    $Self->{Translation}->{'Export all available public keys to authorized_keys file.'} = 'Exportiert alle verfügbaren öffentlichen Schlüssel in die Datei "authorized_keys".';
    $Self->{Translation}->{'Export all relevant releases to ftp server.'} = 'Alle relevanten Releases auf den FTP-Server exportieren.';
    $Self->{Translation}->{'Frontend module registration for the OPMS object in the agent interface.'} =
        'Frontendmodul-Registration für das OPMS-Objekt im Agent-Interface.';
    $Self->{Translation}->{'Frontend module registration for the PublicOPMSRepository object in the public interface.'} =
        'Frontendmodul-Registration des PublicOPMSRepository-Objekts im Public-Interface.';
    $Self->{Translation}->{'Frontend module registration for the PublicOPMSRepositoryLookup object in the public interface.'} =
        'Frontendmodul-Registration für das PublicOPMSRepositoryLookup Objekt im Public-Interface.';
    $Self->{Translation}->{'Frontend module registration for the PublicOPMSTestBuild object in the public interface.'} =
        'Frontendmodul-Registration des PublicOPMSTestBuild-Objekts im Public-Interface.';
    $Self->{Translation}->{'Frontend module registration for the PublicPackageVerification object in the public interface.'} =
        'Frontendmodul-Registration für das PublicPackageVerification Objekt im Public-Interface.';
    $Self->{Translation}->{'Frontend module registration for the admin interface.'} = '';
    $Self->{Translation}->{'GIT Author registration.'} = 'Registrierung der GIT Verfasser.';
    $Self->{Translation}->{'Generate HTML comment hooks for the specified blocks so that filters can use them.'} =
        'Generiert HTML-Kommentar-Anker für die angegebenen Blöcke, damit Filter diese nutzen können.';
    $Self->{Translation}->{'Generate documentations once per night.'} = '';
    $Self->{Translation}->{'Git'} = 'Git';
    $Self->{Translation}->{'Git Management'} = 'Git-Verwaltung';
    $Self->{Translation}->{'Git Repository'} = '';
    $Self->{Translation}->{'Group, whose members have delete admin permissions in OPMS.'} = 'Gruppe, dessen Mitglieder Delete-Admin-Rechte in OPMS haben.';
    $Self->{Translation}->{'Group, whose members have repository admin permissions in OPMS.'} =
        'Gruppe, dessen Mitglieder Repository-Admin-Rechte in OPMS haben.';
    $Self->{Translation}->{'Group, whose members will see CI test result information in OPMS screens.'} =
        'Gruppe, deren Mitglieder Informationen zu CI-Testergebnissen in OPMS-Bildschirmen sehen.';
    $Self->{Translation}->{'Groups an authenticated user (by user login and password) must be member of to build test packages via the public interface.'} =
        'Gruppen denen ein authentifizierter Benutzer (durch Benutzernamen und Passwort) angehören muss, um Testpakete über das Public-Interface zu erzeugen.';
    $Self->{Translation}->{'Groups which will be set during git project creation processes while adding OPMS repositories.'} =
        'Gruppen welche automatisch durch das Anlegen von GIT-Projekten gesetzt werden, während OPMS Repositories angelegt werden.';
    $Self->{Translation}->{'Manage dynamic field in screens.'} = 'Verwaltung von dynamischen Feldern in Oberflächen.';
    $Self->{Translation}->{'Manage your public SSH key(s) for Git access here. Make sure to save this preference when you add a new key.'} =
        'Verwalten Sie hier Ihre öffentlichen SSH-Schlüssel für den Git-Zugang. Achten Sie darauf, diese Einstellung zu speichern, wenn Sie einen neuen Schlüssel hinzufügen.';
    $Self->{Translation}->{'Module to generate statistics about the added code lines.'} = 'Modul zur Erstellung von Statistiken über die hinzugefügten Code-Zeilen.';
    $Self->{Translation}->{'Module to generate statistics about the growth of code.'} = 'Modul zur Generierung von Statistiken über das Wachstum von Code.';
    $Self->{Translation}->{'Module to generate statistics about the number of git commits.'} =
        'Modul zur Erstellung von Statistiken über die Anzahl der Git-Commits.';
    $Self->{Translation}->{'Module to generate statistics about the removed code lines.'} = 'Modul zur Erstellung von Statistiken über die gelöschten Code-Zeilen.';
    $Self->{Translation}->{'OPMS'} = 'OPMS';
    $Self->{Translation}->{'Only users who have rw permissions in one of these groups may access git.'} =
        'Nur Benutzer, die über rw-Berechtigungen in einer dieser Gruppen verfügen, können auf Git zugreifen.';
    $Self->{Translation}->{'Option to set a package compatibility manually.'} = '';
    $Self->{Translation}->{'Parameters for the pages in the BranchView screen.'} = 'Parameter für die Seiten in der BranchView-Ansicht.';
    $Self->{Translation}->{'Pre-Definition of the \'GITProjectName\' Dynamic Field: Group => Group with access to the Dynamic Fields; AlwaysVisible => Field can be removed (0|1); InformationAreaName => Name of the Widgets; InformationAreaSize => Size and position of the widgets (Large|Small); Name => Name of the Dynamic Field which should be used; Priority => Order of the Dynamic Fields; State => State of the Fields (0 = disabled, 1 = active, 2 = mandatory), FilterRepository => Regex which the repository name has to match to be displayed, FilterPackage => Regex which the package name has to match to be displayed, FilterBranch => Regex which the branch name has to match to be displayed, FilterRelease => Regex which the repelase version string has to match to be displayed.'} =
        'Vor-Definition des dynamischen Feldes \'GITProjectName\': Group => Gruppe mit Zugriff auf das dynamische Feld; AlwaysVisible => Feld kann entfernt werden (0|1); InformationAreaName => Name des Widgets (Informationsbereich); InformationAreaSize => Größe und Position des Widgets (Large|Small); Name => Name des zu verwendeten dynamischen Feldes; Priority => Anordnung der dynamischen Felder; State => Status der dynamischen Felder (0 = deaktiviert, 1 = aktiviert, 2 = Pflichtfeld), FilterRepository => Regex der den Repository-Namen matchen muss um angezeigt zu werden, FilterPackage => Regex der den Packen-Namen matchen muss um angezeigt zu werden, FilterBranch => Regex der den Branch-Namen matchen muss um angezeigt zu werden, FilterRelease => Regex der den Release Version-String matchen muss um angezeigt zu werden.';
    $Self->{Translation}->{'Pre-Definition of the \'GITRepositoryName\' Dynamic Field: Group => Group with access to the Dynamic Fields; AlwaysVisible => Field can be removed (0|1); InformationAreaName => Name of the Widgets; InformationAreaSize => Size and position of the widgets (Large|Small); Name => Name of the Dynamic Field which should be used; Priority => Order of the Dynamic Fields; State => State of the Fields (0 = disabled, 1 = active, 2 = mandatory), FilterRepository => Regex which the repository name has to match to be displayed, FilterPackage => Regex which the package name has to match to be displayed, FilterBranch => Regex which the branch name has to match to be displayed, FilterRelease => Regex which the repelase version string has to match to be displayed.'} =
        'Vor-Definition des dynamischen Feldes \'GITRepositoryName\': Group => Gruppe mit Zugriff auf das dynamische Feld; AlwaysVisible => Feld kann entfernt werden (0|1); InformationAreaName => Name des Widgets (Informationsbereich); InformationAreaSize => Größe und Position des Widgets (Large|Small); Name => Name des zu verwendeten dynamischen Feldes; Priority => Anordnung der dynamischen Felder; State => Status der dynamischen Felder (0 = deaktiviert, 1 = aktiviert, 2 = Pflichtfeld), FilterRepository => Regex der den Repository-Namen matchen muss um angezeigt zu werden, FilterPackage => Regex der den Packen-Namen matchen muss um angezeigt zu werden, FilterBranch => Regex der den Branch-Namen matchen muss um angezeigt zu werden, FilterRelease => Regex der den Release Version-String matchen muss um angezeigt zu werden.';
    $Self->{Translation}->{'Pre-Definition of the \'PackageDeprecated\' Dynamic Field: Group => Group with access to the Dynamic Fields; AlwaysVisible => Field can be removed (0|1); InformationAreaName => Name of the Widgets; InformationAreaSize => Size and position of the widgets (Large|Small); Name => Name of the Dynamic Field which should be used; Priority => Order of the Dynamic Fields; State => State of the Fields (0 = disabled, 1 = active, 2 = mandatory), FilterRepository => Regex which the repository name has to match to be displayed, FilterPackage => Regex which the package name has to match to be displayed, FilterBranch => Regex which the branch name has to match to be displayed, FilterRelease => Regex which the repelase version string has to match to be displayed.'} =
        'Vor-Definition des dynamischen Feldes \'PackageDeprecated\': Group => Gruppe mit Zugriff auf das dynamische Feld; AlwaysVisible => Feld kann entfernt werden (0|1); InformationAreaName => Name des Widgets (Informationsbereich); InformationAreaSize => Größe und Position des Widgets (Large|Small); Name => Name des zu verwendeten dynamischen Feldes; Priority => Anordnung der dynamischen Felder; State => Status der dynamischen Felder (0 = deaktiviert, 1 = aktiviert, 2 = Pflichtfeld), FilterRepository => Regex der den Repository-Namen matchen muss um angezeigt zu werden, FilterPackage => Regex der den Packen-Namen matchen muss um angezeigt zu werden, FilterBranch => Regex der den Branch-Namen matchen muss um angezeigt zu werden, FilterRelease => Regex der den Release Version-String matchen muss um angezeigt zu werden.';
    $Self->{Translation}->{'Recipients that will be informed by email in case of errors.'} =
        '';
    $Self->{Translation}->{'SSH Keys for Git Access'} = 'SSH-Schlüssel für den Git-Zugang';
    $Self->{Translation}->{'Send analysis file'} = 'Sende Analysedatei';
    $Self->{Translation}->{'Sets the git clone address to be used in repository listings.'} =
        'Legt die Git-Clone-Adresse fest, die in Repository-Listen verwendet werden soll.';
    $Self->{Translation}->{'Sets the home directory for git repositories.'} = 'Legt das Home-Verzeichnis für Git-Repositorys fest.';
    $Self->{Translation}->{'Sets the path for the BugzillaAddComment post receive script location.'} =
        'Legt den Pfad zums BugzillaAddComment post receive Skript fest.';
    $Self->{Translation}->{'Sets the path for the OTRSCodePolicy  script location. It is recommended to have a separate clone of the OTRSCodePolicy module that is updated via cron.'} =
        'Legt den Pfad für den Speicherort des OTRSCodePolicy-Skripts fest. Es wird empfohlen, einen separaten Klon des OTRSCodePolicy-Moduls zu haben, der über Cron aktualisiert wird.';
    $Self->{Translation}->{'Sets the path for the OTRSCodePolicy pre receive script location. It is recommended to have a separate clone of the OTRSCodePolicy module that is updated via cron.'} =
        'Legt den Pfad zum OTRSCodePolicy pre-receive Skript fest. Es wird empfohlen, einen separaten Klon des OTRSCodePolicy-Moduls zu verwenden, der über Cron aktualisiert wird.';
    $Self->{Translation}->{'Show latest commits in git repositories.'} = '';
    $Self->{Translation}->{'Shows a link in the menu to go create a unit test from the current ticket.'} =
        '';
    $Self->{Translation}->{'Synchronize OPMS tables with a remote database.'} = 'Synchronisiert OPMS Tabellen mit einer entfernten Datenbank.';
    $Self->{Translation}->{'The minimum version of the sphinx library.'} = 'Die Mindestversion der Sphinx-Bibliothek.';
    $Self->{Translation}->{'The name of the sphinx theme to be used.'} = '';
    $Self->{Translation}->{'The path to the OTRS CSS file (relative below the static path).'} =
        '';
    $Self->{Translation}->{'The path to the OTRS logo (relative below the static path).'} = 'Der Pfad zum OTRS-Logo (relativ unterhalb des statischen Pfades).';
    $Self->{Translation}->{'The path to the static folder, containing images and css files.'} =
        'Der Pfad zum statischen Ordner, der Bilder und CSS-Dateien enthält.';
    $Self->{Translation}->{'The path to the theme folder, containing the sphinx themes.'} = '';
    $Self->{Translation}->{'This configuration defines all possible screens to enable or disable default columns.'} =
        'Diese Konfiguration definiert alle möglichen Oberflächen in denen dynamische Felder als DefaultColumns aktiviert/deaktiviert werden können.';
    $Self->{Translation}->{'This configuration defines all possible screens to enable or disable dynamic fields.'} =
        'Diese Konfiguration definiert alle möglichen Oberflächen in denen dynamische Felder als DynamicFields aktiviert/deaktiviert werden können.';
    $Self->{Translation}->{'This configuration defines if only valids or all (invalids) dynamic fields should be shown.'} =
        'Diese Konfiguration definiert ob nur gültige oder alle (ungültige) dynamischen Felder angezeigt werden sollen.';
    $Self->{Translation}->{'This configuration defines if the OTRS package verification should be active or disabled. If disabled all packages are shown as verified. It\'s still recommended to use only verified packages.'} =
        '';
    $Self->{Translation}->{'This configuration defines the URL to the OTRS CloudService Proxy service. The http or https prefix will be added, depending on selection SysConfig \'Znuny4OTRSRepoType\'.'} =
        'Diese Konfiguration definiert die URL zum OTRS CloudService Proxy-Dienst. Das http oder https Präfix wird hinzugefügt, abhängig von der Auswahl der SysConfig \'Znuny4OTRSRepoType\'.';
    $Self->{Translation}->{'This configuration registers a Output post-filter to extend package verification.'} =
        '';
    $Self->{Translation}->{'This configuration registers an OutputFilter module that removes OTRS Business Solution TM advertisements.'} =
        '';
    $Self->{Translation}->{'This configuration registers an output filter to hide online repository selection in package manager.'} =
        '';
    $Self->{Translation}->{'Tidy unprocessed release that not passed test pomules checks for a long time.'} =
        'Aufgeräumte, unbearbeitete Freigabe, die schon lange nicht mehr von Testpomulen geprüft wurde.';
    $Self->{Translation}->{'Users who have rw permissions in one of these groups are permitted to execute force pushes \'git push --force\'.'} =
        'Benutzer, die rw-Berechtigungen in einer dieser Gruppen haben, dürfen Force-Pushes \'git push --force\' ausführen.';
    $Self->{Translation}->{'Users who have rw permissions in one of these groups are permitted to manage projects. Additionally the members have administration permissions to the git management.'} =
        'Benutzer die über rw-Berechtigungen in einer dieser Gruppen verfügen, können Projekte verwalten. Zusätzlich haben die Mitglieder Administrationsberechtigungen für die Git-Verwaltung.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'No',
    'Ok',
    'Settings',
    'Submit',
    'This might be helpful',
    'Yes',
    );

}

1;
