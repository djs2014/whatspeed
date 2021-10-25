import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import WhatAppBase;

class whatspeedView extends WatchUi.DataField {
  hidden var mWD;

  function initialize() {
    DataField.initialize();
    mWD = new WhatAppBase.WhatDisplay();
  }

  // Set your layout here. Anytime the size of obscurity of
  // the draw context is changed this will be called.
  function onLayout(dc as Dc) as Void { mWD.onLayout(dc); }

  // The given info object contains all the current workout information.
  // Calculate a value and save it locally in this method.
  // Note that compute() and onUpdate() are asynchronous, and there is no
  // guarantee that compute() will be called before onUpdate().
  function compute(info as Activity.Info) as Void {
    $._wiTop = getShowInformation($._showInfoTop, $._showInfoHrFallback,
                                  $._showInfoTrainingEffectFallback, info);
    $._wiBottom = getShowInformation($._showInfoBottom, $._showInfoHrFallback,
                                     $._showInfoTrainingEffectFallback, info);
    $._wiLeft = getShowInformation($._showInfoLeft, $._showInfoHrFallback,
                                   $._showInfoTrainingEffectFallback, info);
    $._wiRight = getShowInformation($._showInfoRight, $._showInfoHrFallback,
                                    $._showInfoTrainingEffectFallback, info);

    if ($._wiTop != null) {
      $._wiTop.updateInfo(info);
    }
    if ($._wiBottom != null) {
      $._wiBottom.updateInfo(info);
    }
    if ($._wiLeft != null) {
      $._wiLeft.updateInfo(info);
    }
    if ($._wiRight != null) {
      $._wiRight.updateInfo(info);
    }
  }

  // Display the value you computed here. This will be called
  // once a second when the data field is visible.
  function onUpdate(dc as Dc) as Void {
    mWD.onUpdate(dc);
    mWD.clearDisplay(getBackgroundColor(), getBackgroundColor());
    mWD.setNightMode((getBackgroundColor() == Graphics.COLOR_BLACK));
    var TopFontColor = null;
    if (mWD.isNightMode()) {  // @@ in mWD
      TopFontColor = Graphics.COLOR_WHITE;
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    } else {
      TopFontColor = Graphics.COLOR_BLACK;
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    }

    $._wiTop = getShowInformation($._showInfoTop, $._showInfoHrFallback,
                                  $._showInfoTrainingEffectFallback, null);
    $._wiBottom = getShowInformation($._showInfoBottom, $._showInfoHrFallback,
                                     $._showInfoTrainingEffectFallback, null);
    $._wiLeft = getShowInformation($._showInfoLeft, $._showInfoHrFallback,
                                   $._showInfoTrainingEffectFallback, null);
    $._wiRight = getShowInformation($._showInfoRight, $._showInfoHrFallback,
                                    $._showInfoTrainingEffectFallback, null);

    var showTop = $._wiTop != null;
    var showLeft = $._wiLeft != null;
    var showRight = $._wiRight != null;
    var showBottom = $._wiBottom != null;

    mWD.setShowTopInfo(showTop);
    mWD.setShowLeftInfo(showLeft);
    mWD.setShowRightInfo(showRight);
    mWD.setShowBottomInfo(showBottom);
    mWD.setMiddleLayout($._showInfoLayout);

    drawTopInfo(dc);
    drawLeftInfo(dc);
    drawRightInfo(dc);
    drawBottomInfo(dc);
  }

  function drawLeftInfo(dc) {
    if ($._wiLeft == null) {
      return;
    }
    var value = $._wiLeft.formattedValue(WhatAppBase.SmallField);
    var zone = $._wiLeft.zoneInfoValue();
    var avgZone = $._wiLeft.zoneInfoAverage();
    mWD.drawLeftInfo(zone.fontColor, value, zone.color, $._wiLeft.units(),
                     avgZone.color, zone.perc, zone.color100perc);
  }
  function drawTopInfo(dc) {
    if ($._wiTop == null) {
      return;
    }
    var value = $._wiTop.formattedValue(WhatAppBase.SmallField);
    var zone = $._wiTop.zoneInfoValue();
    var avgZone = $._wiTop.zoneInfoAverage();
    mWD.drawTopInfo(zone.name, zone.fontColor, value, zone.color,
                    $._wiTop.units(), avgZone.color, zone.perc,
                    zone.color100perc);
  }

  function drawRightInfo(dc) {
    if ($._wiRight == null) {
      return;
    }
    var value = $._wiRight.formattedValue(WhatAppBase.SmallField);
    var zone = $._wiRight.zoneInfoValue();
    var avgZone = $._wiRight.zoneInfoAverage();
    mWD.drawRightInfo(zone.fontColor, value, zone.color, $._wiRight.units(),
                      avgZone.color, zone.perc, zone.color100perc);
  }

