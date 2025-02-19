within AixLib.Utilities.Math.Examples;
 model Average "Test model for average function"
   extends Modelica.Icons.Example;
   AixLib.Utilities.Math.Average average(nin=2)
     annotation (Placement(transformation(extent={{20,-10},{40,10}})));
   Modelica.Blocks.Sources.Ramp x1(duration=1)
     annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
   Modelica.Blocks.Sources.Ramp x2(
     height=2,
     duration=1,
     offset=2)
     annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
   Modelica.Blocks.Routing.Multiplex2 multiplex2_1
     annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
 equation
   connect(x1.y, multiplex2_1.u1[1]) annotation (Line(
       points={{-39,20},{-28,20},{-28,6},{-22,6}},
       color={0,0,127}));
   connect(x2.y, multiplex2_1.u2[1]) annotation (Line(
       points={{-39,-20},{-28,-20},{-28,-6},{-22,-6}},
       color={0,0,127}));
   connect(multiplex2_1.y, average.u)
                                  annotation (Line(
       points={{1,0},{18,0}},
       color={0,0,127}));
   annotation ( experiment(Tolerance=1e-6, StopTime=1.0),
 __Dymola_Commands(file="modelica://AixLib/Resources/Scripts/Dymola/Utilities/Math/Examples/Average.mos"
         "Simulate and plot"), Documentation(info="<html>
 <p>
 This model tests the implementation of
 <a href=\"modelica://AixLib.Utilities.Math.Average\">
 AixLib.Utilities.Math.Average</a>.
 </p>
 </html>", revisions="<html>
 <ul>
 <li>
 November 28, 2013 by Marcus Fuchs:<br/>
 First implementation.
 </li>
 </ul>
 </html>"),  
   __Dymola_LockedEditing="Model from IBPSA");
 end Average;
