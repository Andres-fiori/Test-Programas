using {Products as service} from '../service';

annotate service.ProductDetails with {
    baseUnit   @title: 'Base Unit' @Common.FieldControl : #ReadOnly;
    depth      @title: 'Depth'   @Measures.Unit: unitVolume;
    height     @title: 'Height'  @Measures.Unit: unitVolume;
    width      @title: 'Width'   @Measures.Unit: unitVolume;
    weight     @title: 'Weigth'  @Measures.Unit: unitWeight;
    unitVolume @Common.IsUnit @Common.FieldControl : #ReadOnly; 
    unitWeight @Common.IsUnit @Common.FieldControl : #ReadOnly;
};

annotate service.ProductDetails with @(
    UI.FieldGroup #TechnicalData : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : baseUnit
            },
            {
                $Type : 'UI.DataField',
                Value : width
            },
            {
                $Type : 'UI.DataField',
                Value : height
            },
            {
                $Type : 'UI.DataField',
                Value : depth
            },
            {
                $Type : 'UI.DataField',
                Value : weight
            }
        ]
    },
    UI.Facets  : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#TechnicalData',
            Label : 'Technical Data'
        }
    ]
);

