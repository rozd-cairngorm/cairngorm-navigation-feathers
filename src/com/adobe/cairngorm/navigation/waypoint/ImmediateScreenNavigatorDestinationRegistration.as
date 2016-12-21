/**
 * Created by max.rozdobudko@gmail.com on 9/1/16.
 */
package com.adobe.cairngorm.navigation.waypoint
{
import com.adobe.cairngorm.navigation.NavigationUtil;
import com.adobe.cairngorm.navigation.core.DestinationRegistry;
import com.adobe.cairngorm.navigation.core.DestinationStateController;
import com.adobe.cairngorm.navigation.core.NavigationController;

import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItemExt;

[Event(name="waypointFound", type="com.adobe.cairngorm.navigation.waypoint.WaypointEvent")]
public class ImmediateScreenNavigatorDestinationRegistration extends AbstractDestinationRegistration implements IDestinationRegistration
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function ImmediateScreenNavigatorDestinationRegistration()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override public function onRegisterDestinations():void
    {
        var screenIds:Vector.<String> = view.getScreenIDs();

        registerDestinationFromChildren(view as ScreenNavigator, screenIds);
    }

    override public function unregisterDestinations():void
    {
        super.unregisterDestinations();
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------


    private function registerDestinationFromChildren(view:ScreenNavigator, ids:Vector.<String>):void
    {
        var proposedWaypointName:String = null;

        for (var i:int, length:int = ids.length; i < length; i++)
        {
            var child:ScreenNavigatorItemExt = view.getScreen(ids[i]) as ScreenNavigatorItemExt;
            _hasRegisteredChildren = true;
            if (!child) continue;
            proposedWaypointName = registerChild(child);
        }

        if (waypointName == null)
        {
            _waypointName = proposedWaypointName;

            dispatchEvent(new WaypointEvent(waypointName));
        }
    }

    private function registerChild(child:ScreenNavigatorItemExt):String
    {
        var destination:String = child.landmark;

        if (destination == null || destination == "")
        {
            throw new Error("Cannot find a destination from automationName on: " + child);
        }
        else if (NavigationUtil.getParent(destination) == null)
        {
            throw new Error("The destination " + destination + " on view: " + child + " doesn't have a parent (waypoint).");
        }

        controller.registerDestination(destination);

        setWaypointAvailable(destination);

        destinations.push(destination);

        var waypoint:String = NavigationUtil.getParent(destination);

        if (waypoint == null)
        {
            throw new Error("A waypoint cannot be found on destination: " + destination);
        }

        return waypoint;
    }

    private function setWaypointAvailable(destination:String):void
    {
        var registry:DestinationRegistry = NavigationController(controller).destinations;
        var dest:DestinationStateController = registry.getDestination(destination);
        while (dest)
        {
            dest.isWaypointAvailable = true;
            var parentDestination:String = NavigationUtil.getParent(dest.destination);
            dest = registry.getDestination(parentDestination);
        }
    }
}
}