  function drawBottomInfo(dc) {
    if ($._wiBottom == null) {
      return;
    }
    var value = $._wiBottom.formattedValue(mWD.fieldType);
    var zone = $._wiBottom.zoneInfoValue();
    var label = zone.name;  // @@ should be short
    mWD.drawBottomInfo(zone.fontColor, label, value, $._wiBottom.units(),
                       zone.color, zone.perc, zone.color100perc);
  }

  function drawBottomDataTriangle(dc) {
    var value = $._wiBottom.formattedValue(mWD.fieldType);
    var zone = $._wiBottom.zoneInfoValue();
    var label = zone.name;  // @@ should be short

    var color = zone.fontColor;
    var backColor = zone.color;

    mWD.drawInfoTriangleThingy(color, label, value, $._wiBottom.units(),
                               backColor, zone.perc, zone.color100perc);
  }

  function getShowInformation(showInfo, showInfoHrFallback,
                              showInfoTrainingEffectFallback,
                              info as Activity.Info) as WhatInformation {
    // System.println("showInfo: " + showInfo);
    switch (showInfo) {
      case WhatAppBase.ShowInfoPower:
        return new WhatAppBase.WhatInformation(
            $._wPower.powerPerX(), $._wPower.getAveragePower(),
            $._wPower.getMaxPower(), $._wPower);
      case WhatAppBase.ShowInfoHeartrate:
        if (info != null) {
          $._wHeartrate.updateInfo(info);
        }
        if (!$._wHeartrate.isAvailable() &&
            showInfoHrFallback != WhatAppBase.ShowInfoNothing) {
          return getShowInformation(showInfoHrFallback,
                                    WhatAppBase.ShowInfoNothing,
                                    WhatAppBase.ShowInfoNothing, null);
        }
        return new WhatAppBase.WhatInformation(
            $._wHeartrate.getCurrentHeartrate(),
            $._wHeartrate.getAverageHeartrate(),
            $._wHeartrate.getMaxHeartrate(), $._wHeartrate);
      case WhatAppBase.ShowInfoSpeed:
        return new WhatAppBase.WhatInformation(
            $._wSpeed.getCurrentSpeed(), $._wSpeed.getAverageSpeed(),
            $._wSpeed.getMaxSpeed(), $._wSpeed);
      case WhatAppBase.ShowInfoCadence:
        return new WhatAppBase.WhatInformation(
            $._wCadence.getCurrentCadence(), $._wCadence.getAverageCadence(),
            $._wCadence.getMaxCadence(), $._wCadence);
      case WhatAppBase.ShowInfoAltitude:
        return new WhatAppBase.WhatInformation(
            $._wAltitude.getCurrentAltitude(), 0, 0, $._wAltitude);
      case WhatAppBase.ShowInfoGrade:
        return new WhatAppBase.WhatInformation($._wGrade.getGrade(), 0, 0,
                                               $._wGrade);
      case WhatAppBase.ShowInfoHeading:
        return new WhatAppBase.WhatInformation($._wHeading.getCurrentHeading(),
                                               0, 0, $._wHeading);
      case WhatAppBase.ShowInfoDistance:
        return new WhatAppBase.WhatInformation(
            $._wDistance.getElapsedDistanceMorKm(), 0, 0, $._wDistance);
      case WhatAppBase.ShowInfoAmbientPressure:
        return new WhatAppBase.WhatInformation($._wPressure.getPressure(), 0, 0,
                                               $._wPressure);
      case WhatAppBase.ShowInfoTimeOfDay:
        return new WhatAppBase.WhatInformation($._wTime.getTime(), 0, 0,
                                               $._wTime);
      case WhatAppBase.ShowInfoCalories:
        return new WhatAppBase.WhatInformation($._wCalories.getCalories(), 0, 0,
                                               $._wCalories);
      case WhatAppBase.ShowInfoTotalAscent:
        return new WhatAppBase.WhatInformation($._wAltitude.getTotalAscent(), 0,
                                               0, $._wAltitude);
      case WhatAppBase.ShowInfoTotalDescent:
        return new WhatAppBase.WhatInformation($._wAltitude.getTotalDescent(),
                                               0, 0, $._wAltitude);
      case WhatAppBase.ShowInfoTrainingEffect:
        if (info != null) {
          $._wTrainingEffect.updateInfo(info);
        }
        if (!$._wTrainingEffect.isAvailable() &&
            showInfoTrainingEffectFallback != WhatAppBase.ShowInfoNothing) {
          return getShowInformation(showInfoTrainingEffectFallback,
                                    WhatAppBase.ShowInfoNothing,
                                    WhatAppBase.ShowInfoNothing, null);
        }
        return new WhatAppBase.WhatInformation(
            $._wTrainingEffect.getTrainingEffect(), 0, 0, $._wTrainingEffect);
      case WhatAppBase.ShowInfoEnergyExpenditure:
        return new WhatAppBase.WhatInformation(
            $._wEngergyExpenditure.getEnergyExpenditure(), 0, 0,
            $._wEngergyExpenditure);
      case WhatAppBase.ShowInfoNothing:
      default:
        return null;
    }
  }
}