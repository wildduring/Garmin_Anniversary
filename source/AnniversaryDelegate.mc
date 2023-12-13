import Toybox.Lang;
import Toybox.WatchUi;

class AnniversaryDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        //WatchUi.pushView(new Rez.Menus.MainMenu(), new AnniversaryMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}