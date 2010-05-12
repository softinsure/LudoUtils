/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: XFormatter.as 
 * Project Name: LudoUtils 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.common.utils
{
	import mx.formatters.*;
	/**
	 * static functions to format 
	 * @author Goutam
	 * 
	 */
	public class XFormatter
	{
		/**
		 * formats date string. default format is 'MM/DD/YYYY' 
		 * @param date
		 * @param formatString
		 * @return 
		 * 
		 */
		public static function formatDateString(date:String, formatString:String="MM/DD/YYYY"):String
		{
			var dateFormatter:DateFormatter=new DateFormatter();
			dateFormatter.formatString=formatString;
			return dateFormatter.format(date);
		}
	}
}