import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using WhatAppBase;
var _wiTop as WhatAppBase.WhatInformation;
var _wiLeft as WhatAppBase.WhatInformation;
var _wiRight as WhatAppBase.WhatInformation;
var _wiBottom as WhatAppBase.WhatInformation;

var _wPower as WhatAppBase.WhatPower;
var _wHeartrate as WhatAppBase.WhateHeartrate;
var _wCadence as WhatAppBase.WhatCadence;
var _wGrade as WhatAppBase.WhatGrade;
var _wDistance as WhatAppBase.WhatDistance;
var _wAltitude as WhatAppBase.WhatAltitude;
var _wSpeed as WhatAppBase.WhatSpeed;
var _wPressure as WhatAppBase.WhatPressure;
var _wCalories as WhatAppBase.WhatCalories;
var _wTrainingEffect as WhatAppBase.WhatTrainingEffect;
var _wTime as WhatAppBase.WhatTime;
var _wHeading as WhatAppBase.WhatHeading;
var _wEngergyExpenditure as WhatAppBase.WhatEngergyExpenditure;

var _showInfoTop = WhatAppBase.ShowInfoPower;
var _showInfoLeft = WhatAppBase.ShowInfoNothing;
var _showInfoRight = WhatAppBase.ShowInfoNothing;
var _showInfoBottom = WhatAppBase.ShowInfoNothing;
var _showInfoHrFallback = WhatAppBase.ShowInfoNothing;
var _showInfoTrainingEffectFallback = WhatAppBase.ShowInfoNothing;
var _showInfoLayout = WhatAppBase.LayoutMiddleCircle;
var _showSealevelPressure = true;

class whatspeedApp extends Application.AppBase {
  function initialize() {
    AppBase.initialize();

    $._wPower = new WhatAppBase.WhatPower();
    $._wHeartrate = new WhatAppBase.WhateHeartrate();
    $._wCadence = new WhatAppBase.WhatCadence();
    $._wDistance = new WhatAppBase.WhatDistance();
    $._wAltitude = new WhatAppBase.WhatAltitude();
    $._wGrade = new WhatAppBase.WhatGrade();
    $._wSpeed = new WhatAppBase.WhatSpeed();
    $._wPressure = new WhatAppBase.WhatPressure();
    $._wCalories = new WhatAppBase.WhatCalories();
    $._wTrainingEffect = new WhatAppBase.WhatTrainingEffect();
    $._wTime = new WhatAppBase.WhatTime();
    $._wHeading = new WhatAppBase.WhatHeading();
    $._wEngergyExpenditure = new WhatAppBase.WhatEngergyExpenditure();
  }

  // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    function onSettingsChanged() { loadUserSettings(); }

    //! Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates> ? {
      loadUserSettings();
      return [new whatspeedView()] as Array < Views or InputDelegates > ;
    }
    function loadUserSettings() {
      try {
        $._showInfoTop = WhatAppBase.getNumberProperty(
            "showInfoTop", WhatAppBase.ShowInfoTrainingEffect);
        $._showInfoLeft = WhatAppBase.getNumberProperty(
            "showInfoLeft", WhatAppBase.ShowInfoPower);
        $._showInfoRight = WhatAppBase.getNumberProperty(
            "showInfoRight", WhatAppBase.ShowInfoHeartrate);
        $._showInfoBottom = WhatAppBase.getNumberProperty(
            "showInfoBottom", WhatAppBase.ShowInfoCalories);
        $._showInfoHrFallback = WhatAppBase.getNumberProperty(
            "showInfoHrFallback", WhatAppBase.ShowInfoCadence);
        $._showInfoTrainingEffectFallback = WhatAppBase.getNumberProperty(
            "showInfoTrainingEffectFallback",
            WhatAppBase.ShowInfoEnergyExpenditure);

        $._showInfoLayout = WhatAppBase.getNumberProperty(
            "showInfoLayout", WhatAppBase.LayoutMiddleCircle);

        $._wPower.setFtp(WhatAppBase.getNumberProperty("ftpValue", 200));
        $._wPower.setPerSec(WhatAppBase.getNumberProperty("powerPerSecond", 3));

        $._wPressure.setShowSeaLevelPressure(
            WhatAppBase.getBooleanProperty("showSeaLevelPressure", true));
        $._wPressure.setPerMin(
            WhatAppBase.getNumberProperty("calcAvgPressurePerMinute", 30));
        $._wPressure.reset();  //@@ QnD start activity

        $._wHeartrate.initZones();
        $._wSpeed.setTargetSpeed(
            WhatAppBase.getNumberProperty("targetSpeed", 30));
        $._wCadence.setTargetCadence(
            WhatAppBase.getNumberProperty("targetCadence", 95));
        $._wDistance.setTargetDistance(
            WhatAppBase.getNumberProperty("targetDistance", 150));
        $._wCalories.setTargetCalories(
            WhatAppBase.getNumberProperty("targetCalories", 2000));
        $._wEngergyExpenditure.setTargetEngergyExpenditure(
            WhatAppBase.getNumberProperty("targetEnergyExpenditure", 15));
        $._wHeading.setMinimalLocationAccuracy(
            WhatAppBase.getNumberProperty("minimalLocationAccuracy", 2));

        System.println("Settings loaded");
      } catch (ex) {
        ex.printStackTrace();
      }
    }
}

function getApp() as whatspeedApp {
  return Application.getApp() as whatspeedApp;
}