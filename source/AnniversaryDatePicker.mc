import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class AnniversaryDatePicker extends WatchUi.Picker {

    private var _default_time as Time.Moment;

    public function initialize(default_time as Time.Moment) {
        _default_time = default_time;
        var title = new WatchUi.Text({:text=>$.Rez.Strings.datePickerTitle, :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});
        Picker.initialize({:title=>title, :pattern=>[new $.NumberPickerFactory(1970, 2037, 1, {})], :defaults=>[Gregorian.info(_default_time, Time.FORMAT_SHORT).year-1970]});
    }

}

class DatePickerDelegate extends WatchUi.PickerDelegate {

    private var _menuView as AnniversaryEditMenu;
    private var _default_time as Time.Moment;
    private var _needTime as Boolean;

    public function initialize(menuView as AnniversaryEditMenu, default_time as Time.Moment, needTime as Boolean) {
        PickerDelegate.initialize();
        _menuView = menuView;
        _default_time = default_time;
        _needTime = needTime;
    }

    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    public function onAccept(values as Array) as Boolean {
        WatchUi.popView(WatchUi.SLIDE_LEFT);
        WatchUi.pushView(new AnniversaryMonthPicker(_default_time), new MonthPickerDelegate(_menuView, _default_time, values, _needTime), WatchUi.SLIDE_LEFT);
        return true;
    }

}

class AnniversaryMonthPicker extends WatchUi.Picker {

    private var _default_time as Time.Moment;

    public function initialize(default_time as Time.Moment) {
        _default_time = default_time;
        var months = [$.Rez.Strings.month01, $.Rez.Strings.month02, $.Rez.Strings.month03,
                      $.Rez.Strings.month04, $.Rez.Strings.month05, $.Rez.Strings.month06,
                      $.Rez.Strings.month07, $.Rez.Strings.month08, $.Rez.Strings.month09,
                      $.Rez.Strings.month10, $.Rez.Strings.month11, $.Rez.Strings.month12];
        var title = new WatchUi.Text({:text=>$.Rez.Strings.datePickerTitle, :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});
        Picker.initialize({:title=>title, :pattern=>[new $.WordPickerFactory(months, {})], :defaults=>[Gregorian.info(_default_time, Time.FORMAT_SHORT).month-1]});
    }

}

class MonthPickerDelegate extends WatchUi.PickerDelegate {

    private var _menuView as AnniversaryEditMenu;
    private var _default_time as Time.Moment;
    private var _date as Lang.Array;
    private var _needTime as Boolean;

    public function initialize(menuView as AnniversaryEditMenu, default_time as Time.Moment, date as Lang.Array, needTime as Boolean) {
        PickerDelegate.initialize();
        _menuView = menuView;
        _default_time = default_time;
        _date = date;
        _needTime = needTime;
    }

    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    public function onAccept(values as Array) as Boolean {
        var months = [$.Rez.Strings.month01, $.Rez.Strings.month02, $.Rez.Strings.month03,
                      $.Rez.Strings.month04, $.Rez.Strings.month05, $.Rez.Strings.month06,
                      $.Rez.Strings.month07, $.Rez.Strings.month08, $.Rez.Strings.month09,
                      $.Rez.Strings.month10, $.Rez.Strings.month11, $.Rez.Strings.month12];
        _date.add(months.indexOf(values[0])+1);
        WatchUi.popView(WatchUi.SLIDE_LEFT);
        WatchUi.pushView(new AnniversaryDayPicker(_default_time, _date[0], _date[1]), new DayPickerDelegate(_menuView, _default_time, _date, _needTime), WatchUi.SLIDE_LEFT);
        return true;
    }

}

class AnniversaryDayPicker extends WatchUi.Picker {

    private var _default_time as Time.Moment;
    private var _year as Lang.Number;
    private var _month as Lang.Number;

    public function initialize(default_time as Time.Moment, year as Lang.Number, month as Lang.Number) {
        _default_time = default_time;
        _year = year;
        _month = month;
        var lastDay = getDaysInMonthOptimized(_year, _month);
        var defaultDay = Gregorian.info(_default_time, Time.FORMAT_SHORT).day <= lastDay ? Gregorian.info(_default_time, Time.FORMAT_SHORT).day : 1;
        var title = new WatchUi.Text({:text=>$.Rez.Strings.datePickerTitle, :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});
        Picker.initialize({:title=>title, :pattern=>[new $.NumberPickerFactory(1, lastDay, 1, {})], :defaults=>[defaultDay-1]});
    }

