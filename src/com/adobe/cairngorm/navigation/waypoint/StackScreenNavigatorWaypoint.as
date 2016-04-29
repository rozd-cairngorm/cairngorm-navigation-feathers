/**
 * Created by max on 3/31/16.
 */
package com.adobe.cairngorm.navigation.waypoint
{
import com.adobe.cairngorm.navigation.NavigationEvent;

import feathers.controls.ScreenNavigator;

import feathers.controls.StackScreenNavigator;

import starling.events.Event;

public class StackScreenNavigatorWaypoint extends AbstractWaypoint implements IWaypoint
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function StackScreenNavigatorWaypoint()
    {
        super();

        _registration = new StackScreenNavigatorDestinationRegistration();
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
        return StackScreenNavigator(view).rootScreenID;
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
        if (StackScreenNavigator(view).activeScreenID != event.destination)
        {
            StackScreenNavigator(view).pushScreen(event.destination);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Handlers
    //
    //--------------------------------------------------------------------------

    private function changeHandler(event:Event):void
    {
        var view:StackScreenNavigator = event.target as StackScreenNavigator;

        var destination:String = view.activeScreenID;

        _selectedIndex = view.getScreenIDs().indexOf(destination);

        navigateTo(destination);
    }
}
}
