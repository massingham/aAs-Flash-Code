package com.aA.Time 
{
	/**
	 * Static time classes
	 * @author Anthony Massingham
	 */
	public class Time 
	{
		/**
		 * 
		 * @param	time
		 * @return
		 */
		public static function timeSince(time:Number, excess:Number = 1):String {
			var currentTime:Date = new Date();
			var importDate:Date = new Date();
			importDate.time = time*excess;
			
			var difference:Date = new Date();
			difference.time = currentTime.time-importDate.time;
			
			if (difference.time > Time.days(14)) {
				return importDate.getDate() + "/" + importDate.getMonth() + 1 + "/" + importDate.getFullYear();
			} else {
				return Time.xDaysxHoursxMinutes(difference.time / 1000, "ago");
			}
		}
		
		public static function xDaysxHoursxMinutes(numSeconds:Number, append:String = ""):String {
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
			
			if (d != 0) {
				if (d == 1) {
					returnTime = days + " day, ";
				} else {
					returnTime = days + " days, ";
				}
			}
			
			if (h != 0) {
				if (h == 1) {
					returnTime += hours + " hour, "
				}else {
					returnTime += hours + " hours, "
				}
			}
			
			if(minutes != "00"){
				if (minutes == "01") {
					returnTime += minutes + " minute"
				} else {
					returnTime += minutes + " minutes"
				}
			}
			
			if(append != ""){
				return returnTime + " " + append;
			} else {
				return returnTime;
			}
		}
		
		public static function doubleZero(val:String):String {
			if (val.length < 2) {
				val = "0" + val;
			}
			return val;
		}
		
		public static function days(num:int):Number {
			return num * 24 * 60 * 60 * 1000;
		}
		
	}

}