using {Products as service} from '../service';

using from './annotations-productdetails';
using from './annotations-reviews';
using from './annotations-inventories';

annotate service.Products with {
    product     @title: 'Product';
    productName @title: 'Product Name';
    description @title: 'Description';
    category    @title: 'Category';
    subCategory @title: 'Sub Category';
    supplier    @title: 'Supplier';
    statu       @title: 'Status';
    rating      @title: 'Rating';
    price       @title: 'Price'     @Measures.ISOCurrency: currency_code;
    currency    @title: 'Currency'  @Common.IsCurrency;
};

annotate service.Products with {
    category    @Common: {
        Text           : category.category,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Categories',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: category_ID,
                ValueListProperty: 'ID'
            }]
        }
    };
    subCategory @Common: {
        Text           : subCategory.subCategory,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_SubCategories',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: category_ID,
                    ValueListProperty: 'category_ID'
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: subCategory_ID,
                    ValueListProperty: 'ID'
                }
            ]
        }
    };
    supplier    @Common: {
        Text           : supplier.supplierName,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Suppliers',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: supplier_ID,
                ValueListProperty: 'ID'
            }]
        }
    };
};


annotate service.Products with @(
    UI.SelectionFields                : [
        product,
        category_ID,
        subCategory_ID,
        supplier_ID,
        statu_code
    ],
    UI.HeaderInfo                     : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Product',
        TypeNamePlural: 'Products',
        Title         : {
            $Type: 'UI.DataField',
            Value: productName
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: product
        }
    },
    UI.LineItem                       : [
        {
            $Type: 'UI.DataField',
            Value: product
        },
        {
            $Type: 'UI.DataField',
            Value: productName
        },
        {
            $Type: 'UI.DataField',
            Value: category_ID
        },
        {
            $Type: 'UI.DataField',
            Value: subCategory_ID
        },
        {
            $Type: 'UI.DataField',
            Value: supplier_ID
        },
        {
            $Type      : 'UI.DataField',
            Value      : statu.name,
            Criticality: statu.criticality
        },
        {
            $Type             : 'UI.DataFieldForAnnotation',
            Target            : '@UI.DataPoint',
            Label             : 'Average Rating',
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }
        },
        {
            $Type             : 'UI.DataField',
            Value             : price,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }
        }
    ],
    UI.DataPoint                      : {
        $Type        : 'UI.DataPointType',
        Value        : rating,
        Visualization: #Rating,
        Title        : 'Star Ratings'
    },
    UI.DataPoint #Price               : {
        $Type        : 'UI.DataPointType',
        Value        : price,
        Visualization: #Number,
        Title        : 'Price'
    },
    UI.FieldGroup #CategoryAndSupplier: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: category_ID
            },
            {
                $Type: 'UI.DataField',
                Value: subCategory_ID
            },
            {
                $Type: 'UI.DataField',
                Value: supplier_ID
            }
        ]
    },
    UI.FieldGroup #Description        : {
        $Type: 'UI.FieldGroupType',
        Data : [{
            $Type: 'UI.DataField',
            Value: description,
            Label: ''
        }]
    },
    UI.FieldGroup #Availability       : {
        $Type: 'UI.FieldGroupType',
        Data : [{
            $Type      : 'UI.DataField',
            Value      : statu.name,
            Criticality: statu.criticality,
            Label      : ''
        }]
    },
    UI.HeaderFacets                   : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#CategoryAndSupplier',
            Label : ''
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Description',
            Label : 'Description'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Availability',
            Label : 'Availability'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.DataPoint#Price'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.DataPoint'
        },
    ],
    UI.Facets                         : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'detail/@UI.FieldGroup#TechnicalData',
            Label : 'Technical Data'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'toReviews/@UI.LineItem',
            Label : 'Reviews'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'toInventories/@UI.LineItem',
            Label : 'Inventory Information'
        },
    ]
);
