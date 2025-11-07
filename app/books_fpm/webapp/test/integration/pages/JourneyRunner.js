sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"booksfpm/test/integration/pages/BooksSetMain"
], function (JourneyRunner, BooksSetMain) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('booksfpm') + '/test/flp.html#app-preview',
        pages: {
			onTheBooksSetMain: BooksSetMain
        },
        async: true
    });

    return runner;
});

