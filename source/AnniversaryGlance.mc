import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Math;

class AnniversaryGlance extends WatchUi.GlanceView{

    private var _passed as String;
    private var _left as String;
    private var _day as String;
    private var _days as String;
    private var _lanber as Number;

    private var _anni;
    private var _dura;

    function initialize(){
        GlanceView.initialize();

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
        setLayout(Rez.Layouts.GlanceLayout(dc));
    }

    function onUpdate(dc){
        _anni = new Time.Moment(Properties.getValue("date0"));
        _dura = calculate_duration(_anni);

        updateLabelText("anniversary_name", Properties.getValue("name0").toString());
        updateLabelText("anniversary_PoL", PoLText(_dura));
        updateLabelText("anniversary_date", dateText(_dura));

        updateLabelLocat("anniversary_name", 0, dc.getHeight()/14);
        updateLabelLocat("anniversary_PoL", Graphics.getFontDescent(Graphics.FONT_SMALL)*Properties.getValue("name0").toString().length()*_lanber.toNumber()+10, dc.getHeight()/14+Graphics.getFontDescent(Graphics.FONT_SMALL)-Graphics.getFontDescent(Graphics.FONT_XTINY));
        updateLabelLocat("anniversary_date", 0, dc.getHeight()/14+Graphics.getFontAscent(Graphics.FONT_SMALL));

        View.onUpdate(dc);
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
        var dura = Math.ceil(today.compare(anni).toDouble()/3600/24).toNumber();
        return dura;
    }

    private function PoLText(duration as Number) as String{
        if (duration <= 0) {
            return _left;
        }
        else {
            return _passed;
        }
    }

    private function dateText(duration as Number) as String{
        if (duration == 0) {
            return duration.abs().toString() + _day;
        }
        else {
            return duration.abs().toString() + _days;
        }
    }

}