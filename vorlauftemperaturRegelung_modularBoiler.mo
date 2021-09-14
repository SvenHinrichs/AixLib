within ;
model vorlauftemperaturRegelung_modularBoiler
   //Heating Curve
 replaceable function HeatingCurveFunction =
      AixLib.Controls.SetPoints.Functions.HeatingCurveFunction constrainedby
    AixLib.Controls.SetPoints.Functions.PartialBaseFct;
 parameter Boolean use_tableData=true  "Choose between tables or function to calculate TSet";
 parameter
    AixLib.DataBase.Boiler.DayNightMode.HeatingCurvesDayNightBaseDataDefinition
    heatingCurveRecord=AixLib.DataBase.Boiler.DayNightMode.HeatingCurves_Vitotronic_Day25_Night10()  "Record with information about heating curve data";
 parameter Real declination=1;
 parameter Real day_hour=6;
 parameter Real night_hour=22;
 parameter AixLib.Utilities.Time.Types.ZeroTime zerTim=AixLib.Utilities.Time.Types.ZeroTime.NY2017
    "Enumeration for choosing how reference time (time = 0) should be defined. Used for heating curve";







  AixLib.Controls.SetPoints.HeatingCurve heatingCurve(
    final TOffset=0,
    final use_dynTRoom=false,
    final zerTim=zerTim,
    final day_hour=day_hour,
    final night_hour=night_hour,
    final heatingCurveRecord=heatingCurveRecord,
    final declination=declination,
    redeclare function HeatingCurveFunction = HeatingCurveFunction,
    final use_tableData=use_tableData,
    final TRoom_nominal=293.15)
    annotation (Placement(transformation(extent={{-54,-20},{-34,0}})));
  Modelica.Blocks.Interfaces.RealOutput T_Vorlauf
    annotation (Placement(transformation(extent={{90,-20},{110,0}})));

  Modelica.Blocks.Interfaces.RealInput T_outdoor
    annotation (Placement(transformation(extent={{-120,-30},{-80,10}})));
  Modelica.Blocks.Interfaces.RealInput PLR_ein
    annotation (Placement(transformation(extent={{-120,50},{-80,90}})));
  Modelica.Blocks.Interfaces.RealOutput PLR_aus annotation (Placement(
        transformation(extent={{92,58},{116,82}}), iconTransformation(extent={{92,58},
            {116,82}})));
equation

  connect(heatingCurve.TSet, T_Vorlauf)
    annotation (Line(points={{-33,-10},{100,-10}},
                                                color={0,0,127}));
  connect(T_outdoor, heatingCurve.T_oda)
    annotation (Line(points={{-100,-10},{-56,-10}}, color={0,0,127}));
  connect(PLR_ein, PLR_aus) annotation (Line(points={{-100,70},{104,70}},
                           color={0,0,127}));
  annotation (uses(AixLib(version="1.0.0"), Modelica(version="3.2.3")));
end vorlauftemperaturRegelung_modularBoiler;