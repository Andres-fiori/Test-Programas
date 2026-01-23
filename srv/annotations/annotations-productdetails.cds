using {ProductSRV as service} from '../service';

annotate service.ProductDetails with {
    baseUnit    @title: 'BaseUnit'  @Common.Label       : #ReadOnly;
    width       @title: 'Width'     @Measures.Unit      : unitVolume;
    height      @title: 'Heigth'    @Measures.Unit      : unitVolume;
    depth       @title: 'Depth'     @Measures.Unit      : unitVolume;
    weight      @title: 'Weight'    @Measures.Unit      : unitWeight;
    baseUnit    @Common.IsUnit      @Common.FieldControl: #ReadOnly;
    unitVolume  @Common.IsUnit      @Common.FieldControl: #ReadOnly;
    unitWeight  @Common.IsUnit      @Common.FieldControl: #ReadOnly;
};

annotate service.ProductDetails with @(
    UI.FieldGroup #ProductDetails: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: baseUnit,
            },
            {
                $Type: 'UI.DataField',
                Value: width,
            },
            {
                $Type: 'UI.DataField',
                Value: height,
            },
            {
                $Type: 'UI.DataField',
                Value: depth,
            },
            {
                $Type: 'UI.DataField',
                Value: weight
            }
        ]
    },
    UI.Facets                    : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.FieldGroup#ProductDetails',
        Label : 'Technical Product',
        ID    : 'TechnicalProduct'
    }]
);
