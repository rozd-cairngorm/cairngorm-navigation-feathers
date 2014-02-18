/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 11/15/13
 * Time: 2:25 PM
 * To change this template use File | Settings | File Templates.
 */
package feathers.controls
{
import starling.display.DisplayObject;
import starling.display.DisplayObject;

public class ScreenNavigatorItemExt extends ScreenNavigatorItem
{
    public function ScreenNavigatorItemExt(screen:Object = null, events:Object = null, properties:Object = null, navigation:Object = null, reuse:Boolean = false)
    {
        super(screen, events, properties);

        this.landmark = navigation.landmark;

        this.isDefault = navigation.isDefault;

        this.reuse = reuse;
    }

    public var landmark:String;

    public var isDefault:Boolean;

    public var reuse:Boolean;

    override internal function getScreen():DisplayObject
    {
        var instance:DisplayObject = super.getScreen();

        if (reuse)
        {
            this.screen = instance;
        }

        return instance;
    }
}
}
