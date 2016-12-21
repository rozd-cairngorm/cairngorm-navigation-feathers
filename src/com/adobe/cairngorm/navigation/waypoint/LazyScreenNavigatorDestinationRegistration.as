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

import feathers.controls.IScreen;

import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;
import feathers.controls.ScreenNavigatorItemExt;
import feathers.core.IFeathersControl;

import feathers.events.FeathersEventType;

import flash.events.EventDispatcher;

import starling.display.DisplayObject;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.events.Event;

[Event(name="waypointFound", type="com.adobe.cairngorm.navigation.waypoint.WaypointEvent")]
public class LazyScreenNavigatorDestinationRegistration extends AbstractDestinationRegistration implements IDestinationRegistration
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function LazyScreenNavigatorDestinationRegistration()
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
        if (IFeathersControl(view).isCreated)
        {
            registerDestinationFromChildren(view as ScreenNavigator);
        }
        else
        {
            listenForCreationComplete(view as ScreenNavigator);
            listenForChildChange(view as ScreenNavigator);
        }
    }

    override public function unregisterDestinations():void
    {
        super.unregisterDestinations();

        view.removeEventListener(Event.ADDED, handleChildAdd);
        view.removeEventListener(Event.REMOVED, handleChildRemove);
        view.removeEventListener(FeathersEventType.CREATION_COMPLETE, handleCreationComplete);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function listenForCreationComplete(view:ScreenNavigator):void
    {
        view.addEventListener(FeathersEventType.CREATION_COMPLETE, handleCreationComplete);
    }

    private function handleCreationComplete(event:Event):void
    {
        var view:DisplayObject = DisplayObject(event.currentTarget);

        registerDestinations(view);

        view.removeEventListener(FeathersEventType.CREATION_COMPLETE, handleCreationComplete);
    }

    private function listenForChildChange(view:DisplayObjectContainer):void
    {
        view.addEventListener(Event.ADDED, handleChildAdd);
        view.addEventListener(Event.REMOVED, handleChildRemove);
    }

    private function handleChildAdd(event:Event):void
    {
        var screen:IScreen = event.target as IScreen;

        if (screen)
        {
            registerScreen(screen);
        }
    }

    private function handleChildRemove(event:Event):void
    {
        var screen:IScreen = event.target as IScreen;

        if(screen)
        {
            unregisterScreen(screen);
        }
    }

    private function registerDestinationFromChildren(view:ScreenNavigator):void
    {
        var proposedWaypointName:String = null;

        var ids:Vector.<String> = view.getScreenIDs();
        for (var i:int, length:int = ids.length; i < length; i++)
        {
            var child:ScreenNavigatorItemExt = view.getScreen(ids[i]) as ScreenNavigatorItemExt;
            _hasRegisteredChildren = true;
            if (!child) continue;
            proposedWaypointName = registerScreenItem(child);
        }

        if (waypointName == null)
        {
            _waypointName = proposedWaypointName;

            dispatchEvent(new WaypointEvent(waypointName));
        }
    }

    private function registerScreenItem(item:ScreenNavigatorItemExt):String
    {
        var destination:String = item.landmark;

        if (destination == null || destination == "")
        {
            throw new Error("Cannot find a destination from automationName on: " + item);
        }
        else if (NavigationUtil.getParent(destination) == null)
        {
            throw new Error("The destination " + destination + " on view: " + item + " doesn't have a parent (waypoint).");
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

    private function unregisterScreenItem(item:ScreenNavigatorItemExt):void
    {
        var destination:String = item.landmark;
        if (destination == null || destination == "")
        {
            throw new Error("Cannot find a destination from automationName on: " + item);
        }
        else if (NavigationUtil.getParent(destination) == null)
        {
            throw new Error("The destination " + destination + " on view: " + item + " doesn't have a parent (waypoint).");
        }

        var registry:DestinationRegistry = NavigationController(controller).destinations;
        registry.getDestination(destination).isWaypointAvailable = false;

        controller.unregisterDestination(destination);
        var index:int = destinations.indexOf(destination);
        destinations.splice(index, 1);
    }

    private function registerScreen(screen:IScreen):void
    {
        var viewAsNavigator:ScreenNavigator = view as ScreenNavigator;

        if (viewAsNavigator.hasScreen(screen.screenID))
        {
            var item:ScreenNavigatorItemExt = viewAsNavigator.getScreen(screen.screenID) as ScreenNavigatorItemExt;

            registerScreenItem(item);
        }
    }

    private function unregisterScreen(screen:IScreen):void
    {
        var viewAsNavigator:ScreenNavigator = view as ScreenNavigator;

        if (viewAsNavigator.hasScreen(screen.screenID))
        {
            var item:ScreenNavigatorItemExt = viewAsNavigator.getScreen(screen.screenID) as ScreenNavigatorItemExt;

            unregisterScreenItem(item);
        }
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
