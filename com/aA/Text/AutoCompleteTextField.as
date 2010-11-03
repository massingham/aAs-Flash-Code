package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	public class AutoCompleteTextField extends Sprite {
		
		private var dictionary:Array;
		private var textField:TextField;
		private var currentList:Array;
		private var wordList:Sprite;
		
		public function AutoCompleteTextField(inputTF:TextField, dictionary:Array, submitButton:Boolean = false) {
			wordList = new Sprite();
			addChild(wordList);
			
			this.dictionary = dictionary;
			this.dictionary.sort();
			
			for (var i = 0; i < this.dictionary.length; i++) {
				dictionary[i] = dictionary[i].toUpperCase();
			}
			
			currentList = new Array();
			
			textField = inputTF;
			
			textField.addEventListener(Event.CHANGE, autoComplete);
			textField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
			if (submitButton) {
				var submitB:Sprite = new Sprite();
				addChild(submitB);
				
				submitB.graphics.lineStyle(0, 0, 0.2);
				submitB.graphics.beginFill(0xD1D9E0);
				submitB.graphics.moveTo(0, 0);
				submitB.graphics.lineTo(0, 0 - textField.height / 2);
				submitB.graphics.lineTo(textField.height, 0);
				submitB.graphics.lineTo(0, textField.height / 2);
				submitB.graphics.lineTo(0, 0);
				
				submitB.graphics.endFill();
				
				submitB.x = textField.x + textField.width + 5;
				submitB.y = 0 + textField.height / 2;
				
				submitB.addEventListener(MouseEvent.CLICK, submit);
				submitB.addEventListener(MouseEvent.MOUSE_OVER, mEvents);
				submitB.addEventListener(MouseEvent.MOUSE_OUT, mEvents);
				
				submitB.buttonMode = true;
			}
		}
		
		/**
		 * Checks the dictionary for any of the inputted words
		 * @param	event
		 */
		private function autoComplete(event:Event):void {
			textField.text = textField.text.toUpperCase();
			
			if(textField.text != ""){
				var textSplit:String = textField.text;
				
				var regex:RegExp = new RegExp(textSplit,"gi");
				var selectedWords:Array = new Array();
				
				for (var i = 0; i < dictionary.length; i++) {
					if (dictionary[i].search(regex) != -1) {
						selectedWords.push(dictionary[i]);
					}
				}
				
				clearList();
				createList(selectedWords, textSplit);
			} else {
				clearList();
			}
		}
		
		/**
		 * Clears the list of selected words...
		 */
		public function clearList():void {
			wordList.graphics.clear();
			
			for (var i = wordList.numChildren - 1; i >= 0; i--) {
				wordList.removeChildAt(i);
			}
		}
		
		/**
		 * Creates a list of the selected words...
		 * @param	selectedWords
		 */
		private function createList(selectedWords:Array, substring:String):void {
			wordList.graphics.clear();
			
			var regex:RegExp = new RegExp(substring,"gi");
			
			for (var i = 0; i < selectedWords.length; i++) {
				var tfSpriteThing:Sprite = new Sprite();
				
				var tf2:TextField = TextFormatter.getTextField();
				
				var text:String = selectedWords[i];
				var startPos:Number = text.search(regex);
				var textSplit:String = text.substr(0, startPos) + "<u>" + substring + "</u>" + text.substring(startPos + substring.length);
				
				tf2.htmlText = textSplit;
				tfSpriteThing.addChild(tf2);
				
				wordList.addChild(tfSpriteThing);
				
				if(i%2==0){
					tfSpriteThing.graphics.beginFill(0x728AB1);
				} else {
					tfSpriteThing.graphics.beginFill(0xA2B1CC);
				}
				
				tfSpriteThing.graphics.drawRect(0, 0, textField.width, tf2.height);
				tfSpriteThing.graphics.endFill();
				
				tfSpriteThing.x = textField.x;
				tfSpriteThing.y = (textField.y + textField.height) + (i * tf2.height);
				
				tfSpriteThing.name = tf2.text;
				
				tf2.mouseEnabled = false;
				tf2.selectable = false;
				
				tfSpriteThing.buttonMode = true;
				tfSpriteThing.addEventListener(MouseEvent.MOUSE_OVER, mEvents);
				tfSpriteThing.addEventListener(MouseEvent.MOUSE_OUT, mEvents);
				tfSpriteThing.addEventListener(MouseEvent.CLICK, mEvents);
			}
			
			wordList.graphics.lineStyle(0, 0x556C84);
			wordList.graphics.drawRect(textField.x, (textField.y + textField.height), wordList.width, wordList.height);
		}
		
		private function mEvents(event:MouseEvent):void {
			var colorTransform:ColorTransform;
			switch(event.type) {
				case "mouseOver":
					//
					colorTransform = new ColorTransform(1.1, 1.1, 1.1);
					Sprite(event.currentTarget).transform.colorTransform = colorTransform;
				break;
				case "mouseOut":
					//
					colorTransform = new ColorTransform(1, 1, 1);
					Sprite(event.currentTarget).transform.colorTransform = colorTransform;
				break;
				case "click":
					clickButton(event.currentTarget.name);
					submit(event);
				break;
			}
		}
		
		private function keyDown(event:KeyboardEvent):void {
			if (event.keyCode == 13) {
				submit(null);
			}
		}
		
		private function submit(event:Event):void {
			clearList();
			dispatchEvent(new Event("submit"));
		}
		
		private function clickButton(inputName:String):void {
			textField.text = inputName;
		}
		
		public function getText():String {
			return textField.text;
		}
		
	}
}