/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 6/13/13
 * Time: 5:08 PM
 * To change this template use File | Settings | File Templates.
 */
package com.adobe.cairngorm.navigation.waypoint
{
import com.adobe.cairngorm.navigation.NavigationEvent;

import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItemExt;

import starling.events.Event;

public class ScreenNavigatorWaypoint extends AbstractWaypoint implements IWaypoint
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function ScreenNavigatorWaypoint()
    {
        super();

        _registration = new ScreenNavigatorDestinationRegistration();
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //---------------------------------
    //  Methods: IWaypoint
    //---------------------------------

    public function getDefaultDestination():String
    {
        var destination:String;

        var ids:Vector.<String> = view.getScreenIDs();

        var child:ScreenNavigatorItemExt;

        for (var i:int = 0, n:int = ids.length; i < n; i++)
        {
            child = view.getScreen(ids[i]) as ScreenNavigatorItemExt;

            if (child != null && child.isDefault)
            {
                _selectedIndex = i;
                destination = getDestination(child);
                break;
            }
        }

//        if (destination == null)
//        {
//            child = view.getScreen(ids[0]);
//
//            if (child != null)
//            {
//                _selectedIndex = 0;
//                destination = getDestination(child);
//            }
//        }

        return destination;
    }

    public function subscribeToViewChange(view:Object):void
    {
        this.view = view as ScreenNavigator;

        view.addEventListener(Event.CHANGE, changeHandler);
    }

    public function unsubscribeFromViewChange():void
    {
        if (view != null)
        {
            view.removeEventListener(Event.CHANGE, changeHandler);
        }

        this.view = null;
    }

    public function handleNavigationChange(event:NavigationEvent):void
    {
        var child:ScreenNavigatorItemExt = findChild(event.destination);

        if (view.activeScreenID != event.destination)
        {
            view.showScreen(event.destination);
        }
    }

    //---------------------------------
    //  Methods: Internal
    //---------------------------------

    private function getDestination(child:ScreenNavigatorItemExt):String
    {
        return child.landmark;
    }

    private function findChild(destination:String):ScreenNavigatorItemExt
    {
        var ids:Vector.<String> = view.getScreenIDs();

        for (var i:int; i < ids.length; i++)
        {
            var child:ScreenNavigatorItemExt = view.getScreen(ids[i]) as ScreenNavigatorItemExt;

            if (child != null && getDestination(child) == destination)
            {
                return child;
            }
        }
        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Handlers
    //
    //--------------------------------------------------------------------------

    private function changeHandler(event:Event):void
    {
        var view:ScreenNavigator = event.target as ScreenNavigator;

        var id:String = view.activeScreenID;

        var child:ScreenNavigatorItemExt = view.getScreen(id) as ScreenNavigatorItemExt;

        if (!child) return;

        var destination:String = getDestination(child);

        _selectedIndex = view.getScreenIDs().indexOf(id);

        navigateTo(destination);
    }
}
}
