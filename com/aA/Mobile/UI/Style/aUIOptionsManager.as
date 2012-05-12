package com.aA.Mobile.UI.Style 
{
	import com.aA.Mobile.UI.Views.aUIMenu;
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIOptionsManager extends Sprite
	{
		private static var _instance:aUIOptionsManager;
		private var m:aUIMenu;
		
		public function aUIOptionsManager() 
		{
			
		}
		
		public static function getInstance():aUIOptionsManager {
			if (_instance == null) {
				_instance = new aUIOptionsManager();
			} 
			return _instance;
		}
		
		public function addMenu(m:aUIMenu):void {
			this.m = m;
			addChild(this.m);
			m.addEventListener("back", back);
		}
		
		private function back(event:Event):void {
			hide();
			dispatchEvent(event);
		}
		
		public function getMenu(menuName:String):aUIMenu {
			return m;
		}
		
		public function display():void {
			this.visible = true;
			
			if (stage.orientation == StageOrientation.ROTATED_RIGHT) {
				stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOptionsOrientationChange);
				stage.setOrientation(StageOrientation.DEFAULT);
			}
		}
		
		private function onOptionsOrientationChange(event:StageOrientationEvent):void {
			
		}
		
		public function hide():void {
			this.visible = false;
			
			// need to dispatch a return
		}
	}

}