/**
 * cbpAnimatedHeader.js v1.0.0
 * http://www.codrops.com
 *
 * Licensed under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright 2013, Codrops
 * http://www.codrops.com
 */
var cbpAnimatedHeader = (function() {

	var docElem = document.documentElement,
		header = $('.navbar-default'),
		didScroll = false,
		changeHeaderOn = 100;

	function init() {
		window.addEventListener( 'scroll', function( event ) {
			if( !didScroll ) {
				didScroll = true;
				setTimeout( scrollPage, 250 );
			}
		}, false );
	}

	function scrollPage() {
		console.log("Scrolling Page");
		var sy = scrollY();
		if ( sy >= changeHeaderOn ) {
			console.log("Change navbar style.");
			$('.navbar-default').addClass('navbar-scroll');
		}
		else {
			console.log("Classic navbar style.");
			$('.navbar-default').removeClass('navbar-scroll');
		}
		didScroll = false;
	}

	function scrollY() {
		return window.pageYOffset || docElem.scrollTop;
	}

	init();

})();
