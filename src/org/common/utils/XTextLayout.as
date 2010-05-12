package org.common.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.IConfiguration;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.WhiteSpaceCollapse;
	
	import mx.core.UIComponent;

	public class XTextLayout
	{
		/*
		public function XTextLayout()
		{
		}
		*/
		public static function XTextFlow(text:String,
										 styleSheet:StyleSheet,
										 format:String="",
										 config:IConfiguration=null,
										 selection:Boolean=false,
										 width:Number=100,
										 height:Number=NaN
		):UIComponent
		{
			var textContainer:UIComponent =new UIComponent();
			// make the text selectable
			if(format==null || format == "")
			{
				format=TextConverter.TEXT_LAYOUT_FORMAT;
			}
			var textFlow:TextFlow=TextConverter.importToFlow(text,format,config);
			if(selection)
			{
				textFlow.interactionManager = new SelectionManager();
			}
			textFlow.whiteSpaceCollapse = flashx.textLayout.formats.WhiteSpaceCollapse.PRESERVE;
			textFlow.flowComposer.addController(new ContainerController(textContainer,width,height));
			//textFlow.flowComposer.updateAllControllers();
			textFlow.formatResolver = new CSSFormatResolver(styleSheet);
			textFlow.invalidateAllFormats();
			textFlow.flowComposer.updateAllControllers();
			return textContainer;
		}
		public static function XTextFlowFromXMLTag(textLayout:XML,format:String="",config:IConfiguration=null,selection:Boolean=false,width:Number=100,height:Number=NaN):UIComponent
		{
			var css:String;
			var text:String;
			var styleSheet:StyleSheet=new StyleSheet();
			if(textLayout.hasOwnProperty("text"))
			{
				text=String(textLayout.text);
			}
			if(textLayout.hasOwnProperty("css"))
			{
				css=String(textLayout.css);
				styleSheet.parseCSS(css);
			}
			if(format==null || format == "")
			{
				format=TextConverter.TEXT_LAYOUT_FORMAT;
			}
			var textContainer:UIComponent =new UIComponent();
			// make the text selectable
			var textFlow:TextFlow=TextConverter.importToFlow(text,format,config);
			if(selection)
			{
				textFlow.interactionManager = new SelectionManager();
			}
			textFlow.whiteSpaceCollapse = flashx.textLayout.formats.WhiteSpaceCollapse.PRESERVE;
			textFlow.flowComposer.addController(new ContainerController(textContainer,width,height));
			textFlow.flowComposer.updateAllControllers();
			textFlow.formatResolver = new CSSFormatResolver(styleSheet);
			return textContainer;
		}
		public static function XStyleSheetLoader(styleSheet:StyleSheet,cssPath:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(cssPath));
			loader.addEventListener(Event.COMPLETE,loadCompleteHandler);	
			loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			function loadCompleteHandler(e:Event):void
			{
				styleSheet.parseCSS(e.target.data);
			}
			function errorHandler(e:IOErrorEvent):void
			{
				throw new Error("load error: "+"\n"+IOErrorEvent(e).text); 
			}
		}		
		public static function XTextFlowLoader(container:*,textPath:String,cssPath:String="",config:IConfiguration=null,selection:Boolean=false,width:Number=300,height:Number=NaN):void
		{
			//var textContainer:UIComponent;
			var text:String = "";
			var styleSheet:StyleSheet=new StyleSheet();
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(textPath));	// for example
			loader.addEventListener(Event.COMPLETE,loadCompleteHandler);	
			loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			function loadCompleteHandler(e:Event):void
			{
				text=e.target.data;
				if(cssPath!="")
				{
					var loaderStyle:URLLoader = new URLLoader();
					loaderStyle.load(new URLRequest(cssPath));
					loaderStyle.addEventListener(Event.COMPLETE,loadStyle);	
					loaderStyle.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				}
				else
				{
					loadFlow(text,TextConverter.TEXT_LAYOUT_FORMAT);
				}
				
				//textContainer=XTextFlow(e.target.data,config,selection,width,height);
			}
			function loadFlow(textFlow:String,format:String):void
			{
				if("addElement" in container)
				{
					container.addElement(XTextFlow(textFlow,styleSheet,format,config,selection,width,height));
				}
				else
				{
					container.addChild(XTextFlow(textFlow,styleSheet,format,config,selection,width,height));
				}
				
			}
			function errorHandler(e:IOErrorEvent):void
			{
				loadFlow("\n"+IOErrorEvent(e).text,TextConverter.PLAIN_TEXT_FORMAT);
				/*
				if("addElement" in container)
				{
					container.addElement(XTextFlow("\n"+IOErrorEvent(e).text,styleSheet,TextConverter.PLAIN_TEXT_FORMAT,config,selection,width,height));
				}
				else
				{
					container.addChild(XTextFlow("\n"+IOErrorEvent(e).text,styleSheet,TextConverter.PLAIN_TEXT_FORMAT,config,selection,width,height));
				}
				*/
				//textContainer=XTextFlow("\n"+IOErrorEvent(e).text,config,selection,width,height);
			}
			function loadStyle(e:Event):void
			{
				styleSheet.parseCSS(e.target.data);
				loadFlow(text,TextConverter.TEXT_LAYOUT_FORMAT);
			}
		}
		/*
		private function errorHandler(e:IOErrorEvent):void
		{
			//textFlow = TextFilter.importToFlow("\n"+IOErrorEvent(e).text, TextFilter.PLAIN_TEXT_FORMAT);
			var textFlow:TextFlow=TextConverter.importToFlow("\n"+IOErrorEvent(e).text, TextConverter.PLAIN_TEXT_FORMAT,_config);
			if(_selection)
			{
				textFlow.interactionManager = new SelectionManager();
			}
			textFlow.whiteSpaceCollapse = flashx.textLayout.formats.WhiteSpaceCollapse.PRESERVE;
			textFlow.flowComposer.addController(new ContainerController(_textContainer,_width,_height));
			textFlow.flowComposer.updateAllControllers();
		}
		private function loadCompleteHandler(e:Event):void
		{
			// make the text selectable
			var textFlow:TextFlow=TextConverter.importToFlow(e.target.data,TextConverter.TEXT_LAYOUT_FORMAT,_config);
			if(_selection)
			{
				textFlow.interactionManager = new SelectionManager();
			}
			textFlow.whiteSpaceCollapse = flashx.textLayout.formats.WhiteSpaceCollapse.PRESERVE;
			textFlow.flowComposer.addController(new ContainerController(_textContainer,_width,_height));
			textFlow.flowComposer.updateAllControllers();
			//editor.textFlow = TextFilter.importToFlow(e.target.data, TextFilter.TEXT_LAYOUT_FORMAT);
			//editor.textFlow.formatResolver = new CSSFormatResolver();
		}
		*/
	}
}