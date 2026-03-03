namespace com.logaligroup;

using {
    cuid,
    managed,
    sap.common.Currencies,
    sap.common.CodeList
} from '@sap/cds/common';

using {API_BUSINESS_PARTNER as bp} from '../srv/external/API_BUSINESS_PARTNER';


entity Products : cuid, managed {
    image         : LargeBinary  @Core.MediaType: imageType  @UI.IsImage;
    imageType     : String       @Core.IsMediaType;
    product       : String(8);
    productName   : String(80);
    description   : LargeString;
    category      : Association to Categories; //category_ID
    subCategory   : Association to SubCategories; //subCategory_ID
    statu         : Association to Status; //statu_code
    price         : Decimal(6, 2);
    rating        : Decimal(3, 2);
    currency      : Association to Currencies; //currency_code
    detail        : Composition of ProductDetails; //detail_ID
    supplier      : Association to Suppliers; //supplier_ID
    rsupplier     : Association to bp.A_Supplier; //rsupplier - rsupplier_Supplier
    toReviews     : Composition of many Reviews
                        on toReviews.product = $self;
    toInventories : Composition of many Inventories
                        on toInventories.product = $self;
    toSales       : Composition of many Sales
                        on toSales.product = $self;
};

type volume : Decimal(6, 3);

entity ProductDetails : cuid {
    baseUnit   : String default 'EA';
    width      : volume;
    depth      : volume;
    height     : volume;
    weight     : volume;
    unitVolume : String default 'CM';
    unitWeight : String default 'KG';
};


entity Suppliers : cuid {
    supplier     : String(10);
    supplierName : String(40);
    webAddress   : String(250);
    contact      : Association to Contacts; //contact_ID
};

entity Contacts : cuid { //ID
    fullName    : String(40);
    email       : String(80);
    phoneNumber : String(14);
};

entity Reviews : cuid {
    rating     : Decimal(3, 2);
    date       : Date;
    user       : String(20);
    reviewText : LargeString;
    product    : Association to Products; //product_ID
};

entity Inventories : cuid {
    stockNumber : String(12);
    department  : Association to Departments;
    min         : Integer;
    max         : Integer;
    target      : Integer;
    quantity    : Decimal(6, 3);
    baseUnit    : String default 'EA';
    product     : Association to Products; // product_ID
};

entity Sales : cuid {
    month         : String(20);
    monthCode     : String(2);
    year          : String(4);
    quantitySales : Integer;
    product       : Association to Products;
};


/** Value Helps */


entity Categories : cuid {
    category        : String(40);
    description     : String(250);
    toSubCategories : Composition of many SubCategories
                          on toSubCategories.category = $self;
};


entity SubCategories : cuid {
    subCategory : String(40);
    description : String(250);
    category    : Association to Categories; //category_ID
};

entity Status : CodeList {
    key code        : String enum {
            InStock = 'In Stock';
            OutOfStock = 'Out of Stock';
            LowAvailability = 'Low Availability';
        }
        criticality : Int16; // 1,2,3,5
};

entity Departments : cuid {
    department : String(60);
};

entity Options : CodeList {
    key code : String(10) enum {
            A = 'Add';
            D = 'Discount'
        }
};
entity Months {
    key code  : String(2);
        descr : String(20);
}
