package com.aA.Game 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class SpriteManager extends EventDispatcher
	{
		
		private static var _instance:SpriteManager;
		private var library:Dictionary;
		private var bitmapLibrary:Dictionary;
		
		private var loader:Loader;
		
		public function SpriteManager() 
		{
			library = new Dictionary();
			bitmapLibrary = new Dictionary();
		}
		
		public static function getInstance():SpriteManager {
			if (_instance == null) {
				_instance = new SpriteManager();
			}
			return _instance;
		}
		
		public function addItem(item:String):void {
			library[item] = loader.contentLoaderInfo.applicationDomain.getDefinition(item);
		}
		
		public function getItem(name:String):MovieClip {
			//if (library[name] == null) {
			//	trace("  Missing asset '" + name + "', are you sure you added it?");
			//	return null;
			//}
			//return new library[name]() as MovieClip;
			
			// return [name] as MovieClip;
			//var c:Object = ApplicationDomain.currentDomain.parentDomain.getDefinition(name); 
			var returnObject:Object = getDefinitionByName(name);
			var returnMovieClip:MovieClip = new returnObject() as MovieClip;
			
			return returnMovieClip;
		}
		
		public static function toBitmap(asset:DisplayObject, setWidth:Number = -1, setHeight:Number = -1):Bitmap {
			var data:BitmapData;
			var finalWidth:int = setWidth;
			var finalHeight:int = setHeight;
			
			if (setWidth == -1 && setHeight != -1) {
				finalWidth = (finalHeight / asset.height) * asset.width;
			} else if (setWidth != -1 &&  setHeight == -1) {
				finalHeight = (finalWidth / asset.width) * asset.height;
			} else if (setHeight == -1 && setWidth == -1) {
				finalWidth = asset.width;
				finalHeight = asset.height;
			}
			
			var matrix:Matrix = new Matrix();
			matrix.scale(finalWidth / asset.width, finalHeight / asset.height);
			
			data = new BitmapData(finalWidth, finalHeight, true, 0x00FFFFFF);
			data.draw(asset, matrix);
			
			return new Bitmap(data, "auto", true);
		}
		
		public function getItemAsBitmap(name:String, setWidth:Number = -1, setHeight:Number = -1, rotate:Number = 0):Bitmap {
			var asset:MovieClip = SpriteManager.getInstance().getItem(name);
			if (asset == null) {
				return null;
			}
			/**var data:BitmapData;
			
			var finalWidth:int = setWidth;
			var finalHeight:int = setHeight;
			
			if (setWidth == -1 && setHeight != -1) {
				// width is equal to the height ratio
				finalWidth = (finalHeight / asset.height) * asset.width;
			} else if (setWidth != -1 &&  setHeight == -1) {
				// height is equal to the height ratio
				finalHeight = (finalWidth / asset.width) * asset.height;
			} else if (setHeight == -1 && setWidth == -1) {
				finalWidth = asset.width;
				finalHeight = asset.height;
			}
			
			var matrix:Matrix = new Matrix();
			matrix.scale(finalWidth / asset.width, finalHeight / asset.height);
			
			//if (rotate != 0) {
			//	matrix.translate(0 - finalWidth / 2, 0 - finalHeight / 2);
			//	matrix.rotate(rotate * (Math.PI / 180));
			//	matrix.translate(finalWidth / 2, finalHeight / 2);
			//}
			
			data = new BitmapData(finalWidth, finalHeight, true, 0x00FFFFFF);
			data.draw(asset, matrix);
			
			//if (bitmapLibrary[name] == null && asset.width > finalWidth && asset.height > finalHeight) {
			//	bitmapLibrary[name] = data;
			//}
			
			return new Bitmap(data, "auto", true);**/
			return toBitmap(asset, setWidth, setHeight);
		}
		
		public function load(ba:Class):void {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, spritesInit);
			var context:LoaderContext = new LoaderContext();
			//if (Capabilities.playerType == "Desktop") {
				if(Capabilities.playerType != "PlugIn" && Capabilities.playerType != "ActiveX") {
					trace("ALLOWING CODE EXECUTION");
					context["allowCodeImport"] = true;
				}
			//}
			loader.loadBytes(new ba(), context);
		}
		
		private function spritesInit(event:Event):void {
			dispatchEvent(new Event("done"));
			trace("loader : " + loader);
			//var SymbolClass:Class = loader.contentLoaderInfo.applicationDomain.getDefinition("com.gskinner.MyClass");
			// trace(loader.contentLoaderInfo.applicationDomain.getDefinition("Standard_Man"));
			
			
			//var symbolInstance:Sprite = new SymbolClass() as Sprite;
		}
		
	}

}