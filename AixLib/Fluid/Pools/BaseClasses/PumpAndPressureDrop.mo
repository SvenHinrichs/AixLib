within AixLib.Fluid.Pools.BaseClasses;
model PumpAndPressureDrop
  "Model for a pump and a corresponding pressure drop to avoid pressure build up in the system"
  extends AixLib.Fluid.Interfaces.PartialTwoPort
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

  parameter Modelica.SIunits.Pressure pumpHead( min=0.001) "Nominal pressure difference pump and resistance";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min= 0.0001);
  parameter Modelica.SIunits.Pressure p_start;
  parameter Modelica.SIunits.Temperature T_water;

  Modelica.Blocks.Interfaces.RealOutput P( final quantity = "Power", final unit= "W")
    "Output eletric energy needed for pump operation"
    annotation (Placement(transformation(extent={{96,36},{116,56}})));
  AixLib.Fluid.Movers.FlowControlled_m_flow CirculationPump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_start=p_start,
    T_start=T_water,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    redeclare AixLib.Fluid.Movers.Data.Generic per,
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=pumpHead,
    m_flow_start=m_flow_nominal)
    annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
  AixLib.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = AixLib.Media.Water,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    show_T=false,
    from_dp=false,
    dp_nominal= pumpHead,
    homotopyInitialization=true,
    linearized=false,
    deltaM=0.3)
    annotation (Placement(transformation(extent={{22,-10},{42,10}})));
  Modelica.Blocks.Interfaces.RealInput setMFlow annotation (Placement(
        transformation(extent={{-128,44},{-88,84}}), iconTransformation(
          extent={{-112,60},{-88,84}})));
  AixLib.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        AixLib.Media.Water, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
  AixLib.Controls.Continuous.LimPID PI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=5,
    yMax=m_flow_nominal/0.9,
    yMin=0) annotation (Placement(transformation(extent={{-82,54},{-62,74}})));
equation
  connect(CirculationPump.P, P) annotation (Line(points={{-41,9},{-24,9},{-24,
          46},{106,46}},
                     color={0,0,127}));
  connect(PI.u_m, senMasFlo.m_flow) annotation (Line(points={{-72,52},{-72,30},
          {-12,30},{-12,11}},
                          color={0,0,127}));
  connect(PI.u_s, setMFlow) annotation (Line(points={{-84,64},{-108,64}},
                          color={0,0,127}));
  connect(PI.y, CirculationPump.m_flow_in) annotation (Line(points={{-61,64},
          {-52,64},{-52,12}},          color={0,0,127}));
  connect(CirculationPump.port_b, senMasFlo.port_a)
    annotation (Line(points={{-42,0},{-22,0}},color={0,127,255}));
  connect(senMasFlo.port_b, res.port_a)
    annotation (Line(points={{-2,0},{22,0}}, color={0,127,255}));
  connect(port_a, CirculationPump.port_a)
    annotation (Line(points={{-100,0},{-62,0}}, color={0,127,255}));
  connect(res.port_b, port_b)
    annotation (Line(points={{42,0},{100,0}}, color={0,127,255}));
  annotation (Icon(graphics={Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(points={{0,60},{60,0},{0,-60}},
            color={0,0,0})}), Documentation(info="<html>
<p>This is model&nbsp; describes a&nbsp;pump&nbsp;with prescribed mass flow (<a href=\"AixLib.Fluid.Movers.FlowControlled_m_flow\">AixLib.Fluid.Movers.FlowControlled_m_flow</a>) and&nbsp;a&nbsp;corresponding&nbsp;pressure&nbsp;drop&nbsp;(<a href=\"FixedResistances.PressureDrop\">FixedResistances.PressureDrop</a>) to&nbsp;avoid&nbsp;pressure&nbsp;build&nbsp;up&nbsp;in&nbsp;the&nbsp;system, while calculating the consumed power. </p>
</html>"));
end PumpAndPressureDrop;