sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"products/test/integration/pages/ProductSetMain"
], function (JourneyRunner, ProductSetMain) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('products') + '/test/flp.html#app-preview',
        pages: {
			onTheProductSetMain: ProductSetMain
        },
        async: true
    });

    return runner;
});

