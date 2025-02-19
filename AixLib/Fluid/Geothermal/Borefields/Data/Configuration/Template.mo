within AixLib.Fluid.Geothermal.Borefields.Data.Configuration;
 record Template
   "Template for configuration data records"
   extends Modelica.Icons.Record;
 
   parameter AixLib.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration borCon
     "Borehole configuration";
 
   parameter Boolean use_Rb = false
     "true if the value borehole thermal resistance Rb should be given and used";
   parameter Real Rb(unit="(m.K)/W") = 0.0
     "Borehole thermal resistance Rb. Only to fill in if known"
     annotation(Dialog(enable=use_Rb));
   parameter Modelica.SIunits.MassFlowRate mBor_flow_nominal
     "Nominal mass flow rate per borehole"
     annotation (Dialog(group="Nominal condition"));
   parameter Modelica.SIunits.MassFlowRate mBorFie_flow_nominal = mBor_flow_nominal*nBor
     "Nominal mass flow of borefield"
     annotation (Dialog(group="Nominal condition"));
   parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")
     "Pressure losses for the entire borefield"
     annotation (Dialog(group="Nominal condition"));
 
   //------------------------- Geometrical parameters ---------------------------
   parameter Modelica.SIunits.Height hBor "Total height of the borehole"
     annotation (Dialog(group="Borehole"));
   parameter Modelica.SIunits.Radius rBor "Radius of the borehole"
     annotation (Dialog(group="Borehole"));
   parameter Modelica.SIunits.Height dBor "Borehole buried depth"
     annotation (Dialog(group="Borehole"));
   parameter Integer nBor = size(cooBor, 1) "Total number of boreholes"
     annotation (Dialog(group="Borehole"));
 
   parameter Modelica.SIunits.Length[:,2] cooBor
     "Cartesian coordinates of the boreholes in meters"
     annotation (Dialog(group="Borehole"));
 
   // -- Tube
   parameter Modelica.SIunits.Radius rTub "Outer radius of the tubes"
     annotation (Dialog(group="Tubes"));
   parameter Modelica.SIunits.ThermalConductivity kTub "Thermal conductivity of the tube"
     annotation (Dialog(group="Tubes"));
 
   parameter Modelica.SIunits.Length eTub "Thickness of a tube"
     annotation (Dialog(group="Tubes"));
 
   parameter Modelica.SIunits.Length xC
     "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole"
     annotation (Dialog(group="Tubes"));
 
   //------------------------- Advanced parameters ------------------------------
 
   /*--------Flow: */
   parameter Modelica.SIunits.MassFlowRate mBor_flow_small(min=0) = 1E-4*abs(mBor_flow_nominal)
     "Small mass flow rate for regularization of zero flow"
     annotation (Dialog(tab="Advanced"));
 
   annotation (
   defaultComponentPrefixes="parameter",
   defaultComponentName="conDat",
     Documentation(
 info="<html>
 <p>
 This record is a template for the records in
 <a href=\"modelica://AixLib.Fluid.Geothermal.Borefields.Data.Configuration\">
 AixLib.Fluid.Geothermal.Borefields.Data.Configuration</a>.
 </p>
 </html>",
 revisions="<html>
 <ul>
 <li>
 July 15, 2018, by Michael Wetter:<br/>
 Revised implementation, added <code>defaultComponentPrefixes</code> and
 <code>defaultComponentName</code>.
 </li>
 <li>
 June 28, 2018, by Damien Picard:<br/>
 First implementation.
 </li>
 </ul>
 </html>"),  
   __Dymola_LockedEditing="Model from IBPSA");
 end Template;
