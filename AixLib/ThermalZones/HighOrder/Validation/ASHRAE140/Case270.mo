within AixLib.ThermalZones.HighOrder.Validation.ASHRAE140;
model Case270
  extends AixLib.ThermalZones.HighOrder.Validation.ASHRAE140.Case220(
    absInnerWallSurf=AixLib.ThermalZones.HighOrder.Components.Types.selectorCoefficients.abs09,
                  Room(outerWall_South(windowSimple(redeclare model
                  correctionSolarGain =
            Components.WindowsDoors.BaseClasses.CorrectionSolarGain.CorG_ASHRAE140))),
    ReferenceHeatingLoad(table=[270,4510,5920]),
    ReferenceCoolingLoad(table=[270,-10350,-7528]));
  annotation (Documentation(revisions="<html>
 <ul>
 <li><i>July 1, 2020</i> by Konstantina Xanthopoulou:<br/>Implemented</li>
 </ul>
 </html>", info="<html>
<p>As described in ASHRAE Standard 140.</p>
<p>Difference to case 220: </p>
<ul>
<li> Window according to ASHRAE</li>
<li> Solar absorptance on exterior surface = 0.1</li>
<li> Solar absorptance on exterior surface = 0.9</li>
</ul>
</ul>
</ul>
</html>"));
end Case270;
