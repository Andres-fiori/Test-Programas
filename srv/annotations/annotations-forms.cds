using {Products as service} from '../service';


annotate service.form with {
    foption @title: 'Option';
    famount @title: 'Amount';
};

annotate service.form with {
    foption @Common: {ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'VH_Options',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: foption,
                ValueListProperty: 'code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            }
        ]
    }}
};
