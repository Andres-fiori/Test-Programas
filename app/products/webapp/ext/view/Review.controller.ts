import Controller from "sap/fe/core/PageController";
import View from "sap/ui/core/mvc/View";
import JSONModel from "sap/ui/model/json/JSONModel";
import ODataListBinding from "sap/ui/model/odata/v4/ODataListBinding";
import ODataModel from "sap/ui/model/odata/v4/ODataModel";
import Utils from "products/Utils/Utils";
import { Route$PatternMatchedEvent } from "sap/ui/core/routing/Route";

/**
 * @namespace products.ext.view
 */
export default class Review extends Controller {

    /**
     * Called when a controller is instantiated and its View controls (if available) are already created.
     * Can be used to modify the View before it is displayed, to bind event handlers and do other one-time
     * @memberOf products.ext.view.Review
     */
    // Dentro de la clase Review extends Controller
    public onInit(): void {
        super.onInit(); // Inicialización base del controlador de página
        const router = this.getAppComponent().getRouter(); // Obtiene el router de la app

        // Adjunta un handler al evento de coincidencia de la ruta "SalesReviewPage"
        // El '?' es por si la ruta no existe, para evitar errores de TypeScript.
        router.getRoute("SalesReviewPage")?.attachPatternMatched(this._onObjectMatched, this);
    }

    private _onObjectMatched(_event: Route$PatternMatchedEvent): void {
        console.log("Estamos en Review")
        const utils = new Utils(); // Instancia de la clase Utils
        // Extrae los datos (id, year, month) de la URL actual
        this.getQuantitySales(utils.extractDataFromUrl(window.location.href));
        console.log(this.getQuantitySales(utils.extractDataFromUrl(window.location.href)));
    }


    // Dentro de la clase Review extends Controller
    public async getQuantitySales(object: any): Promise<void> {
        const odata = this.getExtensionAPI().getModel() as ODataModel;

        const view = this.getView() as View;

        await
            this.getExtensionAPI().getEditFlow().invokeAction("ProductSRV.getQuantitySales", {
                model: odata,
                parameterValues: [
                    {
                        name: 'id',
                        value: object.id
                    },
                    {
                        name: 'year',
                        value: object.year
                    },
                    {
                        name: 'month',
                        value: object.month
                    }
                ],
                skipParameterDialog: true
            }).then((result) => {
                const model = new JSONModel(result) as
                    JSONModel;
                view.setModel(model, "sales");

            });

    }
}
