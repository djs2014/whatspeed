import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Background;
using WhatAppBase;

(:background)
class whatspeedApp extends Application.AppBase {
  var isForeGround as Boolean = false;
  
  function initialize() {
    AppBase.initialize();
  }

  // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
      if (isForeGround) {
          System.println("FG onStart");
          WhatAppBase.WhatApp.instance().onStart(state); 
      } else {
          System.println("BG onStart");
      }
    }

    // onStop() is called when your application is exiting
    (:typecheck(disableBackgroundCheck))
    function onStop(state as Dictionary?) as Void {
      if (isForeGround) {
          System.println("FG onStop");
          WhatAppBase.WhatApp.instance().onStop(state); 
          Background.deleteTemporalEvent();
      } else {
          System.println("BG onStop");
      }
    }

    (:typecheck(disableBackgroundCheck))
    function getInitialView() as Array<Views or InputDelegates>? {
        isForeGround = true;
        var whatApp = WhatAppBase.WhatApp.instance();
        var appName = Application.loadResource(Rez.Strings.AppName) as Lang.String;
        whatApp.setAppName(appName);
        return whatApp.getInitialView();
    }

    (:typecheck(disableBackgroundCheck))
    function onSettingsChanged() { WhatAppBase.WhatApp.instance().onSettingsChanged(); }

    public function getServiceDelegate() as Array<System.ServiceDelegate> {     
        return [new WhatAppBase.BackgroundServiceDelegate()] as Array<System.ServiceDelegate>;
    }

    (:typecheck(disableBackgroundCheck))
    function onBackgroundData(data) {
        System.println("Background data recieved");
        WhatAppBase.WhatApp.instance().onBackgroundData(data);              
        WatchUi.requestUpdate();
    }
}

function getApp() as whatspeedApp {
  return Application.getApp() as whatspeedApp;
}