include("shared.lua");
ENT.ChevronColor = Color(200,65,0);
if (SGLanguage!=nil and SGLanguage.GetMessage!=nil) then
ENT.Category = SGLanguage.GetMessage("Enhanced StarGates");
ENT.PrintName = SGLanguage.GetMessage("Stargate (SG1 HD)");
end