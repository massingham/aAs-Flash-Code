package com.aA.Utils 
{
	
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class ArrayTools
	{
		
		/**
		 * REMOVEDUPLICATES
		 * Removes sets of two
		 * ie: 2,2,2,2,5,5 becomes 2,2,5.
		 * 
		 * @param	inputArray	The Input Array
		 * @return	Returns the new array without any duplicated entries.
		 */
		public static function removeDuplicates(inputArray:Array):Array
		{
			var returnArray:Array = copyArray(inputArray);
			
			for (var i:int = 0; i < returnArray.length; i++) {
				for (var n:int = i + 1; n < returnArray.length; n++) {
					if (returnArray[i] == returnArray[n] && i != n) {
						returnArray.splice(n, 1);
					}
				}
			}
			
			return returnArray;
		}	
		
		/**
		 * Creates a copy of an array
		 * 
		 * @param	input
		 * @return
		 */
		public static function copyArray(input:Array):Array {
			var newArray:Array = new Array();
			for (var i:int = 0; i < input.length; i++) {
				newArray.push(input[i]);
			}
			
			return newArray;
		}
		
		/**
		 * Returns a random value from an array
		 * 
		 * @param	inputArray
		 * @param	remove
		 * @return
		 */
		public static function getRandomValue(inputArray:Array, remove:Boolean = false):*
		{
			if (remove) {
				var pos:int = Math.round((Math.random() * (inputArray.length - 1)));
				var val:* = inputArray[pos];
				inputArray.splice(pos, 1);
				return val;
			} else {
				return inputArray[Math.round((Math.random() * (inputArray.length - 1)))];
			}
		}
		
		/**
		 * SEARCHARRAY
		 * Searches through an array for a particular value, returns the position in the Array where it is located
		 * 
		 * @param	theValue	The Value to Search For ( String, Int, Char, Number etc )
		 * @param	theArray	The Array to Search
		 * @return	Array		Array of Positions.  Null if nothing was found
		 */
		public static function searchArray(theValue:*, theArray:Array, caseSensitive:Boolean = true):Array
		{
			if (!caseSensitive) {
				theValue = String(theValue).toLowerCase();
			}
			var returnArray:Array = new Array();
			for (var i:int = 0; i < theArray.length; i++)
			{				
				if (!caseSensitive) {
					theArray[i] = String(theArray[i]).toLowerCase();
				}
				
				//trace("Looking for '" + theValue + "' in '" + theArray[i] + "'");
				
				if (theValue == theArray[i])
				{
					//trace("Compared :" + theValue +" to " + theArray[i] + " and found it");
					returnArray.push(i);
				} else if (String(theArray[i]).search(/\*/g) != -1) {
					//trace("wildcard...");
					theArray[i] = String(theArray[i]).substr(0, theArray[i].length - 1);
					
					var checkChars:Boolean = true;
					//trace("Comparing :" + theValue +" to " + theArray[i]);
					for (var n:int = 0; n < theArray[i].length; n++) {
						//trace("Checking : " + theArray[i].charAt(n) + " against " + theValue.charAt(n));
						if (theArray[i].charAt(n) != theValue.charAt(n)) {
							checkChars = false;
						}
					}
					
					if (checkChars) {
						//trace("Correct");
						returnArray.push(i);
					}
				}
			}
			
			if (returnArray.length == 0) {
				returnArray = null;
			}
			
			return returnArray;
		}
		
	}

}