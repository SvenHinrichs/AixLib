within AixLib.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
 model IncidenceAngle "Test model for incidence angle"
   extends Modelica.Icons.Example;
   AixLib.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
     "Declination angle"
     annotation (Placement(transformation(extent={{0,20},{20,40}})));
   AixLib.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
     solHouAng "Solar hour angle"
     annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
   AixLib.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incAng(
     azi=AixLib.Types.Azimuth.S,
     til=AixLib.Types.Tilt.Wall,
     lat=0.73268921998722) "Incidence angle"
     annotation (Placement(transformation(extent={{40,-10},{60,10}})));
   AixLib.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
     filNam=Modelica.Utilities.Files.loadResource("modelica://AixLib/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
     "Weather data"
     annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
   AixLib.BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
     annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
 equation
   connect(decAng.decAng, incAng.decAng) annotation (Line(
       points={{21,30},{30,30},{30,5.4},{37.8,5.4}},
       color={0,0,127}));
   connect(solHouAng.solHouAng, incAng.solHouAng) annotation (Line(
       points={{21,-30},{28,-30},{28,-4.8},{38,-4.8}},
       color={0,0,127}));
   connect(weaDat.weaBus, weaBus) annotation (Line(
       points={{-60,5.82867e-16},{-54,5.82867e-16},{-54,1.13798e-15},{-48,
           1.13798e-15},{-48,5.55112e-16},{-36,5.55112e-16}},
       color={255,204,51},
       thickness=0.5), Text(
       textString="%second",
       index=1,
       extent={{6,3},{6,3}}));
   connect(weaBus.cloTim, decAng.nDay) annotation (Line(
       points={{-36,5.55112e-16},{-20,5.55112e-16},{-20,30},{-2,30}},
       color={255,204,51},
       thickness=0.5), Text(
       textString="%first",
       index=-1,
       extent={{-6,3},{-6,3}}));
   connect(weaBus.solTim, solHouAng.solTim) annotation (Line(
       points={{-36,5.55112e-16},{-20,5.55112e-16},{-20,-30},{-2,-30}},
       color={255,204,51},
       thickness=0.5), Text(
       textString="%first",
       index=-1,
       extent={{-6,3},{-6,3}}));
   annotation (
   Documentation(info="<html>
 <p>
 This example computes the solar incidence angle on a tilted surface.
 This model is also part of more extensive tests that run the
 model for different orientations. These tests are at
 <a href=\"modelica://AixLib.BoundaryConditions.SolarGeometry.Examples.IncidenceAngle\">
 AixLib.BoundaryConditions.SolarGeometry.Examples.IncidenceAngle</a>.
 </p>
 </html>", revisions="<html>
 <ul>
 <li>
 March 24, 2015, by Michael Wetter:<br/>
 Assigned azimuth and tilt using the types from
 <a href=\"modelica://AixLib.Types.Tilt\">
 AixLib.Types.Tilt</a>.
 </li>
 <li>
 May 19, 2010, by Wangda Zuo:<br/>
 First implementation.
 </li>
 </ul>
 </html>"),
   experiment(Tolerance=1e-6, StopTime=86400),
 __Dymola_Commands(file="modelica://AixLib/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/BaseClasses/Examples/IncidenceAngle.mos"
         "Simulate and plot"), 
   __Dymola_LockedEditing="Model from IBPSA");
 end IncidenceAngle;
