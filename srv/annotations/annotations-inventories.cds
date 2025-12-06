using {Products as service} from '../service';

annotate service.Inventories with {
    stockNumber @title: 'Stock Number';
    department  @title: 'Department';
    min         @title: 'Min'               @Measures.Unit: baseUnit;
    max         @title: 'Max'               @Measures.Unit: baseUnit;
    target      @title: 'Stock'             @Measures.Unit: baseUnit;
    quantity    @title: 'Ordered Quantity'  @Measures.Unit: baseUnit;
    baseUnit    @Common.IsUnit;
};

annotate service.Inventories with {
    department @Common: {
        Text           : department.department,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Departments',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: department_ID,
                ValueListProperty: 'ID'
            }]
        }
    }
};


annotate service.Inventories with @(
    UI.HeaderInfo   : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Inventory',
        TypeNamePlural: 'Inventories',
        Title         : {
            $Type: 'UI.DataField',
            Value: product.productName
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: product.product
        }
    },
    UI.LineItem     : [
        {
            $Type: 'UI.DataField',
            Value: stockNumber
        },
        {
            $Type: 'UI.DataField',
            Value: department_ID
        },
        {
            $Type             : 'UI.DataFieldForAnnotation',
            Target            : '@UI.Chart#Bullet',
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '12rem'
            },
            Label             : 'Stock'
        },
        {
            $Type: 'UI.DataField',
            Value: quantity
        }
    ],
    UI.DataPoint    : {
        $Type                 : 'UI.DataPointType',
        Value                 : target,
        MinimumValue          : min,
        MaximumValue          : max,
        CriticalityCalculation: {
            $Type                 : 'UI.CriticalityCalculationType',
            ImprovementDirection  : #Maximize,
            ToleranceRangeLowValue: 200,
            DeviationRangeLowValue: 100
        },
        Title                 : 'Stock'
    },
    UI.Chart #Bullet: {
        $Type            : 'UI.ChartDefinitionType',
        Title            : 'Stock',
        ChartType        : #Bullet,
        Measures         : [target],
        MeasureAttributes: [{
            $Type    : 'UI.ChartMeasureAttributeType',
            DataPoint: '@UI.DataPoint',
            Measure  : target
        }]
    },
    UI.FieldGroup   : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: stockNumber
            },
            {
                $Type: 'UI.DataField',
                Value: department_ID
            },
            {
                $Type: 'UI.DataField',
                Value: min,
            },
            {
                $Type: 'UI.DataField',
                Value: max,
            },
            {
                $Type: 'UI.DataField',
                Value: target
            },
            {
                $Type: 'UI.DataField',
                Value: quantity
            }
        ]
    },
    UI.Facets       : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.FieldGroup',
        Label : 'Inventory Inforamtion'
    }]
);
