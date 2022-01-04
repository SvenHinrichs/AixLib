within ControlUnity;
model hierarchicalControl_modularBoilerNEW

  ///Hierarchy Control
  parameter Real PLRmin=0.15;
  parameter Boolean use_advancedControl=false      "Selection between two position control and flow temperature control, if true=flow temperature control is active"
                                                                                                                                                                    annotation(choices(
      choice=true "Flow temperature control",
      choice=false "Two position control",
      radioButtons=true));

  Modelica.Blocks.Interfaces.RealInput Tb "Boiler temperature"
    annotation (Placement(transformation(extent={{-122,-36},{-82,4}})));
  Modelica.Blocks.Interfaces.RealOutput PLRset
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

  Modelica.Blocks.Interfaces.RealInput PLRin if not use_advancedControl or (
    use_advancedControl and severalHeatcurcuits)
    annotation (Placement(transformation(extent={{-120,54},{-80,94}})));

      emergencySwitch_modularBoiler emergencySwitch_modularBoiler1
    annotation (Placement(transformation(extent={{-60,16},{-40,36}})));
 //Two position controller
 replaceable twoPositionController.BaseClass.twoPositionControllerCal.twoPositionController_top
    twoPositionController_layers(
    n=n,
    variablePLR=variablePLR,
    bandwidth=bandwidth,
    Tref=Tref) if              not use_advancedControl
                                 constrainedby
    ControlUnity.twoPositionController.BaseClass.partialTwoPositionController(Tref=Tref, bandwidth=bandwidth, n=n)
    annotation (Placement(transformation(extent={{24,24},{44,44}})), choicesAllMatching=true, Dialog(enable=not use_advancedControl));
  Modelica.Blocks.Interfaces.RealInput TLayers[n]
    "Different temperatures of layers of buffer storage, 1 lowest layer and n top layer; if simple two position controller, then it is equal to Tin"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={6,100})));


  parameter Integer n=3 "Number of layers in the buffer storage" annotation(Dialog(
        group="Two position controller"));

  parameter Real bandwidth "Bandwidth around reference signal" annotation(Dialog(
        group="Two position controller"));
   //////
   //////
   //////

  //Flow temperature control
  flowTemperatureController.flowTemperatureControl_heatingCurve
    flowTemperatureControl_heatingCurve(declination=declination) if
                                           use_advancedControl and not severalHeatcurcuits
    annotation (Placement(transformation(extent={{-28,-70},{-8,-50}})));

    Modelica.Blocks.Interfaces.RealInput Tamb if use_advancedControl and not
    severalHeatcurcuits
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-120,-98},{-80,-58}})));

        flowTemperatureController.renturnAdmixture.returnAdmixture returnAdmixture(k=k,
    TBoiler=TBoiler,
    Tset=Tset,
    bandwidth=bandwidth) if                                                           use_advancedControl and severalHeatcurcuits
    annotation (Placement(transformation(extent={{46,-74},{66,-54}})));
  Modelica.Blocks.Interfaces.RealOutput valPos[k] if use_advancedControl and severalHeatcurcuits
    "Valve position to control the three-way valve"
    annotation (Placement(transformation(extent={{90,-76},{110,-56}})));
  parameter Boolean severalHeatcurcuits=false "If true, there are two or more heat curcuits" annotation(Dialog(enable=use_advancedControl, group="Flow temperature control"), choices(
      choice=true "Several heat curcuits",
      choice=false "One heat curcuit",
      radioButtons=true));


  //Flow temperature control

  parameter Modelica.SIunits.Temperature THotMax=378.15
    "Maximum temperature, from which the system is switched off" annotation(Dialog(group="Security-related systems"));




  Modelica.Blocks.Interfaces.BooleanInput isOn
    annotation (Placement(transformation(extent={{-120,16},{-80,56}})));

  parameter Boolean variablePLR=false
    "If true, the user can determine the PLR between PLRmin and 1; else you have a two position conttol with the values 0 and 1 for PLR";

  parameter Integer k "Number of heat curcuits";
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
        group="Flow temperature control"));
  parameter Modelica.SIunits.Temperature Tref
    "Reference Temperature for the on off controller"
                                                     annotation(Dialog(
        group="Two position controller"));
  parameter Modelica.SIunits.Temperature Tset[k];
  Modelica.Blocks.Interfaces.RealInput TCon[k] if use_advancedControl and
    severalHeatcurcuits "Set temperature for the consumers" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={38,-116})));
  parameter Real declination=1 annotation(Dialog(group="Flow temperature control"));
