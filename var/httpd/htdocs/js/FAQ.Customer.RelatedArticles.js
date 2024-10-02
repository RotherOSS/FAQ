// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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
FAQ.Customer = FAQ.Customer || {};

/**
 * @namespace
 * @exports TargetNS as FAQ.Customer.RelatedArticles
 * @description
 *      This namespace contains the special module functions for FAQ.
 */
FAQ.Customer.RelatedArticles = (function (TargetNS) {

    var QueuesEnabled = $('#QueuesEnabled').val(),
        LastData;

    if (typeof QueuesEnabled != 'undefined') {
        Core.App.Subscribe('Event.UI.RichTextEditor.InstanceCreated', function() {
            $('#Dest').on('change.RelatedFAQArticle', function () {
                var SelectedQueue = $(this).val(),
                    SelectedQueueName = SelectedQueue.replace(/\d*\|\|-?/, '');

                // XXX handle class hidden extra
                // if ( $('#FAQRelatedArticles').hasClass('Hidden') && (!QueuesEnabled.length || !SelectedQueueName || $.inArray(SelectedQueueName, QueuesEnabled) > -1) ) {
                if ( (!QueuesEnabled.length || !SelectedQueueName || $.inArray(SelectedQueueName, QueuesEnabled) > -1) ) {

                    if ( $('#FAQRelatedArticles').hasClass('Hidden') ) { // XXX handle class
                        $('#FAQRelatedArticles').removeClass('Hidden');
                    }

                    if ($('#Subject').val() || CKEditorInstances['RichText'].getData()) {
                        $('#Subject').trigger('change');
                    }
                }
                else if ( !SelectedQueueName || ( QueuesEnabled.length && $.inArray(SelectedQueueName, QueuesEnabled) == -1 ) ) {
                    $('#FAQRelatedArticles').addClass('Hidden');
                }
            });

            // FAQ Service
            $('#ServiceID').on('change', function (Event) {
                $('#Subject').trigger('change');
            });
            // eo FAQ Service

            $('#Subject').on('change', function (Event) {
                var SelectedQueue = $('#Dest').val(),
                    SelectedQueueName,
                    Data;

                if (SelectedQueue) {
                    SelectedQueue.replace(/\d*\|\|-?/, '')
                }

                if ( !QueuesEnabled.length || !SelectedQueueName || $.inArray(SelectedQueueName, QueuesEnabled) > -1 ) {

                    Data = {
                        Action: 'CustomerFAQRelatedArticles',
                        Subject: $('#Subject').val(),
                        ServiceID: $('#ServiceID').val(), // FAQ Service
                        Body: CKEditorInstances['RichText'].getData(),
                    };

                    if ( !LastData || LastData.Subject != Data.Subject || LastData.Body != Data.Body || LastData.ServiceID != Data.ServiceID ) {

                        if (!$('.FAQMiniList').length) {
                            $('#FAQRelatedArticles .Content').html('<div class="Center"><span class="AJAXLoader" title="' + Core.Config.Get('LoadingMsg') + '"></span></div>');
                        }
                        else if (!$('#FAQRelatedArticles .Header .AJAXLoader').length) {
                            $('#FAQRelatedArticles .Header h3').after('<span class="AJAXLoader" style="float: right; margin: 0;" title="' + Core.Config.Get('LoadingMsg') + '"></span>');
                        }

                        if ($('#Subject').data('RelatedFAQArticlesXHR')) {

                            $('#Subject').data('RelatedFAQArticlesXHR').abort();
                            $('#Subject').removeData('RelatedFAQArticlesXHR');
                        }

                        $('#Subject').data('RelatedFAQArticlesXHR', Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (Response) {

                            $('#Subject').removeData('RelatedFAQArticlesXHR');

                            // Remember the last data to execute the ajax request only if necessary.
                            LastData = Data;

                            if ( $('#FAQRelatedArticles').length ) {

                                $('#FAQRelatedArticles').html(Response.CustomerRelatedFAQArticlesHTMLString);
                                $('#FAQRelatedArticles').removeClass('Hidden'); // XXX handle class
                                $('#FAQRelatedArticles:not(.Hidden)').show();
                            }

                            if ( $('#FAQRelatedArticles .Content > .FAQMiniList').length == 0 ) {
                                // $('#FAQRelatedArticles').hide(); // XXX: maybe the bug
                                // XXX: is hidden necessary at all?
                                // $('#FAQRelatedArticles').addClass('Hidden');
                            }
                        }));
                    }
                }
            });

            $('#Subject').on('paste keydown', function (Event) {
                var Value = $('#Subject').val();

                // trigger only the change event for the subject, if space or enter was pressed
                if (( Event.type === 'keydown' && ( Event.which == 32 || Event.which == 13 ) && ( Value.length > 10 || CKEditorInstances['RichText'].getData())) || Event.type !== 'keydown') {
                    $('#Subject').trigger('change');
                }
            });

            // The "change" event is fired whenever a change is made in the editor.
            CKEditorInstances['RichText'].on( 'key', function (Event) {

                // trigger only the change event for the subject, if space or enter was pressed
                if ( Event.data.keyCode == 32 || Event.data.keyCode == 13) {
                    $('#Subject').trigger('change');
                }
            });

            // The "paste" event is fired whenever a paste is made in the editor.
            CKEditorInstances['RichText'].on( 'paste', function (Event) {

                // trigger only the change event for the subject
                $('#Subject').trigger('change');
            });

            // The "blur" event is fired whenever a blur is made in the editor.
            CKEditorInstances['RichText'].on( 'blur', function (Event) {

                // trigger only the change event for the subject
                $('#Subject').trigger('change');
            });

            // Trigger the 'RelatedFAQArticle' change event to hide/show the relatd faq article widget for the case
            //  that the queue is already selected at the page load or show the widget always if the queue selection is disabled.
            if ( !$('#Dest').length ) {
                $('#FAQRelatedArticles').removeClass('Hidden');

                if ($('#Subject').val() || CKEditorInstances['RichText'].getData()) {
                    $('#Subject').trigger('change');
                }
            }
            else {
                $('#Dest').trigger('change.RelatedFAQArticle');
            }

        });
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(FAQ.Customer.RelatedArticles || {}));
