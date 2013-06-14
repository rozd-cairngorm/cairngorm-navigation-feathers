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
import feathers.controls.ScreenNavigatorItem;

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
        for each (var destination:String in destinations)
        {
            controller.unregisterDestination(destination);
        }

        destinations = null;

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
        var child:ScreenNavigatorItem = event.target as ScreenNavigatorItem;

        if(child)
        {
            registerChild(child);
        }
    }

    private function handleChildRemove(event:Event):void
    {
        var child:ScreenNavigatorItem = event.target as ScreenNavigatorItem;

        if(child)
        {
            unregisterChild(child);
        }
    }

    private function registerDestinationFromChildren(view:ScreenNavigator, ids:Vector.<String>):void
    {
        for (var i:int, length:int = ids.length; i < length; i++)
        {
            var child:ScreenNavigatorItem = view.getScreen(ids[i]);
            _hasRegisteredChildren = true;
            registerChild(child);
        }
    }

    private function registerChild(child:ScreenNavigatorItem):void
    {
        var destination:String = child.properties.landmark;

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

        if (waypointName == null)
        {
            _waypointName = NavigationUtil.getParent(destination);

            if (waypointName == null)
            {
                throw new Error("A waypoint cannot be found on destination: " + destination);
            }

            dispatchEvent(new WaypointEvent(waypointName));
        }
    }

    private function unregisterChild(child:ScreenNavigatorItem):void
    {
        var destination:String = child.properties.landmark;
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
