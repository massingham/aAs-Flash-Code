package com.aA.Mobile.UI 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class aUIComboBoxEvent extends Event
	{
		public static const ITEM_SELECTED:String = "ITEM_SELECTED";
		public var item:String;
		
		public function aUIComboBoxEvent(type:String, item:String) 
		{
			this.item = item;
			super(type);
		}
		
	}

}