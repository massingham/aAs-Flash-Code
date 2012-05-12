package com.aA.Game 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import com.aA.Utils.ArrayTools;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class LiveSettings extends EventDispatcher
	{
		private static var _instance:LiveSettings;
		private var loader:URLLoader;
		private var data:XML;
		private var preloaderSprite:Sprite;
		
		public function LiveSettings(e:SingletonEnforcer) 
		{
			preloaderSprite = new Sprite();
		}
		
		public static function getInstance():LiveSettings {
			if (_instance == null) {
				_instance = new LiveSettings(new SingletonEnforcer);
			}
			return _instance;
		}
		
		public function loadSettings(url:String = "settings.xml"):void {
			preloaderSprite.graphics.clear();
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, complete);			
			loader.addEventListener(ProgressEvent.PROGRESS, drawPreloader);
			// loader.load(new URLRequest(url + new Date().toUTCString()));
			loader.load(new URLRequest(url + "?" + new Date().toUTCString()));
		}
		
		private function drawPreloader(event:ProgressEvent):void {
			var percent:Number = event.bytesLoaded / event.bytesTotal;
			
			preloaderSprite.graphics.clear();
			preloaderSprite.graphics.beginFill(0, 0.3);
			preloaderSprite.graphics.drawRect(0, 0, 200, 100);
			preloaderSprite.graphics.endFill();
			
			preloaderSprite.graphics.lineStyle(0, 0, 0.5);
			preloaderSprite.graphics.drawRect(10, 10, 180, 80);
			
			preloaderSprite.graphics.lineStyle();
			preloaderSprite.graphics.beginFill(0, 0.3);
			preloaderSprite.graphics.drawRect(10, 10, 180 * percent, 80);
			preloaderSprite.graphics.endFill();
		}
		
		public function getPreloaderSprite():Sprite {
			return preloaderSprite;
		}
		
		private function complete(event:Event):void {
			data = XML(loader.data);
			
			dispatchEvent(event);
		}
		
		public function getData(key:String):XMLList {
			var xml:XMLList = data.child(key);
			return xml;
		}
		
		public function getItemNames(key:String):Array {
			var list:XMLList = getData(key);
			var returnArray:Array = new Array();
			
			for (var i:int = 0; i < list.children().length(); i++) {
				returnArray.push(list.child(i).name);
			}
			
			return returnArray;
		}
		
		public function isValid(object:String, value:String):Boolean {
			var list:Array = LiveSettings.getInstance().getItemNames(object);
			var results:Array = ArrayTools.searchArray(value, list, false);
			
			if (results == null) {
				return false;
			} else {
				return true;
			}
		}
	}

}

class SingletonEnforcer {
	
}