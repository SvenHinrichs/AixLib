within AixLib.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
 model GFunction_100boreholes
   "g-Function calculation for a field of 10 by 10 boreholes"
   extends Modelica.Icons.Example;
 
   parameter Integer nBor = 100 "Number of boreholes";
   parameter Modelica.SIunits.Position cooBor[nBor, 2] = {{7.5*mod(i-1,10), 7.5*floor((i-1)/10)} for i in 1:nBor}
     "Coordinates of boreholes";
   parameter Modelica.SIunits.Height hBor = 150 "Borehole length";
   parameter Modelica.SIunits.Height dBor = 4 "Borehole buried depth";
   parameter Modelica.SIunits.Radius rBor = 0.075 "Borehole radius";
   parameter Modelica.SIunits.ThermalDiffusivity aSoi = 1e-6 "Ground thermal diffusivity used in g-function evaluation";
   parameter Integer nSeg = 12 "Number of line source segments per borehole";
   parameter Integer nTimSho = 26 "Number of time steps in short time region";
   parameter Integer nTimLon = 50 "Number of time steps in long time region";
   parameter Real ttsMax = exp(5) "Maximum non-dimensional time for g-function calculation";
 
   final parameter Integer nTimTot=nTimSho+nTimLon;
   final parameter Real[nTimTot] gFun(each fixed=false);
   final parameter Real[nTimTot] lntts(each fixed=false);
   final parameter Modelica.SIunits.Time[nTimTot] tGFun(each fixed=false);
   final parameter Real[nTimTot] dspline(each fixed=false);
 
   Real gFun_int "Interpolated value of g-function";
   Real lntts_int "Non-dimensional logarithmic time for interpolation";
 
   discrete Integer k "Current interpolation interval";
   discrete Modelica.SIunits.Time t1 "Previous value of time for interpolation";
   discrete Modelica.SIunits.Time t2 "Next value of time for interpolation";
   discrete Real gFun1 "Previous g-function value for interpolation";
   discrete Real gFun2 "Next g-function value for interpolation";
   parameter Modelica.SIunits.Time ts = hBor^2/(9*aSoi) "Bore field characteristic time";
 
 initial equation
   // Evaluate g-function for the specified bore field configuration
   (tGFun,gFun) =
     AixLib.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction(
       nBor = nBor,
       cooBor = cooBor,
       hBor = hBor,
       dBor = dBor,
       rBor = rBor,
       aSoi = aSoi,
       nSeg = nSeg,
       nTimSho = nTimSho,
       nTimLon = nTimLon,
       ttsMax = ttsMax);
   lntts = log(tGFun/ts .+ Modelica.Constants.small);
   // Initialize parameters for interpolation
   dspline = AixLib.Utilities.Math.Functions.splineDerivatives(
     x = tGFun,
     y = gFun);
   k = 1;
   t1 = tGFun[1];
   t2 = tGFun[2];
   gFun1 = gFun[1];
   gFun2 = gFun[2];
 
 equation
   // Dimensionless logarithmic time
   lntts_int = log(AixLib.Utilities.Math.Functions.smoothMax(time, 1e-6, 2e-6)/ts);
   // Interpolate g-function
   gFun_int = AixLib.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
     x = time,
     x1 = t1,
     x2 = t2,
     y1 = gFun1,
     y2 = gFun2,
     y1d = dspline[pre(k)],
     y2d = dspline[pre(k)+1]);
   // Update interpolation parameters, when needed
   when time >= pre(t2) then
     k = min(pre(k) + 1, nTimTot);
     t1 = tGFun[k];
     t2 = tGFun[k+1];
     gFun1 = gFun[k];
     gFun2 = gFun[k+1];
   end when;
 
    annotation(experiment(Tolerance=1e-6, StopTime=3.7e11),
 __Dymola_Commands(file="modelica://AixLib/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/GFunction_100boreholes.mos"
         "Simulate and plot"),
       Documentation(info="<html>
 <p>
 This example checks the implementation of functions that evaluate the
 g-function of a borefield of 100 boreholes in a 10 by 10 configuration.
 </p>
 </html>",
 revisions="<html>
 <ul>
 <li>
 March 20, 2018, by Massimo Cimmino:<br/>
 First implementation.
 </li>
 </ul>
 </html>"),  
   __Dymola_LockedEditing="Model from IBPSA");
 end GFunction_100boreholes;
