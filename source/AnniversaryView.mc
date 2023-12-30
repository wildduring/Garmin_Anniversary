import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Time;
import Toybox.Time.Gregorian;

enum ImageKeys {
    a1 = $.Rez.Drawables.anniversary,
    a2 = $.Rez.Drawables.work,
    a3 = $.Rez.Drawables.love,
    a4 = $.Rez.Drawables.marry,
    a5 = $.Rez.Drawables.graduate,
    a6 = $.Rez.Drawables.birth,
    a7 = $.Rez.Drawables.studay,
    a8 = $.Rez.Drawables.spring
}

class AnniversaryView extends WatchUi.View {

    private var _passed as String;
    private var _left as String;
    private var _day as String;
    private var _days as String;
    private var _lanber as Number;

    private var _anni;
    private var _dura;

    function initialize() {
        View.initialize();

        _passed = WatchUi.loadResource($.Rez.Strings.passed) as String;
        _left = WatchUi.loadResource($.Rez.Strings.left) as String;
        _day = WatchUi.loadResource($.Rez.Strings.day) as String;
        _days = WatchUi.loadResource($.Rez.Strings.days) as String;
        _lanber = WatchUi.loadResource($.Rez.Strings.lanber) as Number;
        _anni = 0;
        _dura = 0;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        
        _anni = new Time.Moment(Properties.getValue("date0"));
        _dura = calculate_duration(_anni);

        updateLabelText("anniversary_name", Properties.getValue("name0").toString());
        updateLabelText("anniversary_date", date_translate(_anni));
        updateLabelText("anniversary_PoL", PoLText(_dura));
        updateLabelText("anniversary_number_text", _dura.toString());
        updateLabelText("anniversary_day_text", dayText(_dura));
        
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    //! Update a label with new text
    //! @param labelId The label to update
    //! @param labelText The text for the label
    private function updateLabelText(labelId as String, labelText as String) as Void {
        var drawable = View.findDrawableById(labelId);
        if (drawable != null) {
            (drawable as Text).setText(labelText);
        }
    }

    //! Update a label with new location
    //! @param labelId The label to update
    //! @param labelX The X for the label
    //! @param labelY The Y for the label
    private function updateLabelLocat(labelId as String, labelX as Number, labelY as Number) as Void {
        var drawable = View.findDrawableById(labelId);
        if (drawable != null) {
            (drawable as Text).setLocation(labelX, labelY);
        }
    }

    private function calculate_duration(anni as Time.Moment) as Number{
        var today = new Time.Moment(Time.today().value());
        var dura = today.compare(anni)/3600/24;
        return dura;
    }

    private function date_translate(date as Time.Moment) as String{
        var language = WatchUi.loadResource($.Rez.Strings.UserLanguage) as String;
        if (language.equals("ENG")){
            var trans_day = Gregorian.info(date, Time.FORMAT_MEDIUM);
            var dateString = Lang.format(
                "$1$ $2$ $3$",
                [
                    trans_day.day,
                    trans_day.month,
                    trans_day.year
                ]
            );
            return dateString;
        }
        else if (language.equals("ZHS")){
            var trans_day = Gregorian.info(date, Time.FORMAT_SHORT);
            var dateString = Lang.format(
                "$1$年$2$月$3$日",
                [
                    trans_day.year,
                    trans_day.month,
                    trans_day.day
                ]
            );
            return dateString;
        }
        else{
            var trans_day = Gregorian.info(date, Time.FORMAT_MEDIUM);
            var dateString = Lang.format(
                "$1$ $2$ $3$",
                [
                    trans_day.day,
                    trans_day.month,
                    trans_day.year
                ]
            );
            return dateString;
        }

    }

    private function PoLText(duration as Number) as String{
        if (duration <= 0) {
            return _left;
        }
        else {
            return _passed;
        }
    }

    private function dayText(duration as Number) as String{
        if (duration == 0) {
            return _day;
        }
        else {
            return _days;
        }
    }

}
