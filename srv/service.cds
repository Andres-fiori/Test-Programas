using {com.logaligroup as entities} from '../db/schema';
using {API_BUSINESS_PARTNER as cloud} from './external/API_BUSINESS_PARTNER';
using {API_BUSINESS_PARTNER_ONPREMISE as onpremise} from './external/API_BUSINESS_PARTNER_ONPREMISE';

service ProductSRV {

    type dialog {
        abc    : String(10); //Suma / Resta
        amount : Integer; //Valor
    };

    entity Products          as projection on entities.Products;
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
                            option: dialog:abc,
                            amount: dialog:amount)
        };

    entity Sales             as projection on entities.Sales;

    /** Remote - Entities */
    @cds.persistence.exists
    @cds.persistence.skip
    entity CustomersCloud    as
        projection on cloud.A_Customer {
            key Customer,
                CustomerFullName as FullName,
                CustomerName     as Name,
                Supplier         as Supplier,
                County,
                CityCode
        };

    @cds.persistence.exists
    @cds.persistence.skip
    entity SuppliersCloud    as
        projection on cloud.A_Supplier {
            key Supplier,
                SupplierName,
                SupplierFullName,
                Customer
        };

    @cds.persistence.exists
    @cds.persistence.skip
    entity BussinesPartnerOP as
        projection on onpremise.A_BusinessPartner {
            key BusinessPartner,
                Customer,
                Supplier,
                FirstName,
                LastName
        };

    @cds.persistence.exists
    @cds.persistence.skip
    @readonly
    entity VH_Supplier       as
        projection on onpremise.A_Supplier {
            key Supplier,
                SupplierName,
                SupplierFullName,
                Customer
        };

    /*action setSales(productId: UUID,
                    year: String(4),
                    month: String(3),
                    quantity: Integer);*/

    /** Value Help */
    @readonly
    entity VH_Categories     as projection on entities.Categories;

    @readonly
    entity VH_SubCategories  as projection on entities.SubCategories;

    @readonly
    entity VH_Departments    as projection on entities.Departments;

    @readonly
    entity VH_Options        as projection on entities.Options;
};
