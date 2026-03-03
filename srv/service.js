const cds = require('@sap/cds');
const { SELECT, UPDATE } = require('@sap/cds/lib/ql/cds-ql');

module.exports = class Products extends cds.ApplicationService {

    async init() {

        const { Products, Inventories, VH_Supplier, VH_BusinessParner, VH_Customer } = this.entities;
        const bp = await cds.connect.to("API_BUSINESS_PARTNER");
        const rbp = await cds.connect.to("API_BUSINESS_PARTNER_RM");

        //CREATE  --> NEW
        //UPDATE
        //DELETE
        //READ

        //before,on,after

        this.on('READ', VH_Supplier, async (req) => {
            return await bp.tx(req).send({
                query: req.query,
                headers: {
                    apikey: process.env.APIKEY
                }
            });
        });

        this.on('READ', VH_BusinessParner, async (req) => {
            return await bp.tx(req).send({
                query: req.query,
                headers: {
                    apikey: process.env.APIKEY
                }
            });
        });

        this.on('READ', VH_Customer, async (req) => {
            return await rbp.tx(req).send({
                query: req.query,
                headers: {
                    Authorization: process.env.Authorization
                }
            });
        });

        this.before('NEW', Products.drafts, async (req) => {
            req.data.detail ??= {
                baseUnit: 'EA',
                width: null,
                depth: null,
                height: null,
                weight: null,
                unitVolume: 'CM',
                unitWeight: 'KG'
            }
        });

        this.before('NEW', Inventories.drafts, async (req) => {
            let dbp = await SELECT.one.from(Inventories).columns('max(stockNumber)');
            let dbd = await SELECT.one.from(Inventories.drafts).columns('max(stockNumber)');

            let max = parseInt(dbp.max);
            let max2 = parseInt(dbd.max);
            let newMax = 0;

            if (isNaN(max2)) {
                newMax = max + 1; //10000000360 --> 10000000361
            } else if (max < max2) {
                newMax = max2 + 1; //10000000361 --> 10000000362
            } else {
                newMax = max + 1;
            }

            req.data.stockNumber = newMax.toString();
        });

        this.on('setStock', async (req) => {
            const productId = req.params[0].ID;
            const inventoryId = req.params[1].ID;

            const { quantity } = await SELECT.one.from(Inventories).columns('quantity').where({ ID: inventoryId });
            let newAmount = 0;

            //newAmount > 300 (statu_code = InStock)
            //newAmount >0 <=300  (statu_code = LowAvailability)
            //newAmount = 0 (statu_code = OutOfStock)

            if (req.data.option === 'A') {
                newAmount = req.data.amount + quantity;

                if (newAmount > 300) {
                    await UPDATE(Products).set({ statu_code: 'InStock' }).where({ ID: productId });
                }

                await UPDATE(Inventories).set({ quantity: newAmount }).where({ ID: inventoryId });
                return req.info(200, `The amount ${req.data.amount} has benn added to the inventory`);
            } else if (req.data.amount > quantity) {
                return req.error(400, `There is no availability for the requested quantiy`);
            } else {
                newAmount = quantity - req.data.amount;
                if (newAmount > 0 && newAmount <= 300) {
                    await UPDATE(Products).set({ statu_code: 'LowAvailability' }).where({ ID: productId });
                } else if (newAmount === 0) {
                    await UPDATE(Products).set({ statu_code: 'OutOfStock' }).where({ ID: productId });
                }

                await UPDATE(Inventories).set({ quantity: newAmount }).where({ ID: inventoryId });
                return req.info(200, `The amount ${req.data.amount} has been removed from the inventory`)
            }

        });
        /* this.on('READ', 'VH_Years', async (req) => {
 
             const years = await SELECT.distinct
                 .from('com.logaligroup.Sales')
                 .columns('year');
 
             return years
                 .filter(y => y.year)
                 .map(y => ({ year: y.year }));
 
         });*/
        this.on('setSales', 'Products', async (req) => {

            const { year, month, quantity } = req.data;
            const monthData = await SELECT.one
                .from('com.logaligroup.Months')
                .where({ code: month });

            await INSERT.into('com.logaligroup.Sales').entries({
                year: year,
                monthCode: month,
                month: monthData.descr,
                quantitySales: quantity,
                product_ID: productID
            });
        });

        return super.init();
    }
}