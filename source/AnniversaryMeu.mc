import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Time;
import Toybox.WatchUi;

class AnniversaryMenu extends WatchUi.CustomMenu {

    const STORAGE_KEY = "anniversaries";
    private var _anniversaries as Array;
    private var _dirty_anniversaries as Boolean;

    public function initialize() {
        CustomMenu.initialize(80, Graphics.COLOR_BLACK, {
            :title => new $.DrawableMenuTitle()
        });
        _anniversaries = [];
        _dirty_anniversaries = false;
    }

    public function onShow() as Void {
        _anniversaries = Storage.getValue(STORAGE_KEY);
        if(_anniversaries == null || !(_anniversaries instanceof Array)) {
            _anniversaries = [];
            _dirty_anniversaries = true;
        }

        while(self.deleteItem(0)) {
            //pass
        }

        for(var i = 0; i<_anniversaries.size(); i++) {
            var item = _anniversaries[i];
            if(!(item instanceof Dictionary)) {
                _anniversaries = [];
                _dirty_anniversaries = true;
                break;
            }
            self.addItem(new $.CustomAnniItem(i.toString(), item["name"], item["date"], item["icon"]));
        }

        self.addItem(new $.CustomAnniItem("add_anniversary", Application.loadResource($.Rez.Strings.add_new), -1, ""));
    }

    public function onHide() as Void {
        if(_dirty_anniversaries) {
            _dirty_anniversaries = false;
            Storage.setValue(STORAGE_KEY, _anniversaries);
        }
    }

}

class AnniversaryMenuDelegate extends WatchUi.Menu2InputDelegate {

    public function initialize(){
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String;
        if(id.equals("add_anniversary")) {
            var view = new $.AnniversaryEditMenu(-1);
            WatchUi.pushView(view, new $.AnniversaryEditMenuDelegate(view), WatchUi.SLIDE_LEFT);
        } else {
            var view = new $.AnniversaryEditMenu(id.toNumber());
            WatchUi.pushView(view, new $.AnniversaryEditMenuDelegate(view), WatchUi.SLIDE_LEFT);
        }
    }

}

class DrawableMenuTitle extends WatchUi.Drawable {

    //! Constructor
    public function initialize() {
        Drawable.initialize({});
    }

    //! Draw the application icon and main menu title
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        var spacing = 2;
        var appIcon = WatchUi.loadResource($.Rez.Drawables.LauncherIcon) as BitmapResource;
        var bitmapWidth = appIcon.getWidth();
        var labelWidth = dc.getTextWidthInPixels(Application.loadResource($.Rez.Strings.anniversary).substring(0, 4), Graphics.FONT_SMALL);

        var bitmapX = (dc.getWidth() - (bitmapWidth + spacing + labelWidth)) / 2;
        var bitmapY = (dc.getHeight() - appIcon.getHeight()) / 2;
        var labelX = bitmapX + bitmapWidth + spacing;
        var labelY = dc.getHeight() / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.drawBitmap(bitmapX, bitmapY, appIcon);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(labelX, labelY, Graphics.FONT_MEDIUM, Application.loadResource($.Rez.Strings.anniversary).substring(0, 4), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

}

class CustomAnniItem extends WatchUi.CustomMenuItem {

    private var _id as String;
    private var _name as String;
    private var _date as Number;
    private var _icon as String;

    //! Constructor
    public function initialize(id as String, name as String, date as Number, icon as String) {
        CustomMenuItem.initialize(id, { });

        _id = id;
        _name = name;
        _date = date;
        _icon = icon;
    }

    //! Draw the application icon and main menu title
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        var _anni = new Time.Moment(_date);
        var _dura = calculate_duration(_anni);

        if(_id.equals("add_anniversary")) {
            var spacing = 2;
            var appIcon = WatchUi.loadResource($.Rez.Drawables.add40) as BitmapResource;
            var bitmapWidth = appIcon.getWidth();
            var labelWidth = dc.getTextWidthInPixels(_name, Graphics.FONT_SMALL);

            var bitmapX = (dc.getWidth() - (bitmapWidth + spacing + labelWidth)) / 2;
            var bitmapY = (dc.getHeight() - appIcon.getHeight()) / 2;
            var labelX = bitmapX + bitmapWidth + spacing;
            var labelY = dc.getHeight() / 2;

            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.clear();

            dc.drawBitmap(bitmapX, bitmapY, appIcon);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(labelX, labelY, Graphics.FONT_SMALL, _name, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        } else {
            var spacingX = 2;
            var spacingY = 2;
            var appIcon = WatchUi.loadResource(icon_translate(_icon)) as BitmapResource;
            var bitmapWidth = appIcon.getWidth();

            var bitmapX = 0;
            var bitmapY = (dc.getHeight() - appIcon.getHeight()) / 2;
            var nameTextX = bitmapX + bitmapWidth + spacingX;
            var nameTextY = (dc.getHeight() - dc.getFontHeight(Graphics.FONT_LARGE) - spacingY) / 2 ;
            var PoLTextX = nameTextX + dc.getTextWidthInPixels(_name, Graphics.FONT_SMALL) + spacingX;
            var PoLTextY = nameTextY + (dc.getFontHeight(Graphics.FONT_SMALL) - dc.getFontHeight(Graphics.FONT_XTINY)) / 2;
            var dateTextX = nameTextX;
            var dateTextY = nameTextY + (dc.getFontHeight(Graphics.FONT_SMALL) + spacingY + dc.getFontHeight(Graphics.FONT_LARGE)) / 2;

            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.clear();

            dc.drawBitmap(bitmapX, bitmapY, appIcon);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(nameTextX, nameTextY, Graphics.FONT_SMALL, _name, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(PoLTextX, PoLTextY, Graphics.FONT_XTINY, PoLText(_dura), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dateTextX, dateTextY, Graphics.FONT_LARGE, dateText(_dura), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
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

    private function calculate_duration(anni as Time.Moment) as Number{
        var today = new Time.Moment(Time.today().value());
        var dura = Math.ceil(today.compare(anni).toDouble()/3600/24).toNumber();
        return dura;
    }

    private function PoLText(duration as Number) as String{
        if (duration <= 0) {
            return WatchUi.loadResource($.Rez.Strings.left) as String;
        }
        else {
            return WatchUi.loadResource($.Rez.Strings.passed) as String;
        }
    }

    private function dateText(duration as Number) as String{
        if (duration.abs() <= 1) {
            return duration.abs().toString() + WatchUi.loadResource($.Rez.Strings.day) as String;
        }
        else {
            return duration.abs().toString() + WatchUi.loadResource($.Rez.Strings.days) as String;
        }
    }

}
