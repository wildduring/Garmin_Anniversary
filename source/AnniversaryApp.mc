import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class AnniversaryApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new AnniversaryView() ] as Array<Views or InputDelegates>;
    }

    function getGlanceView() as Array<GlanceView or GlanceViewDelegate>? {
        return [ new AnniversaryGlance() ] as Array<GlanceView or GlanceViewDelegate>;
    }

}

function getApp() as AnniversaryApp {
    return Application.getApp() as AnniversaryApp;
}