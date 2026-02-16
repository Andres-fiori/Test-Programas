import ControllerExtension from 'sap/ui/core/mvc/ControllerExtension';
import ExtensionAPI from 'sap/fe/templates/ObjectPage/ExtensionAPI';
import Popover from 'sap/m/Popover';
import Context from 'sap/ui/model/odata/v4/Context';
import { Chart$SelectionChangeEvent } from 'sap/fe/macros/Chart';
import Fragment from 'sap/ui/core/Fragment';
import JSONModel from 'sap/ui/model/json/JSONModel';
import View from 'sap/ui/core/mvc/View';
import type Dialog from 'sap/m/Dialog';
import MessageToast from 'sap/m/MessageToast';
import ODataModel from 'sap/ui/model/odata/v4/ODataModel';
import Button from 'sap/m/Button';
import Routing from 'sap/fe/core/controllerextensions/Routing';

/**
 * @namespace products.ext.controller
 * @controller
 */
export default class ProductObjectPage extends ControllerExtension<ExtensionAPI> {
	// "ProductObjectPage" es el nombre de la clase del controller
	// Representa una extensión del Object Page en Fiori Elements
	// Aquí se implementan lógicas personalizadas (acciones, eventos, navegación, etc.)
	//
	// "extends ControllerExtension<ExtensionAPI>"
	// Indica que esta clase NO es un controller UI5 normal,
	// sino un controller de extensión específico de Fiori Elements
	//
	// ControllerExtension:
	// - Permite extender el comportamiento estándar de FE
	// - Se integra con el lifecycle del framework
	//
	// <ExtensionAPI>:
	// Es el tipo genérico que define la API disponible:
	// this.base.getExtensionAPI()
	//
	// Gracias a esto podés usar:
	// - getModel()
	// - getBindingContext()
	// - getEditFlow()
	// - getRouting()
	// - invokeAction()
	// etc.

	// Declara una propiedad privada del controller para almacenar un JSONModel
	// para guardar datos temporales del formulario
	// (por ejemplo campos de un diálogo: año, mes, cantidad, etc.)
	private _oFormModel: JSONModel;

	// Declara una propiedad privada para almacenar la instancia del Popover
	// poder reutilizar el fragment sin volver a cargarlo
	private popover: Popover;

	// Declara una propiedad privada para almacenar la instancia del Dialog
	// Permite abrir/cerrar el diálogo desde distintos métodos del controller
	private dialog: Dialog;
	private year: string;
	private month: string;


