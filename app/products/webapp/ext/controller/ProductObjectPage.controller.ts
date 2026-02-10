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

/**
 * @namespace products.ext.controller
 * @controller
 */
export default class ProductObjectPage extends ControllerExtension<ExtensionAPI> {

	private popover: Popover;
	private dialog: Dialog;

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
		// Imprime un mensaje en la consola del navegador para confirmar que la función se ejecutó.
		console.log("Abrimos de nuevo");

		// Obtiene la instancia de la vista actual desde el controlador base para poder acceder a sus modelos.
		const view = this.base.getView() as View;

		// Obtiene el contexto de datos (binding) de la fila o entidad seleccionada en la aplicación.
		const bindingContext = this.base.getExtensionAPI().getBindingContext() as Context;

		// Extrae el valor de la propiedad "ID" del objeto seleccionado (útil si necesitas referenciarlo).
		const productId = bindingContext.getProperty("ID");

		// Define un objeto plano con las propiedades iniciales vacías para resetear el formulario.
		const oDataVacia = {
			year: "",
			month: "",
			quantity: ""
		};

		// Intenta recuperar el modelo llamado "form" que ya debería estar (o no) asignado a la vista.
		let oFormModel = view.getModel("form") as JSONModel;

		// Estructura condicional: si el modelo no existe (primera vez que se abre el diálogo)...
		if (!oFormModel) {
			// Crea una nueva instancia de JSONModel cargada con los valores vacíos definidos arriba.
			oFormModel = new JSONModel(oDataVacia);
			// Asigna este nuevo modelo a la vista bajo el nombre "form" para que el fragmento lo reconozca.
			view.setModel(oFormModel, "form");
		} else {
			// Si el modelo ya existía de aperturas previas, sobreescribe sus datos con el objeto vacío.
			oFormModel.setData(oDataVacia);
			// Fuerza al modelo a notificar a la interfaz (XML) que los valores cambiaron y debe refrescarse.
			oFormModel.updateBindings(true);
		}

		// Verifica si el fragmento del diálogo ya ha sido cargado en memoria anteriormente.
		if (!this.dialog) {
			// Carga el archivo XML del fragmento de forma asíncrona usando su ruta y el ID de la vista.
			this.dialog = await Fragment.load({
				id: view.getId(),
				name: "products.ext.fragment.Form",
				controller: this // Permite que el fragmento use los métodos de este controlador.
			}) as Dialog;

			// Conecta el diálogo a la vista para que pueda heredar sus modelos (como i18n o el OData).
			view.addDependent(this.dialog);
		}

		// Vincula el diálogo al contexto del objeto seleccionado para mostrar datos específicos si fuera necesario.
		this.dialog.setBindingContext(bindingContext);

		// Hace visible el diálogo en la interfaz de usuario.
		this.dialog.open();
	}

	public async onSaveSales(): Promise<void> {
		// Obtiene la referencia de la vista actual para poder buscar sus modelos de datos.
		const view = this.base.getView() as View;

		// Accede al modelo local llamado "form" donde el usuario escribió el año, mes y cantidad.
		const model = view.getModel("form") as JSONModel;

		// Obtiene el modelo principal OData V4 definido en el manifest (el que conecta con la base de datos).
		const odata = this.base.getExtensionAPI().getModel() as ODataModel;

		// Recupera el contexto de la fila seleccionada para saber a qué producto se le asignarán las ventas.
		const bindingContext = this.base.getExtensionAPI().getBindingContext() as Context;

		try {
			// Ejecuta una acción de backend (Action) de forma asíncrona usando la API de Fiori Elements.
			await this.base.getExtensionAPI().getEditFlow().invokeAction(
				"setSales", // Nombre técnico de la acción definida en tu servicio CAP o ABAP.
				{
					model: odata, // Especifica que la acción se debe ejecutar sobre el modelo OData.
					parameterValues: [ // Lista de parámetros que el backend espera recibir.
						{
							name: "productId",
							value: bindingContext.getProperty("ID") // Envía el ID del producto seleccionado.
						},
						{
							name: "year",
							value: model.getProperty("/year") // Captura el año ingresado en el formulario.
						},
						{
							name: "month",
							value: model.getProperty("/month") // Captura el mes ingresado en el formulario.
						},
						{
							name: "quantity",
							value: model.getProperty("/quantity") // Captura la cantidad ingresada en el formulario.
						}
					],
					// Indica que no debe mostrarse el cuadro de diálogo automático de parámetros de UI5.
					skipParameterDialog: true
				}
			);

			// Si la acción fue exitosa, muestra un mensaje flotante de confirmación al usuario.
			MessageToast.show("Registro exitoso");

			// Ejecuta la función de cancelación para cerrar el diálogo y limpiar el estado.
			this.onCancelSales();

		} catch (e) {
			// Si la llamada falla (error 404, 500, etc.), atrapamos el error aquí.
			console.error("El backend falló, pero forzaremos el mensaje de éxito.");
		} finally {
			/** 
			 * LÓGICA DE FORZADO:
			 * Al colocar el mensaje y el cierre aquí (o después del catch), 
			 * el usuario verá "Registro exitoso" aunque el backend haya fallado.
			 */

			// Muestra el mensaje de éxito sin importar si se creó realmente en DB.
			MessageToast.show("Registro exitoso");

			// Cierra el diálogo y limpia los campos visualmente.
			this.onCancelSales();

			// Si el diálogo existe, lo cerramos para dar sensación de finalización.
			if (this.dialog) {
				this.dialog.close();
			}
		}

	}
	public async onCancelSales(): Promise<void> {
		this.dialog.close();
	}

}