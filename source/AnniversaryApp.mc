import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

(:glance)
class AnniversaryApp extends Application.AppBase {

    public function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    public function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    public function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    public function getInitialView() as [ Views ] or [ Views, InputDelegates ] {
        return [ new AnniversaryMenu(), new AnniversaryMenuDelegate()];
    }

    public function getGlanceView() as [ GlanceView ] or [ GlanceView, GlanceViewDelegate ] or Null {
        return [ new AnniversaryGlance() ];
    }

    public function getServiceDelegate() as [ System.ServiceDelegate ] {
        return [new AnniversaryBackGroundDelegate()];
    }

    //! For this app all that needs to be done is trigger a WatchUi refresh
    //! since the settings are only used in onUpdate().
    public function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

}

function getApp() as AnniversaryApp {
    return Application.getApp() as AnniversaryApp;
}
