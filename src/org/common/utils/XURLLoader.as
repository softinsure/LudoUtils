package org.common.utils
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class XURLLoader
	{
		/*
		public function XURLLoader()
		{
		}
		*/
		public static function load(url:String,onComplete:Function,OnIOError:Function=null,onOpen:Function=null,onSecurityError:Function=null,onProgress:Function=null,statusCheck:Function=null):void
		{
			var urlLdr:URLLoader = new URLLoader();
			urlLdr.addEventListener(Event.COMPLETE, onComplete);
			if(onOpen!=null)
			{
				urlLdr.addEventListener(Event.OPEN, onOpen);
			}
			if(statusCheck!=null)
			{
				urlLdr.addEventListener(HTTPStatusEvent.HTTP_STATUS, statusCheck);
			}
			if(OnIOError!=null)
			{
				urlLdr.addEventListener(IOErrorEvent.IO_ERROR, OnIOError);
			}
			if(onProgress!=null)
			{
				urlLdr.addEventListener(ProgressEvent.PROGRESS, onProgress);
			}
			if(onSecurityError!=null)
			{
				urlLdr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			}
			urlLdr.load(new URLRequest(url));
		}
	}
}