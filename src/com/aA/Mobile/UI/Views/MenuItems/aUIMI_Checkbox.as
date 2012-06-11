package com.aA.Mobile.UI.Views.MenuItems 
{
	import com.aA.UI.SimpleCheckList.SimpleCheckItem;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIMI_Checkbox extends aUIMenuItem
	{
		private var checkBox:SimpleCheckItem;
		
		public function aUIMI_Checkbox(itemType:int, itemWidth:Number, itemHeight:Number, data:Object) 
		{
			super(aUIMenuItem.TYPE_INPUT_CHECK, itemWidth, itemHeight, data)
		}
		
		override protected function init():void 
		{
			contentSprite = new Sprite();
			addChild(contentSprite);
			
			addInputLabel(itemName);
			
			checkBox = new SimpleCheckItem(itemHeight / 2, itemWidth / 2, 0xA7A7A7, "");
			contentSprite.addChild(checkBox);
			
			checkBox.x = itemWidth - ((itemHeight / 2) + padding * 2);
			
			contentSprite.y = itemHeight / 2 - contentSprite.height / 2;
			contentSprite.x = padding;
			
			inputLabelTF.y = checkBox.y + checkBox.height / 2 - inputLabelTF.height / 2;
			
			drawHitArea();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, toggle);
		}
		
		public function toggle(event:MouseEvent):void {
			if (checkBox.checked) {
				checkBox.uncheck();
			} else {
				checkBox.check();
			}
			changed(null);
		}
		
		public function set value(val:*):void {
			if (typeof val == "string") {
				if (val == "true") {
					checkBox.check();
				} else {
					checkBox.uncheck();
				}
			} else if (typeof val == "number") {
				if (val == 0) {
					checkBox.uncheck();
				} else {
					checkBox.check();
				}
			} else if (typeof val == "boolean") {
				if (val == true) {
					checkBox.check();
				} else {
					checkBox.uncheck();
				}
			} else {
				trace("UNSURE : " + val);
			}
		}
		
		public function get value():Boolean {
			return checkBox.checked;
		}
		
	}

}