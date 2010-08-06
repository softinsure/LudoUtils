/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: XFormatter.as 
 * Project Name: LudoUtils 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.common.utils
{
	import mx.formatters.*;
	/**
	 * static functions to format 
	 * @author SoftInsure
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