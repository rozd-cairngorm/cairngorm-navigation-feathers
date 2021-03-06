/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/13/13
 * Time: 6:17 PM
 * To change this template use File | Settings | File Templates.
 */
package com.adobe.cairngorm.navigation.waypoint
{
import com.adobe.cairngorm.navigation.NavigationUtil;
import com.adobe.cairngorm.navigation.core.DestinationRegistry;
import com.adobe.cairngorm.navigation.core.DestinationStateController;
import com.adobe.cairngorm.navigation.core.INavigationRegistry;
import com.adobe.cairngorm.navigation.core.NavigationController;

import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItemExt;

import feathers.events.FeathersEventType;

import flash.events.EventDispatcher;

import starling.display.DisplayObject;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.events.Event;

[Event(name="waypointFound", type="com.adobe.cairngorm.navigation.waypoint.WaypointEvent")]
public class ScreenNavigatorDestinationRegistration extends AbstractDestinationRegistration implements IDestinationRegistration
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function ScreenNavigatorDestinationRegistration()
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

        if (screenIds.length < 1)
        {
            listenForInitialize(view as ScreenNavigator);
            return;
        }

        registerDestinationFromChildren(view as ScreenNavigator, screenIds);
        listenForChildChange(view as ScreenNavigator);
    }

    override public function unregisterDestinations():void
    {
        super.unregisterDestinations();

        view.removeEventListener(Event.ADDED, handleChildAdd);
        view.removeEventListener(Event.REMOVED, handleChildRemove);
        view.removeEventListener(FeathersEventType.INITIALIZE, handleInitialize);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function listenForInitialize(view:ScreenNavigator):void
    {
        view.addEventListener(FeathersEventType.INITIALIZE, handleInitialize);
    }

    private function handleInitialize(event:Event):void
    {
        var view:DisplayObject = DisplayObject(event.currentTarget);

        registerDestinations(view);

        view.removeEventListener(FeathersEventType.INITIALIZE, handleInitialize);
    }

    private function listenForChildChange(view:DisplayObjectContainer):void
    {
        view.addEventListener(Event.ADDED, handleChildAdd);
        view.addEventListener(Event.REMOVED, handleChildRemove);
    }

    private function handleChildAdd(event:Event):void
    {
        var child:ScreenNavigatorItemExt = event.target as ScreenNavigatorItemExt;

        if (child)
        {
            registerChild(child);
        }
    }

    private function handleChildRemove(event:Event):void
    {
        var child:ScreenNavigatorItemExt = event.target as ScreenNavigatorItemExt;

        if(child)
        {
            unregisterChild(child);
        }
    }

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

    private function unregisterChild(child:ScreenNavigatorItemExt):void
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

        var registry:DestinationRegistry = NavigationController(controller).destinations;
        registry.getDestination(destination).isWaypointAvailable = false;

        controller.unregisterDestination(destination);
        var index:int = destinations.indexOf(destination);
        destinations.splice(index, 1);
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
