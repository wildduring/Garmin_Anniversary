import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class AnniversaryEditMenu extends WatchUi.Menu2 {

    const STORAGE_KEY = "anniversaries";

    private var _index as Number;
    private var _anniversaries as Array;

    public function initialize(index as Number) {
        Menu2.initialize({
            :title => new $.DrawableEditTitle()
        });
        _index = index;
        _anniversaries = [];
    }

    public function onShow() as Void {
        _anniversaries = Storage.getValue(STORAGE_KEY) as Array;
        if (_index < 0) {
            _index = _anniversaries.size();
            _anniversaries.add({
                "name" => "汉江畔",
                "date" => 1674172800,
                "icon" => "1",
                "showInGlance" => false,
                "shouldNotify" => false,
                "NotifyTime" => 1674172800
            });
        }
        var _item = _anniversaries[_index] as Dictionary;
        var _anni = new Time.Moment(_item["date"]);

        while(self.deleteItem(0)) {
            //pass
        }

        self.addItem(new MenuItem($.Rez.Strings.set_anni_name, _item["name"], "name", null));
        self.addItem(new MenuItem($.Rez.Strings.set_anni_date, date_translate(_anni), "date", null));
        self.addItem(new IconMenuItem($.Rez.Strings.set_anni_icon, null, "icon", new DrawableEditIcon(icon_translate(_item["icon"])), null));
        self.addItem(new IconMenuItem($.Rez.Strings.set_anni_showInGlance, null, "showInGlance", new DrawableEditIcon(_item["showInGlance"] ? $.Rez.Drawables.switch_on40 : $.Rez.Drawables.switch_off40), null));
        self.addItem(new IconMenuItem($.Rez.Strings.set_anni_shouldNotify, null, "shouldNotify", new DrawableEditIcon(_item["shouldNotify"] ? $.Rez.Drawables.switch_on40 : $.Rez.Drawables.switch_off40), null));
        if(_item["shouldNotify"]) {
            var _NotifyTime = new Time.Moment(_item["NotifyTime"]);
            var _temp_date = Gregorian.info(_NotifyTime, Time.FORMAT_SHORT);
            var NotifyTime = Lang.format("$1$.$2$.$3$ $4$:$5$", [
                _temp_date.year.format("%04u"),
                _temp_date.month.format("%02u"),
                _temp_date.day.format("%02u"),
                _temp_date.hour.format("%02u"),
                _temp_date.min.format("%02u")
                ]) as String;
            self.addItem(new MenuItem($.Rez.Strings.set_anni_NotifyTime, NotifyTime, "NotifyTime", null));
        }
        self.addItem(new MenuItem($.Rez.Strings.set_anni_delete, null, "delete", null));
    }

    public function onHide() as Void {
        Storage.setValue(STORAGE_KEY, _anniversaries);
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

    public function set_value(key as String, value as Lang.Object) {
        if(key.equals("name")) {
            _anniversaries[_index].put("name", value);
            Storage.setValue(STORAGE_KEY, _anniversaries);
        } else if(key.equals("date")) {
            _anniversaries[_index].put("date", value);
            Storage.setValue(STORAGE_KEY, _anniversaries);
        } else if(key.equals("icon")) {
            _anniversaries[_index].put("icon", value);
            Storage.setValue(STORAGE_KEY, _anniversaries);
        } else if(key.equals("showInGlance")) {
            var _item = _anniversaries[_index] as Dictionary;
            _anniversaries[_index].put("showInGlance", !_item["showInGlance"]);
            Storage.setValue(STORAGE_KEY, _anniversaries);
            _item = _anniversaries[_index] as Dictionary;
            self.updateItem(new IconMenuItem($.Rez.Strings.set_anni_showInGlance, null, "showInGlance", new DrawableEditIcon(_item["showInGlance"] ? $.Rez.Drawables.switch_on40 : $.Rez.Drawables.switch_off40), null), self.findItemById("showInGlance"));
        } else if(key.equals("shouldNotify")) {
            var _item = _anniversaries[_index] as Dictionary;
            _anniversaries[_index].put("shouldNotify", !_item["shouldNotify"]);
            Storage.setValue(STORAGE_KEY, _anniversaries);
            _item = _anniversaries[_index] as Dictionary;
            self.updateItem(new IconMenuItem($.Rez.Strings.set_anni_shouldNotify, null, "shouldNotify", new DrawableEditIcon(_item["shouldNotify"] ? $.Rez.Drawables.switch_on40 : $.Rez.Drawables.switch_off40), null), self.findItemById("shouldNotify"));
            if (_item["shouldNotify"]) {
                self.deleteItem(self.findItemById("delete"));
                var _NotifyTime = new Time.Moment(_item["NotifyTime"]);
                var _temp_date = Gregorian.info(_NotifyTime, Time.FORMAT_SHORT);
                var NotifyTime = Lang.format("$1$.$2$.$3$ $4$:$5$", [
                    _temp_date.year.format("%04u"),
                    _temp_date.month.format("%02u"),
                    _temp_date.day.format("%02u"),
                    _temp_date.hour.format("%02u"),
                    _temp_date.min.format("%02u")
                ]) as String;
                self.addItem(new MenuItem($.Rez.Strings.set_anni_NotifyTime, NotifyTime, "NotifyTime", null));
                self.addItem(new MenuItem($.Rez.Strings.set_anni_delete, null, "delete", null));
            } else {
                self.deleteItem(self.findItemById("NotifyTime"));
            }
        } else if(key.equals("NotifyTime")) {
            
        } else if(key.equals("delete")) {
            _anniversaries.remove(_anniversaries[_index]);
            Storage.setValue(STORAGE_KEY, _anniversaries);
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
        }
    }

    public function getAnniversaryDictionary() as Lang.Dictionary {
        return _anniversaries[_index];
    }

}

class AnniversaryEditMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _view as AnniversaryEditMenu;

    public function initialize(view as AnniversaryEditMenu) {
        Menu2InputDelegate.initialize();
        _view = view;
    }

    public function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String;

        if(id.equals("name")) {
            if(WatchUi has :TextPicker) {
                WatchUi.pushView(new WatchUi.TextPicker(item.getSubLabel()), new KeyboardDelegate(_view), WatchUi.SLIDE_LEFT);
            }
        } else if(id.equals("date")) {
            var default_time  = new Time.Moment(_view.getAnniversaryDictionary()["date"]);
            WatchUi.pushView(new AnniversaryDatePicker(default_time), new DatePickerDelegate(_view, default_time, false), WatchUi.SLIDE_LEFT);
        } else if(id.equals("icon")) {
            var menu = new WatchUi.Menu2({});
            menu.addItem(new WatchUi.IconMenuItem($.Rez.Strings.anniversary, null, "1", new DrawableEditIcon($.Rez.Drawables.anniversary40), null));
            menu.addItem(new WatchUi.IconMenuItem($.Rez.Strings.work, null, "2", new DrawableEditIcon($.Rez.Drawables.work40), null));
            menu.addItem(new WatchUi.IconMenuItem($.Rez.Strings.love, null, "3", new DrawableEditIcon($.Rez.Drawables.love40), null));
            menu.addItem(new WatchUi.IconMenuItem($.Rez.Strings.marry, null, "4", new DrawableEditIcon($.Rez.Drawables.marry40), null));
            menu.addItem(new WatchUi.IconMenuItem($.Rez.Strings.graduate, null, "5", new DrawableEditIcon($.Rez.Drawables.graduate40), null));
            menu.addItem(new WatchUi.IconMenuItem($.Rez.Strings.birth, null, "6", new DrawableEditIcon($.Rez.Drawables.birth40), null));
            menu.addItem(new WatchUi.IconMenuItem($.Rez.Strings.studay, null, "7", new DrawableEditIcon($.Rez.Drawables.studay40), null));
            menu.addItem(new WatchUi.IconMenuItem($.Rez.Strings.spring, null, "8", new DrawableEditIcon($.Rez.Drawables.spring40), null));
            WatchUi.pushView(menu, new AnniversaryIconMenuDelegate(_view), WatchUi.SLIDE_LEFT);
        } else if(id.equals("showInGlance")) {
            _view.set_value("showInGlance", 0);
        } else if(id.equals("shouldNotify")) {
            _view.set_value("shouldNotify", 0);
        } else if(id.equals("NotifyTime")) {
            
        } else if(id.equals("delete")) {
            _view.set_value("delete", 0);
        }
    }

}

