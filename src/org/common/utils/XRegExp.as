/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: XRegExp.as 
 * Project Name: LudoUtils 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.common.utils
{
	/**
	 * static regular expression functions 
	 * @author SoftInsure
	 * 
	 */
	public class XRegExp
	{
		public static function ZipCodeUSA():RegExp
		{
			return /^[0-9]\{5\}(-[0-9]\{4\})?$/ as RegExp;
		}
		public static function phoneUSA():RegExp
		{
			return /[(]?[0-9]{3}?[)]?[[:blank:]]*[-]?[[:blank:]]*[0-9]{3}[[:blank:]]*[-][[:blank:]]*[0-9]{4}/ig as RegExp;
		}
	}
}