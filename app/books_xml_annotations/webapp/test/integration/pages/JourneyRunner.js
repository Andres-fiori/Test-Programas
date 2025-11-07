sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/logaligroup/booksxmlannotations/test/integration/pages/BooksSetList",
	"com/logaligroup/booksxmlannotations/test/integration/pages/BooksSetObjectPage"
], function (JourneyRunner, BooksSetList, BooksSetObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/logaligroup/booksxmlannotations') + '/test/flp.html#app-preview',
        pages: {
			onTheBooksSetList: BooksSetList,
			onTheBooksSetObjectPage: BooksSetObjectPage
        },
        async: true
    });

    return runner;
});

