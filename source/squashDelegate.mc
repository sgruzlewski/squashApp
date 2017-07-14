using Toybox.WatchUi as Ui;
using Toybox.ActivityRecording as Record;
using Toybox.Attention as Attention;
using Toybox.System as Sys;
using Toybox.FitContributor as Fit;

var session = null;
var session_field_player_1;
var session_field_player_2;

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
    
    function onBack() {
    	var dialogHeaderString = "Quit?";
    	var dialog;
        dialog = new Ui.Confirmation(dialogHeaderString);
        Ui.pushView(dialog, new ConfirmationDialogDelegate(), Ui.SLIDE_IMMEDIATE);
        return true;
    }
    
    function onSelect() {
    	
    	var vibrateData =  [new Attention.VibeProfile( 100, 1000 )];
    	Attention.vibrate(vibrateData);
    
        if( Toybox has :ActivityRecording ) {
            if( ( session == null ) || ( session.isRecording() == false ) ) {
                session = Record.createSession({:name=>"Squash", :sport=>Record.SPORT_GENERIC, :subSport=>Record.SUB_SPORT_MATCH});
                /*session_field_player_1 = session.createField("Player 1 Score", 0, Fit.DATA_TYPE_FLOAT, {:mesgType=>Fit.MESG_TYPE_RECORD, :units=>"B"});
                session_field_player_2 = session.createField("Player 2 Score", 1, Fit.DATA_TYPE_FLOAT, {:mesgType=>Fit.MESG_TYPE_RECORD, :units=>"B"});*/
                session.start();
                recordingStatus(1);
                Attention.playTone(1);
                
            }
            else if( ( session != null ) && session.isRecording() ) {
                Attention.playTone(2);
                Ui.pushView(new Rez.Menus.MainMenu(), new squashAppMenuDelegate(), Ui.SLIDE_UP);
       		 	return true;
                
            }
        }
        return true;
    }     
}

class ConfirmationDialogDelegate extends Ui.ConfirmationDelegate {
    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(value) {
        if (value == 0) {
            
        }
        else {
        Sys.exit();
        }
    }
}

