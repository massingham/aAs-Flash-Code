package com.aA.Mobile.UI.Views 
{
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class MenuMaker 
	{
		private static var currentMenu:String;
		
		
		public static function newMenu():void {
			currentMenu = "{\"menu\":{\"menuitems\":[";
		}
		
		public static function endMenu():String {
			currentMenu += "]}}";
			
			return currentMenu;
		}
		
		public static function addSection(sectionName:String):void {
			currentMenu += "{";
			currentMenu += "\"" + sectionName + "\":[";
		}
		
		public static function endSection():void {
			currentMenu = currentMenu.slice(0, currentMenu.length - 1) + "]}";
		}
	
		public static function addItem(itemType:int, itemTitle:String, itemDescription:String, data:Object = null):void {
			currentMenu += "{";
			currentMenu += "\"itemtype\":" + itemType + ",";
			currentMenu += "\"itemTitle\":\"" + itemTitle + "\",";
			currentMenu += "\"itemDescription\":\"" + itemDescription + "\"";
			if(data!=null){
				for (var key:String in data) {
					currentMenu += "," + key + ":" + data[key];
				}
			}
			currentMenu += "},";
		}
	}

}