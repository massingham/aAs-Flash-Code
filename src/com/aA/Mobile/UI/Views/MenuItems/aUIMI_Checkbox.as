package com.aA.Mobile.UI.Views.MenuItems 
{
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIMI_Checkbox extends aUIMenuItem
	{
		
		public function aUIMI_Checkbox(itemType:int, itemWidth:Number, itemHeight:Number, data:Object) 
		{
			super(aUIMenuItem.TYPE_INPUT_CHECK, itemWidth, itemHeight, data)
		}
		
		override protected function init():void 
		{
			super.init();
		}
		
	}

}