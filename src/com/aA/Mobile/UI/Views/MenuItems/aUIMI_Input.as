package com.aA.Mobile.UI.Views.MenuItems 
{
	import com.aA.Mobile.UI.aUIInput;
	import com.aA.Mobile.UI.aUIInput_NST;
	import com.aA.Style.StyleManager;
	import com.aA.Text.Text;
	import flash.display.Sprite;
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
			
			addInputLabel(itemName);
			inputTF = new aUIInput_NST(itemWidth / 2, itemHeight * .7, 1, itemDescription, StyleManager.getInstance().getProperty("font", "small"));
			contentSprite.addChild(inputTF);
			
			inputTF.x = itemWidth - (inputTF.width + padding * 2);
			inputTF.y = 0;
			
			contentSprite.y = itemHeight / 2 - (itemHeight*.7) / 2;
			contentSprite.x = padding;
			
			inputLabelTF.y = inputTF.y + inputTF.height / 2 - inputLabelTF.height / 2;
			
			drawHitArea();
		}		
	}

}