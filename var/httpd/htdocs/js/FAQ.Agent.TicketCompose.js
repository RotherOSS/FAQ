// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
// --
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.
// --

"use strict";

var FAQ = FAQ || {};
FAQ.Agent = FAQ.Agent || {};

/**
 * @namespace
 * @exports TargetNS as FAQ.Agent.TicketCompose
 * @description
 *      This namespace contains the special module functions for TicketCompose.
 */
FAQ.Agent.TicketCompose = (function (TargetNS) {

    /**
     * @name InitFAQTicketCompose
     * @memberof FAQ.Agent.TicketCompose
     * @function
     * @param {jQueryObject} $Element The editor
     * @description
     *      Initialize the needed stuff for the FAQ functionality of the ticket screens.
     */
    TargetNS.InitFAQTicketCompose = function ($Element) {

        // See bug#9116:
        // In Chrome sometimes the click event is triggered before the focus event
        // we prevent that by checking EditorGotFocus first
        var InstanceName = $Element.attr('id'),
            EditorGotFocus = false;

        function GetCursorPosition() {
            var Element = $Element[0],
                Range,
                TextRange,
                TextRangeDuplicate,
                StartRange = 0,
                EndRange = 0;
            // Firefox
            if (Element.selectionStart) {
                StartRange = Element.selectionStart;
                EndRange = Element.selectionEnd;
            }
            // IE
            else if (document.selection) {
                Range = document.selection.createRange().duplicate();
                TextRange = Element.createTextRange();
                TextRangeDuplicate = TextRange.duplicate();
                TextRange.moveToBookmark(Range.getBookmark());
                TextRangeDuplicate.setEndPoint('EndToStart', TextRange);
                StartRange = EndRange = TextRangeDuplicate.text.length;
            }

            // Save cursor position for later usage
            $Element.data('Cursor', {
                StartRange: StartRange,
                EndRange: EndRange
            });
        }

        // Register RTE events for saving the cursor position
        if (typeof CKEditorInstances !== 'undefined' && CKEditorInstances[InstanceName]) {

            // Get last cursor position and save it (on focus we come back to this position)
            CKEditorInstances[InstanceName].on('contentDom', function() {
                CKEditorInstances[InstanceName].document.on('click', function () {
                    if (EditorGotFocus) {
                        $('#' + InstanceName).data('RTECursor', CKEditorInstances[InstanceName].getSelection().getRanges());
                    }
                });
                CKEditorInstances[InstanceName].document.on('keyup', function () {
                    if (EditorGotFocus) {
                        $('#' + InstanceName).data('RTECursor', CKEditorInstances[InstanceName].getSelection().getRanges());
                    }
                });
            });

            // needed for client-side validation and inserting data into RTE
            CKEditorInstances[InstanceName].on('focus', function () {
                // if a saved cursor position exists, set this position now
                var RTECursorRange = $('#' + InstanceName).data('RTECursor'),
                    Selection;

                EditorGotFocus = true;

                if (RTECursorRange) {
                    Selection = new CKEDITOR.dom.selection(CKEditorInstances[InstanceName].document);
                    Selection.selectRanges(RTECursorRange);
                    // delete saved cursor position (to not keep old stuff)
                    $('#' + InstanceName).data('RTECursor', undefined);
                }
            });
        }
        // Register events for saving the cursor position of textarea
        else {
            $Element.unbind('click.FAQComposing').bind('click.FAQComposing', function () {
                GetCursorPosition();
            });
            $Element.unbind('keyup.FAQComposing').bind('keyup.FAQComposing', function () {
                GetCursorPosition();
            });
        }
    };

    /**
     * @name SetData
     * @memberof FAQ.Agent.TicketCompose
     * @function
     * @param {String} FAQTitle of a FAQ article to be returned into ticket Subject
     * @param {String} FAQContent of a FAQ article and/or Link to the public interface in plain text
     * @param {String} FAQHTMLContent of a FAQ article and/or Link to the public interface in HTML
     * @description
     *      Do nothing and show an error message.
     */
    function SetData (FAQTitle, FAQContent, FAQHTMLContent) {

        var $ParentSubject = $('#Subject', parent.document),
            $ParentBody = $('#RichText', parent.document),
            ParentBody = $ParentBody[0],
            ParentBodyValue = $ParentBody.val(),
            Range,
            StartRange = 0,
            EndRange = 0,
            NewPosition = 0;

        if ($('#Subject', parent.document).length && $('#RichText', parent.document).length) {

            if (Core.Config.Get('TicketCompose.UpdateArticleSubject') === '1' && $('#UpdateArticleSubjectOption').prop('checked')) {
                // copy subject
                if ($ParentSubject.val() === '') {
                    $ParentSubject.val(FAQTitle);
                }
                else {
                    $ParentSubject.val($ParentSubject.val() + ' - ' + FAQTitle);
                }
            }

            // add FAQ text and/or link to WYSIWYG editor in parent window
            if ( parent.CKEditorInstances && parent.CKEditorInstances['RichText'] ) {
                let editor = parent.CKEditorInstances['RichText'];
                editor.focus();
                window.setTimeout(function () {

                    // html string has to be converted to modelfragment for ckeditor insertion
                    // might pose problems for some special html
                    let ViewFragment = editor.data.processor.toView( FAQHTMLContent );
                    let ModelFragment = editor.data.toModel( ViewFragment );

                    editor.model.insertContent( ModelFragment );

                    window.setTimeout(function () {
                        parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
                    }, 50);
                }, 100);
                return;
            }

            // insert body and/or link to textarea (if possible to cursor position otherwise to the top)
            else {
                // Get previously saved cursor position of textarea
                if (parent.$('#RichText', parent.document).data('Cursor')) {
                    StartRange = parent.$('#RichText', parent.document).data('Cursor').StartRange;
                    EndRange = parent.$('#RichText', parent.document).data('Cursor').EndRange;
                }

                // Add new text to textarea
                $ParentBody.val(ParentBodyValue.substr(0, StartRange) + FAQContent + ParentBodyValue.substr(EndRange, ParentBodyValue.length));
                NewPosition = StartRange + FAQContent.length;

                // Jump to new cursor position (after inserted text)
                if (ParentBody.selectionStart) {
                    ParentBody.selectionStart = NewPosition;
                    ParentBody.selectionEnd = NewPosition;
                }
                else if (document.selection) {
                    Range = document.selection.createRange().duplicate();
                    Range.moveStart('character', NewPosition);
                    Range.select();
                }

                parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
                return;
            }
        }
        else {
            alert('$JSText{"This window must be called from compose window"}');
            parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
            return;
        }
    }

    /**
     * @name SetText
     * @memberof FAQ.Agent.TicketCompose
     * @function
     * @param {Boolean} InsertText to add FAQ item text or not
     * @param {Boolean} InsertLink to add FAQ item link or not
     */
    TargetNS.SetText = function (InsertText, InsertLink) {
        var FAQTitle = $('#FAQTitle').val(),
        FAQContent = '',
        FAQHTMLContent = '',
        FAQLink;

        if (InsertText === 1) {
            FAQContent = $('#FAQBody').val();
            FAQHTMLContent = FAQContent;
        }
        else {
            FAQContent = '';
            FAQHTMLContent = FAQContent;
        }

        if (InsertLink === 1) {
            FAQLink = $('#FAQPublicLink').val();
            FAQContent = FAQContent + '\n' + FAQLink;
            FAQHTMLContent = FAQHTMLContent + '<br/>' + '<a href="' + FAQLink + '">' + FAQTitle + '</a>';
        }

        SetData(FAQTitle, FAQContent, FAQHTMLContent);
    };


    /**
     * @name SetFullFAQ
     * @memberof FAQ.Agent.TicketCompose
     * @function
     * @param {Boolean} InsertText to add FAQ item text or not
     * @param {Boolean} InsertLink to add FAQ item link or not
     */
    TargetNS.SetFullFAQ = function (InsertText, InsertLink) {

        // get the FAQ richtext and trigger attachment processing
        parent.Core.AJAX.FunctionCall(
            parent.Core.Config.Get('Baselink'),
            {
                Action: 'AgentFAQRichText',
                ItemID: $('input[name=FAQID]').val(),
                FormID: parent.$('input[name=FormID]').val()
            },
            function (Response) {
                var FAQTitle = Response.FAQTitle,
                    FAQContent = '',
                    FAQHTMLContent = '',
                    FAQLink,
                    AttachmentList;

                if (InsertText === 1) {
                    FAQContent = Response.FAQContent;
                    FAQHTMLContent = Response.FAQHTMLContent;
                }

                if (InsertLink === 1) {
                    FAQLink = $('#FAQPublicLink').val();
                    FAQContent = FAQContent + '\n' + FAQLink;
                    FAQHTMLContent = FAQHTMLContent + '<br/><br/>' + '<a href="' + FAQLink + '">' + FAQTitle + '</a>';
                }

                // Get parent window attachment list.
                AttachmentList = parent.$('.AttachmentList');

                // Add attachment unless it is a duplicate.
                $(Response.TicketAttachments).each(function() {
                    var AttachmentItem,
                        Filename = this.Filename,
                        AttachmentExist = parent.$('.AttachmentList tbody tr td.Filename').filter(function () {
                            if ($(this).text() === Filename) {
                                return $(this);
                            }
                        });

                    if (!AttachmentExist.length) {
                        AttachmentItem = parent.Core.Template.Render('AjaxDnDUpload/AttachmentItem', {
                            'Filename' : Filename,
                            'Filetype' : this.ContentType,
                            'Filesize' : this.Filesize,
                            'FileID'   : this.FileID,
                        });
                        parent.$(AttachmentItem).prependTo(AttachmentList.find('tbody')).fadeIn();
                    }
                });

                SetData(FAQTitle, FAQContent, FAQHTMLContent);

                parent.Core.UI.InitAjaxDnDUpload();
            },
            'json'
        );
    };
    return TargetNS;
}(FAQ.Agent.TicketCompose || {}));
