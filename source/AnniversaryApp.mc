import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

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

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new AnniversaryView(0), new AnniversaryViewDelegate(0, Properties.getValue("Anniversary_num"))] as Array<Views or InputDelegates>;
    }

    function getGlanceView() as Array<GlanceView or GlanceViewDelegate>? {
        return [ new AnniversaryGlance() ] as Array<GlanceView or GlanceViewDelegate>;
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
