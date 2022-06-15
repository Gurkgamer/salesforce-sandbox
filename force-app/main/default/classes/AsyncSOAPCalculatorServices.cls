//Generated by wsdl2apex

public class AsyncSOAPCalculatorServices {
    public class doDivideResponseFuture extends System.WebServiceCalloutFuture {
        public Double getValue() {
            SOAPCalculatorServices.doDivideResponse response = (SOAPCalculatorServices.doDivideResponse)System.WebServiceCallout.endInvoke(this);
            return response.return_x;
        }
    }
    public class doSubtractResponseFuture extends System.WebServiceCalloutFuture {
        public Double getValue() {
            SOAPCalculatorServices.doSubtractResponse response = (SOAPCalculatorServices.doSubtractResponse)System.WebServiceCallout.endInvoke(this);
            return response.return_x;
        }
    }
    public class doMultiplyResponseFuture extends System.WebServiceCalloutFuture {
        public Double getValue() {
            SOAPCalculatorServices.doMultiplyResponse response = (SOAPCalculatorServices.doMultiplyResponse)System.WebServiceCallout.endInvoke(this);
            return response.return_x;
        }
    }
    public class doAddResponseFuture extends System.WebServiceCalloutFuture {
        public Double getValue() {
            SOAPCalculatorServices.doAddResponse response = (SOAPCalculatorServices.doAddResponse)System.WebServiceCallout.endInvoke(this);
            return response.return_x;
        }
    }
    public class AsyncCalculatorImplPort {
        public String endpoint_x = 'https://th-apex-soap-service.herokuapp.com/service/calculator';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://calculator.services/', 'SOAPCalculatorServices'};
        public AsyncSOAPCalculatorServices.doDivideResponseFuture beginDoDivide(System.Continuation continuation,Double arg0,Double arg1) {
            SOAPCalculatorServices.doDivide request_x = new SOAPCalculatorServices.doDivide();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            return (AsyncSOAPCalculatorServices.doDivideResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSOAPCalculatorServices.doDivideResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://calculator.services/',
              'doDivide',
              'http://calculator.services/',
              'doDivideResponse',
              'SOAPCalculatorServices.doDivideResponse'}
            );
        }
        public AsyncSOAPCalculatorServices.doSubtractResponseFuture beginDoSubtract(System.Continuation continuation,Double arg0,Double arg1) {
            SOAPCalculatorServices.doSubtract request_x = new SOAPCalculatorServices.doSubtract();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            return (AsyncSOAPCalculatorServices.doSubtractResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSOAPCalculatorServices.doSubtractResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://calculator.services/',
              'doSubtract',
              'http://calculator.services/',
              'doSubtractResponse',
              'SOAPCalculatorServices.doSubtractResponse'}
            );
        }
        public AsyncSOAPCalculatorServices.doMultiplyResponseFuture beginDoMultiply(System.Continuation continuation,Double arg0,Double arg1) {
            SOAPCalculatorServices.doMultiply request_x = new SOAPCalculatorServices.doMultiply();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            return (AsyncSOAPCalculatorServices.doMultiplyResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSOAPCalculatorServices.doMultiplyResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://calculator.services/',
              'doMultiply',
              'http://calculator.services/',
              'doMultiplyResponse',
              'SOAPCalculatorServices.doMultiplyResponse'}
            );
        }
        public AsyncSOAPCalculatorServices.doAddResponseFuture beginDoAdd(System.Continuation continuation,Double arg0,Double arg1) {
            SOAPCalculatorServices.doAdd request_x = new SOAPCalculatorServices.doAdd();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            return (AsyncSOAPCalculatorServices.doAddResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSOAPCalculatorServices.doAddResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://calculator.services/',
              'doAdd',
              'http://calculator.services/',
              'doAddResponse',
              'SOAPCalculatorServices.doAddResponse'}
            );
        }
    }
}