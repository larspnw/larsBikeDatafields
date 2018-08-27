using Toybox.Time as Time;
using Toybox.System as Sys;


class larsBikeFields {
    // last 60 seconds - 'current speed' samples
    hidden var lastSecs = new [60];
    hidden var lastHR = new [180];
    hidden var curPos;
    hidden var hrPos;
    hidden var tempCount = 290; //used to check temperature every 5 min; first run is 10 seconds
    const METERS_TO_MILES = 0.000621371;
    const METERS_TO_FEET = 3.28;
    
    // public fields - usable after the user calls compute
    var dist;
    var hr;
    var hrN; 
    var timer;
    var timerSecs = null;
    var time;
    var avgHR3 = 0; 
    var trimp; //TODO implement
    var elevationGain = 0;
    var eleGain = 0.0;
    var lastAlt = null;
    var temperature = null;
    var ipcTemp = null;
    
    function initialize() {
        for (var i = 0; i < lastSecs.size(); ++i) {
            lastSecs[i] = 0.0;
        }
        
        for (var i = 0; i < lastHR.size(); i++) {
       		lastHR[i] = 0; 
        }

        curPos = 0;
        hrPos = 0;
    }
 
    function getAverage(a) {
        var count = 0;
        var sum = 0.0;
        for (var i = 0; i < a.size(); ++i) {
            if (a[i] > 0.0) {
                count++;
                sum += a[i];
            }
        }
        if (count > 0) {
            return sum / count;
        } else {
            return null;
        }
    }

    function getNAvg(a, curIdx, n) {
        var start = curIdx - n;
        if (start < 0) {
            start += a.size();
        }
        var count = 0;
        var sum = 0.0;
        for (var i = start; i < (start + n); ++i) {
            var idx = i % a.size();
            if (a[idx] > 0.0) {
                count++;
                sum += a[idx];
            }
        }
        if (count > 0) {
            return sum / count;
        } else {
            return null;
        }
    }

    function toDist(d) {
        if (d == null) {
            return "0.00";
        }

        var dist;
        if (Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC) {
            dist = d / 1000.0;
        } else {
            dist = d / 1609.0;
        }
        return dist.format("%.2f");
    }
    
    function toStr(o) {
        if (o != null) {
            return "" + o;
        } else {
            return "---";
        }
    }
    
    function toInt(f) {
    	//System.println("toInt: " + f);
    	if (f == null ) {
    		return "--";
    	} else {
   			return f.format("%d"); 
   		}
    }

    function fmtSecs(secs) {
        if (secs == null) {
            return "--:--";
        }

        var s = secs.toLong();
        var hours = s / 3600;
        s -= hours * 3600;
        var minutes = s / 60;
        s -= minutes * 60;
        var fmt;
        if (hours > 0) {
            fmt = "" + hours + ":" + minutes.format("%02d");
        } else {
            fmt = "" + minutes + ":" + s.format("%02d");
        }

        return fmt;
    }

    function fmtTime(clock) {
        var h = clock.hour;
        if (!Sys.getDeviceSettings().is24Hour) {
            if (h > 12) {
                h -= 12;
            } else if (h == 0) {
                h += 12;
            }
        }
        return "" + h + ":" + clock.min.format("%02d");
    }

    function compute(info) {

       	if (info.currentHeartRate != null ) {
            var idx = hrPos % lastHR.size();
            hrPos++;
            lastHR[idx] = info.currentHeartRate;
        }
         
        hr = toStr(info.currentHeartRate);
        hrN = info.currentHeartRate;
        avgHR3 = toInt(getAverage(lastHR));
        
        //TODO power? pace10s =  fmtSecs(toPace(avg10s));
        time = fmtTime(Sys.getClockTime());
        dist = toDist(info.elapsedDistance);
        
        var elapsed = info.timerTime;
        //elapsed = 60*23*1000 + info.timerTime;
        //elapsed = 60*60*3*1000 + info.timerTime;
        
       	if (elapsed != null) {
            elapsed /= 1000;

            if (elapsed >= 3600) {
                timerSecs = (elapsed.toLong() % 60).format("%02d");
                System.println("timerSecs: " + timerSecs); 
            }
        } 
        timer = fmtSecs(elapsed);  //will it be annoying to not have secs when > 1 hr
        
        //avgHR = toStr(info.averageHeartRate);
        
        //ascent calc
        if ( info.timerState == Activity.TIMER_STATE_ON ) {
        	if ( lastAlt == null ) {
        		lastAlt = info.altitude;
        	}
        	if ( info.altitude > lastAlt ) {
        		eleGain += (info.altitude - lastAlt);
        		elevationGain = toInt(eleGain * METERS_TO_FEET);
        	}
        	lastAlt = info.altitude;
        }
        
        //temperature - check every 5 min
        tempCount++;
        if ( tempCount > 300 ) {
        	tempCount = 0;
        	var temp = Application.getApp().getProperty(OSDATA);
        	if ( temp != null && temp instanceof Float ) {
        		temp = toInt(temp * 1.8 + 32);
        	} else {
        		temp = "--";
        	}
        	temperature = temp;
        	System.println("temperature: " + temperature);
        }
    }
}
