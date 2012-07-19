package com.aA.Mobile.UI.Views.MenuItems 
{
	import com.aA.Mobile.UI.aUIInput;
	import com.aA.Mobile.UI.aUIInput_NST;
	import com.aA.Mobile.UI.Style.aUIStyleGuide;
	import com.aA.Style.StyleManager;
	import com.aA.Text.Text;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIMI_Input extends aUIMenuItem
	{
		private var inputTF:aUIInput_NST
		
		public function aUIMI_Input(itemType:int, itemWidth:Number, itemHeight:Number, data:Object) 
		{
			super(aUIMenuItem.TYPE_INPUT_TEXT, itemWidth, itemHeight, data);
		}
		
		override protected function init():void 
		{
			contentSprite = new Sprite();
			addChild(contentSprite);
			
			var style:aUIStyleGuide = new aUIStyleGuide()
			style.setColourScheme({
				"textColour":0x7E7E7E,
				"inputBGColour":0xEAEAEA
			});
			
			inputTF = new aUIInput_NST(itemWidth * .9, itemHeight * .7, data.numLines, itemDescription, StyleManager.getInstance().getProperty("font", "medium"));
			inputTF.style = style;
			inputTF.addEventListener(Event.CHANGE, changed);
			contentSprite.addChild(inputTF);
			
			inputTF.border = false;
			
			addInputLabel(itemName);
			
			contentSprite.x = itemWidth * .05;
			inputTF.x = 0;
			inputTF.y = inputLabelTF.y + inputLabelTF.height;
			
			itemHeight = inputTF.height + inputLabelTF.height + itemHeight * .15;
			
			drawHitArea();
		}	
		
		public function set value(val:String):void {
			if (val == null) return;
			inputTF.text = val;
		}
		
		public function get value():String {
			return inputTF.text;
		}
	}

}