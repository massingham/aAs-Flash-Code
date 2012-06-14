package com.aA.Mobile.UI 
{
	import com.aA.Game.SpriteManager;
	import com.aA.Mobile.UI.Behaviour.ScrollableItem;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import com.aA.Text.Text;
	/**
	 * Simple Combo Box
	 * 
	 * Just accepts simple text/sprite combos for now
	 * 
	 * @author Anthony Massingham
	 */
	public class aUIComboBox extends aUISimpleSpriteButton
	{		
		private var items:Vector.<aUIComboItem>;
		private var direction:String;	// UP / DOWN
		private var side:String;		// LEFT / RIGHT
		private var itemSprite:Sprite;
		
		private var _open:Boolean = false;
		private var _fullHeight:Number;
		
		private var minItemWidth:Number;
		private var title:String;
		private var titleTF:TextField;
		
		private var highlightBox:Sprite;
		private var selected:Boolean;
		
		private var maxHeight:Number = -1;
		
		public var showSelected:Boolean = false;
		
		public function aUIComboBox(theWidth:Number, theHeight:Number, direction:String = "UP", title:String = "") 
		{			
			items = new Vector.<aUIComboItem>();
			this.direction = direction.toUpperCase();
			
			selected = false;
			
			super(theWidth, theHeight);
			
			itemSprite = new Sprite();
			addChild(itemSprite);
			itemSprite.visible = false;
			
			_fullHeight = theHeight;			
			minItemWidth = theWidth;
			
			this.title = title;
			if (title != "") {
				//style.getColour("highlightColour")
				titleTF = Text.getTextField(title, _fullHeight * 0.3, 0x003E89, "LEFT", "_sans", false);
				itemSprite.addChild(titleTF);
			}
			
			highlightBox = new Sprite();
			highlightBox.alpha = 0.5;
			redrawHighlightBox(theWidth);
			
			highlightBox.mouseEnabled = false;
			
			addChild(highlightBox);
			highlightBox.visible = false;
			
			this.addEventListener("click", openclose);
		}
		
		public function setMaxHeight(mH:Number):void {
			if (maxHeight != -1) {
				maxHeight = mH;
				itemSprite.dispatchEvent(new Event("change"));
			} else {
				if (itemSprite.height > mH) {
					this.maxHeight = mH;
					var s:ScrollableItem = new ScrollableItem(itemSprite, ScrollableItem.TYPE_VERT, new Point(theWidth, maxHeight));
				}
			}
		}
		
		public function clear():void {
			for (var i:int = items.length - 1; i >= 0; i--) {
				removeItem(items[i].name);
			}
		}
		
		protected function redrawHighlightBox(size:Number):void {
			highlightBox.graphics.clear();
			highlightBox.graphics.beginFill(0x003E89);
			highlightBox.graphics.drawRect(0, 0, size, theHeight);
			highlightBox.graphics.endFill();
		}
		
		override public function get x():Number 
		{
			return super.x;
		}
		
		override public function set x(value:Number):void 
		{
			super.x = value;
			
			if (this.x + minItemWidth > this.stage.stageWidth) {
				side = "RIGHT";
				itemSprite.x -= (minItemWidth-theWidth);
			} else {
				side = "LEFT";
			}
		}
		
		override public function get height():Number 
		{
			return this.theHeight;
		}
		
		private function openclose(event:Event):void {
			_open = !_open;
			
			if (_open) {
				itemSprite.visible = true;
				if (selected && showSelected) {
					// shadowsize is 3.
					redrawHighlightBox(itemSprite.width - 6);
					highlightBox.visible = true;
				}
				this.parent.setChildIndex(this, this.parent.numChildren - 1);
				dispatchEvent(new Event("open"));
			} else {
				itemSprite.visible = false;
				highlightBox.visible = false;
			}
		}
		
		public function hasItem(id:String):Boolean {
			for (var i:int = 0; i < items.length; i++) {
				if (items[i].name == id) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 
		 * @param	text
		 * @param	sprite
		 */
		public function addItem(text:String, sprite:DisplayObject = null, id:String = ""):void {
			var citem:aUIComboItem = new aUIComboItem(theWidth, theHeight, text);
			if (sprite) {
				citem.addSprite(sprite);
			}
			items.push(citem);
			itemSprite.addChild(citem);
			
			if (id == "") {
				citem.name = text;
			} else {
				citem.name = id;
			}
			citem.addEventListener("click", selectItem);
			
			if (citem.width > minItemWidth) {
				minItemWidth = citem.width * 1.1;
			}
			
			redraw();
		}
		
		public function removeItem(id:String):void {
			for (var i:int = items.length - 1; i >= 0; i--) {
				if (items[i].name == id) {
					itemSprite.removeChild(items[i]);
					items[i].removeEventListener("click", selectItem);
					items.splice(i, 1);
					redraw();
					return;
				}
			}
		}
		
		public function disableAll():void {
			for (var i:int = 0; i < items.length; i++) {
				items[i].disable();
				items[i].removeEventListener("click", selectItem);
			}
		}
		
		public function enableAll():void {
			for (var i:int = 0; i < items.length; i++) {
				items[i].enable();
				items[i].addEventListener("click", selectItem);
			}
		}
		
		public function enableSpecificItem(item:int):void {
			items[item].enable();
			items[item].addEventListener("click", selectItem);
		}
		
		public function select(itemID:int):void {
			items[itemID].dispatchEvent(new Event("click"));
			openclose(null);
		}
		
		public function enableItem(itemName:String):void {
			for (var i:int = items.length - 1; i >= 0; i--) {
				if (items[i].name == itemName) {
					items[i].enable();
					items[i].addEventListener("click", selectItem);
				}
			}
		}
		
		public function disableItem(itemName:String):void {
			for (var i:int = items.length - 1; i >= 0; i--) {
				if (items[i].name == itemName) {
					items[i].disable();
					items[i].removeEventListener("click", selectItem);
				}
			}
		}
		
		private function selectItem(event:Event):void {
			event.stopImmediatePropagation();
			openclose(null);
			
			highlightBox.y = event.currentTarget.y;
			selected = true;
			
			// change parent
			
			dispatchEvent(new aUIComboBoxEvent(aUIComboBoxEvent.ITEM_SELECTED, event.currentTarget.name));
		}
		
		private function redraw():void {
			var spacing:Number = theHeight;
			var offset:Number = 0;
			
			if (direction == "UP") {
				spacing = 0 - spacing;
			}
			
			itemSprite.graphics.clear();
			
			for (var i:int = 0; i < items.length; i++) {
				items[i].width = minItemWidth;
				items[i].y = spacing * (i + 1);
				
				if (direction == "UP") {
					items[i].y -= offset;
				} else {
					items[i].y += offset;
				}
			}
			
			var headerSize:int = 0;
			if (title != "") {
				headerSize = _fullHeight;
				
				titleTF.x = _fullHeight * 0.2;
				titleTF.y = items[items.length - 1].y - headerSize + headerSize / 2 - titleTF.height / 2;
			}
			
			
			var shadowsize:int = 3;
			if(shadowsize > 0){
				itemSprite.graphics.beginFill(0x000000, 0.2);
				if (direction == "UP") {
					itemSprite.graphics.drawRoundRect(0 - shadowsize, items[items.length - 1].y - headerSize - shadowsize, minItemWidth + (shadowsize * 2), _fullHeight * items.length + (shadowsize) + headerSize, style.cornerRadius, style.cornerRadius);
				} else {
					itemSprite.graphics.drawRoundRect(0 - shadowsize, items[0].y - headerSize - shadowsize, minItemWidth + (shadowsize * 2), _fullHeight * items.length + headerSize + (shadowsize), style.cornerRadius, style.cornerRadius);
				}			
				itemSprite.graphics.endFill();
			}
			
			itemSprite.graphics.beginFill(0x000000);
			if (direction == "UP") {
				itemSprite.graphics.drawRoundRect(0, items[items.length-1].y - headerSize, minItemWidth, _fullHeight*items.length + headerSize, style.cornerRadius, style.cornerRadius);
			} else {
				itemSprite.graphics.drawRoundRect(0, items[0].y - headerSize, minItemWidth, _fullHeight * items.length + headerSize, style.cornerRadius, style.cornerRadius);
			}			
			itemSprite.graphics.endFill();
			
			itemSprite.graphics.lineStyle(0, 0x202020);
			for (i = 0; i < items.length - 1; i++) {
				itemSprite.graphics.moveTo(0, items[i].y);
				itemSprite.graphics.lineTo(minItemWidth, items[i].y);
			}
			
			itemSprite.graphics.lineStyle(0, 0x202020);
			itemSprite.graphics.moveTo(0, items[0].y + theHeight);
			itemSprite.graphics.lineTo(minItemWidth, items[0].y + theHeight);
			
			if (title != "") {
				itemSprite.graphics.lineStyle(2, 0x003E89, 1, false, "normal", "none");
				itemSprite.graphics.moveTo(0, items[items.length - 1].y);
				itemSprite.graphics.lineTo(minItemWidth, items[items.length - 1].y);
				itemSprite.graphics.lineStyle();
			}
			
			// arrow? 
			/**itemSprite.graphics.lineStyle(0, 0xFFFFFF);
			itemSprite.graphics.beginFill(0x000000);
			if (direction == "UP") {
				itemSprite.graphics.moveTo(theWidth / 2 - offset, 0 - offset);
				itemSprite.graphics.lineTo(theWidth / 2, 0);
				itemSprite.graphics.lineTo(theWidth / 2 + offset, 0 - offset);
				
				itemSprite.graphics.lineStyle();
				itemSprite.graphics.lineTo(theWidth / 2 + offset, 0 - offset * 1.5);
				itemSprite.graphics.lineTo(theWidth / 2 - offset, 0 - offset * 1.5);
			} else {
				itemSprite.graphics.moveTo(theWidth / 2 - offset, _fullHeight + offset);
				itemSprite.graphics.lineTo(theWidth / 2, _fullHeight);
				itemSprite.graphics.lineTo(theWidth / 2 + offset, _fullHeight + offset);
				
				itemSprite.graphics.lineStyle();
				itemSprite.graphics.lineTo(theWidth / 2 + offset, _fullHeight + offset * 1.5);
				itemSprite.graphics.lineTo(theWidth / 2 - offset, _fullHeight + offset * 1.5);
			}
			itemSprite.graphics.lineStyle();
			itemSprite.graphics.endFill();
			*/
		}
	}

}