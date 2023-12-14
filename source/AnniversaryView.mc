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
        /*
        var customMenu = new $.ImagesMenu(80, Graphics.COLOR_BLACK);
        customMenu.addItem(new $.CustomImagesItem(:bear, "Bear", WatchUi.loadResource($.Rez.Drawables.work) as BitmapResource));
        customMenu.addItem(new $.CustomImagesItem(:dog, "Dog", WatchUi.loadResource($.Rez.Drawables.work) as BitmapResource));
        customMenu.addItem(new $.CustomImagesItem(:fox, "Fox", WatchUi.loadResource($.Rez.Drawables.work) as BitmapResource));
        customMenu.addItem(new $.CustomImagesItem(:mouse, "Mouse", WatchUi.loadResource($.Rez.Drawables.work) as BitmapResource));
        customMenu.addItem(new $.CustomImagesItem(:turtle, "Turtle", WatchUi.loadResource($.Rez.Drawables.work) as BitmapResource));
        WatchUi.pushView(customMenu, new $.ImagesCustomDelegate(), WatchUi.SLIDE_UP);
        customMenu.draw(drawable, dc)
        */
        //WatchUi.showActionMenu(customMenu, new $.ImagesCustomDelegate());
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        /*
        var a = new $.CustomImagesItem(:bear, "Bear", WatchUi.loadResource($.Rez.Drawables.work) as BitmapResource);
        var b = new $.CustomImagesItem(:dog, "Dog", WatchUi.loadResource($.Rez.Drawables.studay) as BitmapResource);
        var c = new $.CustomImagesItem(:fox, "Fox", WatchUi.loadResource($.Rez.Drawables.love) as BitmapResource);
        var d = new $.CustomImagesItem(:mouse, "Mouse", WatchUi.loadResource($.Rez.Drawables.work) as BitmapResource);
        var e = new $.CustomImagesItem(:turtle, "Turtle", WatchUi.loadResource($.Rez.Drawables.work) as BitmapResource);
        a.draw(dc);
        b.draw(dc);
        c.draw(dc);
        */
        //View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}

class ImagesMenu extends WatchUi.CustomMenu {

    //! Constructor
    //! @param itemHeight The pixel height of menu items rendered by this menu
    //! @param backgroundColor The color for the menu background
    public function initialize(itemHeight as Number, backgroundColor as ColorType) {
        CustomMenu.initialize(itemHeight, backgroundColor, {});
    }

    //! Draw the menu title
    //! @param dc Device Context
    public function drawTitle(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
        dc.setPenWidth(3);
        dc.drawLine(0, dc.getHeight() - 2, dc.getWidth(), dc.getHeight() - 2);
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_LARGE, "Images", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}


//! This is the menu input delegate for the images custom menu
class ImagesCustomDelegate extends WatchUi.Menu2InputDelegate {

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        WatchUi.requestUpdate();
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

//! This is the custom item drawable.
//! It draws the item's bitmap and label.
class CustomImagesItem extends WatchUi.CustomMenuItem {

    private var _label as String;
    private var _bitmap as BitmapResource;
    private var _bitmapOffset as Number;

    //! Constructor
    //! @param id The identifier for this item
    //! @param label Text to display
    //! @param bitmap Color of the text
    public function initialize(id as Symbol, label as String, bitmap as BitmapResource) {
        CustomMenuItem.initialize(id, {});
        _label = label;
        _bitmap = bitmap;
        _bitmapOffset = 0 - bitmap.getWidth() / 2;
    }

    //! Draw the item's label and bitmap
    //! @param dc Device context
    public function draw(dc as Dc) as Void {
        var font = Graphics.FONT_SMALL;
        var bmXY = dc.getHeight() / 2 + _bitmapOffset;
        if (isFocused()) {
            font = Graphics.FONT_LARGE;
        }

        if (isSelected()) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
            dc.clear();
        }

        dc.drawBitmap(bmXY, bmXY, _bitmap);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getHeight(), dc.getHeight() / 2, font, _label, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
