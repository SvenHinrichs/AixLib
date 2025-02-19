within AixLib.Utilities.Psychrometrics.Functions;
 function X_pTphi
   "Absolute humidity for given pressure, dry bulb temperature and relative humidity"
   extends Modelica.Icons.Function;
   input Modelica.SIunits.Pressure p "Absolute pressure of the medium";
   input Modelica.SIunits.Temperature T "Dry bulb temperature";
   input Real phi(unit="1") "Relative humidity";
   output Modelica.SIunits.MassFraction X_w
     "Water vapor mass fraction per unit mass total air";
 
 algorithm
   X_w:=phi/((p/saturationPressure(T)-phi) / AixLib.Utilities.Psychrometrics.Constants.k_mair + phi);
   annotation (
     inverse(phi=phi_pTX(p,T,X_w)),
     smoothOrder=1,
     Documentation(info="<html>
 <p>
 Absolute humidity of air for given
 pressure, temperature and relative humidity.
 </p>
 <p>
 Note that the absolute humidity is in <i>kg/kg</i>
 total air, and not dry air.
 </p>
 </html>",
 revisions="<html>
 <ul>
 <li>
 April 4, 2019 by Filip Jorissen:<br/>
 First implementation.
 </li>
 </ul>
 </html>"),  
   __Dymola_LockedEditing="Model from IBPSA");
 end X_pTphi;