equation


/// unconditioned quantities

  connect(Tamb, flowTemperatureControl_heatingCurve.Tamb) annotation (Line(
        points={{-100,-78},{-74,-78},{-74,-60},{-28,-60}}, color={0,0,127}));
  connect(isOn, emergencySwitch_modularBoiler1.isOn) annotation (Line(points={{-100,36},
          {-74,36},{-74,33.4},{-60,33.4}},   color={255,0,255}));
  connect(PLRin, twoPositionController_layers.PLRin) annotation (Line(points={{-100,74},
          {-38,74},{-38,43},{24,43}},     color={0,0,127}));
  connect(emergencySwitch_modularBoiler1.y, twoPositionController_layers.isOn)
    annotation (Line(points={{-39.8,29},{10,29},{10,37.4},{24,37.4}}, color={255,
          0,255}));
  connect(emergencySwitch_modularBoiler1.y, flowTemperatureControl_heatingCurve.isOn)
    annotation (Line(points={{-39.8,29},{-36,29},{-36,-68},{-28,-68}}, color={255,
          0,255}));
  connect(emergencySwitch_modularBoiler1.y, returnAdmixture.isOn) annotation (
      Line(points={{-39.8,29},{10,29},{10,-56.6},{46,-56.6}},
                                                          color={255,0,255}));
  connect(returnAdmixture.PLRset, PLRset) annotation (Line(points={{66,-59.4},{
          78,-59.4},{78,60},{100,60}},
                                  color={0,0,127}));
  connect(flowTemperatureControl_heatingCurve.PLRset, PLRset) annotation (Line(
        points={{-8,-60},{-2,-60},{-2,-4},{86,-4},{86,60},{100,60}}, color={0,0,
          127}));
  connect(twoPositionController_layers.PLRset, PLRset) annotation (Line(points={{45.2,
          34.6},{62,34.6},{62,60},{100,60}},        color={0,0,127}));
  connect(TLayers, twoPositionController_layers.TLayers)
    annotation (Line(points={{6,100},{6,31.8},{24,31.8}}, color={0,0,127}));
  connect(returnAdmixture.valPos, valPos) annotation (Line(points={{66,-67.2},{
          82,-67.2},{82,-66},{100,-66}}, color={0,0,127}));
  connect(Tb, emergencySwitch_modularBoiler1.TBoiler) annotation (Line(points={
          {-102,-16},{-82,-16},{-82,20.4},{-60,20.4}}, color={0,0,127}));
  connect(Tb, returnAdmixture.TMeaBoiler) annotation (Line(points={{-102,-16},{
          -114,-16},{-114,-92},{30,-92},{30,-61},{46,-61}}, color={0,0,127}));
  connect(Tb, flowTemperatureControl_heatingCurve.TMea) annotation (Line(points=
         {{-102,-16},{-114,-16},{-114,-92},{-11.4,-92},{-11.4,-70}}, color={0,0,
          127}));
  connect(TMeaCon, returnAdmixture.TMea) annotation (Line(points={{90,-116},{90,
          -86},{56,-86},{56,-74}}, color={0,0,127}));
  connect(TCon, returnAdmixture.TCon) annotation (Line(points={{38,-116},{38,
          -67.2},{46,-67.2}}, color={0,0,127}));
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
end hierarchicalControl_modularBoilerNEW;
