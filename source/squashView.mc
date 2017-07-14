using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Sensor as Snsr;
using Toybox.Activity as Act;
using Toybox.Time as Time;
using Toybox.Timer as Timer;
using Toybox.System as Sys;


var appName = "SqashApp";
var player1Name = "Home";
var player2Name = "Guests";
var player1Score = 0;
var player2Score = 0;
var servingPlayer = 0;
var p1Counter = 0;
var p2Counter = 0;
var activityStatus = 0;
var player1SetScore = 0;
var player2SetScore = 0;
var currentHR = 0;
var caloriesBurned = 0;
var activityDetails;
var systemTime;
var timeElapsed;
var timerHelper = 0;
var timeSeconds = 0;
var timeMinutes = 0;
var timeHours = 0;
var testTime = "---";
var activityTime;
var czas;
var actSec;
var actMin;
var actH;
var maxScore = 11;
var serveScore = true;



function clearScore(command) {
if (command == 1) {
player1Score = 0;
player2Score = 0;
servingPlayer = 0;
p1Counter = 0;
p2Counter = 0;}

Ui.requestUpdate();

}


function handleTime(seconds, minutes, hours)
	{
		var secondsHlp;
		var minutesHlp;
		var hoursHlp;
		
		if (seconds < 10) {secondsHlp = "0"+seconds;} else {secondsHlp = seconds;}
		if (minutes < 10) {minutesHlp = "0"+minutes;} else {minutesHlp = minutes;}
		if (hours < 10) {hoursHlp = "0"+hours;} else {hoursHlp = hours;}
		
		if (timeHours < 1) {testTime = minutesHlp + ":" + secondsHlp;}
		else {testTime = hoursHlp + ":" + minutesHlp;}
		
	}


function recordingStatus(status)
{
if (status == 1) 
{activityStatus = 1;
//todo
}
else if (status == 0) {activityStatus = 0; timeSeconds = 0; timeMinutes = 0; timeHours = 0;}
Ui.requestUpdate();
}


function modifyServe(increase) {

	if (increase == 3) {servingPlayer = 1;}

    if (increase == 1)
    {
    servingPlayer = 1;
    p2Counter = 0;
    if (serveScore == true)
    {p1Counter++;}
    else if (serveScore == false)
    {p1Counter = 2;}
    
    if (p1Counter == 2)
    {
    player1Score++;
    p1Counter = 1;
    }
    
    }
    
    else if (increase == 2)
    {
    servingPlayer = 2;
    p1Counter = 0;
    if (serveScore == true)
    {p2Counter++;}
    else if (serveScore == false)
    {p2Counter = 2;}
    
    if (p2Counter == 2)
    {
    player2Score++;
    p2Counter = 1;
    }
    
    }
    
    if (player1Score >= maxScore && (player1Score - player2Score) > 1)
    
    {
    player1SetScore++;
    player1Score = 0;
    player2Score = 0;
    p1Counter = 0;
    p2Counter = 0;
    servingPlayer = 0;
    }
    
    if (player2Score >= maxScore && (player2Score - player1Score) > 1)
    
    {
    player2SetScore++;
    player1Score = 0;
    player2Score = 0;
    p1Counter = 0;
    p2Counter = 0;
    servingPlayer = 0;
    }
    
    
    Ui.requestUpdate();
}

function actTime(time) {
actSec = (time / 1000) % 60;
actMin = (time / (1000 * 60 )) % 60;
actH = (time / (1000 * 60 * 60)) % 24;
}


class squashView extends Ui.View {

    function initialize() {
        View.initialize();
        Snsr.setEnabledSensors( [Snsr.SENSOR_HEARTRATE] );
        Snsr.enableSensorEvents( method(:onSnsr) );
        currentHR = "---";
        
    }
    
    function onSnsr(sensor_info)
    {
        var HR = sensor_info.heartRate;
        var bucket;
        if( sensor_info.heartRate != null )
        {
            currentHR = HR.toString();

        }
        else
        {
            currentHR = "---";
        }

        Ui.requestUpdate();
    }
    

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
       player1Name = Application.getApp().getProperty("player1Name"); 
       player2Name = Application.getApp().getProperty("player2Name");
       maxScore = Application.getApp().getProperty("maxScore");
       serveScore = Application.getApp().getProperty("serveScore");

	dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );    
        
    dc.drawText(65, 10, Gfx.FONT_MEDIUM, appName, Gfx.TEXT_JUSTIFY_LEFT);
   	
   	dc.fillRectangle(1, 50, 500, 2);
    
    dc.drawText(65, 60, Gfx.FONT_TINY, player1Name, Gfx.TEXT_JUSTIFY_LEFT);
    dc.drawText(65, 80, Gfx.FONT_TINY, player2Name, Gfx.TEXT_JUSTIFY_LEFT);
    dc.drawText(55, 60, Gfx.FONT_TINY, player1Score, Gfx.TEXT_JUSTIFY_RIGHT);
    dc.drawText(55, 80, Gfx.FONT_TINY, player2Score, Gfx.TEXT_JUSTIFY_RIGHT);
    
    if (player1SetScore > 0 || player2SetScore > 0) 
    {
    dc.drawText(190, 60, Gfx.FONT_TINY, player1SetScore, Gfx.TEXT_JUSTIFY_LEFT);
    dc.drawText(190, 80, Gfx.FONT_TINY, player2SetScore, Gfx.TEXT_JUSTIFY_LEFT);
    }
    
    
    if (activityStatus == 1) 
    {
    
    {  /*dc.drawText(55, 140, Gfx.FONT_TINY, "Recording...", Gfx.TEXT_JUSTIFY_LEFT);*/
    
    
    activityDetails = Act.getActivityInfo();
    systemTime = Sys.getClockTime();
    var activityTimeSec;
    activityTimeSec = activityDetails.elapsedTime;
    actTime(activityTimeSec);
    
    
    if (activityDetails.calories != null) {caloriesBurned = activityDetails.calories;} else {caloriesBurned = "---";}
    
    dc.drawText(65, 125, Gfx.FONT_TINY, "bpm", Gfx.TEXT_JUSTIFY_LEFT);
    dc.drawText(125, 125, Gfx.FONT_TINY, "ET", Gfx.TEXT_JUSTIFY_LEFT);
    dc.drawText(125, 145, Gfx.FONT_TINY, "CT", Gfx.TEXT_JUSTIFY_LEFT);
    dc.drawText(65, 145, Gfx.FONT_TINY, "kcal", Gfx.TEXT_JUSTIFY_LEFT);
    
    dc.drawText(55, 125, Gfx.FONT_TINY, currentHR, Gfx.TEXT_JUSTIFY_RIGHT);
    dc.drawText(55, 145, Gfx.FONT_TINY, caloriesBurned, Gfx.TEXT_JUSTIFY_RIGHT);
    
    if (actMin < 60) {dc.drawText(205, 125, Gfx.FONT_TINY, actMin.format("%02d") + ":" + actSec.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT);} 
    
    else {dc.drawText(205, 125, Gfx.FONT_TINY, actH.format("%02d") + ":" + actMin.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT);}
    
    dc.drawText(205, 145, Gfx.FONT_TINY, systemTime.hour + ":" + systemTime.min.format("%02d") , Gfx.TEXT_JUSTIFY_RIGHT);
    
    dc.fillRectangle(1, 180, 500, 2);
    
    dc.drawText(75, 195, Gfx.FONT_TINY, "Recording...", Gfx.TEXT_JUSTIFY_LEFT);
    
    }
    }
    //actSec +":"+ actMin +":"+ actH
    
    else if (activityStatus == 0) {dc.drawText(55, 140, Gfx.FONT_TINY, "Press select to \nrecord activity", Gfx.TEXT_JUSTIFY_LEFT);}
    
    dc.fillRectangle(1, 120, 500, 2);
    
    if (servingPlayer == 1)
    {dc.fillCircle(150, 73, 5);}
    
    else if (servingPlayer == 2)
    {dc.fillCircle(150, 95, 5);}
    
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
