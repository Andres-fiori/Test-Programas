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
		const bindingContextSales = event.getSource().getBindingContext() as Context;
		const salesId = bindingContextSales.getProperty("ID");
		//let data = event.getParameter("data")[0].data as object;
		const data = (event.getParameter("data" as never) as any)[0].data;
		const routing = this.base.getExtensionAPI().getRouting() as Routing;
		const bindingContext = this.base.getExtensionAPI().getBindingContext() as Context;
		const view = this.base.getView() as View;
		//const actionDialog = this.base.getExtensionAPI().byId("products::ProductsObjectPage--fe:: CustomSubSection:: Sales--chart") as Button;
        

		if (!this.popover) {
			this.popover = await Fragment.load({
				id: view.getId(),
				name: 'products.ext.fragment.Popover',
				controller: this
			}) as Popover;
		};
		const model = new JSONModel(data);
		view.addDependent(this.popover);
		this.popover.setModel(model);
		//this.popover.openBy(actionDialog);
		this.popover.openBy(this.base.getView());
	}
	
	public async onOpenDialog(): Promise<void> {

		console.log("onOpenDialog");
		const bindingContext = this.base.getExtensionAPI().getBindingContext() as Context;
		const productId = bindingContext.getProperty("ID");
		const view = this.base.getView() as View;
		if (!this.dialog) {
			this.dialog ??= await Fragment.load({
				id: view.getId(),
				name: 'products.ext.fragment.Form',
				controller: this
			}) as Dialog;
		}
		view.addDependent(this.dialog);
		this.dialog.bindElement({
			                     path: '/', 
								model: '' });
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