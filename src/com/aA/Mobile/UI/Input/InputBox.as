package com.aA.Mobile.UI.Input 
{
	import com.aA.Mobile.UI.aUIButton;
	import com.aA.Mobile.UI.aUIInput_NST;
	import com.aA.Mobile.UI.Style.aUIStyleGuide;
	import com.aA.Style.StyleManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.events.SoftKeyboardTrigger;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class InputBox extends Sprite
	{
		private var inputTF:aUIInput_NST;
		private var submitButton:aUIButton;
		
		private var defaultX:Number = 0;
		private var defaultY:Number = 0;
		
		public function InputBox(boxWidth:Number, boxHeight:Number, style:aUIStyleGuide = null) 
		{
			super();
			
			// this.addEventListener(Event.ADDED_TO_STAGE, initEventListeners);
			init(boxWidth, boxHeight, style);
		}
		
		private function initEventListeners(event:Event):void {
			this.stage.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, moveInput);
			this.stage.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, moveInputBack);
		}
		
		private function init(boxWidth:Number, boxHeight:Number, style:aUIStyleGuide):void {
			var sendWidth:Number = boxWidth * .2;
			
			var inputStyle:aUIStyleGuide = new aUIStyleGuide();
			if (style == null) {
				inputStyle.setColourScheme({
					inputBGColour:0xFFFFFF,
					textColour:0x363636,
					buttonTextColour:StyleManager.getInstance().getProperty("colour", "font_subheading"),
					fillColour:0xFFFFFF,
					highlightColour:0x7F7F7F
				});
			} else {
				inputStyle = style;
			}
			
			inputTF = new aUIInput_NST(boxWidth - sendWidth, boxHeight, 1, "Write a reply", StyleManager.getInstance().getProperty("font", "small"));
			inputTF.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			inputTF.x = 0;
			inputTF.style = inputStyle;
			addChild(inputTF);
			inputTF.border = false;
			
			submitButton = new aUIButton("Send", sendWidth, boxHeight);
			submitButton.setTextHeight(StyleManager.getInstance().getProperty("font", "small"));
			submitButton.style = inputStyle;
			addChild(submitButton);
			submitButton.x = boxWidth - sendWidth;
			
			submitButton.addEventListener(MouseEvent.MOUSE_DOWN, sendMessage);
			
			var lines:Sprite = new Sprite();
			addChild(lines);
			
			lines.graphics.lineStyle(0, StyleManager.getInstance().getProperty("colour", "font_subheading"));
			lines.graphics.moveTo(0, 0);
			lines.graphics.lineTo(boxWidth, 0);
			lines.graphics.moveTo(submitButton.x, boxHeight * .2);
			lines.graphics.lineTo(submitButton.x, boxHeight * .8);
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ENTER) {
				submitMessage();
				stage.focus = null;
			}
		}
		
		private function sendMessage(event:MouseEvent):void {
			submitMessage();
		}
		
		private function submitMessage():void {
			if (inputTF.text == "") return;
			dispatchEvent(new Event("submit"));
		}
		
		private function moveInput(event:SoftKeyboardEvent):void {
			super.y = stage.softKeyboardRect.y - this.height;
		}
		
		private function moveInputBack(event:SoftKeyboardEvent):void {
			super.x = defaultX;
			super.y = defaultY;
		}
		
		override public function set x(value:Number):void 
		{
			super.x = value;
			defaultX = value;
		}
		
		override public function set y(value:Number):void 
		{
			super.y = value;
			defaultY = value;
		}
		
		public function get text():String {
			return inputTF.text;
		}
		
		public function clear():void {
			inputTF.text = "";	
		}
		
		public function focus():void {
			inputTF.focus();
		}
	}

}