	// Objeto especial usado en Fiori Elements Extension Controllers
	// "overrides" permite redefinir lifecycle hooks estándar de FE
	static overrides = {
		/**
		 * Método que se ejecuta automáticamente cuando se inicializa la página
		 * Es equivalente al onInit() de un controller UI5 tradicional,
		 * pero adaptado al framework de Fiori Elements
		 */
		onInit(this: ProductObjectPage) {
			// Hace un bind del método al contexto del controller
			// Garantiza que "this" dentro de onNavToDetails siempre apunte al controller
			// Es necesario cuando el método se usa como handler de eventos
			//this.onNavToDetails = this.onNavToDetails.bind(this);

			// Hace lo mismo para el método que abre el diálogo
			// Evita el error típico: "this is undefined"
			//this.onOpenDialog = this.onOpenDialog.bind(this);

			// Obtiene el modelo OData principal del servicio RAP
			// Este modelo está gestionado por Fiori Elements
			// Se puede usar para leer datos, ejecutar acciones, etc.
			const model = this.base.getExtensionAPI().getModel();
			this.loadModel();
		}
	}
	private loadModel(): void {
		let data = {
			year: "",
			month: "",
			quantity: null
		}
		const view = this.base.getView() as View;
		const model = new JSONModel(data) as JSONModel;
		view.setModel(model, "form");

	}
		// Method onSaveSales //
	public async onSaveSales(): Promise<void> {
		console.log("Creamos el items");
		const view = this.base.getView() as View;
		const model = view.getModel("form") as JSONModel;
		const odata = this.base.getExtensionAPI().getModel() as ODataModel;
		const bindingContext = this.base.getExtensionAPI().getBindingContext() as Context;
		const $this = this;

		await this.base.getExtensionAPI().getEditFlow().invokeAction("setSales", {
			model: odata,
			parameterValues: [
				{
					name: "id",
					value: bindingContext.getProperty("ID")
				},
				{
					name: "year",
					value: model.getProperty("/year")
				},
				{
					name: "month",
					value: model.getProperty("/month")
				},
				{
					name: "quantity",
					value: model.getProperty("/quantity")
				}
			],
			skipParameterDialog: true
		}).then(() => {
			MessageToast.show("Registro exitoso");
			$this.onCancelSales();
		})
	}
	// Method onSelectionChange //
	public async onSelectionChange(event: Chart$SelectionChangeEvent): Promise<void> {

		const bindingContextSales = event.getSource().getBindingContext() as Context;
		const salesId = bindingContextSales.getProperty("ID");
		const data = (event.getParameter("data" as never) as any)[0].data;
		const routing = this.base.getExtensionAPI().getRouting() as Routing;
		const bindingContext = this.base.getExtensionAPI().getBindingContext() as Context;
		const view = this.base.getView() as View;
		const actionDialog = this.base.getExtensionAPI().byId("products::ProductsObjectPage--fe::CustomSubSection::Sales--chart") as any;

		if (!this.popover) {
			this.popover = await Fragment.load({
				id: view.getId(),
				name: 'products.ext.fragment.Popover',
				controller: this
			}) as Popover;
		};

		const anchor = actionDialog || event.getSource();
		const model = new JSONModel(data);
		view.addDependent(this.popover);
		this.popover.setModel(model);

		if (this.popover && anchor) {
			this.popover.openBy(anchor as any);
		}
	}

	// Method onOpenDialog //
	public async onOpenDialog(): Promise<void> {
		console.log("Es prueba");
		const bindingContext = this.base.getExtensionAPI().getBindingContext() as Context;
		const productId = bindingContext.getProperty("ID");
		const view = this.base.getView() as View;

		if (!this.dialog) {
			this.dialog = await Fragment.load({
				id: view.getId(),
				name: 'products.ext.fragment.Form',
				controller: this
			}) as Dialog;
		}
		view.addDependent(this.dialog);
		this.dialog.bindElement({
			path: '/',
			model: ''
		});
		this.dialog.open();
	}
	public CancelSales(): void {
		this.dialog.close();
	}

	// Method onCancelSales
	public async onCancelSales(): Promise<void> {
		this.dialog.close();
	}
	// Method onCloseNavToDetails //
	public onCloseNavToDetails(): void {
		// Verifica que el popover exista antes de intentar cerrarlo
		if (this.popover) {
			this.popover.close();
		}
	}
	// Method onNavToDetails //
	public onNavToDetails(): void {
		console.log("Entramos a details");

		const bindingContext = this.base.getExtensionAPI().getBindingContext() as Context;
		const productId = bindingContext.getProperty("ID");
		const isActiveEntity = bindingContext.getProperty("IsActiveEntity");

		// SOLUCIÓN: Extraer los datos exactos que muestra tu consola
		//const oSelectedData = this.popover.getModel("selectedPoint").getData();
		const oSelectedData = (this as any).popover.getModel("selectedPoint").getData();

		// Verificamos en consola antes de navegar
		console.log("Año extraído:", oSelectedData.year); // Debería decir "2022"
		console.log("Mes extraído:", oSelectedData.month); // Debería decir "February"

		this.base.getExtensionAPI().getRouting().navigateToRoute("SalesReviewPage", {
			key: productId,
			boolean: isActiveEntity,
			year: oSelectedData.year,  // Ahora pasará "2022"
			month: oSelectedData.month // Ahora pasará "February"
		});

		console.log(oSelectedData, productId);
	}

}