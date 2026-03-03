import Controller from "sap/fe/core/PageController";
import View from "sap/ui/core/mvc/View";
import JSONModel from "sap/ui/model/json/JSONModel";
import ODataListBinding from "sap/ui/model/odata/v4/ODataListBinding";
import ODataModel from "sap/ui/model/odata/v4/ODataModel";
import Utils from "products/utils/Utils";
import { Route$PatternMatchedEvent } from "sap/ui/core/routing/Route";
import values from "sap/base/util/values";


/**
 * @namespace products.ext.view
 */
export default class Review extends Controller {

    /**
     * Called when a controller is instantiated and its View controls (if available) are already created.
     * Can be used to modify the View before it is displayed, to bind event handlers and do other one-time initialization.
     * @memberOf products.ext.view.Review
     */
    public onInit(): void {
        super.onInit(); // needs to be called to properly initialize the page controller
        const router = this.getAppComponent().getRouter();
        router.getRoute("SalesReviewPage")?.attachPatternMatched(this._onObjectMatched, this);
    }
    private _onObjectMatched(event: Route$PatternMatchedEvent): void {
        const utils = new Utils();
        this.getQuantitySales(utils.extractDataFromUrl(window.location.href));
    }

    // En products.ext.view.Review (Controlador)
    public async getQuantitySales(object: any): Promise<void> {
        console.log("Estamos en Reviews");
        const odata = this.getExtensionAPI().getModel() as ODataModel;
        const view = this.getView() as View;

        await this.getExtensionAPI().getEditFlow().invokeAction("ProductSRV.getQuantitySales", {
            model: odata,
            parameterValues: [
                { name: 'id', value: object.key }, // Usamos 'key' porque así está en el manifest
                { name: 'year', value: object.year },
                { name: 'month', value: object.month }
            ],
            skipParameterDialog: true
        }).then((oContext: any) => {
            // AQUÍ VA LA LÓGICA QUE ME PASASTE:
            const oRawData = oContext.getObject();
            const aResults = oRawData.value || oRawData;

            console.log("Datos para la tabla:", aResults);

            const data = {
                results: Array.isArray(aResults) ? aResults : [aResults],
                sum: Array.isArray(aResults) ? aResults.length : (aResults ? 1 : 0)
            };

            const model = new JSONModel(data);
            view.setModel(model, "sales");
        });
    }

    /**
     * Similar to onAfterRendering, but this hook is invoked before the controller's View is re-rendered
     * (NOT before the first rendering! onInit() is used for that one!).
     * @memberOf products.ext.view.Review
     */
    // public  onBeforeRendering(): void {
    //
    //  }

    /**
     * Called when the View has been rendered (so its HTML is part of the document). Post-rendering manipulations of the HTML could be done here.
     * This hook is the same one that SAPUI5 controls get after being rendered.
     * @memberOf products.ext.view.Review
     */
    // public  onAfterRendering(): void {
    //
    //  }

    /**
     * Called when the Controller is destroyed. Use this one to free resources and finalize activities.
     * @memberOf products.ext.view.Review
     */
    // public onExit(): void {
    //
    //  }
}