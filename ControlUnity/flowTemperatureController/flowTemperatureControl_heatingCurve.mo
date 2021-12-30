within ControlUnity.flowTemperatureController;
model flowTemperatureControl_heatingCurve
  "Flow temperature control (power control) with heating curve"


   //Heating Curve
 replaceable function HeatingCurveFunction =
      AixLib.Controls.SetPoints.Functions.HeatingCurveFunction constrainedby
    AixLib.Controls.SetPoints.Functions.PartialBaseFct;
 parameter Boolean use_tableData=true  "Choose between tables or function to calculate TSet";
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
    final heatingCurveRecord=
        AixLib.DataBase.Boiler.DayNightMode.HeatingCurves_Vitotronic_Day23_Night10(),
    final declination=declination,
    redeclare function HeatingCurveFunction = HeatingCurveFunction,
    final use_tableData=true,
    final TRoom_nominal=293.15)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));

  Modelica.Blocks.Interfaces.RealOutput PLRset
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    "Ambient temperature for heating curve"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Continuous.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.3,
    Ti=3,
    yMax=0.99,
    yMin=0) "PI Controller for controlling the valve position"
            annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-48})));
  Modelica.Blocks.Interfaces.RealInput TMea annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={66,-100})));
  Modelica.Blocks.Interfaces.BooleanInput isOn
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}})));
equation


  connect(Tamb, heatingCurve.T_oda)
    annotation (Line(points={{-100,0},{-70,0}}, color={0,0,127}));
  connect(heatingCurve.TSet, PID.u_s)
    annotation (Line(points={{-47,0},{-24,0}}, color={0,0,127}));
  connect(switch1.y, PID.u_m)
    annotation (Line(points={{30,-37},{30,-24},{-12,-24},{-12,-12}},
                                               color={0,0,127}));
  connect(PID.y, PLRset)
    annotation (Line(points={{-1,0},{100,0}}, color={0,0,127}));
  connect(isOn, switch1.u2) annotation (Line(points={{-100,-80},{30,-80},{30,
          -60}}, color={255,0,255}));
  connect(heatingCurve.TSet, switch1.u3) annotation (Line(points={{-47,0},{-38,
          0},{-38,42},{120,42},{120,-66},{38,-66},{38,-60}}, color={0,0,127}));
  connect(TMea, switch1.u1) annotation (Line(points={{66,-100},{66,-72},{22,-72},
          {22,-60}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>Ambient temperature guided flow temperature control for heat generators. The temperature control can be switched on and off via the isOn input from the outside. A heating curve model is used to determine the required flow temperature depending on the ambient temperature. The associated data are recorded in a table and the values are determined by means of interpolation. Furthermore, the model has a day and night mode, in which the set temperatures differ at the same ambient temperature. The PI-Controller was set for this application. </p>
<h4>Important parameters</h4>
<ul>
<li>declination: The user can choose the steepness of the curve. The higher the parameter, the higher the determined </li>
</ul>
</html>"));
end flowTemperatureControl_heatingCurve;
