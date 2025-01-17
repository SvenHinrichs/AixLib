within AixLib.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.Validation;
 model ConvectionResistanceCircularPipe
   "Validation of the correlation used to evaluate the convection resistance in circular pipes"
   extends Modelica.Icons.Example;
 
   parameter Modelica.SIunits.Height hSeg = 1.0 "Height of the element";
   parameter Modelica.SIunits.Radius rTub = 0.02 "Tube radius";
   parameter Modelica.SIunits.Length eTub = 0.002 "Tube thickness";
   // thermal properties
   parameter Modelica.SIunits.ThermalConductivity kMed = 0.6
     "Thermal conductivity of the fluid";
   parameter Modelica.SIunits.DynamicViscosity muMed = 1.002e-3
     "Dynamic viscosity of the fluid";
   parameter Modelica.SIunits.SpecificHeatCapacity cpMed = 4182
     "Specific heat capacity of the fluid";
   parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
     "Nominal mass flow rate";
 
   Real Re "Reynolds number";
   Real Nu "Reynolds number";
   Modelica.SIunits.MassFlowRate m_flow "Mass flow rate";
   Modelica.SIunits.ThermalResistance RConv "Convection resistance";
 
 equation
 
   Re = time;
   Re = 2*m_flow/(muMed*Modelica.Constants.pi*(rTub-eTub));
   RConv = AixLib.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe(
     hSeg=hSeg,
     rTub=rTub,
     eTub=eTub,
     kMed=kMed,
     muMed=muMed,
     cpMed=cpMed,
     m_flow=m_flow,
     m_flow_nominal=m_flow_nominal);
   Nu = 1/(kMed*Modelica.Constants.pi*hSeg*RConv);
 
   annotation (experiment(Tolerance=1e-6, StopTime=10000.0),
     __Dymola_Commands(file=
           "modelica://AixLib/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Functions/Validation/ConvectionResistanceCircularPipe.mos"
         "Simulate and plot"),
     Documentation(info="<html>
 <p>
 This example validates the implementation of
 <a href=\"modelica://AixLib.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe\">
 AixLib.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe</a>
 for the evaluation of the convection thermal resistance in circular pipes.
 </p>
 <p>
 In this validation case, the fluid mass flow rate increases with time so that
 <i>Re = t</i>.
 </p>
 </html>", revisions="<html>
 <ul>
 <li>
 June 21, 2018, by Massimo Cimmino:<br/>
 First implementation.
 </li>
 </ul>
 </html>"),  
   __Dymola_LockedEditing="Model from IBPSA");
 end ConvectionResistanceCircularPipe;
