using {Products as service} from '../service';


annotate service.VH_Departments with {
    @title: 'Departments'
    ID @Common: {
        Text           : department,
        TextArrangement: #TextOnly
    };
};
