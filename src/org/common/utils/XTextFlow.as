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

	public class XTextFlow
	{
		private var textpath:String="";
		private var csspath:String="";
		private var config:IConfiguration;
		private var selection:Boolean=false;
		private var w:Number=NaN;
		private var h:Number=NaN;
		private var parent:*;
		private var text:String="";
		private var format:String="";
		private var container:UIComponent;
		private var styleSheet:StyleSheet=new StyleSheet();
		private var controller:ContainerController;
		private var textFlow:TextFlow;
		private var smanager:SelectionManager;
		
		
		public function XTextFlow(container:*,conFig:IConfiguration=null,selecTion:Boolean=false,forMat:String="",width:Number=NaN,height:Number=NaN)
		{
			config=conFig;
			selection=selecTion;
			w=width;
			h=height;
			parent=container;
			format=forMat;
		}
		public function load(textPath:String,cssPath:String=""):void
		{
			textpath=textPath;
			csspath=cssPath;
			XURLLoader.load(textPath,loadCompleteHandler,errorHandler);
		}
		/*
		public function loadByXML(textLayout:XML):void
		{
			if(textLayout.hasOwnProperty("text"))
			{
				text=String(textLayout.text);
			}
			if(textLayout.hasOwnProperty("css"))
			{
				styleSheet.parseCSS(String(textLayout.css));
			}
			loadFlow();
		}
		*/
		public function resize(width:Number,height:Number=NaN):void
		{
			if(controller!=null)
			{
				w=width;
				h=height;
				controller.setCompositionSize(w,h);
				textFlow.flowComposer.updateAllControllers();
			}
		}
		private function loadCompleteHandler(e:Event):void
		{
			text=e.target.data;
			if(csspath!="")
			{
				XURLLoader.load(csspath,loadStyle,errorHandler);
			}
			else
			{
				loadFlow();
			}
		}
		private function loadFlow():void
		{
			addFlow();
			if("addElement" in parent)
			{
				parent.addElement(container);
			}
			else
			{
				parent.addChild(container);
			}
		}
		private function errorHandler(e:IOErrorEvent):void
		{
			text="\n"+IOErrorEvent(e).text;
			addFlow();
			if("addElement" in parent)
			{
				parent.addElement(container);
			}
			else
			{
				parent.addChild(container);
			}
		}
		private function loadStyle(e:Event):void
		{
			styleSheet.parseCSS(e.target.data);
			loadFlow();
		}
		private function addFlow():void
		{
			if(format==null || format == "")
			{
				format=TextConverter.TEXT_LAYOUT_FORMAT;
			}
			//textFlow=new TextFlow();
			textFlow=TextConverter.importToFlow(text,format,config);
			if(selection)
			{
				smanager=new SelectionManager();
				textFlow.interactionManager = smanager;
			}
			container=new UIComponent();
			controller=new ContainerController(container,w,h);
			textFlow.whiteSpaceCollapse = flashx.textLayout.formats.WhiteSpaceCollapse.PRESERVE;
			textFlow.flowComposer.addController(controller);
			textFlow.formatResolver = new CSSFormatResolver(styleSheet);
			textFlow.invalidateAllFormats();
			textFlow.flowComposer.updateAllControllers();
		}
	}
}