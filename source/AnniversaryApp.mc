import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

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
    (:typecheck(disableBackgroundCheck))
    public function getInitialView() as [ Views ] or [ Views, InputDelegates ] {
        return [ new AnniversaryMenu(), new AnniversaryMenuDelegate()];
    }

    (:typecheck(disableBackgroundCheck) :glance)
    public function getGlanceView() as [ GlanceView ] or [ GlanceView, GlanceViewDelegate ] or Null {
        return [ new AnniversaryGlance() ];
    }

    (:background)
    public function getServiceDelegate() as [ $.Toybox.System.ServiceDelegate ] {
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
