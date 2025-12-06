using {Products as service} from '../service';

annotate service.Suppliers with {
    ID @title : 'Suppliers'
       @Common: {
        Text           : supplierName,
        TextArrangement: #TextOnly
    }
};
