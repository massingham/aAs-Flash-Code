package com.aA.Style 
{
	/**
	 * Simple object to hold style information
	 * @author Anthony Massingham
	 */
	public dynamic class Style extends Object
	{
		public var name:String;
		
		public function Style(n:String) 
		{
			super();
			this.name = name
		}
		
		public function getProperty(prop:String):* {
			if (this.hasOwnProperty(prop)) {
				return this[prop];
			} else {
				throw new Error("Sorry, Don't have property " + prop);
			}
		}
		
		public function setProperty(prop:String, value:*):void {
			trace("\t" + prop + "->" + value);
			this[prop] = value;
		}
	}

}