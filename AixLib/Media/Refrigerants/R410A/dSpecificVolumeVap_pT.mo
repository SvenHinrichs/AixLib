within AixLib.Media.Refrigerants.R410A;
 function dSpecificVolumeVap_pT
   "Function that calculates the Jacobian of specific volume R410A vapor based on pressure and temperature"
   input Modelica.SIunits.AbsolutePressure p
     "Pressure of refrigerant vapor";
   input Modelica.SIunits.Temperature T
     "Temperature of refrigerant";
   input Real dp(
     final unit="Pa/s")
     "Delta of pressure of refrigerant vapor";
   input Real dT(
     final unit="K/s")
     "Delta of temperature of refrigerant";
   output Real dv(
     final unit="m3/(kg.s)")
     "Delta of specific volume of refrigerant";
 
 protected
   Real dpdT(
     final unit="Pa/K")
      "Derivative of pressure with regards to temperature";
 
   Real dpdv(
     final unit="Pa.kg/m3")
      "Derivative of pressure with regards to specific volume";
 
   Modelica.SIunits.SpecificVolume v
     "Specific volume of refrigerant";
 
 algorithm
 
   v := AixLib.Media.Refrigerants.R410A.specificVolumeVap_pT(p, T);
   dpdT := AixLib.Media.Refrigerants.R410A.dPressureVap_dTemperature_Tv(T, v);
   dpdv := AixLib.Media.Refrigerants.R410A.dPressureVap_dSpecificVolume_Tv(T, v);
 
   dv := dp/dpdv + dT*(dpdT/dpdv);
 
 annotation (preferredView="info",Documentation(info="<HTML>
 <p>
 Function that calculates the derivatives of
 <a href=\"modelica://AixLib.Media.Refrigerants.R410A.specificVolumeVap_pT\">
 AixLib.Media.Refrigerants.R410A.specificVolumeVap_pT</a>
 </p>
 </html>", revisions="<html>
 <ul>
 <li>
 November 30, 2016, by Massimo Cimmino:<br/>
 First implementation.
 </li>
 </ul>
 </html>"),  
   __Dymola_LockedEditing="Model from IBPSA");
 end dSpecificVolumeVap_pT;
