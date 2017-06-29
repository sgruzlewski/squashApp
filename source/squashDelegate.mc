using Toybox.WatchUi as Ui;
using Toybox.ActivityRecording as Record;
using Toybox.Attention as Attention;

var session = null;

class squashDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        clearScore(1);
        return true;
    }
    
    function onPreviousPage() {
        modifyServe(1);
        
        return true;
    }
    
    function onNextPage() {
        modifyServe(2);
        
        return true;
    }  
    
    function onSelect() {
    	
    	var vibrateData =  [new Attention.VibeProfile( 100, 1000 )];
    	Attention.vibrate(vibrateData);
    
        if( Toybox has :ActivityRecording ) {
            if( ( session == null ) || ( session.isRecording() == false ) ) {
                session = Record.createSession({:name=>"Squash", :sport=>Record.SPORT_TRAINING});
                session.start();
                recordingStatus(1);
                Attention.playTone(1);
                
            }
            else if( ( session != null ) && session.isRecording() ) {
                session.stop();
                session.save();
                session = null;
                recordingStatus(0);
                Attention.playTone(2);
                
            }
        }
        return true;
    }     

}