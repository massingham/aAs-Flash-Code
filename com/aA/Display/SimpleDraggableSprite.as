package com.aA.Display 
{
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class SimpleDraggableSprite extends Sprite
	{
		
		public function SimpleDraggableSprite() 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, doDrag);
		}
		
		private function doDrag(event:MouseEvent):void {
			switch(event.type) {
				case "mouseDown":
					this.parent.stage.addEventListener(MouseEvent.MOUSE_UP, doDrag);
					this.parent.setChildIndex(this, this.parent.numChildren - 1);
					this.startDrag();
				break;
				case "mouseUp":
					this.parent.stage.removeEventListener(MouseEvent.MOUSE_UP, doDrag);
					this.stopDrag();
				break;
			}
		}
		
	}

}