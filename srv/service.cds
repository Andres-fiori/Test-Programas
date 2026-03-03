using {com.logaligroup as entities} from '../db/schema';
using {API_BUSINESS_PARTNER as bp} from './external/API_BUSINESS_PARTNER';
using {API_BUSINESS_PARTNER_RM as rbp} from './external/API_BUSINESS_PARTNER_RM';

service Products {
    type form {
        foption : String(10);
        famount : Integer;
    }

    // entity Products         as projection on entities.Products;
    entity Products as projection on entities.Products
    actions {

        @Common.SideEffects: {
            TargetEntities: ['toSales'],
            TargetProperties: ['*']
        }
        action setSales(
            year     : String(4),
            month    : String(2),
            quantity : Integer
        );

    };

    entity ProductDetails    as projection on entities.ProductDetails;
    entity Suppliers         as projection on entities.Suppliers;
    entity Contacts          as projection on entities.Contacts;
    entity Reviews           as projection on entities.Reviews;
    

    entity Inventories       as projection on entities.Inventories
        actions {
            @Core.OperationAvailable: {$edmJson: {$If: [
                {$Eq: [
                    {$Path: 'in/product/IsActiveEntity'},
                    true
                ]},
                true,
                false
            ]}}
            @Common                 : {SideEffects: {
                $Type           : 'Common.SideEffectsType',
                TargetProperties: ['in/quantity', ],
                TargetEntities  : [in.product],
            }, }
            action setStock(in: $self,
                            option: form:foption,
                            amount: form:famount)
        };

    entity Sales             as projection on entities.Sales;


    /** ValueHelps -  */

    @readonly
    entity VH_Categories     as projection on entities.Categories;

    @readonly
    entity VH_SubCategories  as projection on entities.SubCategories;

    @readonly
    entity VH_Status         as projection on entities.Status;

    @readonly
    entity VH_Departments    as projection on entities.Departments;

    @readonly
    entity VH_Options        as projection on entities.Options;

    /** Services OData - Remote */

    @readonly
    entity VH_Supplier       as
        projection on bp.A_Supplier {
            key Supplier,
                SupplierFullName as FullName,
                SupplierName
        };

    @readonly
    entity VH_BusinessParner as
        projection on bp.A_BusinessPartner {
            key BusinessPartner,
                PersonFullName,
                NameCountry
        };

    @readonly
    entity VH_Customer       as
        projection on rbp.A_Customer {
            key Customer,
                CustomerFullName,
                CustomerName
        };
    
    @readonly
    entity VH_Months as projection on entities.Months;
}
