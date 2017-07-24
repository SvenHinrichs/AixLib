within AixLib.Controls.Interfaces;
expandable connector FVUControlBus
  "Standard data bus for facade ventilation units"
  extends Modelica.Icons.SignalBus;

 Real coolingValveOpening "Relative opening of the cooling valve (0..1)";

 Real heatingValveOpening "Relative opening of the cooling valve (0..1)";

 Real fanExhaustAirPower "Relative speed of the exhaust air fan (0..1)";

 Real fanSupplyAirPower "Relative speed of the supply air fan (0..1)";

 Real circulationDamperOpening "Relative opening of the circulation damper (0..1)";

 Real hRCDamperOpening "Relative opening of the heat recovery damper (0..1)";

 Real freshAirDamperOpening "Relative opening of thefresh air damper (0..1)";

 Modelica.SIunits.ThermodynamicTemperature roomTemperature
 "Room air temperature measurement";

 Modelica.SIunits.ThermodynamicTemperature outdoorTemperature
 "Outdoor air temperature measurement";

  Modelica.SIunits.ThermodynamicTemperature roomSetTemperature
 "Room air set temperature measurement";

 Modelica.SIunits.Concentration co2Concentration "CO2 concentration measurement";



  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Definition of a standard bus that contains basic data points that appear facade ventilation units.</p>
</html>", revisions="<html>
<p>July 2017, by Marc Baranski:</p>
<p>First implementation. </p>
</html>"));


end FVUControlBus;
