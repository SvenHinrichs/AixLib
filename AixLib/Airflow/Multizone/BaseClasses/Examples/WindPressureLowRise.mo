within AixLib.Airflow.Multizone.BaseClasses.Examples;
 model WindPressureLowRise "Test model for wind pressure function"
   extends Modelica.Icons.Example;
   parameter Real Cp0 = 0.6
     "Wind pressure coefficient for normal wind incidence angle";
   Modelica.SIunits.Angle incAng "Wind incidence angle (0: normal to wall)";
   parameter Real G = Modelica.Math.log(0.5) "Natural logarithm of side ratio";
   Real Cp "Wind pressure coefficient";
 equation
   incAng=time*2*Modelica.Constants.pi;
   Cp = AixLib.Airflow.Multizone.BaseClasses.windPressureLowRise(
     Cp0=Cp0,
     G=G,
     incAng=incAng);
   annotation (
 experiment(StartTime=-2, Tolerance=1e-6, StopTime=2),
   __Dymola_Commands(file="modelica://AixLib/Resources/Scripts/Dymola/Airflow/Multizone/BaseClasses/Examples/WindPressureLowRise.mos"
         "Simulate and plot"), Documentation(info="<html>
 <p>
 This examples demonstrates the
 <a href=\"modelica://AixLib.Airflow.Multizone.BaseClasses.windPressureLowRise\">
 AixLib.Airflow.Multizone.BaseClasses.windPressureLowRise</a>
 function.
 </p>
 </html>", revisions="<html>
 <ul>
 <li>
 October 27, 2011, by Michael Wetter:<br/>
 First implementation.
 </li>
 </ul>
 </html>"),  
   __Dymola_LockedEditing="Model from IBPSA");
 end WindPressureLowRise;
