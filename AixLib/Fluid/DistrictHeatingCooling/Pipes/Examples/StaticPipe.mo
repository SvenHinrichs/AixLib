within AixLib.Fluid.DistrictHeatingCooling.Pipes.Examples;
model StaticPipe "Simple example of StaticPipe"
  extends Modelica.Icons.Example;
  replaceable package Medium = AixLib.Media.Water "Medium in the pipe" annotation (
      choicesAllMatching=true);
  Modelica.Blocks.Sources.Ramp Tin(
    height=20,
    duration=0,
    offset=273.15 + 50,
    startTime=100) "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-92,-6},{-72,14}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{82,-10},{62,10}})));
  AixLib.Fluid.DistrictHeatingCooling.Pipes.StaticPipe pip(
    redeclare package Medium = Medium,
    nPorts=1,
    dh=0.1,
    length=100,
    dIns=0.05,
    kIns=0.028,
    m_flow_nominal=1,
    cPip=500,
    thickness=0.0032,
    initDelay=true,
    m_flow_start=1,
    rhoPip=8000,
    use_zeta=true,
    T_start_in=323.15,
    T_start_out=323.15) "Pipe"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature bou(T=283.15)
    "Boundary temperature"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  AixLib.Fluid.Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Flow source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  AixLib.Fluid.Sensors.TemperatureTwoPort senTemOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTemIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
equation
  connect(bou.port, pip.heatPort)
    annotation (Line(points={{-20,70},{10,70},{10,10}}, color={191,0,0}));
  connect(Tin.y, sou.T_in)
    annotation (Line(points={{-71,4},{-62,4}}, color={0,0,127}));
  connect(pip.ports_b[1], senTemOut.port_a)
    annotation (Line(points={{20,0},{30,0}}, color={0,127,255}));
  connect(senTemOut.port_b, sin.ports[1])
    annotation (Line(points={{50,0},{62,0}}, color={0,127,255}));
  connect(sou.ports[1], senTemIn.port_a)
    annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
  connect(senTemIn.port_b, pip.port_a)
    annotation (Line(points={{-10,0},{0,0}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(file="modelica://AixLib/Resources/Scripts/Dymola/Fluid/DistrictHeatingCooling/Pipes/Examples/StaticPipe.mos"
                      "Simulate and plot"),
    experiment(StopTime=1000, Tolerance=1e-006),
    Documentation(info="<html><p>
  Basic test of model <a href=
  \"modelica://AixLib.Fluid.DistrictHeatingCooling.Pipes.StaticPipe\">AixLib.Fluid.DistrictHeatingCooling.Pipes.StaticPipe</a>.
  This test includes an inlet temperature step under a constant mass
  flow rate.
</p>
<ul>
  <li>September 25, 2019 by Nils Neuland:<br/>
    First implementation
  </li>
</ul>
</html>"));
end StaticPipe;
