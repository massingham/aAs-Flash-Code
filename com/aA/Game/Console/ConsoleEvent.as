package com.aA.Game.Console
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class ConsoleEvent extends Event
	{
		public static const DISPATCH_COMMAND:String = "DISPATCH_COMMAND";
		public var parameters:Array;
		public var commandName:String;
		
		public function ConsoleEvent(type:String, parameters:Array, commandName:String) 
		{
			this.commandName = commandName;
			this.parameters = parameters;
			super(type);
		}
		
	}

}