package com.aA.Mobile.UI.Behaviour 
{
	import com.aA.Style.StyleManager;
	import com.gskinner.motion.GTween;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class ScrollableItem extends EventDispatcher
	{
		public static const TYPE_HORIZ:String = "HORIZ";
		public static const TYPE_VERT:String = "VERT";
		
		public static const EVENT_CLEAR:String = "clear";
		public static const EVENT_RELEASE:String = "up";
		public static const EVENT_RESET:String = "reset";
		
		private var newPos:Point
		private var oldPos:Point;
		private var speed:Point;
		private var startPosition:Point;
		private var mouseStart:Point;
		public var item:DisplayObject;
		private var visibleArea:Point;
		private var defaultPosition:Point;
		private var mask:Sprite;
		
		private var type:String;
		
		private var scrollbarTween:GTween;
		
		// all for show milladio
		private var scrollbarSprite:Bitmap;
		
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
			
			this.item.addEventListener("reset", resetScroll);
			this.item.addEventListener(MouseEvent.MOUSE_DOWN, mouseEvent);
		}
		
		public function reset():void {
			resetScroll(null);
		}
		
		private function resetScroll(event:Event):void {
			immediateStopMovement();
			
			this.item.x = defaultPosition.x;
			this.item.y = defaultPosition.y;
			
			newPos = new Point(0, 0);
			oldPos = new Point(0, 0);
			speed = new Point(0, 0);
			startPosition = new Point(0, 0);
			mouseStart = new Point(0, 0);
			
			drawScrollbar();
			
			trace("reset");
		}
		
		private function addMask(event:Event):void {
			item.removeEventListener(Event.ADDED_TO_STAGE, addMask);
			
			var m:Sprite = new Sprite();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 0, visibleArea.x, visibleArea.y);
			m.graphics.endFill();
			item.parent.addChild(m);
			item.mask = m;
			m.x = defaultPosition.x;
			m.y = defaultPosition.y;
			
			scrollbarSprite = new Bitmap(new BitmapData(10, 10, false, 0x000000));
			scrollbarSprite.y = defaultPosition.y;
			scrollbarSprite.x = defaultPosition.x + visibleArea.x - 15;
			item.parent.addChild(scrollbarSprite);
			scrollbarSprite.alpha = 0;
			drawScrollbar();
		}
		
		private function drawScrollbar():void {
			// scrollbar as onscreen compared to offscreen values
			if (item.height < visibleArea.y) {
				scrollbarSprite.visible = false;
				return;
			} else if (scrollbarSprite.visible == false) {
				scrollbarSprite.visible = true;
			}
			
			scrollbarSprite.height = visibleArea.y * (visibleArea.y / item.height);	
			
			var p100:Number = (item.y-defaultPosition.y) / (item.height - visibleArea.y);
			var pos:Number = (visibleArea.y - scrollbarSprite.height) * p100;
			
			scrollbarSprite.y = defaultPosition.y - pos;
		}
		
		private function mouseEvent(event:MouseEvent):void { 
			drawScrollbar();
			
			switch(event.type) {
				case MouseEvent.MOUSE_DOWN:
					scrollbarTween = new GTween(scrollbarSprite, 0.2, { alpha:1 } );
					
					item.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseEvent);
					item.stage.addEventListener(MouseEvent.MOUSE_UP, mouseEvent);
					
					if (type == TYPE_HORIZ) {
						if (item.width < visibleArea.x) return;
					} else {
						if (item.height < visibleArea.y) return;
					}
					
					if (item.hasEventListener(Event.ENTER_FRAME)) {
						item.removeEventListener(Event.ENTER_FRAME, velocityUpdate);
					}
					
					speed = new Point(0, 0);
					
					scroll();
				break;
			case MouseEvent.MOUSE_MOVE:
					this.dispatchEvent(new Event(EVENT_CLEAR));
					
					if (type == TYPE_HORIZ) {
						if (item.width < visibleArea.x) return;
					} else {
						if (item.height < visibleArea.y) return;
					}
					
					newPos = new Point(item.stage.mouseX, item.stage.mouseY);
					speed = new Point(newPos.x - oldPos.x, newPos.y - oldPos.y);
					oldPos = newPos.clone();
					
					update(null);
				break;
			case MouseEvent.MOUSE_UP:
					this.dispatchEvent(new Event(EVENT_RELEASE));
					
					if (type == TYPE_HORIZ) {
						if (item.width < visibleArea.x) return;
					} else {
						if (item.height < visibleArea.y) return;
					}
					
					applyVelocity();
					
					item.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEvent);
					item.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvent);
				break;
			}
		}
		
		private function immediateStopMovement():void {
			item.removeEventListener(Event.ENTER_FRAME, update);
			item.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEvent);
			item.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvent);
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
			
			drawScrollbar();
			
			if (type == TYPE_HORIZ) {
				if (Math.abs(speed.x) < 0.15) {
					scrollbarTween = new GTween(scrollbarSprite, 0.5, { alpha:0 } );
					item.removeEventListener(Event.ENTER_FRAME, velocityUpdate);
				}
			} else {
				if (Math.abs(speed.y) < 0.15) {
					scrollbarTween = new GTween(scrollbarSprite, 0.5, { alpha:0 } );
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
				} else if (item.y + item.height < visibleArea.y + defaultPosition.y) {
					dispatchEvent(new Event("bottom"));
					item.y = defaultPosition.y + (visibleArea.y - item.height);
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
				mouseStart.x = item.stage.mouseX;
				oldPos.x = mouseStart.x;
			} else {
				startPosition.y = item.y;
				mouseStart.y = item.stage.mouseY;
				oldPos.y = mouseStart.y;
			}
		}
	}

}