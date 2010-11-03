package aA.Utils 
{
	
	import com.adobe.utils.ArrayUtil;
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
			var returnArray:Array = ArrayUtil.copyArray(inputArray);
			
			for (var i:int = 0; i < returnArray.length; i++) {
				for (var n:int = i + 1; n < returnArray.length; n++) {
					if (returnArray[i] == returnArray[n] && i != n) {
						returnArray.splice(n, 1);
					}
				}
			}
			
			return returnArray;
		}	
		
		public static function getRandomValue(inputArray:Array):*
		{
			return inputArray[Math.round((Math.random() * (inputArray.length - 1)))];
		}
		
	}

}