package com.aA.Mobile.UI.Views.MenuItems 
{
	import com.aA.Game.SpriteManager;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIMI_Icon extends aUIMenuItem
	{
		
		private var icon:Bitmap;
		private var _iconEnabled:Boolean;
		
		public function aUIMI_Icon(itemType:int, itemWidth:Number, itemHeight:Number, data:Object) 
		{
			super(aUIMenuItem.TYPE_ICON, itemWidth, itemHeight, data);
		}
		
		override protected function init():void 
		{
			super.init();
			
			_iconEnabled = true;
			
			var iconHeight:Number = itemHeight * 0.8;
			
			icon = SpriteManager.getInstance().getItemAsBitmap(data["icon"], iconHeight);
			addChild(icon);
			
			icon.x = itemWidth - icon.width - padding;
			icon.y = (itemHeight - iconHeight) / 2;
		}
		
		public function set iconEnabled(val:Boolean):void {
			_iconEnabled = val;
			
			if (_iconEnabled) {
				icon.alpha = 1;			
				
			} else {
				icon.alpha = 0.3;
			}
		}
		
		public function get iconEnabled():Boolean {
			return _iconEnabled;
		}
	}

}