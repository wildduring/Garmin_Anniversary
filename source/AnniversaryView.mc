import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

/*
enum ImageKeys {
    1 = $.Rez.Drawables.anniversary,
    2 = $.Rez.Drawables.work,
    3 = $.Rez.Drawables.love, 
    4 = $.Rez.Drawables.marry,
    5 = $.Rez.Drawables.graduate,
    6 = $.Rez.Drawables.birth,
    7 = $.Rez.Drawables.studay,
    8 = $.Rez.Drawables.spring
}
*/

class AnniversaryView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
