within AixLib.Systems.HydraulicModules.Example;
model SimpleConsumer_Feedback
  extends Modelica.Icons.Example;
  package MediumWater = AixLib.Media.Water;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0) = 0.5
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Volume V_Water = 0.1;

  SimpleConsumer_wPump_wFeedback simpleConsumer_wPump_wFeedback(
    kA=1000,
    capacity=100000,
    V=V_Water,
    Q_flow_fixed=10000,
    hasFeedback=true,
    k_ControlConsumerValve=0.5,
    Ti_ControlConsumerValve=10,
    dp_Valve=400000,
    dpFixed_nominal=0,
    redeclare package Medium = MediumWater,
    T_return=313.15,
    m_flow_nominal=m_flow_nominal,
    functionality="T_fixed",
    demandType=1)
    annotation (Placement(transformation(extent={{-6,-10},{14,10}})));
  BaseClasses.PumpCircuit pumpCircuit(
    redeclare package Medium = MediumWater,
    m_flow_total=m_flow_nominal,
    dp_nom=100000,
    V_Water=V_Water)   annotation (Placement(transformation(
        extent={{-22,-10},{22,10}},
        rotation=180,
        origin={0,-60})));
  Fluid.Sources.Boundary_pT
                      bou(
    use_T_in=false,
    redeclare package Medium = MediumWater,
    nPorts=1)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Sources.RealExpression y_pump(y=1)    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Modelica.Blocks.Sources.RealExpression T_pump(y=273.15 + 50)    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={32,-80})));
  Fluid.Sensors.TemperatureTwoPort senTFlow(
    redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    T_start=293.15)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-34})));
  Fluid.Sensors.TemperatureTwoPort senTReturn(
    redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    T_start=293.15)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={44,-30})));
equation
  connect(bou.ports[1], simpleConsumer_wPump_wFeedback.port_a)
    annotation (Line(points={{-90,0},{-6,0}},  color={0,127,255}));
  connect(y_pump.y, pumpCircuit.y) annotation (Line(points={{-19,-80},{
          -6.66134e-16,-80},{-6.66134e-16,-69.5}},
                                      color={0,0,127}));
  connect(T_pump.y, pumpCircuit.T) annotation (Line(points={{21,-80},{4.4,-80},
          {4.4,-69.5}},color={0,0,127}));
  connect(pumpCircuit.port_b, senTFlow.port_a) annotation (Line(points={{-22,-60},
          {-60,-60},{-60,-44}}, color={0,127,255}));
  connect(senTFlow.port_b, simpleConsumer_wPump_wFeedback.port_a)
    annotation (Line(points={{-60,-24},{-60,0},{-6,0}},  color={0,127,255}));
  connect(simpleConsumer_wPump_wFeedback.port_b, senTReturn.port_a)
    annotation (Line(points={{14,0},{44,0},{44,-20}}, color={0,127,255}));
  connect(senTReturn.port_b, pumpCircuit.port_a)
    annotation (Line(points={{44,-40},{44,-60},{22,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SimpleConsumer_Feedback;
