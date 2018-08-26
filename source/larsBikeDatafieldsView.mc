using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.UserProfile as Up;
using Toybox.Sensor as Sens;

class larsBikeDatafieldsView extends Ui.DataField {

	hidden var fields;
	
	//all are maxes except zone2 which is a min for zone 2 
    var HRZONE2 = 120;
    var HRZONE3 = 134;
    var HRZONE4 = 139;
    var HRZONE5 = 154;
    var hasPower = 0;
  	var f1_label = "label1"; 
  	var f2_label = "label2"; 
  	var f3_label = "label3"; 
  	var f4_label = "label4"; 
  	var f5_label = "label5"; 
  	var f1_value = 11;
  	var f2_value = 2;
  	var f3_value = 333;
  	var f4_value = 4444;
  	var f5_value = 555; 

    function initialize() {
    	DataField.initialize();
        fields = new larsBikeFields(); 
        
        //get users HR zones
		var profile = Up.getProfile();
		var sport = Up.getCurrentSport();
		var HRZones = profile.getHeartRateZones(sport);
		if (HRZones == null) {
			System.println("HRZones not populated, using defaults");
		}
		
		HRZONE2 = HRZones[1];	
		HRZONE3 = HRZones[2];	
		HRZONE4 = HRZones[3];	
		HRZONE5 = HRZones[4];	
		
		//System.println("HR Zones 2-5 for " + sport + ": " + HRZONE2 + " / " + HRZONE3 + " / " + HRZONE4 + " / " + HRZONE5);

/*
		//check for power
		var sensorInfo = Sens.getInfo(); 
		if (sensorInfo has :power && sensorInfo.power != null ){
			System.println("we have power");
			hasPower = 1;
		} 
    */
    }
    
    function onLayout(dc) {
    }

	function drawLayout(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        // horizontal lines
        dc.drawLine(0, 80, 230, 80);
        dc.drawLine(0, 202, 230, 202);
        dc.drawLine(0, 282, 230, 282);
        // vertical lines
        dc.drawLine(115, 1, 115, 80);
        dc.drawLine(115, 202, 115, 282);
    }
    
    function onUpdate(dc) {
  
   		
   		/*
   			if power exists then:
   				f1 HR
   				f2 time
   				f3 power 3s
   				f4 speed
   				f5 distance
   			else
   				f1 time
   				f2 elevation
   				f3 HR
   				f4 distance
   				f5	trimp?
   		*/
   		//TODO test for power existence and then set fields
   		//call compute to get fields and set 	
   		//TODO how to alter HR text??
   	
   		//TODO pretend no power
   		if ( hasPower ) {
   			//TODO power
   		} else {
   			f1_label = "Time";	
   			f1_value = fields.timer;	//TODO need secs?
   		
   			f2_label = "Tot Ascent";	
   			f2_value = fields.elevationGain; 
   		
   			f3_label = "HR";	
   			f3_value = fields.hr;
   		
   			f4_label = "Distance";	
   			f4_value = fields.dist;
   		
   			f5_label = "HRavg 3min";	
   			f5_value = fields.avgHR3;
   		}
   		 
    	//new layout 
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

		//layout:
        textC(dc, 57, 9, Graphics.FONT_XTINY, f1_label);
        textL(dc, 1, 46 , Graphics.FONT_NUMBER_MEDIUM,  f1_value);
        if (fields.timerSecs != null) {
            var length = dc.getTextWidthInPixels(f1_value, Graphics.FONT_NUMBER_MEDIUM);
            textL(dc, 1 + length + 1, 56, Graphics.FONT_MEDIUM, fields.timerSecs);
            System.println("display timerSecs " + fields.timerSecs + " length: " + length);
        }
        
        textC(dc, 172, 9, Graphics.FONT_XTINY, f2_label);
        textC(dc, 172, 46, Graphics.FONT_NUMBER_MEDIUM,  f2_value);
        
        textC(dc, 115, 90, Graphics.FONT_XTINY, f3_label);
        textC(dc, 115, 152, Graphics.FONT_NUMBER_THAI_HOT,  f3_value);
        textL(dc, 1, 152, Graphics.FONT_NUMBER_HOT, getHrZone(fields.hrN));
        
        textC(dc, 57, 212, Graphics.FONT_XTINY, f4_label);
        textC(dc, 57, 248 , Graphics.FONT_NUMBER_MEDIUM,  f4_value);
        
        textC(dc, 172, 212, Graphics.FONT_XTINY, f5_label);
        textC(dc, 172, 248, Graphics.FONT_NUMBER_MEDIUM,  f5_value);
        
		//time and battery
        textL(dc, 75, 292, Graphics.FONT_TINY, fields.time);
        drawBattery(dc);
        drawLayout(dc);
        return true;
    }

	//return zone since 130 doesn't support color
	function getHrZone(hr) {
        if (hr == null) {
            return "";
        }

        if (hr >= HRZONE5) {
            return 5;
        } else if (hr > HRZONE4) {
            return 4;
        } else if (hr > HRZONE3) {
            return 3;
        } else if (hr > HRZONE2) {
            return 2;
        } else {
            return 1;
        }
    }

    function drawBattery(dc) {
        var pct = Sys.getSystemStats().battery;
        dc.drawRectangle(130, 288, 18, 11);
        dc.fillRectangle(148, 291, 2, 5);

        var color = Graphics.COLOR_GREEN;
        if (pct < 25) {
            color = Graphics.COLOR_RED;
        } else if (pct < 40) {
            color = Graphics.COLOR_YELLOW;
        }
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        var width = (pct * 16.0 / 100 + 0.5).toLong();
        if (width > 0) {
            //Sys.println("" + pct + "=" + width);
            if (width > 16) {
                width = 16;
            }
            dc.fillRectangle(131, 289, width, 9);
        }
    }

    function compute(info) {
        fields.compute(info);
        return 1;
    }

    function textL(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    function textC(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    function textR(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }	
}
