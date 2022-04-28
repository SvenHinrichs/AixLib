within AixLib.Systems.HydraulicModules.Example;
model SimpleConsumer_Pump_Feedback
  extends Modelica.Icons.Example;
  extends AixLib.Fluid.Interfaces.LumpedVolumeDeclarations;

  package MediumWater = AixLib.Media.Water;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0) = 0.5
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Volume V_Water = 0.1;

  SimpleConsumer_wPump_wFeedback simpleConsumer_wPump_wFeedback(
    kA=1000,
    capacity=100000,
    V=V_Water,
    Q_flow_fixed=10000,
    hasPump=true,
    k_ControlConsumerPump=0.5,
    Ti_ControlConsumerPump=10,
    hasFeedback=true,
    k_ControlConsumerValve=0.5,
    Ti_ControlConsumerValve=10,
    dp_Valve=400000,
    redeclare package Medium = MediumWater,
    T_return=313.15,
    m_flow_nominal=m_flow_nominal,
    functionality="Q_flow_fixed",
    demandType=1)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Fluid.Sources.Boundary_pT
                      bou(
    use_T_in=false,
    redeclare package Medium = MediumWater,
    nPorts=1)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
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
  Fluid.MixingVolumes.MixingVolume              vol(
    redeclare package Medium = MediumWater,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    mSenFac=mSenFac,
    allowFlowReversal=false,
    V=V_Water,
    m_flow_nominal=m_flow_nominal,
    nPorts=2)
    annotation (Placement(transformation(extent={{-8,-60},{8,-44}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
                                                      fixedTemperature(T=323.15)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=180,
        origin={2,-90})));
equation
  connect(bou.ports[1], simpleConsumer_wPump_wFeedback.port_a)
    annotation (Line(points={{-90,0},{-8,0}},  color={0,127,255}));
  connect(senTFlow.port_b, simpleConsumer_wPump_wFeedback.port_a)
    annotation (Line(points={{-60,-24},{-60,0},{-8,0}},  color={0,127,255}));
  connect(simpleConsumer_wPump_wFeedback.port_b, senTReturn.port_a)
    annotation (Line(points={{12,0},{44,0},{44,-20}}, color={0,127,255}));
  connect(fixedTemperature.port, vol.heatPort) annotation (Line(points={{-4,-90},
          {-40,-90},{-40,-52},{-8,-52}}, color={191,0,0}));
  connect(senTReturn.port_b, vol.ports[1]) annotation (Line(points={{44,-40},{44,
          -60},{-1.6,-60}}, color={0,127,255}));
  connect(vol.ports[2], senTFlow.port_a) annotation (Line(points={{1.6,-60},{-60,
          -60},{-60,-44}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SimpleConsumer_Pump_Feedback;
