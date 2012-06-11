package com.aA.Mobile.UI.Views.MenuItems 
{
	import com.aA.Mobile.UI.Style.aUIOptionsManager;
	import com.aA.Mobile.UI.Views.aUIMenu;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUISubMenu extends aUIMenuItem
	{
		public var subMenu:aUIMenu;
		
		public function aUISubMenu(itemType:int, itemWidth:Number, itemHeight:Number, data:Object) 
		{
			super(aUIMenuItem.TYPE_ICON, itemWidth, itemHeight, data);
		}
		
		override protected function init():void {
			super.init();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, showSubMenu);
			
			// create menu
			subMenu = new aUIMenu(data["itemName"]);
			aUIOptionsManager.getInstance().addMenu(subMenu);
			subMenu.renderMenu(data["data"]);
		}
		
		private function showSubMenu(event:MouseEvent):void {
			aUIOptionsManager.getInstance().display(data["itemName"]);
			
			dispatchEvent(new Event("open"));
		}
		
		public function getItem(id:String):aUIMenuItem {
			return subMenu.getItem(id);
		}
	}

}