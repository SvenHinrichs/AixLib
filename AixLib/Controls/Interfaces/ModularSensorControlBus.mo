within AixLib.Controls.Interfaces;
expandable connector ModularSensorControlBus
  "Connector used for modular sensors"
  extends Modelica.Icons.SignalBus;

  // Definition of parameters describing modular approach in general
  //
  parameter Integer nValSen = 1
    "Number of expansion valves"
    annotation(Dialog(tab="General",group="Modular approach"),
               HideResult=true);
  parameter Integer nEvaSen = 1
    "Number of evaporators"
    annotation(Dialog(tab="General",group="Modular approach"),
               HideResult=true);
  parameter Integer nComSen = 1
    "Number of compressors"
    annotation(Dialog(tab="General",group="Modular approach"),
               HideResult=true);
  parameter Integer nConSen = 1
    "Number of condensers"
    annotation(Dialog(tab="General",group="Modular approach"),
               HideResult=true);

  // Definition of variables describing expansion valves
  //
  Modelica.SIunits.AbsolutePressure senPreVal[nValSen]
    "Array of measured pressures at expansion valves' outlets"
    annotation(Dialog(tab="Measurements",group="Expansion Valves"));
  Modelica.SIunits.Temperature senTemVal[nValSen]
    "Array of measured temperatures at expansion valves' outlets"
    annotation(Dialog(tab="Measurements",group="Expansion Valves"));
  Modelica.SIunits.MassFlowRate senMasFloVal[nValSen]
    "Array of measured mass flow rates at expansion valves' outlets"
    annotation(Dialog(tab="Measurements",group="Expansion Valves"));
  Real senPhaVal[nValSen](unit="1")
    "Array of measured phases at expansion valves' outlets"
    annotation(Dialog(tab="Measurements",group="Expansion Valves"));

  // Definition of variables describing evaporators
  //
  Modelica.SIunits.AbsolutePressure senPreEva[nEvaSen]
    "Array of measured pressures at evaporators' outlets"
    annotation(Dialog(tab="Measurements",group="Evaporators"));
  Modelica.SIunits.Temperature senTemEva[nEvaSen]
    "Array of measured temperatures at evaporators' outlets"
    annotation(Dialog(tab="Measurements",group="Evaporators"));
  Modelica.SIunits.MassFlowRate senMasFloEva[nEvaSen]
    "Array of measured mass flow rates at evaporators' outlets"
    annotation(Dialog(tab="Measurements",group="Evaporators"));
  Real senPhaEva[nEvaSen](unit="1")
    "Array of measured phases at evaporators' outlets"
    annotation(Dialog(tab="Measurements",group="Evaporators"));

  // Definition of variables describing compressors
  //
  Modelica.SIunits.AbsolutePressure senPreCom[nComSen]
    "Array of measured pressures at compressors' outlets"
    annotation(Dialog(tab="Measurements",group="Compressors"));
  Modelica.SIunits.Temperature senTemCom[nComSen]
    "Array of measured temperatures at compressors' outlets"
    annotation(Dialog(tab="Measurements",group="Compressors"));
  Modelica.SIunits.MassFlowRate senMasFloCom[nComSen]
    "Array of measured mass flow rates at compressors' outlets"
    annotation(Dialog(tab="Measurements",group="Compressors"));
  Real senPhaCom[nComSen](unit="1")
    "Array of measured phases at compressors' outlets"
    annotation(Dialog(tab="Measurements",group="Compressors"));

  // Definition of variables describing condensers
  //
  Modelica.SIunits.AbsolutePressure senPreCon[nConSen]
    "Array of measured pressures at expansion valves' outlets"
    annotation(Dialog(tab="Measurements",group="Condensers"));
  Modelica.SIunits.Temperature senTemCon[nConSen]
    "Array of measured temperatures at expansion valves' outlets"
    annotation(Dialog(tab="Measurements",group="Condensers"));
  Modelica.SIunits.MassFlowRate senMasFloCon[nConSen]
    "Array of measured mass flow rates at expansion valves' outlets"
    annotation(Dialog(tab="Measurements",group="Condensers"));
  Real senPhaCon[nConSen](unit="1")
    "Array of measured phases at expansion valves' outlets"
    annotation(Dialog(tab="Measurements",group="Condensers"));

  // Definition of variables describing heat pumps sources
  //
  Modelica.SIunits.AbsolutePressure senPreEvaSou[nEvaSen]
    "Array of measured pressures at source-sided evaporators' outlets"
    annotation(Dialog(tab="Measurements",group="Sources"));
  Modelica.SIunits.Temperature senTemEvaSouInl[nEvaSen]
    "Array of measured temperatures at source-sided evaporators' inlets"
    annotation(Dialog(tab="Measurements",group="Sources"));
  Modelica.SIunits.Temperature senTemEvaSouOut[nEvaSen]
    "Array of measured temperatures at source-sided evaporators' outlet"
    annotation(Dialog(tab="Measurements",group="Sources"));
  Modelica.SIunits.MassFlowRate senMasFloEvaSou[nEvaSen]
    "Array of measured mass flow rates source-sided at evaporators' outlets"
    annotation(Dialog(tab="Measurements",group="Sources"));

  // Definition of variables describing heat pumps sinks
  //
  Modelica.SIunits.AbsolutePressure senPreConSin[nConSen]
    "Array of measured pressures at sink-sided expansion valves' outlets"
    annotation(Dialog(tab="Measurements",group="Sinks"));
  Modelica.SIunits.Temperature senTemConSinInl[nConSen]
    "Array of measured temperatures at sink-sided expansion valves' inlets"
    annotation(Dialog(tab="Measurements",group="Sinks"));
  Modelica.SIunits.Temperature senTemConSinOut[nConSen]
    "Array of measured temperatures at sink-sided expansion valves' outlets"
    annotation(Dialog(tab="Measurements",group="Sinks"));
  Modelica.SIunits.MassFlowRate senMasFloConSin[nConSen]
    "Array of measured mass flow rates at sink-sided expansion valves' outlets"
    annotation(Dialog(tab="Measurements",group="Sinks"));

  annotation (Documentation(revisions="<html>
<ul>
  <li>
  October 25, 2017, by Mirko Engelpracht:<br/>
  First implementation
  (see <a href=\"https://github.com/RWTH-EBC/AixLib/issues/457\">issue 457</a>).
  </li>
</ul>
</html>", info="<html>
<p>
This connector is a base connector used for modular heat pumps and contains 
typical variables that may be measured in modular heat pumps.
</p>
<h4>Overview of sensors' installation sites</h4>
<p>
Typically, a heat pump consists of four main components: A compressor, a
condenser, an expansion valve and an evaporator. Furthermore, considering the 
viewpoint of the refrigerant used in the heat pump, the evaporator is the 
source and the condenser is the sink. Therefore, it is assumed that the heat 
pump has six installation sites for sensors:
</p>
<ol>
<li>Compressor's outlet</li>
<li>Condenser's outlet</li>
<li>Expansion valve's outlet</li>
<li>Evaporator's outlet</li>
<li>Source's inlet and outlet</li>
<li>Sink's inlet and outlet</li>
</ol>
<h4>Overview of variables</h4>
<p>
Four different sensors are proposed at refrigerant's side:
</p>
<ol>
<li>Absolute pressure</li>
<li>Temperature</li>
<li>Mass flow rate</li>
<li>Quality</li>
</ol>
<p>
Three different sensors are proposed at source's and sink's sides:
</p>
<ol>
<li>Absolute pressure</li>
<li>Temperature</li>
<li>Mass flow rate</li>
</ol>
</html>"));
end ModularSensorControlBus;