    private function getDaysInMonthOptimized(year as Lang.Number, month as Lang.Number) as Lang.Number {
        if (month < 1 || month > 12) {
            return 0;
        }
        
        // 30天的月份
        if (month == 4 || month == 6 || month == 9 || month == 11) {
            return 30;
        }
        
        // 2月
        if (month == 2) {
            // 闰年判断
            var isLeap = (year % 400 == 0) || (year % 4 == 0 && year % 100 != 0);
            return isLeap ? 29 : 28;
        }
        
        // 其他月份都是31天
        return 31;
    }

}

class DayPickerDelegate extends WatchUi.PickerDelegate {

    private var _menuView as AnniversaryEditMenu;
    private var _default_time as Time.Moment;
    private var _date as Lang.Array;
    private var _needTime as Boolean;

    public function initialize(menuView as AnniversaryEditMenu, default_time as Time.Moment, date as Lang.Array, needTime as Boolean) {
        PickerDelegate.initialize();
        _menuView = menuView;
        _default_time = default_time;
        _date = date;
        _needTime = needTime;
    }

    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    public function onAccept(values as Array) as Boolean {
        WatchUi.popView(WatchUi.SLIDE_LEFT);
        if(_needTime) {

        } else {
            var options = {
                :year   => _date[0],
                :month  => _date[1],
                :day    => values[0]
            };
            _menuView.set_value("date", Gregorian.moment(options).value());
        }
        return true;
    }

}

class NumberPickerFactory extends WatchUi.PickerFactory {

    private var _start as Number;
    private var _stop as Number;
    private var _increment as Number;
    private var _formatString as String;
    private var _font as FontDefinition;

    public function initialize(start as Number, stop as Number, increment as Number, options as {
        :font as FontDefinition,
        :format as String
    }) {
        PickerFactory.initialize();

        _start = start;
        _stop = stop;
        _increment = increment;

        var format = options.get(:format);
        if (format != null) {
            _formatString = format;
        } else {
            _formatString = "%d";
        }

        var font = options.get(:font);
        if (font != null) {
            _font = font;
        } else {
            _font = Graphics.FONT_NUMBER_HOT;
        }
    }

    public function getIndex(value as Number) as Number {
        return (value / _increment) - _start;
    }

    public function getDrawable(index as Number, selected as Boolean) as Drawable? {
        var value = getValue(index);
        var text = "No item";
        if (value instanceof Number) {
            text = value.format(_formatString);
        }
        return new WatchUi.Text({:text=>text, :color=>Graphics.COLOR_WHITE, :font=>_font,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER});
    }

    public function getValue(index as Number) as Object? {
        return _start + (index * _increment);
    }

    public function getSize() as Number {
        return (_stop - _start) / _increment + 1;
    }
    
}

class WordPickerFactory extends WatchUi.PickerFactory {

    private var _words as Array<ResourceId>;
    private var _font as FontDefinition;

    public function initialize(words as Array<ResourceId>, options as {:font as FontDefinition}) {
        PickerFactory.initialize();

        _words = words;

        var font = options.get(:font);
        if (font != null) {
            _font = font;
        } else {
            _font = Graphics.FONT_LARGE;
        }
    }

    public function getIndex(value as String or Symbol) as Number {
        if (value instanceof String) {
            for (var i = 0; i < _words.size(); i++) {
                if (value.equals(WatchUi.loadResource(_words[i]))) {
                    return i;
                }
            }
        } else {
            for (var i = 0; i < _words.size(); i++) {
                if (_words[i].equals(value)) {
                    return i;
                }
            }
        }

        return 0;
    }

    public function getSize() as Number {
        return _words.size();
    }

    public function getValue(index as Number) as Object? {
        return _words[index];
    }

    public function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({:text=>_words[index], :color=>Graphics.COLOR_WHITE, :font=>_font,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER});
    }
    
}
