using {Products as service} from '../service';

annotate service.Sales with {
    month         @title: 'Month' @Common.IsCalendarMonth;
    monthCode     @title: 'Month Code' @Common.IsCalendarMonth;
    year          @title: 'Year' @Common.IsCalendarYear;
    quantitySales @title: 'Quantity'
};

annotate service.Sales with @(
    Analytics.AggregatedProperty #sum: {
        Name : 'Sales',
        AggregationMethod: 'sum',
        AggregatableProperty: 'quantitySales',
        @Common.Label : 'Sales'
    },
    Aggregation.ApplySupported  : {
        $Type : 'Aggregation.ApplySupportedType',
        Transformations : [
            'aggregate',
            'filter',
            'search',
            'join',
            'top',
            'skip',
            'topcount',
            'bottomcount',
            'groupby'
        ],
        Rollup : #None,
        GroupableProperties : [
            'month',
            'monthCode',
            'year'
        ],
        AggregatableProperties : [
            {
                $Type : 'Aggregation.AggregatablePropertyType',
                Property : 'quantitySales'
            }
        ]
    },
    UI.Chart  : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Line,
        DynamicMeasures : [
            '@Analytics.AggregatedProperty#sum'
        ],
        Dimensions : [
            year,
            month
        ]
    }
);

