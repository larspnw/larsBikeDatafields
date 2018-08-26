using Toybox.Background;
using Toybox.System as Sys;
using Toybox.Sensor as Sens;

// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system.

(:background)
class larsBikeDatafieldsServiceDelegate extends Toybox.System.ServiceDelegate {
	
	function initialize() {
		Sys.ServiceDelegate.initialize();
	}


	//doing this for temperature
    function onTemporalEvent() {
   		var sensorInfo = Sens.getInfo(); 
   		var temp = sensorInfo.temperature; 
        Sys.println("bg exit temp: "+temp);
        Background.exit(temp);
    }
    

}
