import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Math;

class AnniversaryView extends WatchUi.View {

    private var _passed as String;
    private var _left as String;
    private var _day as String;
    private var _days as String;

    private var _anni;
    private var _dura;

    private var _thiswindow as Number;

    function initialize(ThisWindow as Number) {
        View.initialize();
        _passed = WatchUi.loadResource($.Rez.Strings.passed) as String;
        _left = WatchUi.loadResource($.Rez.Strings.left) as String;
        _day = WatchUi.loadResource($.Rez.Strings.day) as String;
        _days = WatchUi.loadResource($.Rez.Strings.days) as String;
        _anni = 0;
        _dura = 0;

        _thiswindow = ThisWindow;
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
        
        _anni = new Time.Moment(Properties.getValue("date"+_thiswindow.toString()));
        _dura = calculate_duration(_anni);

        updateBitmapIcon("anniversary_icon", icon_translate(Properties.getValue("icon"+_thiswindow.toString()).toString()));

        updateLabelText("anniversary_name", Properties.getValue("name"+_thiswindow.toString()).toString());
        updateLabelText("anniversary_date", date_translate(_anni));
        updateLabelText("anniversary_PoL", PoLText(_dura));
        updateLabelText("anniversary_number_text", _dura.abs().toString());
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

    //! Update a bitmap with new icon
    //! @param bitmapId The Bitmap to update
    //! @param identifier The Bitmap Icon
    private function updateBitmapIcon(bitmapId as String, identifier as Lang.ResourceId) as Void {
        var drawable = View.findDrawableById(bitmapId);
        if (drawable != null) {
            (drawable as Bitmap).setBitmap(identifier);
        }
    }

    private function calculate_duration(anni as Time.Moment) as Number{
        var today = new Time.Moment(Time.today().value());
        var dura = Math.ceil(today.compare(anni).toDouble()/3600/24).toNumber();
        return dura;
    }


    private function icon_translate(icon_number as String) as Lang.ResourceId{
        if (icon_number.equals("1")){
            return $.Rez.Drawables.anniversary40;
        }
        if (icon_number.equals("2")){
            return $.Rez.Drawables.work40;
        }
        if (icon_number.equals("3")){
            return $.Rez.Drawables.love40;
        }
        if (icon_number.equals("4")){
            return $.Rez.Drawables.marry40;
        }
        if (icon_number.equals("5")){
            return $.Rez.Drawables.graduate40;
        }
        if (icon_number.equals("6")){
            return $.Rez.Drawables.birth40;
        }
        if (icon_number.equals("7")){
            return $.Rez.Drawables.studay40;
        }
        if (icon_number.equals("8")){
            return $.Rez.Drawables.spring40;
        }
        else {
            return $.Rez.Drawables.anniversary40;
        }
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
        if (duration.abs() <= 1) {
            return _day;
        }
        else {
            return _days;
        }
    }

}

class AnniversaryViewDelegate extends WatchUi.BehaviorDelegate{

    private var _thiswindow as Number;
    private var _totalwindow as Number;

    //! Constructor
    public function initialize(ThisWindow as Number, TotalWindow as Number) {
        BehaviorDelegate.initialize();
        _thiswindow = ThisWindow;
        _totalwindow = TotalWindow;
    }

    //! Handle going to the next view
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        if(_thiswindow < _totalwindow){
            WatchUi.switchToView(new AnniversaryView(_thiswindow+1), new AnniversaryViewDelegate(_thiswindow+1, _totalwindow), WatchUi.SLIDE_LEFT);
            return true;
        }
        return false;
    }

    //! Handle going to the previous view
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        if(_thiswindow > 0){
            WatchUi.switchToView(new AnniversaryView(_thiswindow-1), new AnniversaryViewDelegate(_thiswindow-1, _totalwindow), WatchUi.SLIDE_RIGHT);
            return true;
        }
        return false;
    }
}