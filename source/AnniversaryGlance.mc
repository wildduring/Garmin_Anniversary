import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

(:glance)
class AnniversaryGlance extends WatchUi.GlanceView{

    private var _passed as String;
    private var _left as String;
    private var _day as String;
    private var _days as String;

    private var _anniversaries as Lang.Array;

    private var _name;
    private var _anni;
    private var _dura;

    function initialize(){
        GlanceView.initialize();

        _passed = WatchUi.loadResource($.Rez.Strings.passed) as String;
        _left = WatchUi.loadResource($.Rez.Strings.left) as String;
        _day = WatchUi.loadResource($.Rez.Strings.day) as String;
        _days = WatchUi.loadResource($.Rez.Strings.days) as String;

        _name = "汉江畔";
        _anni = new Time.Moment(1674172800);
        _dura = 0;

        _anniversaries = Storage.getValue("anniversaries");    //从 Storage 加载你的纪念日数据数组
        if(_anniversaries != null && _anniversaries instanceof Array) {
            for(var i = 0; i<_anniversaries.size(); i++) {
                var item = _anniversaries[i] as Dictionary;
                if(item["showInGlance"]) {
                    _name = item["name"].toString();
                    _anni = new Time.Moment(item["date"]);
                    break;
                }
            }
        }
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.GlanceLayout(dc));
    }

    function onUpdate(dc){
        _dura = calculate_duration(_anni);

        updateLabelText("anniversary_name", _name);
        updateLabelText("anniversary_PoL", PoLText(_dura));
        updateLabelText("anniversary_date", dateText(_dura));

        var spacingX = 2;
        var spacingY = 2;
        var nameTextX = 0;
        var nameTextY = (dc.getHeight() - dc.getFontHeight(Graphics.FONT_SMALL) - dc.getFontHeight(Graphics.FONT_LARGE) - spacingY) / 2 ;
        var PoLTextX = nameTextX + dc.getTextWidthInPixels(_name, Graphics.FONT_SMALL) + spacingX;
        var PoLTextY = nameTextY + dc.getFontHeight(Graphics.FONT_SMALL) - dc.getFontHeight(Graphics.FONT_XTINY);
        var dateTextX = nameTextX;
        var dateTextY = nameTextY + dc.getFontHeight(Graphics.FONT_SMALL) + spacingY;
        updateLabelLocat("anniversary_name", nameTextX, nameTextY);
        updateLabelLocat("anniversary_PoL", PoLTextX, PoLTextY);
        updateLabelLocat("anniversary_date", dateTextX, dateTextY);

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
        var now = Time.now();
        var dura = now.compare(anni)/3600/24;
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
        if (duration.abs() <= 1) {
            return duration.abs().toString() + _day;
        }
        else {
            return duration.abs().toString() + _days;
        }
    }

}