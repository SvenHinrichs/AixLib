within AixLib.Systems.HydraulicModules.BaseClasses;
model SimpleConsumer_base
  extends AixLib.Fluid.Interfaces.PartialTwoPort(redeclare package Medium =
        Media.Water);
  extends AixLib.Fluid.Interfaces.LumpedVolumeDeclarations;

  parameter Boolean hasPump=false   "circuit has Pump" annotation (Dialog(group = "Pump"), choices(checkBox = true));
  parameter Boolean hasFeedback = false "circuit has Feedback" annotation (Dialog(group = "Feedback"), choices(checkBox = true));
  parameter Boolean fixed_return_T=true  "= true, if fixed return temperature, false if variable" annotation (Dialog(group = "System"), choices(checkBox = true));
  parameter Boolean fixed_flow_T=true  "= true, if fixed return temperature, false if variable" annotation (Dialog(group = "System"), choices(checkBox = true));

  parameter Integer demandType   "Choose between heating and cooling functionality" annotation (choices(
              choice=1 "use as heating consumer",
              choice=-1 "use as cooling consumer"),Dialog(enable=true, group = "System"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0.001)
  "Nominal mass flow rate";
  parameter Modelica.SIunits.Volume V=0.001 "Volume of water";
  parameter Modelica.SIunits.PressureDifference dp_nominalPumpConsumer=500
    annotation (Dialog(enable = hasPump, group = "Pump"));
  final parameter Modelica.SIunits.VolumeFlowRate Vflow_nom = m_flow_nominal/rho_default;
  parameter Modelica.SIunits.PressureDifference dp_Valve = 0 "Pressure Difference set in regulating valve for pressure equalization in heating system"
    annotation (Dialog(enable = hasFeedback, group="Feedback"));
  parameter Modelica.SIunits.PressureDifference dpFixed_nominal[2] = {0,0} "Nominal additional pressure drop e.g. for distributor"
    annotation (Dialog(enable = hasFeedback, group="Feedback"));
  parameter Real k_ControlConsumerPump(min=Modelica.Constants.small)=0.5 "Gain of controller"
    annotation (Dialog(enable = hasPump, group = "Pump"));
  parameter Modelica.SIunits.Time Ti_ControlConsumerPump(min=Modelica.Constants.small)=10 "Time constant of Integrator block"
    annotation (Dialog(enable = hasPump, group = "Pump"));
  parameter Modelica.SIunits.Temperature T_return=293.15  "Return temperature" annotation (Dialog(enable = fixed_return_T));
  parameter Modelica.SIunits.Temperature T_flow=293.15  "Flow temperature" annotation (Dialog(enable = fixed_flow_T));
  parameter Real k_ControlConsumerValve(min=Modelica.Constants.small)=0.5
                                                                        "Gain of controller"
    annotation (Dialog(enable = hasFeedback, group = "Feedback"));
  parameter Modelica.SIunits.Time Ti_ControlConsumerValve=10                              "Time constant of Integrator block"
    annotation (Dialog(enable = hasFeedback, group = "Feedback"));

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default);
  parameter Modelica.SIunits.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";

public
  Fluid.Movers.SpeedControlled_y fan(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    per(pressure(V_flow={0,Vflow_nom,Vflow_nom/0.7}, dp={dp_nominalPumpConsumer/0.7,dp_nominalPumpConsumer,0})),
    addPowerToMedium=false) if hasPump       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={4,-1.77636e-15})));
  Fluid.MixingVolumes.MixingVolume volume(
    redeclare package Medium = Medium,
    final V=V,
    final m_flow_nominal=m_flow_nominal,
    nPorts=3)                                                     annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={32,10})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare package Medium = Medium,
    from_dp=false,
    y_start=0.5,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_Valve,
    dpFixed_nominal=dpFixed_nominal) if hasFeedback
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Fluid.Sensors.TemperatureTwoPort senTFlow(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    T_start=T_start) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-52,0})));
  Fluid.Sensors.TemperatureTwoPort senTReturn(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    T_start=T_start) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={68,0})));
  Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare package Medium = Medium,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));

  Modelica.Blocks.Math.Gain gain(k=demandType) if hasPump
    "Used to reverse direction of operation of controller"
    annotation (Placement(transformation(extent={{2,-44},{-6,-36}})));
  Modelica.Blocks.Continuous.LimPID PIPump(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k_ControlConsumerPump,
    Ti=Ti_ControlConsumerPump,
    yMax=1,
    yMin=0.05,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_start=1) if hasPump
        annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={-22,-30})));
  Modelica.Blocks.Sources.RealExpression TSet_Return(y=demandType*T_return) if
       hasPump and fixed_return_T
    annotation (Placement(transformation(extent={{-54,-40},{-34,-20}})));

  Modelica.Blocks.Continuous.LimPID PIValve(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k_ControlConsumerValve,
    Ti=Ti_ControlConsumerValve,
    yMax=1,
    yMin=0.05,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_start=0.5) if hasFeedback
               annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-52,32})));
  Modelica.Blocks.Sources.RealExpression TSet_Flow(y=demandType*T_flow) if hasFeedback and fixed_return_T
    annotation (Placement(transformation(extent={{-20,22},{-40,42}})));
  Modelica.Blocks.Math.Gain gain2(k=demandType) if hasFeedback
    "Used to reverse direction of operation of controller"
    annotation (Placement(transformation(extent={{-4,-4},{4,4}},
        rotation=90,
        origin={-52,20})));
  Modelica.Blocks.Math.Gain gain_Tf(k=demandType) if hasPump and not fixed_flow_T     "Used to reverse direction of operation of controller" annotation (
      Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={-74,-60})));
  Modelica.Blocks.Math.Gain gain_Tr(k=demandType) if hasFeedback and not fixed_return_T     "Used to reverse direction of operation of controller" annotation (
      Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={-74,-80})));
  Modelica.Blocks.Interfaces.RealInput T_Flow if hasPump and not fixed_flow_T annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-106,-60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-40})));
  Modelica.Blocks.Interfaces.RealInput T_Return if hasFeedback and not fixed_return_T annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-106,-80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-110,-90})));
