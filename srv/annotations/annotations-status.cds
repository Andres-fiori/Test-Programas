using {Products as service} from '../service';

annotate service.VH_Status with {
    code @title : 'Status'
         @Common: {
        Text           : name,
        TextArrangement: #TextOnly
    }
};
