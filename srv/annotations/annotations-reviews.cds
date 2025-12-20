using {Products as service} from '../service';


annotate service.Reviews with {
    product     @title: 'Product';
    reviewText  @title: 'Review Text'  @UI.MultiLineText;
    date        @title: 'Review Date';
    user        @title: 'User';
    rating      @title: 'Rating';
};

annotate service.Reviews with @(
    UI.HeaderInfo: {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Review',
        TypeNamePlural: 'Reviews',
        Title         : {
            $Type: 'UI.DataField',
            Value: product.productName
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: product.product
        }
    },
    UI.LineItem  : [
        {
            $Type             : 'UI.DataFieldForAnnotation',
            Target            : '@UI.DataPoint',
            Label             : 'Rating',
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            },
        },
        {
            $Type: 'UI.DataField',
            Value: date,
        },
        {
            $Type: 'UI.DataField',
            Value: reviewText
        }
    ],
    UI.DataPoint : {
        $Type        : 'UI.DataPointType',
        Value        : rating,
        Visualization: #Rating
    },
    UI.FieldGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: rating,
            },
            {
                $Type: 'UI.DataField',
                Value: date
            },
            {
                $Type: 'UI.DataField',
                Value: reviewText
            },
        ],
    },
    UI.Facets    : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.FieldGroup',
        Label : 'Review Information'
    }, ],
);
