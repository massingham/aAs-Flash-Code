package com.aA.Time 
{
	/**
	 * Static time classes
	 * @author Anthony Massingham
	 */
	public class Time 
	{
		private static var months:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		private static var weekdays:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		
		/**
		 * Returns time since a particular point.
		 * 
		 * @param	time in millis
		 * @return if < 14 days ago will return 'x Days, x Hours, x Minutes ago", otherwise will return the date in DD/MM/YYYY format
		 */
		public static function timeSince(time:Number, excess:Number = 1):String {
			var currentTime:Date = new Date();
			var importDate:Date = new Date();
			importDate.time = time * excess;
			
			var difference:Number = currentTime.time-importDate.time;
			
			if (difference > Time.days(14)) {
				return importDate.getDate() + "/" + importDate.getMonth() + 1 + "/" + importDate.getFullYear();
			} else {
				return Time.xDaysxHoursxMinutes(difference / 1000, "ago");
			}
		}
		
		/**
		 * 
		 * @param	time in millis
		 * @return	If < 60 seconds ago, returns "just now", else if < 1 day ago returns "x Hours, x Minutes ago", else returns simple date
		 */
		public static function getFuzzyTimeSince(time:Number):String {
			var currentTime:Date = new Date();
			var importDate:Date = new Date();
			importDate.time = time;
			
			var difference:Number = currentTime.time-importDate.time;
			
			if (difference < 60000) {
				return "Just Now";
			} else if (difference < Time.days(1)) {
				return Time.xDaysxHoursxMinutes(difference / 1000, "ago", true, true, true);
			} else if (difference > Time.days(1) && difference < (Time.days(7))) {
				return Time.xDaysxHoursxMinutes(difference / 1000, "ago", true, true, false);
			} else {
				return Time.getSimpleDate(time);
			}
			
		}
		
		public static function xDaysxHoursxMinutes(numSeconds:Number, append:String = "", showDays:Boolean = true, showHours:Boolean = true, showMinutes:Boolean = true):String {
			var returnTime:String = "";
			
			var seconds:String;
			var hours:String;
			var minutes:String;
			var days:String;
			
			var s:Number = numSeconds;
			var m:Number = 0;
			var h:Number = 0;
			var d:Number = 0;
			
			while (s > 59) {
				m++;
				s -= 60;
			}
			
			while (m > 59) {
				h++;
				m -= 60;
			}
			
			while (h > 23) {
				d++;
				h -= 24;
			}
			
			seconds = Time.doubleZero(Math.round(s).toString());
			minutes = Time.doubleZero(Math.round(m).toString());
			hours = Math.round(h).toString();
			days = Math.round(d).toString();
			
			if(showDays) {
				if (d != 0) {
					if (d == 1) {
						returnTime += days + " day, ";
					} else {
						returnTime += days + " days, ";
					}
				}
			}
			
			if(showHours) {
				if (h != 0) {
					if (h == 1) {
						returnTime += hours + " hour, "
					}else {
						returnTime += hours + " hours, "
					}
				}
			}
			
			if(showMinutes){
				if(minutes != "00"){
					if (minutes == "01") {
						returnTime += minutes + " min"
					} else {
						returnTime += minutes + " mins"
					}
				}
			}
			
			if (returnTime.charAt(returnTime.length - 1) == ",") {
				returnTime = returnTime.substr(0, returnTime.length - 1);
			}
			
			if (returnTime.charAt(returnTime.length - 2) == ",") {
				returnTime = returnTime.substr(0, returnTime.length - 2);
			}
			
			if(append != ""){
				return returnTime + " " + append;
			} else {
				return returnTime;
			}
		}
		
		/**
		 * turns '1' into '01'
		 * @param	val
		 * @return
		 */
		public static function doubleZero(val:String):String {
			if (val.length < 2) {
				val = "0" + val;
			}
			return val;
		}
		
		/**
		 * Returns time of day for a specific date in millis.  12 hour am/pm format
		 * @param	input
		 * @return
		 */
		public static function getTimeOfDay(input:Number):String {
			var d:Date = new Date();
			d.time = input;
			
			var returnString:String = "";
			
			var isAM:Boolean = false;
			var hours:Number = d.hours;
			
			if (hours < 12) {
				isAM = true;
			} else {
				hours -= 12;
				if (hours == 0) {
					hours = 12;
				}
			}
			
			returnString = hours + ":" + Time.doubleZero(d.getMinutes().toString()) + " ";
			if (isAM) {
				returnString += "am";
			} else {
				returnString += "pm";
			}
			
			return returnString;
		}
		
		/**
		 * Returns a simple date.  The year is ignored if this.year == input.year
		 * @param	input
		 * @return
		 */
		public static function getSimpleDate(input:Number):String {
			var d:Date = new Date();
			d.time = input;
			
			var returnString:String = d.getDate() + Time.getSuffix(d.getDate()) + " " + months[d.getMonth()];
			var currentYear:Date = new Date();
			
			if (currentYear.getFullYear() != d.getFullYear()) {
				returnString += ", " + d.getFullYear();
			}
			
			return returnString;
		}
		
		/**
		 * returns suffix for numbers. ie: 1='st', 2='nd'
		 * @param	val
		 * @return
		 */
		public static function getSuffix(val:Number):String {
			var lastChar:String = val.toString().charAt(val.toString().length-1);
			
			if (val == 11 || val == 13) {
				return "th";
			}
			
			switch(lastChar) {
				case "1":
					return "st";
				break;
				case "3":
					return "rd";
				break;
				default:
					return "th";
				break;
			}
		}
		
		/**
		 * Converts days into millis
		 * @param	num
		 * @return
		 */
		public static function days(num:Number):Number {
			return num * 24 * 60 * 60 * 1000;
		}
		
	}

}