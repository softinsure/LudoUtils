/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: XDateUtil.as 
 * Project Name: LudoUtils 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.common.utils
{
	import com.adobe.utils.DateUtil;

	/**
	 * static utility functions related to date 
	 * @author SoftInsure
	 * 
	 */
	public class XDateUtil
	{
		/**
		 * returns current date 
		 * @return 
		 * 
		 */
		public static function currentDate():Number
		{
			return (new Date()).date;
		}
		/**
		 * returns current month 
		 * @return 
		 * 
		 */
		public static function currentMonth():Number
		{
			return (new Date()).month;
		}
		/**
		 * returns current year 
		 * @return 
		 * 
		 */
		public static function currentYear():Number
		{
			return (new Date()).fullYear;
		}
		/**
		 * checks if string is a date 
		 * @param date
		 * @return 
		 * 
		 */
		public static function isDate(date:String):Boolean
		{
			return (Date.parse(date))? true:false;
		}
		/**
		 * returns Date object from date string 
		 * @param date
		 * @return 
		 * 
		 */
		public static function getDate(date:String):Date
		{
			return Date.parse(date)?new Date(Date.parse(date)):null
		}
		/**
		 * returns current date string as MM/DD/YYYY
		 * @return 
		 * 
		 */
		public static function getCurrentDate():String
		{
			return formatDate(new Date().toString());
		}
		/**
		 * format date object to date string. default format is 'MM/DD/YYY' 
		 * @param date
		 * @param formatString
		 * @return 
		 * 
		 */
		public static function formatDateToString(date:Date, formatString:String="MM/DD/YYYY"):String 
		{
			return formatDate(date.toString(),formatString);
		}
		/**
		 * format date string. default format is 'MM/DD/YYY'
		 * @param date
		 * @param formatString
		 * @return 
		 * 
		 */
		public static function formatDate(date:String, formatString:String="MM/DD/YYYY"):String 
		{
			return XFormatter.formatDateString(date,formatString);
		}
		/**
		 * returns difference between two dates 
		 * @param datepart
		 * @param date1
		 * @param date2
		 * @return 
		 * 
		 */
		public static function dateDiff(datepart:String = "d", date1:Date = null, date2:Date = null):Number 
		{
			datepart=datePart(datepart);
			return getDatePartHashMap()[datepart](date1,date2);
		}
		private static function getDatePartHashMap():Object{
			var dpHashMap:Object = new Object();
			dpHashMap["seconds"] = getSeconds;
			dpHashMap["minutes"] = getMinutes;
			dpHashMap["hours"] = getHours;
			dpHashMap["date"] = getDays;
			dpHashMap["month"] = getMonths;
			dpHashMap["fullYear"] = getYears;
			dpHashMap["miliseconds"] = compareDates;
			return dpHashMap;
		}
		private static function compareDates(date1:Date,date2:Date):Number{
			return date1.getTime() - date2.getTime();
		}
		private static function getSeconds(date1:Date,date2:Date):Number{
			return Math.floor(compareDates(date1,date2)/1000);
		}
		private static function getMinutes(date1:Date,date2:Date):Number{
			return Math.floor(getSeconds(date1,date2)/60);
		}
		private static function getHours(date1:Date,date2:Date):Number{
			return Math.floor(getMinutes(date1,date2)/60);
		}
		private static function getDays(date1:Date,date2:Date):Number{
			return Math.floor(getHours(date1,date2)/24);
		}
		private static function getMonths(date1:Date,date2:Date):Number{
			var yearDiff:Number = getYears(date1,date2);
			var monthDiff:Number = date1.getMonth() - date2.getMonth();
			if(monthDiff < 0){
				monthDiff += 12;
			}
			if(date1.getDate()< date2.getDate()){
				monthDiff -=1;
			}
			return 12 *yearDiff + monthDiff;
		}
		private static function getYears(date1:Date,date2:Date):Number{
			return Math.floor(getDays(date1,date2)/365);
		}
		private static function datePart(datepart:String=""):String
		{
			switch(datepart.toLowerCase()) {
				
				case "y":
				case "fullyear":
				case "yyyy":
				case "year":
					datepart = "fullYear";
					break;
				
				case "m":
				case "month":
					datepart = "month";
					break;
				
				case "d":
				case "day":
				case "date":
					datepart = "date";
					break;
				
				case "h":
				case "hours":
					datepart = "hours";
					break;
				
				case "minutes":
				case "n":
					datepart = "minutes";
					break;
				
				case "seconds":
				case "s":
					datepart = "seconds";
					break;
				
				case "milliseconds":
				case "l":
					datepart = "milliseconds";
					break;
				default:
					datepart = "date";
			}
			return datepart;
		}
		/**
		 * adds datepart to a date 
		 * @param datepart
		 * @param number
		 * @param date
		 * @return 
		 * 
		 */
		public static function dateAdd(datepart:String = "", number:Number = 0, date:Date = null):Date 
		{
		    date = date == null ? new Date() : new Date(date.time);
			datepart=datePart(datepart);
		    if(datepart != null)
		    	date[datepart]  += number;
		    return date;
		}
	}
}