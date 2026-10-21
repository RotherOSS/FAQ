# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::Language::ja_FAQ;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'FAQの新規追加';
    $Self->{Translation}->{'Keywords'} = 'キーワード';
    $Self->{Translation}->{'A category is required.'} = 'カテゴリは必須項目です。';
    $Self->{Translation}->{'Approval'} = '承認';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'FAQ カテゴリ管理';
    $Self->{Translation}->{'Add FAQ Category'} = 'FAQ カテゴリを追加';
    $Self->{Translation}->{'Edit FAQ Category'} = 'FAQ カテゴリを編集';
    $Self->{Translation}->{'Add category'} = 'カテゴリを追加';
    $Self->{Translation}->{'Add Category'} = 'カテゴリを追加';
    $Self->{Translation}->{'Edit Category'} = 'カテゴリを編集';
    $Self->{Translation}->{'Subcategory of'} = '親カテゴリ';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'ひとつ以上の権限のグループを選択してください。';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'このカテゴリで項目にアクセスできる担当者グループ';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = '一覧でコメントとして表示されます。';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'このカテゴリを削除してよろしいですか？';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'このカテゴリを削除することはできません。一つ以上のFAQ記事で使用されているか、または他のカテゴリの親カテゴリになっています。';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'このカテゴリは以下の記事で使用されています。';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'このカテゴリは以下のカテゴリの親カテゴリです。';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'この記事を削除してよろしいですか？';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ一覧';
    $Self->{Translation}->{'Quick Search'} = '検索';
    $Self->{Translation}->{'Wildcards are allowed.'} = 'ワイルドカードが利用可能です。';
    $Self->{Translation}->{'Advanced Search'} = '高機能検索';
    $Self->{Translation}->{'Subcategories'} = 'サブカテゴリ';
    $Self->{Translation}->{'FAQ Articles'} = 'FAQ項目';
    $Self->{Translation}->{'No subcategories found.'} = '子カテゴリはありません。';

    # Template: AgentFAQHistory
    $Self->{Translation}->{'History of'} = '履歴: ';
    $Self->{Translation}->{'History Content'} = '履歴内容';
    $Self->{Translation}->{'Createtime'} = '作成日時';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'ジャーナルの情報がありません。';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'FAQ 言語管理';
    $Self->{Translation}->{'Add FAQ Language'} = 'FAQ 言語を追加';
    $Self->{Translation}->{'Edit FAQ Language'} = 'FAQ 言語を編集';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languages.'} =
        '多言語で作業をしたい場合、この項目を設定してください。';
    $Self->{Translation}->{'Add language'} = '言語を追加';
    $Self->{Translation}->{'Add Language'} = '言語を追加';
    $Self->{Translation}->{'Edit Language'} = '言語を編集';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'この言語を削除することはできません。一つ以上のFAQで使用されています！';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'この言語は、以下のFAQで使用されています。';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = '設定';
    $Self->{Translation}->{'FAQ articles per page'} = 'ページ毎の記事数';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'FAQデータはありません。';

    # Template: AgentFAQRelatedArticles
    $Self->{Translation}->{'out of 5'} = '5つ星のうち';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'キーワード';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = '投票 (例. 10に等しい あるいは 60より大きい)';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = 'レート (例. 25%に等しい あるいは 75%より大きい)';
    $Self->{Translation}->{'Approved'} = '承認';
    $Self->{Translation}->{'Last changed by'} = '最終更新者';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = 'FAQ項目作成日時 (以前/以後)';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = 'FAQ項目作成日時 (期間指定)';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = 'FAQ項目変更日時 (以前/以後)';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = 'FAQ項目変更日時 (期間指定)';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQ全文';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'FAQ検索';
    $Self->{Translation}->{'Profile Selection'} = 'プロファイル選択';
    $Self->{Translation}->{'Vote'} = '投票';
    $Self->{Translation}->{'No vote settings'} = '投票の設定がありません';
    $Self->{Translation}->{'Specific votes'} = '特定の投票';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = '例. 10 に等しい あるいは 60 より大きい';
    $Self->{Translation}->{'Rate'} = 'レート';
    $Self->{Translation}->{'No rate settings'} = 'レートの設定がありません';
    $Self->{Translation}->{'Specific rate'} = '特定のレート';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = '例. 25%に等しい あるいは 75%以上';
    $Self->{Translation}->{'FAQ Article Create Time'} = 'FAQ項目作成日時';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'FAQ項目変更時間';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'FAQ情報';
    $Self->{Translation}->{'Rating'} = 'レーティング';
    $Self->{Translation}->{'Votes'} = '投票';
    $Self->{Translation}->{'No votes found!'} = '投票はありません。';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = '投票はありません。この記事に最初の評価を投票しましょう。';
    $Self->{Translation}->{'Download Attachment'} = '添付ファイルをダウンロード';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        '(一部のOSにおいては)下記のリンクをオープンするためにクリック時に、Ctrl あるいは Cmd または Shiftキーを押下する必要がる場合があります。';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'このFAQ項目はお役にたちましたか? 　FAQデーターベースの改善に役立てますので、レーティングに協力ください。よろしくお願いします';
    $Self->{Translation}->{'not helpful'} = 'あまり役に立たなかった';
    $Self->{Translation}->{'very helpful'} = 'とても役に立った';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = '項目の主題にFAQタイトルを追加する';
    $Self->{Translation}->{'Insert FAQ Text'} = '記事を挿入する';
    $Self->{Translation}->{'Insert Full FAQ'} = 'FAQ全文を挿入する';
    $Self->{Translation}->{'Insert FAQ Link'} = 'リンクを挿入する';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = '記事とリンクを挿入する';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = 'FAQ全文とリンクを挿入する';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'Latest updated FAQ articles'} = '最後に更新されたFAQ項目';
    $Self->{Translation}->{'No FAQ articles found.'} = '該当する記事はありません。';

    # Template: CustomerFAQRelatedArticles
    $Self->{Translation}->{'This might be helpful'} = 'こちらの情報も役にたつかもしれません';
    $Self->{Translation}->{'Found no helpful resources for the subject and text.'} = '件名と本文から有効な情報は見つかりませんでした';
    $Self->{Translation}->{'Type a subject or text to get a list of helpful resources.'} = '件名か本文を記入して、有効な情報のリストを取得';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'FAQ全文検索（例："John*n"、"Will*"）';
    $Self->{Translation}->{'Vote restrictions'} = '投票規制';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = '投票されているFAQのみ...';
    $Self->{Translation}->{'Rate restrictions'} = 'レート規制';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = 'レートされているFAQのみ...';
    $Self->{Translation}->{'Time restrictions'} = '時間制限';
    $Self->{Translation}->{'Only FAQ articles created'} = '作成されたFAQ項目のみ';
    $Self->{Translation}->{'Only FAQ articles created between'} = '期間内に作成されたFAQ項目のみ';
    $Self->{Translation}->{'Search-Profile as Template?'} = 'Search-Profile-検索プロフィール　をテンプレートにしますか?';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = ' FAQ 項目ナンバー';
    $Self->{Translation}->{'Search for articles with keyword'} = '記事のキーワード検索';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = '公開';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = 'FAQエクスプローラーに戻る';

    # Perl Module: Kernel/Modules/AgentFAQAdd.pm
    $Self->{Translation}->{'You need rw permission!'} = '読書き(rw)の権限が必要です！';
    $Self->{Translation}->{'No categories found where user has read/write permissions!'} = 'ユーザーが　読む/書く 権限のあるカテゴリーが見つかりませんでした';
    $Self->{Translation}->{'No default language found and can\'t create a new one.'} = 'デフォルト言語が不明のため、新しいカテゴリの作成ができませんでした。';

    # Perl Module: Kernel/Modules/AgentFAQCategory.pm
    $Self->{Translation}->{'Need CategoryID!'} = 'カテゴリIDの入力が必要です！';
    $Self->{Translation}->{'A category should have a name!'} = '「名前」は必須項目です。';
    $Self->{Translation}->{'This category already exists'} = 'このカテゴリはすでに存在しています。';
    $Self->{Translation}->{'This category already exists!'} = 'このカテゴリはすでに存在しています！';
    $Self->{Translation}->{'No CategoryID is given!'} = 'カテゴリID が指定されていません！';
    $Self->{Translation}->{'Was not able to delete the category %s!'} = 'カテゴリ %s の削除ができませんでした！';
    $Self->{Translation}->{'FAQ category updated!'} = 'カテゴリが更新されました。';
    $Self->{Translation}->{'FAQ category added!'} = '新しいカテゴリが追加されました。';
    $Self->{Translation}->{'Delete Category'} = 'カテゴリを削除';

    # Perl Module: Kernel/Modules/AgentFAQDelete.pm
    $Self->{Translation}->{'No ItemID is given!'} = 'アイテムID が指定されていません！';
    $Self->{Translation}->{'You have no permission for this category!'} = 'あなたはこのカテゴリへの権限がありません！';
    $Self->{Translation}->{'Was not able to delete the FAQ article %s!'} = 'FAQ 記事 %s を削除できませんでした！';

    # Perl Module: Kernel/Modules/AgentFAQExplorer.pm
    $Self->{Translation}->{'The CategoryID %s is invalid.'} = 'CategoryID %sの値が不正です。';

    # Perl Module: Kernel/Modules/AgentFAQHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ItemID is given!'} = 'ItemID が与えられていないため、履歴を表示できませんでした！';
    $Self->{Translation}->{'FAQ History'} = 'FAQ ヒストリー';

    # Perl Module: Kernel/Modules/AgentFAQJournal.pm
    $Self->{Translation}->{'FAQ Journal'} = 'FAQ ジャーナル';
    $Self->{Translation}->{'Need config option FAQ::Frontend::Overview'} = 'FAQ::Frontend::Overview設定オプションが必要です';
    $Self->{Translation}->{'Config option FAQ::Frontend::Overview needs to be a HASH ref!'} =
        '設定オプション FAQ::Frontend::Overview はハッシュ参照である必要があります！';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = '"%s"を閲覧するための設定値がありません！';

    # Perl Module: Kernel/Modules/AgentFAQLanguage.pm
    $Self->{Translation}->{'No LanguageID is given!'} = '言語IDが指定されていません！';
    $Self->{Translation}->{'The name is required!'} = '「名前」は必須項目です。';
    $Self->{Translation}->{'This language already exists!'} = 'この言語は設定済です。';
    $Self->{Translation}->{'Was not able to delete the language %s!'} = '言語 %s の削除ができませんでした！';
    $Self->{Translation}->{'FAQ language updated!'} = '言語が更新されました。';
    $Self->{Translation}->{'FAQ language added!'} = '言語が追加されました。';
    $Self->{Translation}->{'Delete Language %s'} = '言語を削除 %s';

    # Perl Module: Kernel/Modules/AgentFAQPrint.pm
    $Self->{Translation}->{'Result'} = '結果';
    $Self->{Translation}->{'Last update'} = '最終更新日';
    $Self->{Translation}->{'FAQ Dynamic Fields'} = 'FAQ ダイナミック・フィールド';

    # Perl Module: Kernel/Modules/AgentFAQRichText.pm
    $Self->{Translation}->{'No %s is given!'} = '%s  が不足しています。';
    $Self->{Translation}->{'Can\'t load LanguageObject!'} = 'LanguageObject (言語オブジェクト)が読み込めません';

    # Perl Module: Kernel/Modules/AgentFAQSearch.pm
    $Self->{Translation}->{'No Result!'} = '結果がありません。';
    $Self->{Translation}->{'FAQ Number'} = 'FAQナンバー';
    $Self->{Translation}->{'Last Changed by'} = '最終更新';
    $Self->{Translation}->{'FAQ Item Create Time (before/after)'} = 'FAQ項目作成日時 (以前/以後)';
    $Self->{Translation}->{'FAQ Item Create Time (between)'} = 'FAQ項目作成日時 (期間指定)';
    $Self->{Translation}->{'FAQ Item Change Time (before/after)'} = 'FAQ項目変更日時 (以前/以後)';
    $Self->{Translation}->{'FAQ Item Change Time (between)'} = 'FAQ項目変更日時 (期間指定)';
    $Self->{Translation}->{'Equals'} = '等しい';
    $Self->{Translation}->{'Greater than'} = '超';
    $Self->{Translation}->{'Greater than equals'} = '以上';
    $Self->{Translation}->{'Smaller than'} = '未満';
    $Self->{Translation}->{'Smaller than equals'} = '以下';

    # Perl Module: Kernel/Modules/AgentFAQZoom.pm
    $Self->{Translation}->{'Need FileID!'} = 'FileID が必要です！';
    $Self->{Translation}->{'Thanks for your vote!'} = '評価をいただきありがとうございます。';
    $Self->{Translation}->{'You have already voted!'} = 'あなたはすでに評価済です。';
    $Self->{Translation}->{'No rate selected!'} = '評価が選択されていません。';
    $Self->{Translation}->{'The voting mechanism is not enabled!'} = '評価の機能を有効になっていません！';
    $Self->{Translation}->{'The vote rate is not defined!'} = '投票率は定義されていません!';

    # Perl Module: Kernel/Modules/CustomerFAQPrint.pm
    $Self->{Translation}->{'FAQ Article Print'} = '記事印刷';

    # Perl Module: Kernel/Modules/CustomerFAQSearch.pm
    $Self->{Translation}->{'Created between'} = 'この期間内に作成された';
    $Self->{Translation}->{'Created within the last'} = '以内に作成された';
    $Self->{Translation}->{'Created more than ... ago'} = '以前に作成された';

    # Perl Module: Kernel/Modules/CustomerFAQZoom.pm
    $Self->{Translation}->{'Need ItemID!'} = 'アイテムIDの入力が必要です！';

    # Perl Module: Kernel/Modules/PublicFAQExplorer.pm
    $Self->{Translation}->{'FAQ Articles (new created)'} = '新着記事';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = '最近更新された記事';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = '上位10件の記事';

    # Perl Module: Kernel/Modules/PublicFAQRSS.pm
    $Self->{Translation}->{'No Type is given!'} = 'タイプが指定されていません！';
    $Self->{Translation}->{'Type must be either LastCreate or LastChange or Top10!'} = 'タイプは LastCreate、LastChange、Top10 のいずれかである必要があります！';
    $Self->{Translation}->{'Can\'t create RSS file!'} = 'RSSファイルが作成できません！';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/AgentFAQSearch.pm
    $Self->{Translation}->{'%s (FAQFulltext)'} = '%s (FAQ全文)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/CustomerFAQSearch.pm
    $Self->{Translation}->{'%s - Customer (%s)'} = '%s - 顧客のみ (%s)';
    $Self->{Translation}->{'%s - Customer (FAQFulltext)'} = '%s - 顧客のみ (FAQ全文)';

    # Perl Module: Kernel/Output/HTML/HeaderMeta/PublicFAQSearch.pm
    $Self->{Translation}->{'%s - Public (%s)'} = '%s - 公開 (%s)';
    $Self->{Translation}->{'%s - Public (FAQFulltext)'} = '%s - 公開 (FAQ全文)';

    # Perl Module: Kernel/Output/HTML/Layout/FAQ.pm
    $Self->{Translation}->{'Need rate!'} = '評価してください。';
    $Self->{Translation}->{'This article is empty!'} = 'この記事は空です!';
    $Self->{Translation}->{'Latest created FAQ articles'} = '最後に作成されたFAQ項目';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Top 10 FAQ項目';

    # Perl Module: Kernel/Output/HTML/LinkObject/FAQ.pm
    $Self->{Translation}->{'Content Type'} = 'コンテンツタイプ';

    # Perl Module: Kernel/System/DynamicField/Driver/FAQ.pm
    $Self->{Translation}->{'Select the attribute which FAQs will be searched by'} = 'FAQ を検索する際の属性を選択してください';
    $Self->{Translation}->{'External-source key'} = '外部ソースのキー';
    $Self->{Translation}->{'Select the type of display'} = '表示のタイプを選択してください';

    # Database XML / SOPM Definition: FAQ.sopm
    $Self->{Translation}->{'internal'} = '内部向';
    $Self->{Translation}->{'external'} = '外部向';
    $Self->{Translation}->{'public'} = '公開';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possibility is to insert the link to the image.'} =
        '定義した文字列の後ろにリンクを追加する HTML 出力用フィルター。Image 要素には2種類の入力方法があります。1つ目は画像の名前（例: faq.png）で、この場合は OTOBO の画像パスが使用されます。2つ目は画像へのリンクを挿入する方法です。';
    $Self->{Translation}->{'Add FAQ article'} = 'FAQ 記事を追加する';
    $Self->{Translation}->{'CSS color for the voting result.'} = '評価結果の CSS カラー。';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = 'FAQ 項目のキャッシュの有効期間（TTL）。';
    $Self->{Translation}->{'Category Management'} = 'カテゴリー管理';
    $Self->{Translation}->{'Category Management.'} = 'カテゴリー管理。';
    $Self->{Translation}->{'Customer FAQ Print.'} = '顧客用FAQの表示';
    $Self->{Translation}->{'Customer FAQ Related Articles'} = 'お客様FAQ関連記事';
    $Self->{Translation}->{'Customer FAQ Related Articles.'} = '顧客FAQ関連記事。';
    $Self->{Translation}->{'Customer FAQ Zoom.'} = '顧客用FAQの詳細表示';
    $Self->{Translation}->{'Customer FAQ search.'} = '顧客用FAQの検索';
    $Self->{Translation}->{'Customer FAQ.'} = '顧客用FAQ';
    $Self->{Translation}->{'Decimal places of the voting result.'} = '評価結果の小数点以下の桁数。';
    $Self->{Translation}->{'Default category name.'} = 'デフォルトのカテゴリー名。';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = '単一言語モードでの FAQ 記事のデフォルトの言語。';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        'FAQ 記事で表示するタイトルのデフォルトの最大長。';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'FAQ 記事の承認用チケットのデフォルトの優先度。';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'FAQ エントリーのデフォルトのステータス。';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'FAQ 記事の承認用チケットのデフォルトのステータス。';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = 'FAQ 記事の承認用チケットのデフォルトのタイプ。';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        '公開フロントエンドにおける Action パラメータのデフォルト値。Action パラメータはシステムのスクリプトで使用されます。';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'リンクオブジェクト・ウィジェット（LinkObject::ViewMode = "complex"）で設定ボタンを使用できるアクションを定義します。これらのアクションには、次の JS および CSS ファイルが登録されている必要があります: Core.AllocationList.css、Core.UI.AllocationList.js、Core.UI.Table.Sort.js、Core.Agent.TableFilters.js、Core.Agent.LinkObject.js。';
    $Self->{Translation}->{'Define if the FAQ title should be concatenated to article subject.'} =
        'FAQ のタイトルを記事の件名に連結するかどうかを定義します。';
    $Self->{Translation}->{'Define which columns are shown in the linked FAQs widget (LinkObject::ViewMode = "complex"). Note: Only FAQ attributes and dynamic fields (DynamicField_NameX) are allowed for DefaultColumns.'} =
        'リンクされた FAQ ウィジェット（LinkObject::ViewMode = "complex"）に表示する列を定義します。注意: DefaultColumns に使用できるのは、FAQ 属性とダイナミックフィールド（DynamicField_NameX）のみです。';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        'FAQ ジャーナルを小サイズで表示する一覧モジュールを定義します。';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        'FAQ 一覧を小サイズで表示する一覧モジュールを定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} =
        '担当者インタフェースの FAQ 検索で、FAQ のソートに使用するデフォルトの FAQ 属性を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} =
        '顧客インタフェースの FAQ 検索で、FAQ のソートに使用するデフォルトの FAQ 属性を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} =
        '公開インタフェースの FAQ 検索で、FAQ のソートに使用するデフォルトの FAQ 属性を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} =
        '担当者インタフェースの FAQ エクスプローラーで、FAQ のソートに使用するデフォルトの FAQ 属性を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} =
        '顧客インタフェースの FAQ エクスプローラーで、FAQ のソートに使用するデフォルトの FAQ 属性を定義します。';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        '公開インタフェースの FAQ エクスプローラーで、FAQ のソートに使用するデフォルトの FAQ 属性を定義します。';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} =
        '担当者インタフェースの FAQ エクスプローラーの結果における、デフォルトの FAQ の並び順を定義します。Up: 古いものが上。Down: 新しいものが上。';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} =
        '顧客インタフェースの FAQ エクスプローラーの結果における、デフォルトの FAQ の並び順を定義します。Up: 古いものが上。Down: 新しいものが上。';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} =
        '公開インタフェースの FAQ エクスプローラーの結果における、デフォルトの FAQ の並び順を定義します。Up: 古いものが上。Down: 新しいものが上。';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        '担当者インタフェースの検索結果における、デフォルトの FAQ の並び順を定義します。Up: 古いものが上。Down: 新しいものが上。';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} =
        '顧客インタフェースの検索結果における、デフォルトの FAQ の並び順を定義します。Up: 古いものが上。Down: 新しいものが上。';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} =
        '公開インタフェースの検索結果における、デフォルトの FAQ の並び順を定義します。Up: 古いものが上。Down: 新しいものが上。';
    $Self->{Translation}->{'Defines the default shown FAQ search attribute for FAQ search screen.'} =
        'FAQ 検索画面で、デフォルトで表示する FAQ 検索属性を定義します。';
    $Self->{Translation}->{'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).'} =
        'この画面のリッチテキストエディターの高さを定義します。数値（ピクセル）またはパーセント値（相対値）を入力してください。';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        'FAQ を基にしたチケットに挿入する情報を定義します。"Full FAQ" には本文、添付ファイル、インライン画像が含まれます。';
    $Self->{Translation}->{'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.'} =
        'ダッシュボード・バックエンドのパラメータを定義します。"Limit" はデフォルトで表示するエントリー数を定義します。"Group" はプラグインへのアクセスを制限するために使用します（例: Group: admin;group1;group2;）。"Default" は、プラグインをデフォルトで有効にするか、ユーザーが手動で有効にする必要があるかを示します。';
    $Self->{Translation}->{'Defines the parameters for the elasticsearch widget backend.'} =
        'Elasticsearch ウィジェット・バックエンドのパラメータを定義します。';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        'FAQ エクスプローラーに表示する列を定義します。このオプションは列の位置には影響しません。';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        'FAQ ジャーナルに表示する列を定義します。このオプションは列の位置には影響しません。';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        'FAQ 検索に表示する列を定義します。このオプションは列の位置には影響しません。';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed.'} = '\'Insert FAQ\'（FAQ を挿入）リンクを表示する場所を定義します。';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'FAQ 項目のフリーテキスト欄の定義。';
    $Self->{Translation}->{'Delete this FAQ'} = 'この記事を削除';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ add screen of the agent interface.'} =
        '担当者インタフェースの FAQ 追加画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ edit screen of the agent interface.'} =
        '担当者インタフェースの FAQ 編集画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the customer interface.'} =
        '顧客インタフェースの FAQ 一覧画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the public interface.'} =
        '公開インタフェースの FAQ 一覧画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the agent interface.'} =
        '担当者インタフェースの FAQ 印刷画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the customer interface.'} =
        '顧客インタフェースの FAQ 印刷画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the public interface.'} =
        '公開インタフェースの FAQ 印刷画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the agent interface.'} =
        '担当者インタフェースの FAQ 検索画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the customer interface.'} =
        '顧客インタフェースの FAQ 検索画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the public interface.'} =
        '公開インタフェースの FAQ 検索画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ small format overview screen of the agent interface.'} =
        '担当者インタフェースの FAQ 一覧（小サイズ表示）画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the agent interface.'} =
        '担当者インタフェースの FAQ ズーム画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the customer interface.'} =
        '顧客インタフェースの FAQ ズーム画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the public interface.'} =
        '公開インタフェースの FAQ ズーム画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Edit this FAQ'} = 'この記事を編集';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = 'FAQ モジュールで多言語を有効にします。';
    $Self->{Translation}->{'Enable service assignment for FAQs.'} = 'FAQ へのサービスの割り当てを有効にします。';
    $Self->{Translation}->{'Enable the related article feature for the customer frontend.'} =
        '顧客フロントエンドで関連記事機能を有効にします。';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = 'FAQ モジュールで評価（投票）機能を有効にします。';
    $Self->{Translation}->{'Explorer'} = '一覧';
    $Self->{Translation}->{'FAQ AJAX Responder'} = 'FAQ AJAX レスポンダー';
    $Self->{Translation}->{'FAQ AJAX Responder for Richtext.'} = 'リッチテキスト用の FAQ AJAX レスポンダー。';
    $Self->{Translation}->{'FAQ Area'} = 'FAQエリア';
    $Self->{Translation}->{'FAQ Area.'} = 'FAQエリア。';
    $Self->{Translation}->{'FAQ Delete.'} = 'FAQ の削除';
    $Self->{Translation}->{'FAQ Edit.'} = 'FAQ の編集';
    $Self->{Translation}->{'FAQ History.'} = 'FAQ 更新履歴';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = 'FAQジャーナル一覧(S)の表示数';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = 'FAQ一覧(S)の表示数';
    $Self->{Translation}->{'FAQ Print.'} = 'FAQ の表示';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = '担当者インタフェースの FAQ 検索バックエンド・ルーター。';
    $Self->{Translation}->{'Field4'} = 'Field4';
    $Self->{Translation}->{'Field5'} = 'Field5';
    $Self->{Translation}->{'Fields of the faq index, used for the fulltext search. Fields are also stored, but are not mandatory for the overall functionality. Inclusion of attachments can be disabled by setting the entry to 0 or deleting it.'} =
        '全文検索に使用される FAQ インデックスのフィールド。フィールドは保存もされますが、全体の機能には必須ではありません。添付ファイルを含めないようにするには、エントリーを 0 に設定するか削除してください。';
    $Self->{Translation}->{'Fields stored in the faq index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory.'} =
        '全文検索以外の用途にも使用される、FAQ インデックスに保存されるフィールド。すべての機能を利用するには、すべてのフィールドが必須です。';
    $Self->{Translation}->{'Full FAQ'} = 'FAQ全文';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'FAQ 記事を承認するグループ。';
    $Self->{Translation}->{'History of this FAQ'} = 'この記事の履歴';
    $Self->{Translation}->{'If activated, FAQ articles of status type internal are also taken into account for the approval process.'} =
        '有効にすると、ステータスタイプが internal の FAQ 記事も承認プロセスの対象になります。';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = 'FAQ を基にしたチケットに内部用フィールドを含めます。';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = 'FAQ を基にしたチケットに各フィールドの名前を含めます。';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = 'クイック検索を表示するインタフェース。';
    $Self->{Translation}->{'Journal'} = 'ジャーナル';
    $Self->{Translation}->{'Language Management'} = '言語管理';
    $Self->{Translation}->{'Language Management.'} = '言語管理';
    $Self->{Translation}->{'Limit for the search to build the keyword FAQ article list.'} = 'キーワードによる FAQ 記事一覧を作成する検索の上限。';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'このFAQ記事に他オブジェクトを関連付ける';
    $Self->{Translation}->{'List of queue names for which the related article feature is enabled.'} =
        '関連記事機能を有効にするキュー名の一覧。';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        '担当者インタフェースで使用できるステータスタイプの一覧。';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        '顧客インタフェースで使用できるステータスタイプの一覧。';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        '公開インタフェースで使用できるステータスタイプの一覧。';
    $Self->{Translation}->{'Loader module registration for the public interface.'} = '公開インタフェース用のローダーモジュールの登録。';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} =
        '担当者インタフェースの FAQ エクスプローラーの結果に表示する FAQ 記事の最大数。';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} =
        '顧客インタフェースの FAQ エクスプローラーの結果に表示する FAQ 記事の最大数。';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} =
        '公開インタフェースの FAQ エクスプローラーの結果に表示する FAQ 記事の最大数。';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} =
        '担当者インタフェースの FAQ ジャーナルに表示する FAQ 記事の最大数。';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} =
        '担当者インタフェースの検索結果に表示する FAQ 記事の最大数。';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} =
        '顧客インタフェースの検索結果に表示する FAQ 記事の最大数。';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} =
        '公開インタフェースの検索結果に表示する FAQ 記事の最大数。';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the agent interface.'} =
        '担当者インタフェースの FAQ エクスプローラーに表示する、FAQ 記事のタイトルの最大長。';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the customer interface.'} =
        '顧客インタフェースの FAQ エクスプローラーに表示する、FAQ 記事のタイトルの最大長。';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the public interface.'} =
        '公開インタフェースの FAQ エクスプローラーに表示する、FAQ 記事のタイトルの最大長。';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the agent interface.'} =
        '担当者インタフェースの FAQ 検索に表示する、FAQ 記事のタイトルの最大長。';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the customer interface.'} =
        '顧客インタフェースの FAQ 検索に表示する、FAQ 記事のタイトルの最大長。';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the public interface.'} =
        '公開インタフェースの FAQ 検索に表示する、FAQ 記事のタイトルの最大長。';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ journal in the agent interface.'} =
        '担当者インタフェースの FAQ ジャーナルに表示する、FAQ 記事のタイトルの最大長。';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the customer interface.'} =
        '顧客インタフェースでの FAQ の簡易検索用の HTML OpenSearch プロファイルを生成するモジュール。';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the public interface.'} =
        '公開インタフェースでの FAQ の簡易検索用の HTML OpenSearch プロファイルを生成するモジュール。';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short FAQ search.'} =
        'FAQ の簡易検索用の HTML OpenSearch プロファイルを生成するモジュール。';
    $Self->{Translation}->{'New FAQ Article.'} = '新規 FAQ 項目';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = '新しい FAQ 記事は、公開前に承認が必要です。';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} =
        '顧客インタフェースの FAQ エクスプローラーに表示する FAQ 記事の数。';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} =
        '公開インタフェースの FAQ エクスプローラーに表示する FAQ 記事の数。';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} =
        '顧客インタフェースの検索結果の各ページに表示する FAQ 記事の数。';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} =
        '公開インタフェースの検索結果の各ページに表示する FAQ 記事の数。';
    $Self->{Translation}->{'Number of shards (NS), replicas (NR) and fields limit for the index \'faq\'.'} =
        'インデックス \'faq\' のシャード数（NS）、レプリカ数（NR）、フィールド数の上限。';
    $Self->{Translation}->{'Number of shown items in last changes.'} = '最近更新された項目の表示件数。';
    $Self->{Translation}->{'Number of shown items in last created.'} = '最近作成された項目の表示件数。';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = 'トップ10機能の表示件数。';
    $Self->{Translation}->{'Objects to search for, how many entries and which attributes to show. FAQ attributes have to explicitly be stored via Elasticsearch.'} =
        '検索対象のオブジェクト、エントリー数、表示する属性。FAQ 属性は、Elasticsearch に明示的に保存する必要があります。';
    $Self->{Translation}->{'Output filter to add Java-script to CustomerTicketMessage screen.'} =
        'CustomerTicketMessage 画面に JavaScript を追加する出力フィルター。';
    $Self->{Translation}->{'Output limit for the related FAQ articles.'} = '関連する FAQ 記事の出力件数の上限。';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        'FAQ ジャーナル一覧（小サイズ表示）の（FAQ 項目を表示する）ページのパラメータ。';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        'FAQ 一覧（小サイズ表示）の（FAQ 項目を表示する）ページのパラメータ。';
    $Self->{Translation}->{'Print this FAQ'} = 'この記事を印刷';
    $Self->{Translation}->{'Public FAQ Print.'} = '公開FAQの表示';
    $Self->{Translation}->{'Public FAQ Zoom.'} = '公開FAQの詳細を表示';
    $Self->{Translation}->{'Public FAQ search.'} = '公開FAQの検索';
    $Self->{Translation}->{'Public FAQ.'} = '公開FAQ';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = 'FAQ 記事の承認用のキュー。';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = '評価の割合。キーはパーセントで指定する必要があります。';
    $Self->{Translation}->{'S'} = 'S';
    $Self->{Translation}->{'Search FAQ'} = 'FAQを検索';
    $Self->{Translation}->{'Search FAQ Small.'} = 'FAQ(小)を検索。';
    $Self->{Translation}->{'Search FAQ.'} = 'FAQの検索';
    $Self->{Translation}->{'Select how many items should be shown in Journal Overview "Small" by default.'} =
        'ジャーナル概要にデフォルトで「小」として表示される項目の数を選択します。';
    $Self->{Translation}->{'Select how many items should be shown in Overview "Small" by default.'} =
        '概要に表示する項目の数を選択します。デフォルトでは「小」です。';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        'AgentFAQZoom のインライン HTML 欄のデフォルトの高さ（ピクセル）を設定します。';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        'CustomerFAQZoom（および PublicFAQZoom）のインライン HTML 欄のデフォルトの高さ（ピクセル）を設定します。';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        'AgentFAQZoom のインライン HTML 欄の最大の高さ（ピクセル）を設定します。';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        'CustomerFAQZoom（および PublicFAQZoom）のインライン HTML 欄の最大の高さ（ピクセル）を設定します。';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '公開 FAQ 記事について、AgentFAQZoomSmall に「FAQ リンクを挿入」ボタンを表示します。';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" / "Insert Full FAQ & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '公開 FAQ 記事について、AgentFAQZoomSmall に「FAQ 本文とリンクを挿入」／「FAQ 全体とリンクを挿入」ボタンを表示します。';
    $Self->{Translation}->{'Show "Insert FAQ Text" / "Insert Full FAQ" Button in AgentFAQZoomSmall.'} =
        'AgentFAQZoomSmall に「FAQ 本文を挿入」／「FAQ 全体を挿入」ボタンを表示します。';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = 'FAQ 記事を HTML で表示します。';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = 'FAQ のパスを表示する／しない。';
    $Self->{Translation}->{'Show invalid items in the FAQ Explorer result of the agent interface.'} =
        '担当者インタフェースの FAQ エクスプローラーの結果に無効な項目を表示します。';
    $Self->{Translation}->{'Show items of subcategories.'} = 'サブカテゴリーの項目を表示します。';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = '定義したインタフェースに最近更新された項目を表示します。';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = '定義したインタフェースに最近作成された項目を表示します。';
    $Self->{Translation}->{'Show related articles on service change even with empty subject and body.'} =
        '件名と本文が空でも、サービスの変更時に関連記事を表示します。';
    $Self->{Translation}->{'Show the stars for the articles with a rating equal or greater like the defined value (set value \'0\' to deactivate the output).'} =
        '定義した値以上の評価の記事に星を表示します（出力を無効にするには値を \'0\' に設定してください）。';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = '定義したインタフェースにトップ10の項目を表示します。';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = '定義したインタフェースに評価を表示します。';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} =
        '担当者インタフェースの FAQ ズームビューで、FAQ を他のオブジェクトとリンクするためのリンクをメニューに表示します。';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} =
        '担当者インタフェースの FAQ ズームビューで、FAQ を削除するためのリンクをメニューに表示します。';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} =
        '担当者インタフェースの FAQ ズームビューで、FAQ の履歴を表示するためのリンクをメニューに表示します。';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} =
        '担当者インタフェースの FAQ ズームビューで、FAQ を編集するためのリンクをメニューに表示します。';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} =
        '担当者インタフェースの FAQ ズームビューで、前の画面に戻るためのリンクをメニューに表示します。';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} =
        '担当者インタフェースの FAQ ズームビューで、FAQ を印刷するためのリンクをメニューに表示します。';
    $Self->{Translation}->{'Solution'} = '解決';
    $Self->{Translation}->{'Symptom'} = '症状';
    $Self->{Translation}->{'Text Only'} = 'テキストのみ';
    $Self->{Translation}->{'The default languages for the related FAQ articles.'} = '関連する FAQ 記事のデフォルトの言語。';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} =
        'FAQ の識別子（例: FAQ#、KB#、MyFAQ#）。デフォルトは FAQ# です。';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} =
        'この設定は、\'FAQ\' オブジェクトを \'Normal\' リンクタイプで他の \'FAQ\' オブジェクトとリンクできるようにします。';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} =
        'この設定は、\'FAQ\' オブジェクトを \'ParentChild\' リンクタイプで他の \'FAQ\' オブジェクトとリンクできるようにします。';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} =
        'この設定は、\'FAQ\' オブジェクトを \'Normal\' リンクタイプで他の \'Ticket\' オブジェクトとリンクできるようにします。';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} =
        'この設定は、\'FAQ\' オブジェクトを \'ParentChild\' リンクタイプで他の \'Ticket\' オブジェクトとリンクできるようにします。';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = 'FAQ 記事の承認用チケットの本文。';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article. Permitted notification tags are <OTOBO_FAQ_NUMBER>, <OTOBO_FAQ_CATEGORYID>, <OTOBO_FAQ_ITEMID>> <OTOBO_FAQ_TITLE> and <OTOBO_FAQ_STATEID>.'} =
        'FAQ 記事の承認用チケットの件名。使用できる通知タグは <OTOBO_FAQ_NUMBER>、<OTOBO_FAQ_CATEGORYID>、<OTOBO_FAQ_ITEMID>> <OTOBO_FAQ_TITLE>、<OTOBO_FAQ_STATEID> です。';
    $Self->{Translation}->{'Toolbar Item for a shortcut.'} = 'ショートカット用のツールバー項目。';
    $Self->{Translation}->{'external (customer)'} = '外部 (顧客)';
    $Self->{Translation}->{'internal (agent)'} = '内部 (担当者)';
    $Self->{Translation}->{'public (all)'} = '公開 (全員)';
    $Self->{Translation}->{'public (public)'} = '公開　(パブリック)';


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