equation

  if hasPump then
    connect(fan.port_b, volume.ports[1])
      annotation (Line(points={{14,0},{34.6667,0}}, color={0,127,255}));
    connect(senMasFlo.port_b, fan.port_a)
      annotation (Line(points={{-12,0},{-6,0}}, color={0,127,255}));
    connect(PIPump.u_m,gain. y) annotation (Line(points={{-22,-37.2},{-22,-40},{
            -6.4,-40}},     color={0,0,127}));
    if fixed_return_T then
      connect(TSet_Return.y,PIPump. u_s) annotation (Line(points={{-33,-30},{-29.2,
            -30}},      color={0,0,127}));
    else
      connect(T_Return,gain_Tr. u)   annotation (Line(points={{-106,-80},{-81.2,-80}}, color={0,0,127}));
      connect(gain_Tr.y, PIPump.u_s) annotation (Line(points={{-67.4,-80},{-29.2,-80},
          {-29.2,-30}}, color={0,0,127}));
    end if;
    connect(gain.u, senTReturn.T)
      annotation (Line(points={{2.8,-40},{68,-40},{68,-11}}, color={0,0,127}));
    connect(PIPump.y, fan.y)
      annotation (Line(points={{-15.4,-30},{4,-30},{4,-12}}, color={0,0,127}));
  else
    connect(senMasFlo.port_b, volume.ports[1]);
  end if;

  if hasFeedback then
    connect(port_a, val.port_1)
      annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
    connect(volume.ports[2], val.port_3) annotation (Line(points={{32,0},{32,-18},
            {-80,-18},{-80,-10}},
                                color={0,127,255}));
    connect(val.port_2, senTFlow.port_a)
      annotation (Line(points={{-70,0},{-62,0}}, color={0,127,255}));
    if fixed_flow_T then
      connect(PIValve.u_s,TSet_Flow. y)
        annotation (Line(points={{-44.8,32},{-41,32}}, color={0,0,127}));
    else
      connect(T_Flow,gain_Tf. u)   annotation (Line(points={{-106,-60},{-81.2,-60}}, color={0,0,127}));
      connect(gain_Tf.y, PIValve.u_s) annotation (Line(points={{-67.4,-60},{-60,-60},
          {-60,-40},{-100,-40},{-100,44},{-44.8,44},{-44.8,32}}, color={0,0,127}));
    end if;
    connect(gain2.y,PIValve. u_m)
      annotation (Line(points={{-52,24.4},{-52,24.8}}, color={0,0,127}));
    connect(gain2.u, senTFlow.T)
      annotation (Line(points={{-52,15.2},{-52,11}},          color={0,0,127}));

  else
    connect(port_a, senTFlow.port_a);
  end if;

  connect(volume.ports[3], senTReturn.port_a) annotation (Line(points={{29.3333,
          0},{43.6667,0},{43.6667,1.77636e-15},{58,1.77636e-15}}, color={0,127,255}));
  connect(senTReturn.port_b, port_b) annotation (Line(points={{78,-8.88178e-16},
          {89,-8.88178e-16},{89,0},{100,0}}, color={0,127,255}));
  connect(senTFlow.port_b, senMasFlo.port_a)
    annotation (Line(points={{-42,0},{-32,0}}, color={0,127,255}));
  connect(PIValve.y, val.y)
    annotation (Line(points={{-58.6,32},{-80,32},{-80,12}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{20,-124},{60,-139},{20,-154},{20,-124}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=not allowFlowReversal),
        Line(
          points={{55,-139},{-60,-139}},
          color={0,128,255},
          visible=not allowFlowReversal),
                   Ellipse(
          extent={{-80,80},{80,-80}},
          lineColor={95,95,95},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={95,95,95},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),Text(
          extent={{-56,18},{56,-18}},
          lineColor={95,95,95},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="CONSUMER")}),                              Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SimpleConsumer_base;
