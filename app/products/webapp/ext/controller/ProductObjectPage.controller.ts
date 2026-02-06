import ControllerExtension from 'sap/ui/core/mvc/ControllerExtension';
import ExtensionAPI from 'sap/fe/templates/ObjectPage/ExtensionAPI';
import Popover from 'sap/m/Popover';
import Routing from 'sap/fe/core/controllerextensions/Routing';
import Context from 'sap/ui/model/odata/v4/Context';
import { Chart$SelectionChangeEvent } from 'sap/fe/macros/Chart';
import Button from 'sap/m/Button';
import Fragment from 'sap/ui/core/Fragment';
import JSONModel from 'sap/ui/model/json/JSONModel';
import View from 'sap/ui/core/mvc/View';
import type Dialog from 'sap/m/Dialog';

/**
 * @namespace products.ext.controller
 * @controller
 */
export default class ProductObjectPage extends ControllerExtension<ExtensionAPI> {

	private popover: Popover;
	private dialog: Dialog;

	public async onSelectionChange(event: Chart$SelectionChangeEvent): Promise<void> {

		// Obtiene el parámetro "data" del evento de selección del Chart.
		// - event.getParameter("data") devuelve un array con los puntos seleccionados
		// - [0] toma el primer punto seleccionado (modo Single)
		// - .data contiene los valores de dimensión y medidas del gráfico
		// - "as never" y "as any" se usan para evitar conflictos de tipado en TypeScript
		const data = (event.getParameter("data" as never) as any)[0].data;

		// Obtiene la vista actual del Object Page (vista raíz de la extensión)
		// Se usa para:
		// - obtener el ID correcto
		// - registrar dependencias (lifecycle management)
		// - evitar fugas de memoria
		const view = this.base.getView();
        
		// Verifica si el Popover aún no fue creado
        // Esto evita cargar el Fragment cada vez que el usuario selecciona un punto del gráfico
		if (!this.popover) {
		
			// Carga asincrónicamente el Fragment XML del Popover
            // id: se usa como prefijo de IDs internos del fragment (evita colisiones)
            // name: ruta completa del fragment dentro del proyecto
            // controller: permite que los eventos del fragment usen este controller
			this.popover = await Fragment.load({
				id: view.getId(),
				name: "products.ext.fragment.Popover",
				controller: this
			}) as Popover;
            
			// Registra el Popover como dependiente de la vista
			// SAPUI5 se encarga automáticamente de:
			// - destruir el Popover cuando se destruye la vista
			// - propagar modelos y contexto
			view.addDependent(this.popover);
		}
        
		// Crea un modelo JSON con los datos del punto seleccionado del gráfico
        // Este modelo se usará dentro del Popover para mostrar la información
		const model = new JSONModel(data);

		// Asigna el modelo al Popover
		// Por defecto se asigna como modelo principal (sin nombre)
		// Los controles del fragment pueden acceder vía {property}
		this.popover.setModel(model);
        
		// Abre el Popover anclándolo al control que disparó el evento
		// event.getSource() en este caso es el Chart
		// openBy requiere un sap.ui.core.Control válido (no una View)
		this.popover.openBy(event.getSource() as any);

	}

	public async onOpenDialog(): Promise<void> {
		console.log("Hola");
		const bindingContext = this.base.getExtensionAPI().getBindingContext() as Context;
		console.log(bindingContext);
		const productId = bindingContext.getProperty("ID");
		const view = this.base.getView() as View;
		console.log(view);
		if (!this.dialog) {
			this.dialog ??= await Fragment.load({
				id: view.getId(),
				name: 'extension.products.ext.controller.fragment.Form',
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

	static overrides = {
		/**
		 * Called when a controller is instantiated and its View controls (if available) are already created.
		 * Can be used to modify the View before it is displayed, to bind event handlers and do other one-time initialization.
		 * @memberOf products.ext.controller.ProductObjectPage
		 */
		onInit(this: ProductObjectPage) {
			// you can access the Fiori elements extensionAPI via this.base.getExtensionAPI
			const model = this.base.getExtensionAPI().getModel();
		}
	}
}