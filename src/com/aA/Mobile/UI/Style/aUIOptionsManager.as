package com.aA.Mobile.UI.Style 
{
	import com.aA.Mobile.UI.Views.aUIMenu;
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIOptionsManager extends Sprite
	{
		private static var _instance:aUIOptionsManager;
		
		public var stageWidth:Number;
		public var stageHeight:Number;
		public var headerHeight:Number;
		
		private var menus:Dictionary;
		private var rootMenu:String;
		
		public function aUIOptionsManager() 
		{
			menus = new Dictionary();
		}
		
		public static function getInstance():aUIOptionsManager {
			if (_instance == null) {
				_instance = new aUIOptionsManager();
			} 
			return _instance;
		}
		
		public function addMenu(m:aUIMenu, root:Boolean = false):void {
			menus[m.menuName] = m;
			m.addEventListener("back", back);
			
			if (root) { rootMenu = m.menuName };
		}
		
		private function back(event:Event):void {
			var currentMenu:aUIMenu = aUIMenu(event.currentTarget);
			if (currentMenu.menuName == rootMenu) {
				hide(currentMenu, true);
			} else {
				hide(currentMenu, false);
			}
			dispatchEvent(event);
		}
		
		public function getMenu(menuName:String):aUIMenu {
			return menus[menuName];
		}
		
		public function display(menuName:String = ""):void {
			this.visible = true;
			
			if (menuName == "") {
				menuName = rootMenu;
			}
			
			addChild(menus[menuName]);
			menus[menuName].visible = true;
			
			if (stage.orientation == StageOrientation.ROTATED_RIGHT) {
				stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOptionsOrientationChange);
				stage.setOrientation(StageOrientation.DEFAULT);
			}
		}
		
		private function onOptionsOrientationChange(event:StageOrientationEvent):void {
			
		}
		
		public function hide(currentMenu:aUIMenu, hideAll:Boolean = false):void {
			if (currentMenu != null) {
				currentMenu.visible = false;
				this.removeChild(currentMenu);
			}
			
			if (hideAll) {
				hideAllMenus();
			}
		}
		
		private function hideAllMenus():void {
			for (var key:String in menus) {
				menus[key].visible = false;
				if (this.contains(menus[key])) {
					this.removeChild(menus[key]);
				}
			}
		}
	}

}