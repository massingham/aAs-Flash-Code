package com.aA.Mobile.UI.Views 
{
	import com.aA.Colour.Colour;
	import com.aA.Mobile.UI.aUIComponent;
	import com.aA.Mobile.UI.Style.aUIOptionsManager;
	import com.aA.Mobile.UI.Views.MenuItems.aUIMenuItem;
	import com.aA.Style.StyleManager;
	import com.aA.Text.Text;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIMenu extends aUIComponent
	{
		private var headerHeight:Number;
		private var stageWidth:Number;
		private var stageHeight:Number;
		
		private var bgSprite:Sprite;
		private var contentSprite:Sprite;
		private var headerSprite:Sprite;
		private var backButton:Sprite;
		
		public var menuName:String;
		private var headerLabel:TextField;
		private var padding:Number;
		private var yPos:Number;
		
		private var items:Dictionary;
		
		// Menus are sorted in the following way
		// HEADING
		// ---------
		//  ITEMS [ Itemname, item description, item type ]
		
		public function aUIMenu(menuName:String) 
		{			
			this.headerHeight = aUIOptionsManager.getInstance().headerHeight;
			this.menuName = menuName;
			this.stageHeight = aUIOptionsManager.getInstance().stageHeight;
			this.stageWidth = aUIOptionsManager.getInstance().stageWidth;
			
			init();
			
			items = new Dictionary();
		}
		
		protected function init():void {
			bgSprite = new Sprite();
			addChild(bgSprite);
			
			contentSprite = new Sprite();
			addChild(contentSprite);
			
			headerSprite = new Sprite();
			addChild(headerSprite);
			
			backButton = new Sprite();
			addChild(backButton);
			
			drawBG();
			drawBackButton();
			drawHeader();
			
			contentSprite.y = headerSprite.height;
		}
		
		protected function drawBG():void {
			bgSprite.graphics.beginFill(0xFFFFFF);
			bgSprite.graphics.drawRect(0, 0, stageWidth, stageHeight);
			bgSprite.graphics.endFill();
		}
		
		protected function drawHeader():void {
			headerSprite.graphics.lineStyle();
			
			headerSprite.graphics.clear();
			headerSprite.graphics.beginFill(0x202020);
			headerSprite.graphics.drawRect(0, 0, stageWidth, headerHeight);
			headerSprite.graphics.endFill();
			
			headerSprite.graphics.beginFill(Colour.changeBrightness(0x202020, -10));
			headerSprite.graphics.drawRect(0, headerHeight * 0.95, stageWidth, headerHeight * 0.05);
			headerSprite.graphics.endFill();
			
			headerSprite.graphics.beginFill(0x000000,0.3);
			headerSprite.graphics.drawRect(0, headerHeight, stageWidth, headerHeight * 0.05);
			headerSprite.graphics.endFill();
			
			headerSprite.graphics.lineStyle(0, Colour.changeBrightness(0x202020, -30));
			headerSprite.graphics.moveTo(0, headerHeight);
			headerSprite.graphics.lineTo(0, headerHeight);
			
			headerLabel= Text.getTextField(menuName, StyleManager.getInstance().getProperty("font", "medium"), 0xE4E4E4, "LEFT", "_sans", false);
			headerSprite.addChild(headerLabel);
			headerLabel.x = backButton.width + backButton.width * 0.2;
			headerLabel.y = headerHeight / 2 - headerLabel.height / 2;
		}
		
		protected function drawBackButton():void {
			backButton.graphics.beginFill(0x2E5380);
			backButton.graphics.drawRect(0, 0, headerHeight, headerHeight);
			backButton.graphics.endFill();
			
			backButton.graphics.beginFill(0, 0.5);
			backButton.graphics.moveTo(headerHeight * .75, headerHeight * .75);
			backButton.graphics.lineTo(headerHeight * .75, headerHeight * .25);
			backButton.graphics.lineTo(headerHeight * .25, headerHeight / 2);
			backButton.graphics.lineTo(headerHeight * .75, headerHeight * .75);
			backButton.graphics.endFill();
			
			backButton.graphics.lineStyle(0, 0x151515, 0.5);
			backButton.graphics.moveTo(headerHeight, 0);
			backButton.graphics.lineTo(headerHeight, headerHeight);
			
			backButton.addEventListener(MouseEvent.MOUSE_DOWN, back);
		}
		
		private function back(event:MouseEvent):void {
			dispatchEvent(new Event("back"));
		}
		
		/**
		 * Data comes from a json parsed object
		 * @param	menuObject
		 */
		public function renderMenu(menuObject:Object):void {
			yPos = 0;
			padding = stageWidth * 0.1;
			
			var count:int = 0;
			
			for (var i:String in menuObject.menuItems) {
				addHeader(menuObject.menuItems[i].title);
				
				count = 0;
				
				for (var n:String in menuObject.menuItems[i].data) {
					addMenuItem(menuObject.menuItems[i].data[n]);
					
					if (count < menuObject.menuItems[i].data.length-1) {
						contentSprite.graphics.lineStyle(0, 0, 0.4);
						contentSprite.graphics.moveTo(padding / 2, yPos);
						contentSprite.graphics.lineTo(stageWidth - padding * 0.5, yPos);
					}
					
					count++;
				}
				yPos += padding / 2;
			}
		}
		
		protected function addHeader(sectionName:String):void {
			var sectionSprite:Sprite = new Sprite();
			
			var tf:TextField = Text.getTextField("<b>" + sectionName.toUpperCase() + "</b>", StyleManager.getInstance().getProperty("font", "small"), 0x000000, "LEFT", "_sans", false);
			sectionSprite.addChild(tf);
			
			sectionSprite.graphics.lineStyle(2, 0, 0.4);
			sectionSprite.graphics.moveTo(0 - padding / 2, tf.height);
			sectionSprite.graphics.lineTo(stageWidth-padding*1.5, tf.height);
			
			contentSprite.addChild(sectionSprite);
			
			sectionSprite.x = padding;
			
			sectionSprite.y = yPos;
			yPos += tf.height;
		}
		
		protected function addMenuItem(data:Object):void {
			var item:aUIMenuItem = aUIMenuItem.getItem(data["itemType"], stageWidth, headerHeight, data);
			contentSprite.addChild(item);
			item.y = yPos;
			yPos += item.height;
			
			items[item.id] = item;
		}
		
		public function getItem(id:String):aUIMenuItem {
			return items[id];
		}
		
	}

}