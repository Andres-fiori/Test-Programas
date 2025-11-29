using {Products as service} from '../service';

annotate service.Products with @(
    UI.LineItem  : [
        {
            $Type : 'UI.DataField',
            Value : product
        },
        {
            $Type : 'UI.DataField',
            Value : productName
        },
        {
            $Type : 'UI.DataField',
            Value : category_ID
        },
        {
            $Type : 'UI.DataField',
            Value : subCategory_ID
        },
        {
            $Type : 'UI.DataField',
            Value : supplier_ID
        },
        {
            $Type : 'UI.DataField',
            Value : statu_code
        },
        {
            $Type : 'UI.DataField',
            Value : rating
        },
        {
            $Type : 'UI.DataField',
            Value : price
        }
    ]
);