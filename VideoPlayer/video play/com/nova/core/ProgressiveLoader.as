package com.nova.core
{
	import flash.display.LoaderInfo;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.LoaderContext;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
 
	/**
	 * ����ʽ������
	 * �÷���Loaderһ��,
	 * <p><b>��ͬ��:</b></p>
	 * 1.������������ʱֻ�ܻ�ȡ�� "Error #2124: ���ص��ļ�Ϊδ֪���͡�" <br/>
	 * 2.����contentLoaderInfo��Progress�¼���bytesLoaded,bytesTotal�������ļ����Ѽ����ֽں����ֽ�.<br/>
	 * 3.contentLoaderInfo.bytesLoaded, contentLoaderInfo.bytesTotalָ��ǰloader����ֽ��������ֽ�
	 * 
	 * @author lite3
	 */
	public class ProgressiveLoader extends Loader
	{
		private var bytesLoaded:uint = 0;			// �Ѽ��ص��ֽ���
		private var bytesToal:uint = 0; 			// ���ֽ���
 
		private var dataChange:Boolean = false;		// buffer�������Ƿ�ı�	
		private var streamComplete:Boolean = false;	// �ļ��Ƿ�������
 
		private var context:LoaderContext;			// 
 
		private var buffer:ByteArray;				// ���ݻ���
		private var stream:URLStream;				// ��
 
		/**
		 * �ر���,����������������
		 */
		override public function close():void 
		{
			// ��������
			if (stream)
			{
				if (stream.connected) stream.close();
				streamRemoveEvent(stream);
			}
			// ���conentLoaderInfo��ص��¼�
			if (contentLoaderInfo.hasEventListener(Event.COMPLETE))
			{
				loaderInfoRemoveEvent(super.contentLoaderInfo);
			}
			// �����ʾ�����¼�
			if (hasEventListener(Event.ENTER_FRAME))
			{
				removeEventListener(Event.ENTER_FRAME, showData);
			}
			buffer = null;
		}
		/**
		 * �����ֽ�����,�������ڲ�����contentLoaderInfo����¼�
		 * @param	bytes
		 * @param	context
		 */
		override public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void
		{
			close();
			super.unload();
			super.loadBytes(bytes, context);
		}
 
		/**
		 * ����һ��url�ļ�,��������ʾ(����ǽ�����ʽ)
		 * @param	request
		 * @param	context
		 */
		override public function load(request:URLRequest, context:LoaderContext = null):void 
		{
			streamComplete = false;
			if (!stream) stream = new URLStream();
			if (stream.connected) stream.close();
			this.context = context;
			dataChange = false;
 
			buffer = new ByteArray();
			super.unload();
			addEventListener(Event.ENTER_FRAME, showData);
			loaderInfoAddEvent(super.contentLoaderInfo);
			streamAddEvent(stream);
			stream.load(request);
		}
 
		// �������е�������ʾΪͼ��
		private function showData(e:Event = null):void 
		{
			if (!dataChange || !stream.connected) return;
 
			dataChange = false;
			if (stream.bytesAvailable > 0)
			{
				stream.readBytes(buffer, buffer.length, stream.bytesAvailable);
			}
			if (buffer.length > 0)
			{
				super.unload();
				super.loadBytes(buffer, context);
			}
 
			// �������
			if (streamComplete)
			{
				close();
				streamComplete  = false;
			}
		}
		// ����contentLoaderInfo��ProgressEvent.PROGRESS�¼��Ľ���ֵ
		private function loaderProgressHandler(e:ProgressEvent):void 
		{
			e.bytesLoaded = bytesLoaded;
			e.bytesTotal = bytesToal;
		}
 
		// ��ʾ���
		private function loaderCompleteHandler(e:Event):void 
		{
			if (streamComplete)
			{
				streamComplete = false;
				loaderInfoRemoveEvent(super.contentLoaderInfo);
			}else
			{
				e.stopImmediatePropagation();
			}
		}
 
		// ���ݼ������
		private function streamCompleteHandler(e:Event):void 
		{
			streamRemoveEvent(stream);
			// ���ﲻɾ��EnterFrame�¼�,���һ�����ǲ�����ʾ,
			// ����complete�¼���showDataҲ����,
			// ���������ʱ��ʾһ��,
			streamComplete = true;
			dataChange = true;
		}
		// ���ݼ�����,�������ݼ��ص�ֵ
		private function streamProgressHandler(e:ProgressEvent):void 
		{
			bytesLoaded = e.bytesLoaded;
			bytesToal = e.bytesTotal;
			dataChange = true;
		}
		// ����������, ����Ҳ�����400K���ҵ�����,
		// Ȼ����contentLoaderInfo�׳�IOError����IOErrorEvent
		// ��������������,����δ֪�ļ�����
		private function streamErrorHandler(e:IOError):void 
		{
			close();
		}
 
		private function streamAddEvent(stream:URLStream):void
		{
			stream.addEventListener(Event.COMPLETE, streamCompleteHandler);
			stream.addEventListener(ProgressEvent.PROGRESS, streamProgressHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR, streamErrorHandler);
		}
 
		private function streamRemoveEvent(stream:URLStream):void
		{
			stream.removeEventListener(Event.COMPLETE, streamCompleteHandler);
			stream.removeEventListener(ProgressEvent.PROGRESS, streamProgressHandler);
			stream.removeEventListener(IOErrorEvent.IO_ERROR, streamErrorHandler);
		}
 
		private function loaderInfoAddEvent(loaderInfo:LoaderInfo):void
		{
			loaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, int.MAX_VALUE);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler, false, int.MAX_VALUE);
		}
 
		private function loaderInfoRemoveEvent(loaderInfo:LoaderInfo):void
		{
			loaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
		}
	}
}