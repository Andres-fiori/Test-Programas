using {ProductSRV as services} from '../service';

using from './annotations-suppliers';
using from './annotations-productdetails';
using from './annotations-reviews';
using from './annotations-inventories';
using from './annotations-sales';

annotate services.Products with @odata.draft.enabled;

annotate services.Products with {
    image            @title: 'Image'        @UI.IsImage;
    product          @title: 'Product';
    productName      @title: 'Product Name';
    description      @title: 'Description'  @UI.MultiLineText;
    category         @title: 'Category';
    subCategory      @title: 'Sub-Category';
    statu            @title: 'Statu';
    price            @title: 'Price'        @Measures.ISOCurrency: currency_code;
    rating           @title: 'Average Rating';
    currency         @title: 'Currency'     @Common.IsCurrency;
    supplier         @title: 'Supplier';
    supplierExternal @title: 'Supplier External';
};

annotate services.Products with {
    statu            @Common: {
        Text           : statu.name,
        TextArrangement: #TextOnly
    };
    supplier         @Common: {
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
    supplierExternal @Common: {
        Text           : supplierExternal.SupplierFullName,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Supplier',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: supplierExternal_Supplier,
                ValueListProperty: 'Supplier'
            }]
        }
    };
    category         @Common: {
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
    subCategory      @Common: {
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
};


annotate services.Products with @(
    Common.SideEffects             : {
        $Type           : 'Common.SideEffectsType',
        SourceProperties: [supplier_ID],
        TargetEntities  : [supplier]
    },
    Capabilities.FilterRestrictions: {
        $Type                       : 'Capabilities.FilterRestrictionsType',
        FilterExpressionRestrictions: [{
            $Type             : 'Capabilities.FilterExpressionRestrictionType',
            Property          : productName,
            AllowedExpressions: product
        }]
    },
    UI.SelectionFields             : [
        product,
        productName,
        supplier_ID,
        category_ID,
        subCategory_ID,
        statu_code
    ],
    UI.HeaderInfo                  : {
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
        },
    },
    UI.LineItem                    : [
        {
            $Type: 'UI.DataField',
            Value: image,
        },
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
            Value: supplier_ID
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
            $Type                : 'UI.DataFieldForAnnotation',
            Target               : '@UI.DataPoint#Rating',
            Label                : 'Average Rating',
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }
        },
        {
            $Type                : 'UI.DataField',
            Value                : statu_code,
            Criticality          : statu.criticality,
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            },
        },
        {
            $Type                : 'UI.DataField',
            Value                : price,
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            },
        }
    ],
    UI.DataPoint #Rating           : {
        $Type        : 'UI.DataPointType',
        Value        : rating,
        Visualization: #Rating
    },
    UI.DataPoint #Price            : {
        $Type        : 'UI.DataPointType',
        Value        : price,
        Visualization: #Number
    },
    UI.FieldGroup #Group           : {
        $Type: 'UI.FieldGroupType',
        Data : [{Value: image}]
    },
    UI.FieldGroup #GroupA          : {
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
        ],
    },
    UI.FieldGroup #GroupB          : {
        $Type: 'UI.FieldGroupType',
        Data : [{
            $Type: 'UI.DataField',
            Value: description,
            Label: 'Description'
        }],
    },
    UI.FieldGroup #GroupC          : {
        $Type: 'UI.FieldGroupType',
        Data : [{
            $Type : 'UI.DataFieldForAnnotation',
            Target: '@UI.DataPoint#Price',
            Label : ''
        }]
    },
    UI.FieldGroup #GroupD          : {
        $Type: 'UI.FieldGroupType',
        Data : [{
            $Type                  : 'UI.DataField',
            Value                  : statu_code,
            Criticality            : statu.criticality,
            Label                  : '',
            ![@Common.FieldControl]: {$edmJson: {$If: [
                {$Eq: [
                    {$Path: 'IsActiveEntity'},
                    false
                ]},
                1,
                3
            ]}}
        }],
    },
    UI.HeaderFacets                : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Group',
            Label : '',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#GroupA',
            Label : ''
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#GroupB',
            Label : 'Description'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#GroupC',
            Label : 'Price'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#GroupD',
            Label : 'Availability'
        },
    ],
    UI.Facets                      : [
        {
            $Type : 'UI.CollectionFacet',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: 'supplier/@UI.FieldGroup#SupplierInformation',
                    Label : 'Supplier Information',
                    ID    : 'OneSupplier'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: 'supplier/contact/@UI.FieldGroup#ContactInformation',
                    Label : 'Contact Information',
                    ID    : 'OneContact'
                }
            ],
            Label : 'General Information',
            ID    : 'GeneralInformation'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'detail/@UI.FieldGroup#ProductDetails',
            Label : 'Technical Product',
            ID    : 'OneDetail'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'toReviews/@UI.LineItem',
            Label : 'Reviews',
            ID    : 'ToReviews'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'toInventories/@UI.LineItem',
            Label : 'Inventories',
            ID    : 'ToInventories'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'toSales/@UI.Chart',
            Label : 'Sales',
            ID    : 'ToSales'
        }
    ]
);
