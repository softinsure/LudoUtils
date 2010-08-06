////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2008-2009 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in acordance with the terms of the license agreement accompanying it.
//
//////////////////////////////////////////////////////////////////////////////////
package org.common.utils
{
	import flash.utils.Dictionary;
	
	import flashx.textLayout.conversion.ImportExportConfiguration;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.FlowGroupElement;
	import flashx.textLayout.elements.IFormatResolver;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.ITextLayoutFormat;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.formats.TextLayoutFormatValueHolder;
	import flashx.textLayout.property.Property;
	import flashx.textLayout.tlf_internal;
	use namespace tlf_internal;
	
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	import flash.text.StyleSheet;
	import mx.styles.IStyleManager2;
	
	/** This version hands back a style on demand from the dictinoary.
	 * Another way to do it would be to "redo" the cascade top down.
	 */
	public class CSSFormatResolver implements IFormatResolver
	{
		static protected var _styleSheet:StyleSheet;//added by SoftInsure
		private var _textLayoutFormatCache:Dictionary;
		static private var styleManager: IStyleManager2;
		
		static public var classToNameDictionary:Object = { "SpanElement":"span", "ParagraphElement":"p", "TextFlow":"TextFlow", "DivElement":"div", "LinkElement":"a" }
		
		/** Create a flex style resolver.  */
		public function CSSFormatResolver(styleSheet:StyleSheet=null):void
		{
			if(styleSheet!=null)
			{
				_styleSheet = styleSheet;
			}
			// cache results
			_textLayoutFormatCache = new Dictionary(true);
		}
		
		static private function addStyleAttributes(attr:TextLayoutFormatValueHolder, styleSelector:String):TextLayoutFormatValueHolder
		{
			//var foundStyle:CSSStyleDeclaration;
			var foundStyle:Object;
			if(_styleSheet)
			{
				foundStyle=_styleSheet.getStyle(styleSelector);
			}
			else
			{
				foundStyle=styleManager.getStyleDeclaration(styleSelector) as Object;
			}
			//var foundStyle:CSSStyleDeclaration = StyleManager.getStyleDeclaration(styleSelector);
			if (foundStyle)
			{ 				
				for each (var prop:Property in TextLayoutFormat.description)
				{
					var propStyle:Object = foundStyle[prop.name];
					//var propStyle:Object = foundStyle.getStyle(prop.name);
					if (propStyle)
					{
						if (attr == null)
							attr = new TextLayoutFormatValueHolder();
						attr[prop.name] = propStyle;
					}
				}
			}
			return attr;
		}
		
		/** Calculate the TextLayoutFormat style for a particular element. */
		public function resolveFormat(elem:Object):ITextLayoutFormat
		{
			// note usage of TextLayoutFormatValueHolder.  This is just like TextLayoutFormat but optimized
			// for the case where only a few stles are actually filled in.  Its naming and usage is subject to change and review.
			var attr:TextLayoutFormatValueHolder = _textLayoutFormatCache[elem];
			if (attr !== null)
				return attr;
			
			if (elem is FlowElement)
			{
				// maps ParagraphElement to p, SpanElement to span etc.  
				var elemClassName:String = flash.utils.getQualifiedClassName(elem);
				elemClassName = elemClassName.substr(elemClassName.lastIndexOf(":")+1)
				var dictionaryName:String = classToNameDictionary[elemClassName] ;
				attr = addStyleAttributes(attr, dictionaryName ? dictionaryName : elemClassName);
				
				if (elem.styleName != null)
					attr = addStyleAttributes(attr, "." + elem.styleName);
				
				if (elem.id != null)
					attr = addStyleAttributes(attr, "#" + elem.id);
				
				_textLayoutFormatCache[elem] = attr;
			}
			// else if elem is IContainerController inherit via the container?
			return attr;
		}
		
		/** Calculate the user style for a particular element. */
		public function resolveUserFormat(elem:Object,userStyle:String):*
		{
			var flowElem:FlowElement = elem as FlowElement;
			//var cssStyle:CSSStyleDeclaration;
			var cssStyle:Object;
			var propStyle:*;
			
			// support non-tlf styles
			if (flowElem)
			{
				if (flowElem.id)
				{
					//cssStyle = StyleManager.getStyleDeclaration("#"+flowElem.id);
					if(_styleSheet)
					{
						cssStyle=_styleSheet.getStyle("#"+flowElem.styleName);
					}
					else
					{
						cssStyle=styleManager.getStyleDeclaration("#"+flowElem.id) as Object;
					}
					if (cssStyle)
					{
						if(cssStyle.hasOwnProperty("getStyle"))
						{
							//propStyle = cssStyle.getStyle(userStyle);
							propStyle = cssStyle[userStyle];
							if (propStyle !== undefined)
								return propStyle;
						}
					}
				}
				if (flowElem.styleName)
				{
					//cssStyle = StyleManager.getStyleDeclaration("."+flowElem.styleName);
					if(_styleSheet)
					{
						cssStyle=_styleSheet.getStyle("."+flowElem.styleName);
					}
					else
					{
						cssStyle=styleManager.getStyleDeclaration("."+flowElem.styleName) as Object;
					}
					if (cssStyle)
					{
						if(cssStyle.hasOwnProperty("getStyle"))
						{
							propStyle = cssStyle.getStyle[userStyle];
							if (propStyle !== undefined)
								return propStyle;
						}
					}
				}
				
				var elemClassName:String = flash.utils.getQualifiedClassName(flowElem);
				elemClassName = elemClassName.substr(elemClassName.lastIndexOf(":")+1)
				var dictionaryName:String = classToNameDictionary[elemClassName];
				//cssStyle = StyleManager.getStyleDeclaration(dictionaryName == null ? elemClassName : dictionaryName);
				//cssStyle = styleManager.getStyleDeclaration(dictionaryName == null ? elemClassName : dictionaryName);
				if(_styleSheet)
				{
					cssStyle=_styleSheet.getStyle(dictionaryName == null ? elemClassName : dictionaryName);
				}
				else
				{
					cssStyle=styleManager.getStyleDeclaration(dictionaryName == null ? elemClassName : dictionaryName) as Object;
				}
				if(cssStyle)
				{
					if(cssStyle.hasOwnProperty("getStyle"))
					{
						propStyle = cssStyle.getStyle[userStyle];
						if (propStyle !== undefined)
							return propStyle;
					}
				}
			}
			return undefined;
		}
		
		/** Completely clear the cache.  None of the results are valid. */
		public function invalidateAll(tf:TextFlow):void
		{
			_textLayoutFormatCache = new Dictionary(true);	// clears the cache
		}
		
		/** The style of one element is invalidated.  */
		public function invalidate(target:Object):void
		{
			delete _textLayoutFormatCache[target];
			var blockElem:FlowGroupElement = target as FlowGroupElement;
			if (blockElem)
			{
				for (var idx:int = 0; idx < blockElem.numChildren; idx++)
					invalidate(blockElem.getChildAt(idx));
			}
		}
		
		/** these are sharable between TextFlows */
		public function getResolverForNewFlow(oldFlow:TextFlow,newFlow:TextFlow):IFormatResolver
		{ return this; }
	}
}