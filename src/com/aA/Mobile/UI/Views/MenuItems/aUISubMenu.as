package com.aA.Mobile.UI.Views.MenuItems 
{
	import com.aA.Mobile.UI.Style.aUIOptionsManager;
	import com.aA.Mobile.UI.Views.aUIMenu;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUISubMenu extends aUIMenuItem
	{
		
		public function aUISubMenu(itemType:int, itemWidth:Number, itemHeight:Number, data:Object) 
		{
			super(aUIMenuItem.TYPE_ICON, itemWidth, itemHeight, data);
		}
		
		override protected function init():void {
			super.init();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, showSubMenu);
			
			// create menu
			var subMenu:aUIMenu = new aUIMenu(data["itemName"]);
			aUIOptionsManager.getInstance().addMenu(subMenu);
			subMenu.renderMenu(data["data"]);
		}
		
		private function showSubMenu(event:MouseEvent):void {
			aUIOptionsManager.getInstance().display(data["itemName"]);
		}
	}

}