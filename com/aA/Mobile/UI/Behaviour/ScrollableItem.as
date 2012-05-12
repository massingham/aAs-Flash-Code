package com.aA.Mobile.UI.Behaviour 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class ScrollableItem 
	{
		public static const TYPE_HORIZ:String = "HORIZ";
		public static const TYPE_VERT:String = "VERT";
		
		private var newPos:Point
		private var oldPos:Point;
		private var speed:Point;
		private var startPosition:Point;
		private var mouseStart:Point;
		private var item:DisplayObject;
		private var visibleArea:Point;
		private var defaultPosition:Point;
		private var mask:Sprite;
		
		private var type:String;
		
		public function ScrollableItem(item:DisplayObject, type:String, visibleArea:Point):void {
			this.item = item;
			this.type = type;
			this.visibleArea = visibleArea;
			this.defaultPosition = new Point(item.x, item.y);
			
			if (item.parent != null) {
				addMask(null);
			} else {
				item.addEventListener(Event.ADDED_TO_STAGE, addMask);
			}
			
			newPos = new Point(0, 0);
			oldPos = new Point(0, 0);
			speed = new Point(0, 0);
			startPosition = new Point(0, 0);
			mouseStart = new Point(0, 0);
			
			this.item.addEventListener(MouseEvent.MOUSE_DOWN, mouseEvent);
		}
		
		private function addMask(event:Event):void {
			item.removeEventListener(Event.ADDED_TO_STAGE, addMask);
			
			var m:Sprite = new Sprite();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 0, visibleArea.x, visibleArea.y);
			m.graphics.endFill();
			item.parent.addChild(m);
			item.mask = m;
		}
		
		private function mouseEvent(event:MouseEvent):void { 
			switch(event.type) {
				case MouseEvent.MOUSE_DOWN:
					item.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseEvent);
					item.stage.addEventListener(MouseEvent.MOUSE_UP, mouseEvent);
					
					if (item.hasEventListener(Event.ENTER_FRAME)) {
						item.removeEventListener(Event.ENTER_FRAME, velocityUpdate);
					}
					
					scroll();
				break;
			case MouseEvent.MOUSE_MOVE:
					newPos = new Point(item.stage.mouseX, item.stage.mouseY);
					speed = new Point(newPos.x - oldPos.x, newPos.y - oldPos.y);
					oldPos = newPos.clone();
					
					update(null);
				break;
				case MouseEvent.MOUSE_UP:
					applyVelocity();
					
					item.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEvent);
					item.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvent);
				break;
			}
		}
		
		private function applyVelocity():void {
			item.addEventListener(Event.ENTER_FRAME, velocityUpdate);
		}
		
		private function velocityUpdate(event:Event):void {
			if (type == TYPE_HORIZ) {
				item.x += speed.x;
			} else {
				item.y += speed.y;
			}
			
			speed.x *= 0.96;
			speed.y *= 0.96;
			
			// LIMITS
			boundsCheck();
			
			if (type == TYPE_HORIZ) {
				if (Math.abs(speed.x) < 0.1) {
					item.removeEventListener(Event.ENTER_FRAME, velocityUpdate);
				}
			} else {
				if (Math.abs(speed.y) < 0.1) {
					item.removeEventListener(Event.ENTER_FRAME, velocityUpdate);
				}
			}
			
		}
		
		private function boundsCheck():void {
			if (type == TYPE_HORIZ) {
				if (item.x + item.width < visibleArea.x) {
					item.x = visibleArea.x - item.width;
				} else if (item.x > defaultPosition.x) {
					item.x = defaultPosition.x;
				}
			} else {
				if (item.y > defaultPosition.y) {
					item.y = defaultPosition.y;
				} else if (item.y + item.height < visibleArea.y) {
					item.y = visibleArea.y - item.height;
				}
			}
		}
		
		private function update(event:Event):void {
			if (type == TYPE_HORIZ) {
				item.x = startPosition.x + (item.stage.mouseX - mouseStart.x);
			} else {
				item.y = startPosition.y + (item.stage.mouseY - mouseStart.y);
			}
			
			boundsCheck();
		}
		
		private function stopScroll():void {
			item.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		private function scroll():void {
			if (type == TYPE_HORIZ) {
				startPosition.x = item.x;
				mouseStart.x = item.stage.mouseY;
				oldPos.x = mouseStart.x;
			} else {
				startPosition.y = item.y;
				mouseStart.y = item.stage.mouseY;
				oldPos.y = mouseStart.y;
			}
		}
	}

}