class DrawableEditTitle extends WatchUi.Drawable {

    //! Constructor
    public function initialize() {
        Drawable.initialize({});
    }

    //! Draw the application icon and main menu title
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        var spacing = 2;
        var appIcon = WatchUi.loadResource($.Rez.Drawables.settings40) as BitmapResource;
        var bitmapWidth = appIcon.getWidth();
        var labelWidth = dc.getTextWidthInPixels(Application.loadResource($.Rez.Strings.settings), Graphics.FONT_SMALL);

        var bitmapX = (dc.getWidth() - (bitmapWidth + spacing + labelWidth)) / 2;
        var bitmapY = (dc.getHeight() - appIcon.getHeight()) / 2;
        var labelX = bitmapX + bitmapWidth + spacing;
        var labelY = dc.getHeight() / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.drawBitmap(bitmapX, bitmapY, appIcon);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(labelX, labelY, Graphics.FONT_MEDIUM, Application.loadResource($.Rez.Strings.settings), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

}

class DrawableEditIcon extends WatchUi.Drawable {

    private var _icon as Lang.ResourceId;

    //! Constructor
    public function initialize(icon as Lang.ResourceId) {
        Drawable.initialize({});
        _icon = icon;
    }

    //! Draw the application icon and main menu title
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        var appIcon = WatchUi.loadResource(_icon) as BitmapResource;
        var bitmapX = (dc.getWidth() - appIcon.getWidth()) / 2;
        var bitmapY = (dc.getHeight() - appIcon.getHeight()) / 2;

        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        dc.clear();

        dc.drawBitmap(bitmapX, bitmapY, appIcon);
    }

}

class KeyboardDelegate extends WatchUi.TextPickerDelegate {

    private var _view as AnniversaryEditMenu;

    public function initialize(view as AnniversaryEditMenu) {
        WatchUi.TextPickerDelegate.initialize();
        _view = view;
    }

    public function onTextEntered(text as String, changed as Boolean) as Boolean {
        _view.set_value("name", text.toString());
        return true;
    }

}

class AnniversaryIconMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _view as AnniversaryEditMenu;

    public function initialize(view as AnniversaryEditMenu) {
        Menu2InputDelegate.initialize();
        _view = view;
    }

    public function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String;
        _view.set_value("icon", id);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

}
