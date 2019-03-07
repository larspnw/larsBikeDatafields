using Toybox.Application as App;
using Toybox.Background;

var counter=0;
var bgdata="none";
// keys to the object store data
//var OSCOUNTER="oscounter";
var OSDATA="osdata";

(:background)
class larsBikeDatafieldsApp extends App.AppBase {

	
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    //! Return the initial view of your application here
    function getInitialView() {
   
   		/* having battery drain issues so removing for now 
    	//register for temporal events if they are supported
    	if(Toybox.System has :ServiceDelegate) {
    		System.println("background IS available on this device****");
    		Background.registerForTemporalEvent(new Time.Duration(5 * 60));
    		//TODO - is this really registered in seconds? move to 10 min?
    	} else {
    		System.println("****background not available on this device****");
    	}
    	*/
		    	
        return [ new larsBikeDatafieldsView() ];
    }

	function onBackgroundData(data) {
    	//counter++;
    	//var now=System.getClockTime();
    	//var ts=now.hour+":"+now.min.format("%02d");
        //System.println("onBackgroundData="+data+" "+counter+" at "+ts);
        bgdata=data;
        App.getApp().setProperty(OSDATA,bgdata);
        //Ui.requestUpdate();
    }    

    function getServiceDelegate(){
    	//var now=System.getClockTime();
    	//var ts=now.hour+":"+now.min.format("%02d");    
    	//System.println("getServiceDelegate: "+ts);
        return [new larsBikeDatafieldsServiceDelegate()];
    }
}