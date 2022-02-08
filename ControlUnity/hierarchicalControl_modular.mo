within ControlUnity;
model hierarchicalControl_modular

  ///Hierarchy Control
  parameter Real PLRMin=0.15;
  parameter Boolean use_advancedControl      "Selection between two position control and flow temperature control, if true=flow temperature control is active"
                                                                                                                                                              annotation(choices(
      choice=true "Flow temperature control",
      choice=false "Two position control",
      radioButtons=true));
   parameter Boolean manualTimeDelay "If true, the user can set a time during which the heat genearator is switched on independently of the internal control";

  Modelica.Blocks.Interfaces.RealInput Tb "Boiler temperature"
    annotation (Placement(transformation(extent={{-120,-52},{-80,-12}})));
  Modelica.Blocks.Interfaces.RealOutput PLRset
    annotation (Placement(transformation(extent={{92,50},{112,70}})));

  Modelica.Blocks.Interfaces.RealInput PLRin if not use_advancedControl or (
    use_advancedControl and severalHeatcurcuits)
    annotation (Placement(transformation(extent={{-120,38},{-80,78}})));

      emergencySwitch_modularBoiler emergencySwitch_modularBoiler1(TMax=TMax)
    annotation (Placement(transformation(extent={{-70,28},{-50,48}})));
 //Two position controller
 replaceable model TwoPositionController_top =
      ControlUnity.twoPositionController.BaseClass.partialTwoPositionController
 constrainedby
    ControlUnity.twoPositionController.BaseClass.partialTwoPositionController(Tref=Tref, bandwidth=bandwidth, n=n) annotation(choicesAllMatching=true);

  Modelica.Blocks.Interfaces.RealInput TLayers[n]
    "Different temperatures of layers of buffer storage, 1 lowest layer and n top layer; if simple two position controller, then it is equal to Tin"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={4,100})));

  parameter Integer n=3 "Number of layers in the buffer storage" annotation(Dialog(
        group="Two position controller"));

  parameter Real bandwidth "Bandwidth around reference signal" annotation(Dialog(
        group="Two position controller"));
   //////
   //////
   //////

  //Flow temperature control

    Modelica.Blocks.Interfaces.RealInput Tamb if use_advancedControl and not
    severalHeatcurcuits
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-120,-98},{-80,-58}})));

  Modelica.Blocks.Interfaces.RealOutput valPos[k] if use_advancedControl and severalHeatcurcuits
    "Valve position to control the three-way valve"
    annotation (Placement(transformation(extent={{90,-76},{110,-56}})));
  parameter Boolean severalHeatcurcuits "If true, there are two or more heat curcuits" annotation(Dialog(enable=use_advancedControl, group="Flow temperature control"), choices(
      choice=true "Several heat curcuits",
      choice=false "One heat curcuit",
      radioButtons=true));

  //Flow temperature control

  Modelica.Blocks.Interfaces.BooleanInput isOn
    annotation (Placement(transformation(extent={{-122,0},{-82,40}})));

  parameter Boolean variablePLR
    "If true, the user can determine the PLR between PLRmin and 1; else you have a two position conttol with the values 0 and 1 for PLR";

  parameter Integer k "Number of heat curcuits" annotation(Dialog(group="Admixture control"));
  Modelica.Blocks.Interfaces.RealInput TMeaCon[k] if use_advancedControl and
    severalHeatcurcuits
    "Measurement temperature of the consumer" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={90,-116})));
  parameter Modelica.SIunits.Temperature TBoiler=273.15 + 75
    "Fix boiler temperature for the admixture"
                                              annotation(Dialog(
        group="Admixture control"));
  parameter Modelica.SIunits.Temperature Tref
    "Reference Temperature for the on off controller"
                                                     annotation(Dialog(
        group="Two position controller"));

  Modelica.Blocks.Interfaces.RealInput TCon[k] if use_advancedControl and
    severalHeatcurcuits "Set temperature for the consumers" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={34,-116})));
  parameter Real declination=1 "Declination of curve" annotation(Dialog(group="Flow temperature control"));
  parameter Real day_hour=6 "Hour of day in which day mode is enabled" annotation(Dialog(group="Flow temperature control"));
  parameter Real night_hour=22 "Hour of night in which night mode is enabled" annotation (Dialog(group="Flow temperature control"));
  parameter Modelica.SIunits.ThermodynamicTemperature TOffset(displayUnit="K") = 0
    "Offset to heating curve temperature" annotation(Dialog(group="Flow temperature control"));
  parameter Modelica.SIunits.Temperature TMax=273.15 + 105
    "Maximum temperature, at which the system is shut down" annotation(Dialog(group="Security-related systems"));

  Modelica.Blocks.Interfaces.RealInput TBoilerVar if use_advancedControl and severalHeatcurcuits
     and variableSetTemperature_admix "Variable boiler temperature for the admixture control" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-116})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Interfaces.RealInput PLRinEx
    "Set PLR from the extern control"
    annotation (Placement(transformation(extent={{-120,70},{-80,110}})));
  Modelica.Blocks.Interfaces.BooleanInput internControl
    "Choice between intern and extern control" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={42,100})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{76,0},{96,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression
    annotation (Placement(transformation(extent={{54,-10},{68,4}})));

  InternalControl internalControl(
    PLRMin=PLRMin,
    use_advancedControl=use_advancedControl,
    severalHeatcurcuits=severalHeatcurcuits,
    Tref=Tref,
    n=n,
    bandwidth=bandwidth,
    declination=declination,
    day_hour=day_hour,
    night_hour=night_hour,
    TOffset=TOffset,
    variableSetTemperature_admix=variableSetTemperature_admix)
    annotation (Placement(transformation(extent={{-22,14},{-2,34}})));
  parameter Modelica.SIunits.Time time_minOff=900
    "Time after which the device can be turned on again" annotation(Dialog(group="Manual control"));
  parameter Modelica.SIunits.Time time_minOn=900
    "Time after which the device can be turned off again" annotation(Dialog(group="Manual control"));
  parameter Boolean variableSetTemperature_admix
    "Choice between variable oder constant boiler temperature for the admixture control" annotation(Dialog(group="Admixture control"));
  ManualControl manualControl(
    manualTimeDelay=manualTimeDelay,
    time_minOff=time_minOff,
    time_minOn=time_minOn)
    annotation (Placement(transformation(extent={{24,20},{44,40}})));
equation

/// unconditioned quantities

  connect(PLRinEx, switch1.u3) annotation (Line(points={{-100,90},{-64,90},{-64,
          62},{44,62},{44,52},{58,52}}, color={0,0,127}));
  connect(internControl, switch1.u2)
    annotation (Line(points={{42,100},{42,60},{58,60}}, color={255,0,255}));
  connect(switch2.y, PLRset) annotation (Line(points={{97,10},{98,10},{98,46},{
          88,46},{88,60},{102,60}}, color={0,0,127}));
  connect(switch2.u3, realExpression.y)
    annotation (Line(points={{74,2},{72,2},{72,-3},{68.7,-3}},
                                                             color={0,0,127}));
  connect(switch1.y, switch2.u1) annotation (Line(points={{81,60},{84,60},{84,
          30},{64,30},{64,18},{74,18}}, color={0,0,127}));
  connect(emergencySwitch_modularBoiler1.y, switch2.u2) annotation (Line(points={{-49.6,
          38},{-38,38},{-38,10},{74,10}},        color={255,0,255}));
  connect(isOn, emergencySwitch_modularBoiler1.isOn) annotation (Line(points={{-102,20},
          {-90,20},{-90,22},{-80,22},{-80,45.4},{-70,45.4}},     color={255,0,255}));
  connect(Tb, emergencySwitch_modularBoiler1.TBoiler) annotation (Line(points={{-100,
          -32},{-86,-32},{-86,-30},{-78,-30},{-78,31.8},{-70,31.8}},      color=
         {0,0,127}));
  connect(TLayers, internalControl.TLayers) annotation (Line(points={{4,100},{4,
          44},{-11.4,44},{-11.4,34}},
                                    color={0,0,127}));
  connect(Tb, internalControl.Tflow) annotation (Line(points={{-100,-32},{-82,-32},
          {-82,-34},{-58,-34},{-58,20.6},{-22,20.6}}, color={0,0,127}));
  connect(TMeaCon, internalControl.TMeaCon) annotation (Line(points={{90,-116},{
          90,-80},{-3.6,-80},{-3.6,13.8}}, color={0,0,127}));
  connect(TCon, internalControl.TCon) annotation (Line(points={{34,-116},{34,-82},
          {-8.8,-82},{-8.8,13.8}}, color={0,0,127}));
  connect(TBoilerVar, internalControl.TBoilerVar) annotation (Line(points={{0,-116},
          {0,-86},{26,-86},{26,-56},{-11.8,-56},{-11.8,13.8}},
                                                             color={0,0,127}));
  connect(internalControl.valPos, valPos) annotation (Line(points={{-1.6,17.6},{
          50,17.6},{50,-66},{100,-66}}, color={0,0,127}));
  connect(emergencySwitch_modularBoiler1.y, manualControl.isOn) annotation (
      Line(points={{-49.6,38},{12,38},{12,30},{24,30}}, color={255,0,255}));
  connect(internalControl.PLRset, manualControl.PLR) annotation (Line(points={{-2,
          28.2},{2,28.2},{2,32},{16,32},{16,37.6},{23.8,37.6}}, color={0,0,127}));
  connect(PLRin, internalControl.PLRin) annotation (Line(points={{-100,58},{-32,
          58},{-32,30},{-22,30}}, color={0,0,127}));
  connect(Tamb, internalControl.Tamb) annotation (Line(points={{-100,-78},{-32,-78},
          {-32,16.2},{-22,16.2}}, color={0,0,127}));
  connect(manualControl.PLRset, switch1.u1) annotation (Line(points={{44,36.8},{
          50,36.8},{50,38},{52,38},{52,68},{58,68}}, color={0,0,127}));
  connect(emergencySwitch_modularBoiler1.y, internalControl.isOn) annotation (
      Line(points={{-49.6,38},{-38,38},{-38,26},{-22,26}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>Model that contains the three different variants of control for heat generators:</p>
<ul>
<li>Two position control: Flow temperature of the boiler is controlled by an On-Off-Controller with hysteresis.</li>
<li>Ambient guided flow temperature control: Variable flow temperature of boiler which is determined by a heating curve as a function of the ambient temperature.</li>
<li>Admixture control: Fix flow temperature of boiler which is set by the user. The flow temperature to the consumer is also set by the user and is controlled to the set temperature by a valve.</li>
</ul>
<p>The control model is build up hierarchically. The emergency swith precedes all types of regulation. </p>
<h4>Important parameters</h4>
<ul>
<li>use_advancedControl: The user can select between two position control or flow temperature control.</li>
<li>severalHeatcurcuits: The user can select between ambient guided flow temperature control or admixture control.</li>
<li>n: Indicates the number of layers of the buffer storage.</li>
<li>k: Indicates the number of heat curcuits for the different consumers.</li>
<li>TBoiler: The user sets the fix flow temperature of the boiler before the simulation.</li>
<li>Tref: Set temperature for the two position controller.</li>
<li>bandwidth: Width of the hysteresis.</li>
</ul>
</html>"));
end hierarchicalControl_modular;
