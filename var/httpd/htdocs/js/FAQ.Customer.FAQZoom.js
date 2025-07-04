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
FAQ.Customer = FAQ.Customer || {};

/**
 * @namespace
 * @exports TargetNS as FAQ.Customer.TicketZoom
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
FAQ.Customer.FAQZoom = (function (TargetNS) {

    /**
     * @name IframeAutoHeight
     * @memberof FAQ.Customer.FAQZoom
     * @function
     * @param {jQueryObject} $Iframe - The iframe which should be auto-heighted
     * @description
     *      Set iframe height automatically based on real content height and default config setting.
     */
    TargetNS.IframeAutoHeight = function ($Iframe) {

        var NewHeight,
            IframeBodyHeight,
            ArticleHeightMax = Core.Config.Get('FAQ::Frontend::CustomerHTMLFieldHeightMax');

        if (isJQueryObject($Iframe)) {
            // slightly change the width of the iframe to not be exactly 100% width anymore
            // this prevents a double horizontal scrollbar (from iframe and surrounding div)
            $Iframe.width($Iframe.width() - 2);

            IframeBodyHeight = $Iframe.contents().find('body').height();
            NewHeight = $Iframe.contents().height();

            // if the iFrames height is 0, we collapse the widget
            if (NewHeight === 0) {
                $Iframe.closest('.WidgetSimple').removeClass('Expanded').addClass('Collapsed');
            } else if (!NewHeight || isNaN(NewHeight)) {
                NewHeight = Core.Config.Get('FAQ::Frontend::CustomerHTMLFieldHeightDefault');
            }
            else {
                if (IframeBodyHeight > ArticleHeightMax
                    || NewHeight > ArticleHeightMax) {
                    NewHeight = ArticleHeightMax;
                }
                else if (IframeBodyHeight > NewHeight) {
                    NewHeight = IframeBodyHeight;
                }
            }

            // add delta for scrollbar
            if (NewHeight > 0) {
                NewHeight = parseInt(NewHeight, 10) + 25;
            }

            $Iframe.height(NewHeight + 'px');
        }
    };

    /**
     * @function
     * @memberof FAQ.Customer.FAQZoom
     * @param {jQueryObject} $Message - an FAQ field.
     * @description
     *      This function checks the class of a FAQ field:
     *      user calls this function by clicking on the field head, field gets hidden by removing
     *      the class 'Visible'. If the field head is clicked while it does not contain the class
     *      'Visible', the field gets the class 'Visible' again and it will be shown.
     */
    function ToggleMessage($Message){
        if ($Message.hasClass('Visible')) {
            $Message.removeClass('Visible');
        }
        else {
            $Message.addClass('Visible');
        }
    }

    /**
     * @function
     * @memberof FAQ.Customer.FAQZoom
     * @description
     *      This function binds functions to the 'MessageHeader'
     *      to toggle the visibility of the MessageBody and the reply form.
     */
    TargetNS.Init = function(){
        var $Messages = $('#Messages > li'),
            $MessageHeaders = $('.MessageHeader', $Messages);

        $MessageHeaders.click(function(Event){
            ToggleMessage($(this).parent());
            Event.preventDefault();
        });

        // init browser link message close button
        if ($('.FAQMessageBrowser').length) {
            $('.FAQMessageBrowser a.Close').on('click', function () {
                var Data = {
                    Action: 'CustomerFAQZoom',
                    Subaction: 'BrowserLinkMessage'
                };

                $('.FAQMessageBrowser').fadeOut("slow");

                // call server, to save that the button was closed and do not show it again on reload
                Core.AJAX.FunctionCall(
                    Core.Config.Get('CGIHandle'),
                    Data,
                    function () {}
                );

                return false;
            });
        }

        $('a.AsPopup').on('click', function () {
            Core.UI.Popup.OpenPopup($(this).attr('href'), 'TicketAction');
            return false;
        });

        $('.RateButton').on('click', function () {
            var RateNumber = parseInt($(this).closest('div').attr('id').replace(/RateButton/, ''), 10);
            $('#RateValue').val(RateNumber);
            $('#RateSubmitButton').fadeIn(250);
            $('#FAQVoting').find('.RateButton').each(function() {
                var ItemRateNumber = parseInt($(this).closest('div').attr('id').replace(/RateButton/, ''), 10);
                if (ItemRateNumber <= RateNumber) {
                    $(this).addClass('RateChecked');
                    $(this).removeClass('RateUnChecked');
                }
                else {
                    $(this).addClass('RateUnChecked');
                    $(this).removeClass('RateChecked');
                }
            });
        });

        // Make whole FAQ Item row clickable, but not the headers, can't use Core.Customer.ClickableRow()
        // since it uses "table tr" as selector, see bug#9329.
        $("tbody tr").click(function(){
            window.location.href = $("a", this).attr("href");
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(FAQ.Customer.FAQZoom || {}));
