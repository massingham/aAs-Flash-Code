package com.aA.Mobile.UI.Views.MenuItems 
{
	import com.aA.Mobile.UI.aUIComponent;
	import com.aA.Style.StyleManager;
	import com.aA.Text.Text;
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIMenuItem extends aUIComponent
	{
		protected var itemType:int;
		protected var itemHeight:Number;
		protected var itemWidth:Number;
		protected var data:Object;		
		protected var itemName:String;
		protected var itemDescription:String;
		protected var _id:String;
		
		protected var itemNameTF:TextField;
		protected var itemDescriptionTF:TextField;
		
		private var _enabled:Boolean;
		
		protected var padding:Number;
		
		protected var contentSprite:Sprite;
		
		public static const TYPE_BUTTON:int = 0;
		public static const TYPE_ICON:int = 1;
		public static const TYPE_MENU:int = 2;
		
		// input
		public static const TYPE_INPUT_TEXT:int = 3;
		public static const TYPE_INPUT_CHECK:int = 4;
		public static const TYPE_INPUT_LARGETEXT:int = 5;
		
		public function aUIMenuItem(itemType:int, itemWidth:Number, itemHeight:Number, data:Object) 
		{
			this.itemType = itemType;
			this.itemName = data["itemName"]
			this.itemDescription = data["itemDescription"];
			this.itemHeight = itemHeight;
			this.itemWidth = itemWidth;
			this.data = data;
			
			this._id = data["id"];
			
			_enabled = true;
			
			padding = itemWidth * 0.1;
			
			init();
		}
		
		public static function getItem(itemType:int, itemWidth:Number, itemHeight:Number, data:Object):aUIMenuItem {
			var item:aUIMenuItem;
			
			switch(itemType) {
				case aUIMenuItem.TYPE_BUTTON:
					return new aUIMenuItem(itemType, itemWidth, itemHeight, data);
				break;
				case aUIMenuItem.TYPE_MENU:
					return new aUISubMenu(itemType, itemWidth, itemHeight, data);
				break;
				case aUIMenuItem.TYPE_ICON:
					return new aUIMI_Icon(itemType, itemWidth, itemHeight, data);
				break;
				case aUIMenuItem.TYPE_INPUT_CHECK:
					return new aUIMI_Checkbox(itemType, itemWidth, itemHeight, data);
				break;
			}
			
			throw new Error("Invalid Item Type");
		}
		
		protected function init():void {
			contentSprite = new Sprite();
			addChild(contentSprite);
			
			drawItemName();
			drawItemDescription();
			
			contentSprite.y = itemHeight / 2 - contentSprite.height / 2;
			contentSprite.x = padding;
			
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, itemWidth, itemHeight);
			this.graphics.endFill();
		}
		
		protected function drawItemName():void {
			itemNameTF = Text.getTextField(itemName, StyleManager.getInstance().getProperty("font","medium"), 0, "LEFT", "_sans", false);
			contentSprite.addChild(itemNameTF);
		}
		
		protected function drawItemDescription():void {
			itemDescriptionTF = Text.getTextField(itemDescription, StyleManager.getInstance().getProperty("font","small"), 0x494949, "LEFT", "_sans", false);
			contentSprite.addChild(itemDescriptionTF);
			itemDescriptionTF.y = itemNameTF.height;
		}
		
		public function set title(val:String):void {
			if (val == "default") {
				itemNameTF.text = itemName;
			} else {
				itemNameTF.text = val;
			}
		}
		
		public function get title():String {
			return itemNameTF.text;
		}
		
		public function set description(val:String):void {
			if (val == "default") {
				itemDescriptionTF.text = itemDescription;
			} else {
				itemDescriptionTF.text = val;
			}
		}
		
		public function get description():String {
			return itemDescriptionTF.text
		}
		
		public function set enabled(val:Boolean):void {
			_enabled = val;
			
			if (_enabled) {
				this.alpha = 1;
				
				this.mouseEnabled = true;
				this.mouseChildren = true;
			} else {
				this.alpha = 0.4;
				
				this.mouseEnabled = false;
				this.mouseChildren = false;
			}
		}
		
		public function get enabled():Boolean {
			return _enabled
		}
		
		public function get id():String {
			return _id;
		}
	}

}