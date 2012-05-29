package com.aA.UI.SimpleCheckList 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class SimpleCheckList extends Sprite
	{
		public var boxSize:Number = 15;
		public var fontSize:Number = 12;
		public var boxColour:uint = 0x9E9E9E;
		public var boxWidth:Number = 100;
		public var padding:Number = 10;
		public var numPerRow:int = 2;
		
		private var boxes:Array;		
		
		public function SimpleCheckList() 
		{
			boxes = new Array();
		}
		
		public function setValues(array:Array):void {
			for (var i:int = 0; i < array.length; i++) {
				createCheckbox(array[i]);
			}
			align();
		}
		
		public function createCheckbox(value:String):void {
			var b:SimpleCheckItem = new SimpleCheckItem(boxSize, boxWidth, boxColour, value, fontSize);
			addChild(b);
			
			b.addEventListener("check", checkButton);
			
			boxes.push(b);
		}
		
		private function checkButton(event:Event):void {
			dispatchEvent(event);
		}
		
		public function check(buttonid:int):void {
			boxes[buttonid].dispatchEvent(new Event("check"));
		}
		
		private function align():void {
			var xPos:int = padding;
			var yPos:int = 0;
			var currentRow:int = 0;
			for (var i:int = 0; i < boxes.length; i++) {
				if (currentRow >= numPerRow) {
					yPos += boxSize + padding;
					xPos = padding;
					currentRow = 0;
				}
				
				boxes[i].x = xPos;
				boxes[i].y = yPos;
				
				xPos += padding + boxWidth;
				currentRow++;
			}
		}
		
	}

}