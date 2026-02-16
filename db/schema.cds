namespace com.logaligroup;

using {
        cuid,
        managed,
        sap.common.CodeList,
        sap.common.Currencies
} from '@sap/cds/common';

using {API_BUSINESS_PARTNER_ONPREMISE as op} from '../srv/external/API_BUSINESS_PARTNER_ONPREMISE';

type decimal : Decimal(6, 3);

entity Products : cuid, managed {
        image            : LargeBinary @Core.MediaType: imageType;
        imageType        : String      @Core.IsMediaType;
        product          : String(8);
        productName      : String(80);
        description      : LargeString;
        category         : Association to Categories; // category & category_ID
        subCategory      : Association to SubCategories; // subCategory & subCategory_ID
        statu            : Association to Status; // statu statu_code
        price            : Decimal(8, 2);
        rating           : Decimal(3, 2);
        currency         : Association to Currencies; //currency_code
        detail           : Composition of ProductDetails; //detail detail_ID:
        supplier         : Association to Suppliers;
        supplierExternal : Association to op.A_Supplier; //supplierExternal & supplierExternal_Supplier
        toReviews        : Association to many Reviews
                                   on toReviews.product = $self;
        toInventories    : Composition of many Inventories
                                   on toInventories.product = $self;
        toSales          : Composition of many Sales
                                   on toSales.product = $self;

};

entity Suppliers : cuid {
        supplier     : String(10);
        supplierName : String(40);
        webAddress   : String(250);
        contact      : Association to Contacts;
};

entity Contacts : cuid {
        fullName    : String(40);
        email       : String(80);
        phoneNumber : String(14);
};

entity Reviews : cuid {
        rating     : Decimal(3, 2);
        date       : Date;
        reviewText : LargeString;
        user       : String(20);
        product    : Association to Products; //product_ID
};

entity Inventories : cuid {
        stockNumber : String(11);
        department  : Association to Departments;
        min         : Integer default 0;
        max         : Integer default 100;
        target      : Integer;
        quantity    : Decimal(6, 3);
        baseUnit    : String default 'EA';
        product     : Association to Products;
};

/*entity Sales : cuid {
        monthCode     : String(3);
        month         : String(20);
        quantitySales : Integer;
        year          : String(4);
        product       : Association to Products;

};*/
entity Sales : cuid {

        @Analytics.Dimension
        year          : String(4);

        @Analytics.Dimension
        month         : String(20);

        monthCode     : String(3);

        @Analytics.Measure
        quantitySales : Integer;

        product       : Association to Products;
};

entity ProductDetails : cuid {
        baseUnit   : String default 'EA';
        width      : decimal;
        height     : decimal;
        depth      : decimal;
        weight     : decimal;
        unitVolume : String default 'CM';
        unitWeight : String default 'KG';
};

/** Code List */
//1 = Rojo
//2 = Amarillo
//3 = Verde
entity Status : CodeList {
        key code        : String(20) enum {
                    InStock = 'In Stock';
                    OutOfStock = 'Out of Stock';
                    LowAvailability = 'Low Availability';
            };
            criticality : Int16;
};


/** Value Helps */

entity Categories : cuid {
        category        : String(80);
        toSubCategories : Association to many SubCategories
                                  on toSubCategories.category = $self;
};

entity SubCategories : cuid {
        subCategory : String(80);
        category    : Association to Categories; // category category_ID
};

entity Departments : cuid {
        department : String(40);
};


entity Options : CodeList {
        key code : String(10) enum {
                    A = 'Add';
                    D = 'Discount';
            };
};
