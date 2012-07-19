package com.aA.Maths 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Maths 
	{
		public static function roundTo(num:Number, dec:Number):Number {
			return stringRounding(num, dec);
		}
		
		/**
		 * Uses strings to round a number.  Ensures there are no silly floating point errors
		 * @param	num
		 * @param	dec
		 * @return
		 */
		public static function stringRounding(number:Number, numDecimals:Number):Number {
			var stringNumber:String = number.toString()
			var numberArray:Array = stringNumber.split(".");
			
			if (numberArray.length == 1) {
				return number;
			} else {
				if (numberArray[1].length > numDecimals) {
					
					if (Number(numberArray[1].charAt(numDecimals)) < 5) {
						numberArray[1] = String(numberArray[1]).substr(0, numDecimals);
						
						var returnNumber:String = numberArray[0] + "." + numberArray[1];
					} else {
						numberArray[1] = String(numberArray[1]).substr(0, numDecimals);						
						var origNumber:String = numberArray[1];
						
						var tempNumber:String = (Number(numberArray[1]) + 1).toString();
						
						if (tempNumber.length > numberArray[1].length) {
							tempNumber = tempNumber.substr(1);
							numberArray[0] = (Number(numberArray[0]) + 1).toString();
						}
						
						numberArray[1] = tempNumber;
						
						while (numberArray[1].length != origNumber.length) {
							numberArray[1] = "0" + numberArray[1];
						}
						
						returnNumber = numberArray[0] + "." + numberArray[1];
					}
				} else {
					return number;
				}
			}
			
			// trace("rounding " + number + " to " + returnNumber);
			
			return Number(returnNumber);
		}
		
		/**
		 * returns a random number between two values
		 * @param	minNumber
		 * @param	maxNumber
		 * @return
		 */
		public static function getRandomNumber(minNumber:Number, maxNumber:Number, decimalPlaces:int = 0):Number {
			var num:Number = Math.random() * (maxNumber - minNumber);
			num += minNumber;
			return Maths.roundTo(num, decimalPlaces);
		}
		
		/**
		 * Returns the distance between two points
		 * @param	point1
		 * @param	point2
		 * @return
		 */
		public static function distance(point1:Point, point2:Point):Number {
			var distance:Number = Math.sqrt(Math.pow(point2.x - point1.x, 2) + Math.pow(point2.y - point1.y, 2));
			return distance
		}
		
		public static const EPSILON:Number = 5;
		
		public static function IsPointOnLine(linePointA:Point, linePointB:Point, point:Point):Boolean {
			// y = a*x + b
			var a:Number = (linePointB.y - linePointA.y) / (linePointB.x - linePointA.x);
			var b:Number = linePointA.y - a * linePointA.x;
			
			if (Math.abs(point.y - (a * point.x + b)) < EPSILON) {
				return true;
			}
			
			return false;
		}
		
		public static function formatNumber(theNumber:Number):String {
			var formattedNumber:String = "";							// The Return String
			var inputNumber:String = theNumber.toString();				// The Input Number converted to a String
			var sign:String = "";
			if (inputNumber.charAt(0) == "-") {
				inputNumber = inputNumber.slice(1);
				sign = "-";
			}
			var resultArray:Array = inputNumber.split(".");				// Create two separate arrays, separated by a decimal place
			
			// Insert Spaces every 3 places
			if (resultArray[0].length > 3) 
			{		
				if (resultArray.length > 1)
				{
					formattedNumber = "." + resultArray[1];
				}
				var loopvar:Number = 1;
				for (var i:int = resultArray[0].length - 1; i >= 0; i--)
				{
					if (loopvar == 4)
					{
						formattedNumber = ","+formattedNumber;
						loopvar=1;
					}
					
					formattedNumber = resultArray[0].charAt(i) + formattedNumber;
					loopvar ++;
				}
			} else 
			{			
				return sign + inputNumber.toString();
			}
			// trace("returning :" + formattedNumber);
			
			return sign + formattedNumber;
		}
		
		public static function shortFormat(value:Number):String {
			if (value < 99000) {
				return Maths.formatNumber(value);
			} else {
				value /= 1000;
				Math.floor(value);
				return value + "k";
			}
		}
		
	}
	
}