/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: XArrayUtil.as 
 * Project Name: LudoUtils 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.common.utils
{
	/**
	 * static utility functions related to array 
	 * @author Goutam
	 * 
	 */
	public class XArrayUtil
	{
		/**
		 * concat arrays and return unique array 
		 * @param args
		 * @return 
		 * 
		 */		
		public static function concatUnique(...args):Array
		{    
			var retArr:Array = new Array();
			for each (var arg:* in args)
			{
				if (arg is Array)
				{
					for each (var value:* in arg)
					{
						if (retArr.indexOf(value) == -1)
						{
							retArr.push(value);
						}            
					}
				}
				else
				{
					if (retArr.indexOf(arg) == -1)
					{
						retArr.push(arg);
					}
				}
			}
			return retArr;
		}
		/**
		 * concat arrays into one 
		 * @param args
		 * @return 
		 * 
		 */
		public static function concat(...args):Array
		{    
			var retArr:Array = new Array();
			for each (var arg:* in args)
			{
				if (arg is Array)
				{
					for each (var value:* in arg)
					{
						retArr.push(value);           
					}
				}
				else
				{
					retArr.push(arg);
				}
			}
		return retArr;
		}
	}
}