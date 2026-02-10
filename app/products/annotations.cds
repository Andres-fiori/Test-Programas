using ProductSRV as service from '../../srv/service';
using from '../../srv/annotations/annotations-products';
using from '../../srv/annotations/annotations-suppliers';
using from '../../srv/annotations/annotations-contacts';
using from '../../srv/annotations/annotations-productdetails';
using from '../../srv/annotations/annotations-reviews';
using from '../../srv/annotations/annotations-inventories';

annotate service.Products with @(UI.Facets: [
    {
        $Type : 'UI.CollectionFacet',
        Facets: [
            {
                $Type : 'UI.ReferenceFacet',
                Target: 'supplier/@UI.FieldGroup#SupplierInformation',
                Label : 'Supplier Information',
                ID    : 'OneSupplier',
            },
            {
                $Type : 'UI.ReferenceFacet',
                Target: 'supplier/contact/@UI.FieldGroup#ContactInformation',
                Label : 'Contact Information',
                ID    : 'OneContact',
            },
        ],
        Label : 'General Information',
        ID    : 'GeneralInformation',
    },
    {
        $Type : 'UI.ReferenceFacet',
        Target: 'detail/@UI.FieldGroup#ProductDetails',
        Label : 'Technical Product',
        ID    : 'OneDetail',
    },
    {
        $Type : 'UI.ReferenceFacet',
        Target: 'toReviews/@UI.LineItem',
        Label : 'Reviews',
        ID    : 'ToReviews',
    },
    {
        $Type : 'UI.ReferenceFacet',
        Target: 'toInventories/@UI.LineItem',
        Label : 'Inventories',
        ID    : 'ToInventories',
    },
]);
