within AixLib.Fluid.FMI.ExportContainers.Validation.FMUs;
 block HVACThermalZoneAir2 "Validation model for the convective HVAC system"
   extends AixLib.Fluid.FMI.ExportContainers.Validation.FMUs.HVACThermalZoneAir1(
     redeclare package Medium = AixLib.Media.Air(extraPropertiesNames={"CO2"}));
 annotation (
     Documentation(info="<html>
 <p>
 This example validates that
 <a href=\"modelica://AixLib.Fluid.FMI.ExportContainers.HVACZone\">
 AixLib.Fluid.FMI.ExportContainers.HVACZone</a>
 exports correctly as an FMU.
 </p>
 </html>", revisions="<html>
 <ul>
 <li>
 April 14, 2016 by Michael Wetter:<br/>
 First implementation.
 </li>
 </ul>
 </html>"),
 __Dymola_Commands(file="modelica://AixLib/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Validation/FMUs/HVACThermalZoneAir2.mos"
         "Export FMU"), 
   __Dymola_LockedEditing="Model from IBPSA");
 end HVACThermalZoneAir2;
