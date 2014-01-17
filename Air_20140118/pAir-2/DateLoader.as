package 
{
    import flash.events.*;
    import flash.net.*;

    public class DateLoader extends Object
    {
        private var completefunction:Function;
        private var requests:URLRequest;
        private var loader:URLLoader;

        public function DateLoader(param1:Function)
        {
            this.requests = new URLRequest();
            this.loader = new URLLoader();
            this.completefunction = param1;
            return;
        }// end function

        public function loadXml(param1:String, param2:String = "GET", param3:URLVariables = null) : void
        {
            var myUrl:* = param1;
            var method:* = param2;
            var variables:* = param3;
            this.requests.url = myUrl;
            this.requests.data = variables;
            this.requests.method = method;
            this.loader.addEventListener(Event.COMPLETE, this.completeHandler);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.cancel);
            try
            {
                this.loader.load(this.requests);
            }
            catch (error:Error)
            {
                erro(error.toString());
            }
            return;
        }// end function

        private function cancel(event:IOErrorEvent) : void
        {
            trace("erro cuse");
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            this.completefunction(event.target.data);
            return;
        }// end function

        private function erro(param1:String) : void
        {
            trace(param1);
            return;
        }// end function

        private function securityHandle(event:SecurityErrorEvent) : void
        {
            trace(event);
            return;
        }// end function

        private function progressHandle(event:ProgressEvent) : void
        {
            return;
        }// end function

    }
}
