using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.UserProfile as Up;

class larsBikeDatafieldsView extends Ui.DataField {

	hidden var fields;
	
	//all are maxes except zone2 which is a min for zone 2 
    var HRZONE2 = 120;
    var HRZONE3 = 134;
    var HRZONE4 = 139;
    var HRZONE5 = 154;

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
    }
    
    function onLayout(dc) {
    }

	function drawLayout(dc) {
		//TODO - this will need work
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        // horizontal lines
        dc.drawLine(0, 122, 230, 122);
        dc.drawLine(0, 202, 230, 202);
        dc.drawLine(0, 282, 230, 282);
        // vertical lines
        dc.drawLine(115, 122, 115, 282);
        //dc.drawLine(65, 71, 65, 132);
        //dc.drawLine(120, 285, 120, 285);
        //dc.drawLine(120, 132, 120, 213);
    }
    
    function onUpdate(dc) {
   
   		//TODO do i decide layout here every time? if power then...
   		
   		//TODO do the layout for mtb - HERE
   		
   		 
    	//new layout focused on lap:
    	//lap time, HR, lap distance, pace, lap pace, gap, 
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

		/* TODO - update location and fields
		//lap timer
        textC(dc, 75, 60, Graphics.FONT_NUMBER_MEDIUM, fields.lapTime);

        textC(dc, 75, 60, Graphics.FONT_NUMBER_MEDIUM,  fields.lapTime);
        if (fields.timerSecs != null) {
            var length = dc.getTextWidthInPixels(fields.lapTimer, Graphics.FONT_NUMBER_MEDIUM);
            textC(dc, 75 + length + 1, 60, Graphics.FONT_NUMBER_MILD, fields.lapTimerSecs);
        }
        textR(dc, 117, 28, Graphics.FONT_XTINY,  "LapTime");
      	 
		//HR
        doHrBackground(dc, fields.hrN);
        textC(dc, 162, 60, Graphics.FONT_NUMBER_MEDIUM,  fields.hr);
        textC(dc, 155, 28, Graphics.FONT_XTINY, "HR");
	 
		//lap distance
        textC(dc, 70, 122, Graphics.FONT_NUMBER_MEDIUM,  fields.lapDistance);
        textC(dc, 75, 90, Graphics.FONT_XTINY,  "Lap Dist");

		//pace
        textC(dc, 163, 122, Graphics.FONT_NUMBER_MEDIUM, fields.pace10s);
        textL(dc, 124, 90, Graphics.FONT_XTINY,  "Pace10s");

		//lap pace
        textC(dc, 66, 169, Graphics.FONT_NUMBER_MEDIUM, fields.lapPace);
        textR(dc, 115, 201, Graphics.FONT_XTINY, "LapPace");

		//GAP 10s
        textC(dc, 163, 169, Graphics.FONT_NUMBER_MEDIUM, fields.gap);
        textL(dc, 124, 201, Graphics.FONT_XTINY, "GAP 10s");

		*/
		//time
        textL(dc, 75, 292, Graphics.FONT_TINY, fields.time);
        drawBattery(dc);
        drawLayout(dc);
        return true;
    }

	function doHrBackground(dc, hr) {
        if (hr == null) {
            return;
        }

        var color;
        if (hr >= HRZONE5) {
            color = Graphics.COLOR_PURPLE;
        } else if (hr > HRZONE4) {
            color = Graphics.COLOR_RED;
        } else if (hr > HRZONE3) {
            color = Graphics.COLOR_YELLOW;
        } else if (hr > HRZONE2) {
            color = Graphics.COLOR_GREEN;
        } else {
            color = Graphics.COLOR_BLUE;
        }

		//fix spacing
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        //dc.fillRectangle(154, 72, 65, 16);
        //dc.fillRectangle(128, 83, 65, 16);
        dc.fillRectangle(125, 22, 65, 16);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
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
