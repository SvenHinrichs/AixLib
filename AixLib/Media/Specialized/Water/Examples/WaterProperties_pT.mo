within AixLib.Media.Specialized.Water.Examples;
 model WaterProperties_pT
   "Model that tests the implementation of the fluid properties at nominal conditions"
   extends Modelica.Icons.Example;
   extends AixLib.Media.Examples.BaseClasses.FluidProperties(
     redeclare package Medium =
       AixLib.Media.Specialized.Water.ConstantProperties_pT (
         T_nominal=273.15+100,
         p_nominal=5e5),
     TMin=273.15,
     TMax=273.15+150);
 equation
   // Check the implementation of the base properties
   basPro.state.p=p;
   basPro.state.T=T;
    annotation(experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file="modelica://AixLib/Resources/Scripts/Dymola/Media/Specialized/Water/Examples/WaterProperties_pT.mos"
         "Simulate and plot"),
       Documentation(info="<html>
 <p>
 This example checks the thermophysical properties of the medium
 <a href=\"modelica://AixLib.Media.Specialized.Water.Examples.WaterProperties_pT\">
 AixLib.Media.Specialized.Water.Examples.WaterProperties_pT</a>.
 </p>
 </html>",
 revisions="<html>
 <ul>
 <li>
 September 12, 2016, by Marcus Fuchs:<br/>
 First implementation
 </li>
 </ul>
 </html>"),  
   __Dymola_LockedEditing="Model from IBPSA");
 end WaterProperties_pT;
