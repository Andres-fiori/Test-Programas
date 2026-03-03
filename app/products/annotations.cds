using Products as service from '../../srv/service';
using from '../../srv/annotations/annotations-products';
using from '../../srv/annotations/annotations-suppliers';
using from '../../srv/annotations/annotations-contacts';
using from '../../srv/annotations/annotations-productdetails';
using from '../../srv/annotations/annotations-reviews';
using from '../../srv/annotations/annotations-inventories';
using from '../../srv/annotations/annotations-sales';

annotate service.Products with @(
    UI.Facets : [
        {
            $Type : 'UI.CollectionFacet',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : 'supplier/@UI.FieldGroup',
                    Label : 'Supplier Information',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : 'supplier/contact/@UI.FieldGroup',
                    Label : 'Contact information',
                },
            ],
            Label : 'Supplier and Contact',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'detail/@UI.FieldGroup#TechnicalData',
            Label : 'Technical Data',
            ID : 'detail',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'toReviews/@UI.LineItem',
            Label : 'Reviews',
            ID : 'toReviews',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'toInventories/@UI.LineItem',
            Label : 'Inventory Information',
            ID : 'toInventories',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'toSales/@UI.Chart',
            Label : 'Sales',
            ID : 'toSales',
            @UI.Hidden,
        },
    ]
);

