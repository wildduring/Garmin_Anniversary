import Toybox.Application;
import Toybox.Background;
import Toybox.Lang;
import Toybox.Notifications;
import Toybox.System;
import Toybox.Time;

(:background)
class AnniversaryBackGroundDelegate extends System.ServiceDelegate {

    private const STORAGE_KEY = "anniversaries";
    private var _anniversaries = [] as Lang.Array;

    public function initialize() {
        ServiceDelegate.initialize();
    }

    public function onTemporalEvent() as Void {
        var AnniversaryItem = [] as Lang.Array;
        _anniversaries = Storage.getValue(STORAGE_KEY) as Lang.Array;    //读取纪念日列表
        for(var i = 0; i<_anniversaries.size(); i++) {    //遍历纪念日列表
            var item = _anniversaries[i] as Lang.Dictionary;
            if(item["shouldNotify"]) {
                var NotifyTime = new Time.Moment(item["NotifyTime"]);
                if(Time.now().compare(NotifyTime) >= 0) {    //NotifyTime已经过去或者在当下
                    AnniversaryItem.add(item);
                }
            }
        }
        if(AnniversaryItem.size() > 0) {    //如果存在提醒
            AnniversaryItem.sort(new AnniversaryComparatorInterface() as Lang.Comparator);    //将提纪念日列表按照倒序排序，越接近现在越靠前
            var item = AnniversaryItem[0] as Lang.Dictionary;    //最接近现在的提醒日期的纪念日就是触发提醒的纪念日
            var _anni = new Time.Moment(item["date"]);
            var _dura = calculate_duration(_anni);
            var NotifyName = item["name"];
            var NotifySubtitle = NotifyName + PoLText(_dura) + dateText(_dura);
            Notifications.showNotification(NotifyName, NotifySubtitle, {:icon=>icon_translate(item["icon"]), :body=>NotifySubtitle});
        }
        updateTemporalEvent();
    }

    private function updateTemporalEvent() {
        var TemporalEventTime = [] as Lang.Array;
        for(var i = 0; i<_anniversaries.size(); i++) {    //遍历纪念日列表
            var item = _anniversaries[i] as Lang.Dictionary;
            if(item["shouldNotify"]) {
                var NotifyTime = new Time.Moment(item["NotifyTime"]);
                if(Time.now().compare(NotifyTime) < 0) {    //NotifyTime在未来
                    TemporalEventTime.add(NotifyTime.value());
                }
            }
        }
        if(TemporalEventTime.size()>0) {    //如果存在提醒
            TemporalEventTime.sort(null);
            var time = new Time.Moment(TemporalEventTime[0]);
            Background.registerForTemporalEvent(time);
        } else {
            Background.deleteTemporalEvent();    //如果没有提醒，清除所有提醒
        }
    }

    private function calculate_duration(anni as Time.Moment) as Number{
        var now = Time.now();
        var dura = now.compare(anni)/3600/24;
        return dura;
    }

    private function PoLText(duration as Number) as String{
        if (duration <= 0) {
            return Application.loadResource(Rez.Strings.left) as String;
        }
        else {
            return Application.loadResource(Rez.Strings.passed) as String;
        }
    }

    private function dateText(duration as Number) as String{
        if (duration.abs() <= 1) {
            return duration.abs().toString() + Application.loadResource(Rez.Strings.day) as String;
        }
        else {
            return duration.abs().toString() + Application.loadResource(Rez.Strings.days) as String;
        }
    }

    private function icon_translate(icon_number as String) as Lang.ResourceId{
        if (icon_number.equals("1")){
            return Rez.Drawables.anniversary40;
        }
        if (icon_number.equals("2")){
            return Rez.Drawables.work40;
        }
        if (icon_number.equals("3")){
            return Rez.Drawables.love40;
        }
        if (icon_number.equals("4")){
            return Rez.Drawables.marry40;
        }
        if (icon_number.equals("5")){
            return Rez.Drawables.graduate40;
        }
        if (icon_number.equals("6")){
            return Rez.Drawables.birth40;
        }
        if (icon_number.equals("7")){
            return Rez.Drawables.studay40;
        }
        if (icon_number.equals("8")){
            return Rez.Drawables.spring40;
        }
        else {
            return Rez.Drawables.anniversary40;
        }
    }

}

(:background)
class AnniversaryComparatorInterface {    //比较函数
    function compare(item1 as Lang.Dictionary, item2 as Lang.Dictionary) as Lang.Number {
        return item2["NotifyTime"] - item1["NotifyTime"];
    }
}
