# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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
    $Self->{Translation}->{'All fields marked with an asterisk (*) are mandatory.'} = 'Alle mit einem Sternchen (*) gekennzeichneten Felder sind Pflichtfelder.';
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

    # Database XML / SOPM Definition: FAQ.sopm
    $Self->{Translation}->{'internal'} = 'intern';
    $Self->{Translation}->{'external'} = 'extern';
    $Self->{Translation}->{'public'} = 'öffentlich';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possibility is to insert the link to the image.'} =
        '';
    $Self->{Translation}->{'Add FAQ article'} = '';
    $Self->{Translation}->{'CSS color for the voting result.'} = '';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = '';
    $Self->{Translation}->{'Category Management'} = '';
    $Self->{Translation}->{'Category Management.'} = '';
    $Self->{Translation}->{'Customer FAQ Print.'} = '';
    $Self->{Translation}->{'Customer FAQ Related Articles'} = '';
    $Self->{Translation}->{'Customer FAQ Related Articles.'} = '';
    $Self->{Translation}->{'Customer FAQ Zoom.'} = '';
    $Self->{Translation}->{'Customer FAQ search.'} = '';
    $Self->{Translation}->{'Customer FAQ.'} = '';
    $Self->{Translation}->{'Decimal places of the voting result.'} = '';
    $Self->{Translation}->{'Default category name.'} = '';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = '';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        '';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        '';
    $Self->{Translation}->{'Default state for FAQ entry.'} = '';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        '';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        '';
    $Self->{Translation}->{'Define if the FAQ title should be concatenated to article subject.'} =
        '';
    $Self->{Translation}->{'Define which columns are shown in the linked FAQs widget (LinkObject::ViewMode = "complex"). Note: Only FAQ attributes and dynamic fields (DynamicField_NameX) are allowed for DefaultColumns.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        '';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        '';
    $Self->{Translation}->{'Defines if parent-child translations for queues and services should be generated automatically.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default shown FAQ search attribute for FAQ search screen.'} =
        '';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        '';
    $Self->{Translation}->{'Defines the initial height for the rich text editor component in pixels.'} =
        '';
    $Self->{Translation}->{'Defines the initial height in pixels for the rich text editor component for this screen.'} =
        '';
    $Self->{Translation}->{'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed.'} = '';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = '';
    $Self->{Translation}->{'Delete this FAQ'} = '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ add screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ edit screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the public interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the public interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the public interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ small format overview screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the agent interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the public interface.'} =
        '';
    $Self->{Translation}->{'Edit this FAQ'} = '';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = '';
    $Self->{Translation}->{'Enable service assignment for FAQs.'} = '';
    $Self->{Translation}->{'Enable the related article feature for the customer frontend.'} =
        '';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = '';
    $Self->{Translation}->{'Explorer'} = '';
    $Self->{Translation}->{'FAQ AJAX Responder'} = '';
    $Self->{Translation}->{'FAQ AJAX Responder for Richtext.'} = '';
    $Self->{Translation}->{'FAQ Area'} = '';
    $Self->{Translation}->{'FAQ Area.'} = '';
    $Self->{Translation}->{'FAQ Delete.'} = '';
    $Self->{Translation}->{'FAQ Edit.'} = '';
    $Self->{Translation}->{'FAQ History.'} = '';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = '';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = '';
    $Self->{Translation}->{'FAQ Print.'} = '';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = '';
    $Self->{Translation}->{'Field4'} = '';
    $Self->{Translation}->{'Field5'} = '';
    $Self->{Translation}->{'Full FAQ'} = '';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'History of this FAQ'} = '';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = '';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = '';
    $Self->{Translation}->{'Journal'} = '';
    $Self->{Translation}->{'Language Management'} = '';
    $Self->{Translation}->{'Language Management.'} = '';
    $Self->{Translation}->{'Limit for the search to build the keyword FAQ article list.'} = '';
    $Self->{Translation}->{'Link another object to this FAQ item'} = '';
    $Self->{Translation}->{'List of queue names for which the related article feature is enabled.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        '';
    $Self->{Translation}->{'Loader module registration for the public interface.'} = '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ journal in the agent interface.'} =
        '';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the public interface.'} =
        '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short FAQ search.'} =
        '';
    $Self->{Translation}->{'New FAQ Article.'} = '';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} =
        '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} =
        '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} =
        '';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} =
        '';
    $Self->{Translation}->{'Number of shown items in last changes.'} = '';
    $Self->{Translation}->{'Number of shown items in last created.'} = '';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = '';
    $Self->{Translation}->{'Output filter to add Java-script to CustomerTicketMessage screen.'} =
        '';
    $Self->{Translation}->{'Output limit for the related FAQ articles.'} = '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        '';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        '';
    $Self->{Translation}->{'Print this FAQ'} = '';
    $Self->{Translation}->{'Public FAQ Print.'} = '';
    $Self->{Translation}->{'Public FAQ Zoom.'} = '';
    $Self->{Translation}->{'Public FAQ search.'} = '';
    $Self->{Translation}->{'Public FAQ.'} = '';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '';
    $Self->{Translation}->{'S'} = '';
    $Self->{Translation}->{'Search FAQ'} = '';
    $Self->{Translation}->{'Search FAQ Small.'} = '';
    $Self->{Translation}->{'Search FAQ.'} = '';
    $Self->{Translation}->{'Select how many items should be shown in Journal Overview "Small" by default.'} =
        '';
    $Self->{Translation}->{'Select how many items should be shown in Overview "Small" by default.'} =
        '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" / "Insert Full FAQ & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Text" / "Insert Full FAQ" Button in AgentFAQZoomSmall.'} =
        '';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = '';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = '';
    $Self->{Translation}->{'Show invalid items in the FAQ Explorer result of the agent interface.'} =
        '';
    $Self->{Translation}->{'Show items of subcategories.'} = '';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show related articles on service change even with empty subject and body.'} =
        '';
    $Self->{Translation}->{'Show the stars for the articles with a rating equal or greater like the defined value (set value \'0\' to deactivate the output).'} =
        '';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = '';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Solution'} = '';
    $Self->{Translation}->{'Symptom'} = '';
    $Self->{Translation}->{'Text Only'} = '';
    $Self->{Translation}->{'The default languages for the related FAQ articles.'} = '';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = '';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = '';
    $Self->{Translation}->{'Toolbar Item for a shortcut.'} = '';
    $Self->{Translation}->{'external (customer)'} = '';
    $Self->{Translation}->{'internal (agent)'} = '';
    $Self->{Translation}->{'public (all)'} = '';
    $Self->{Translation}->{'public (public)'} = '';


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
