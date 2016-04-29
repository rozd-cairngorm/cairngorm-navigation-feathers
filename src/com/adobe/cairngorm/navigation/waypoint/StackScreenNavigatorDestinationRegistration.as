/**
 * Created by max on 3/31/16.
 */
package com.adobe.cairngorm.navigation.waypoint
{
import com.adobe.cairngorm.navigation.NavigationUtil;
import com.adobe.cairngorm.navigation.core.DestinationRegistry;
import com.adobe.cairngorm.navigation.core.DestinationStateController;
import com.adobe.cairngorm.navigation.core.NavigationController;

import feathers.controls.ScreenNavigator;

import feathers.controls.ScreenNavigatorItemExt;
import feathers.controls.StackScreenNavigator;
import feathers.controls.StackScreenNavigatorItem;
import feathers.events.FeathersEventType;

import starling.display.DisplayObject;

import starling.display.DisplayObjectContainer;

import starling.events.Event;

[Event(name="waypointFound", type="com.adobe.cairngorm.navigation.waypoint.WaypointEvent")]
public class StackScreenNavigatorDestinationRegistration extends AbstractDestinationRegistration implements IDestinationRegistration
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function StackScreenNavigatorDestinationRegistration()
    {
        super();
    }

//    //--------------------------------------------------------------------------
//    //
//    //  Overridden methods
//    //
//    //--------------------------------------------------------------------------
//
//    override public function onRegisterDestinations():void
//    {
//        var screenIds:Vector.<String> = view.getScreenIDs();
//
//        if (screenIds.length < 1)
//        {
//            listenForInitialize(view as StackScreenNavigator);
//            return;
//        }
//
//        registerDestinationFromChildren(view as StackScreenNavigator, screenIds);
//        listenForChildChange(view as StackScreenNavigator);
//    }
//
//    override public function unregisterDestinations():void
//    {
//        for each (var destination:String in destinations)
//        {
//            controller.unregisterDestination(destination);
//        }
//
//        destinations = null;
//
//        view.removeEventListener(Event.ADDED, handleChildAdd);
//        view.removeEventListener(Event.REMOVED, handleChildRemove);
//        view.removeEventListener(FeathersEventType.INITIALIZE, handleInitialize);
//    }
//
//    //--------------------------------------------------------------------------
//    //
//    //  Methods
//    //
//    //--------------------------------------------------------------------------
//
//    private function listenForInitialize(view:StackScreenNavigator):void
//    {
//        view.addEventListener(FeathersEventType.INITIALIZE, handleInitialize);
//    }
//
//    private function handleInitialize(event:Event):void
//    {
//        var view:DisplayObject = DisplayObject(event.currentTarget);
//
//        registerDestinations(view);
//
//        view.removeEventListener(FeathersEventType.INITIALIZE, handleInitialize);
//    }
//
//    private function listenForChildChange(view:DisplayObjectContainer):void
//    {
//        view.addEventListener(Event.ADDED, handleChildAdd);
//        view.addEventListener(Event.REMOVED, handleChildRemove);
//    }
//
//    private function handleChildAdd(event:Event):void
//    {
//        var child:StackScreenNavigatorItem = event.target as StackScreenNavigatorItem;
//
//        if(child)
//        {
//            registerChild(child);
//        }
//    }
//
//    private function handleChildRemove(event:Event):void
//    {
//        var child:StackScreenNavigatorItem = event.target as StackScreenNavigatorItem;
//
//        if(child)
//        {
//            unregisterChild(child);
//        }
//    }
//
//    private function registerDestinationFromChildren(view:StackScreenNavigator, ids:Vector.<String>):void
//    {
//        var proposedWaypointName:String = null;
//
//        for (var i:int, length:int = ids.length; i < length; i++)
//        {
//            var child:StackScreenNavigatorItem = view.getScreen(ids[i]) as StackScreenNavigatorItem;
//            _hasRegisteredChildren = true;
//            proposedWaypointName = registerChild(child);
//        }
//
//        if (waypointName == null)
//        {
//            _waypointName = proposedWaypointName;
//
//            dispatchEvent(new WaypointEvent(waypointName));
//        }
//    }
//
//    private function registerChild(child:StackScreenNavigatorItem):String
//    {
//        var destination:String = child.landmark;
//
//        if (destination == null || destination == "")
//        {
//            throw new Error("Cannot find a destination from automationName on: " + child);
//        }
//        else if (NavigationUtil.getParent(destination) == null)
//        {
//            throw new Error("The destination " + destination + " on view: " + child + " doesn't have a parent (waypoint).");
//        }
//
//        controller.registerDestination(destination);
//
//        setWaypointAvailable(destination);
//
//        destinations.push(destination);
//
//        var waypoint:String = NavigationUtil.getParent(destination);
//
//        if (waypoint == null)
//        {
//            throw new Error("A waypoint cannot be found on destination: " + destination);
//        }
//
//        return waypoint;
//    }
//
//    private function unregisterChild(child:StackScreenNavigatorItem):void
//    {
//        var destination:String = child.landmark;
//        if (destination == null || destination == "")
//        {
//            throw new Error("Cannot find a destination from automationName on: " + child);
//        }
//        else if (NavigationUtil.getParent(destination) == null)
//        {
//            throw new Error("The destination " + destination + " on view: " + child + " doesn't have a parent (waypoint).");
//        }
//
//        var registry:DestinationRegistry = NavigationController(controller).destinations;
//        registry.getDestination(destination).isWaypointAvailable = false;
//
//        controller.unregisterDestination(destination);
//        var index:int = destinations.indexOf(destination);
//        destinations.splice(index, 1);
//    }
//
//    private function setWaypointAvailable(destination:String):void
//    {
//        var registry:DestinationRegistry = NavigationController(controller).destinations;
//        var dest:DestinationStateController = registry.getDestination(destination);
//        while (dest)
//        {
//            dest.isWaypointAvailable = true;
//            var parentDestination:String = NavigationUtil.getParent(dest.destination);
//            dest = registry.getDestination(parentDestination);
//        }
//    }
}
}
