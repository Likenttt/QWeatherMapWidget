using Toybox.Graphics as G;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

(:glance)
class OpenWeatherGlanceView extends Ui.GlanceView {

	var GW;
	var GH;
	
	var tempCelsius = true;

	const DEGREE_SYMBOL = "\u00B0";
	const C_SYMBOL = "\u2103";
	const F_SYMBOL = "\u2109";
	
    function initialize() {
    	//p("GlanceView initialize");
        GlanceView.initialize();
		tempCelsius = !(Sys.getDeviceSettings().temperatureUnits == Sys.UNIT_STATUTE);
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
    	//p("Glance onLayout");
    	GW = dc.getWidth();
    	GH = dc.getHeight();
    }

    function onShow() as Void {}

    // Update the view
    function onUpdate(dc as Dc) as Void {
        GlanceView.onUpdate(dc);
    	//p("Glance onUpdate");
    	dc.setColor(0, G.COLOR_BLACK);
        dc.clear();
        dc.setColor(G.COLOR_WHITE, -1);
        dc.setPenWidth(1);
        dc.drawLine(0, GH /2, GW, GH/2);
        dc.drawText(0, GH/4, G.FONT_SYSTEM_TINY, "天气", G.TEXT_JUSTIFY_LEFT | G.TEXT_JUSTIFY_VCENTER);
        // Retrieve weather data
        var weatherData = App.Storage.getValue("weather");
        var str = "-";

        var apiKey = App.Properties.getValue("api_key");
		if (apiKey == null || apiKey.length() == 0) {
            str = "缺少 API key, 请在自行申请\n 或在公众号李二牛 \n中自行领取";
        }
        else if (App.Storage.getValue("last_location") == null) {
            str = "缺少定位信息";
        }
        
        if (weatherData != null && weatherData[0] == 401) {str = "Invalid API key";}

        if (weatherData != null && weatherData[0] == 200 && weatherData.size() > 16) {
			if (weatherData[10] == null) {weatherData[10] = 0;}

        	str = (tempCelsius ? weatherData[10].format("%.0f") : celsius2fahrenheit(weatherData[10]).format("%.0f")) + (tempCelsius ? C_SYMBOL: F_SYMBOL);
        	str += ": " + capitalize(weatherData[3]);
        }
        
        dc.drawText(0, GH*0.75, G.FONT_SYSTEM_TINY, str, G.TEXT_JUSTIFY_LEFT | G.TEXT_JUSTIFY_VCENTER);
    }

    function onHide() as Void {}

	function celsius2fahrenheit(c) {return (c * 1.8) + 32;}

	function capitalize(s) {
		if (s == null || s.length() == 0) {return s;}
		return s.substring(0,1).toUpper() + (s.length() == 1 ? "" : s.substring(1, s.length()).toLower());
	}

	function p(s) {Sys.println(s);}
}
