/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: XStringUtil.as 
 * Project Name: LudoUtils 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.common.utils
{
	import mx.messaging.channels.StreamingAMFChannel;

	/**
	 * static utility functions for string 
	 * @author Goutam
	 * 
	 */	
	public class XStringUtil
	{
		public static function getStringWithoutQuote(val:String):String
		{
			var exp:RegExp=/".*"|'.*'$///quoted string
			return validStringByRegExp(val,exp)?val.substr(1,val.length-2):val;
		}
		public static function isEmpty(str:String):Boolean
		{
			return str == null || str == "" || str == "undefined";
		}
		public static function validStringByRegExp(str:String,regExpStr:RegExp):Boolean
		{
			if (regExpStr.test(str)) {
                   return true;
                } else {
                    return false;
                }
		}
	 	public static function lpad(str:String,len:int,pad:String):String
		{
			if(pad.length>1)
			{
				throw new Error("Invalid pad "+pad+". Length should be 1.");
			}
			var paddedstr:String = "";
			if( len > str.length )
			{
				for( var i:int = 0; i < len - str.length; i++)
				{
					paddedstr += pad;
				}
				
				paddedstr = paddedstr + str;
			}
			else
			{
				paddedstr = str;
			}
			return paddedstr;
		}
	}
}