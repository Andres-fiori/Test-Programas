sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"products/test/integration/pages/ProductsMain"
], function (JourneyRunner, ProductsMain) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('products') + '/test/flpSandbox.html#products-tile',
        pages: {
			onTheProductsMain: ProductsMain
        },
        async: true
    });

    return runner;
});

