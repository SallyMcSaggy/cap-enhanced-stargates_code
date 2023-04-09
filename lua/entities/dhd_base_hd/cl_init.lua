/*
	DHD SENT for GarrysMod10
	Copyright (C) 2007  aVoN

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH -- This FUCKING THING avoids the clipping bug I have had for ages since stargate BETA 1.0. DAMN!
-- Damn u aVoN. It need to be setted to BOTH. I spend many hours on trying to fix Z-index issue. @Mad

ENT.ChevronColor = Color(200,150,150);

local font = {
	font = "Calibri",
	size = 65,
	weight = 400,
	antialias = true,
	additive = true,
}
surface.CreateFont("DHD_font", font)


--################# Draw @aVoN
function ENT:Draw()
	if (not IsValid(self.Entity)) then return end
	self.Entity:DrawModel();
	if (StarGate.VisualsMisc==nil or not StarGate.VisualsMisc("cl_dhd_letters",true)) then return end
	if self.Entity:GetNetworkedInt("DHD_LETTERS",0)<=0 then return end
	if self:GetNetworkedBool("DisGlyphs",false) then return end
	if self.IsCityDHD and not self:GetNetworkedBool("HasEnergy",false) then return end
	if self:GetNetworkedBool("Destroyed",false) then return end
	if self:GetNetworkedBool("Disabled",false) then return end

	local a = self.Entity:GetAngles();
	-- ################# Get the chevrons
	local address = self.Entity:GetNetworkedString("ADDRESS"):TrimExplode(",");

	local ChevronPositions
	if (self.IsCityDHD) then
		if (self.Entity:GetNetworkedBool("SG_GROUP_SYSTEM")) then
			self.ChevronPositions2 = self.ChevronPositionsGroup2;
		else
			self.ChevronPositions2 = self.ChevronPositionsGalaxy2;
		end
		ChevronPositions = self.ChevronPositions2;
	else
		if (self.Entity:GetNetworkedBool("SG_GROUP_SYSTEM")) then
			self.ChevronPositions = self.ChevronPositionsGroup;
		else
			self.ChevronPositions = self.ChevronPositionsGalaxy;
		end
		ChevronPositions = self.ChevronPositions;
	end
	
	
	local buttonsmode = self.Entity:GetNetworkedBool("ButtonsMode",false)
	
	-- ################# Draw keyboard - Idea of how to use the cam3D2D stuff comes from Night-Eagles Computer SENT. Thank god, you coded it ;)
	local btn;
	if((LocalPlayer():GetShootPos() - self.Entity:LocalToWorld(ChevronPositions.DIAL)):Length() <= 90) then
		btn = self:GetCurrentButton(LocalPlayer());
	end
	local count = #address;
	-- Draw near buttons
	local button_angle = 20; -- Maximum distant-angle of a button to get drawn - High value = massive (clientside)lags, because the SENT will calculate vector/matrix multiplication - and this is very CPU heavy
	if (self.IsCityDHD) then button_angle = 30 end
	local btns = {};
	if(not self.Entity:GetNetworkedBool("Busy",false)/* and not self.Entity:GetNetworkedBool("CITYBUSY",false)*/) then
		if((btn and btn ~= "DIAL") and (buttonsmode or not table.HasValue(address,"DIAL"))) then
			btns = self:GetCurrentButton(LocalPlayer(),button_angle);
		end
	end
	-- ################# Lower the alpha for buttons when 6 are dialled to make the user clear to press chevron 7 now
	local alpha = 60;
	if self.IsCityDHD then alpha = 180; end
	if(not buttonsmode and count >= 6) then
		if self.IsCityDHD then
			alpha = 60;
			if(not table.HasValue(address,"#")) then
				table.insert(btns,{button="#",angle=0});
			end
		else
			alpha = 20;
			if(count >= 6 and count <= 8 and not table.HasValue(address,"#") and not table.HasValue(address,"DIAL")) then
				table.insert(btns,{button="#",angle=0});
			end
		end
	end
	for _,v in pairs(address) do
		if(v ~= "" and v ~= "DIAL" and not v:find(",")) then
			table.insert(btns,{button=tonumber(v) or v,angle=0});
		end
	end
	-- ################# Draw buttons
	local candialg = self.Entity:GetNetworkedInt("CANDIAL_GROUP_DHD");
	local allowed_symbols = 9
	if (not self.IsCityDHD and (candialg==0 or self.Entity:GetNetworkedBool("Locale")==true)) then
		allowed_symbols = 7
	end
	for _,v in pairs(btns) do
		if (ChevronPositions[v.button]) then
			if(v.button ~= "DIAL" and v.button ~= "IRIS") then
				if(buttonsmode and not self:GetNWBool("DisableBtns") or not buttonsmode and count < allowed_symbols or table.HasValue(address,tostring(v.button))) then
					local a = self.Entity:GetAngles();
					local vc = Vector(0,0,1);
					if (self.IsConceptDHD) then vc = Vector(0,0,-1); end
					if (self.IsCityDHD) then vc = Vector(0,0,-0.1); end
					local p = self.Entity:LocalToWorld(ChevronPositions[v.button]-vc); -- Position of chevron
					local d = self.Entity:LocalToWorld(ChevronPositions[v.button]-ChevronPositions.DIAL)-self.Entity:GetPos(); -- Direction from the DHD's center to the chevron
					-- Yaw Rotate, or the buttons face to the wrong direction
					a:RotateAroundAxis(self.Entity:GetUp(),90);
					if not self.IsCityDHD then
						-- Pitch angle - Make the buttons face better to the surface
						if (self.IsConceptDHD) then
							a:RotateAroundAxis(self.Entity:GetRight(),-45); -- Correct little pitch for texturesurface
						else
							local pitch = self.Entity:GetForward():Dot(d:GetNormalized());
							a:RotateAroundAxis(self.Entity:GetRight(),-15*pitch); -- Correct little pitch for texturesurface
						end
					end
					-- Fading color for the buttons pendent from their distance
					local color = Color(255,255,255,alpha*(1-v.angle/button_angle));
					-- When 6 buttons are dialled, highligh chevron 7 white. Furthermore the alpha (watch above) is lowered from 255 to 100 for all other buttons, so even noobs will find out, to press chevron 7
					if(table.HasValue(address,tostring(v.button))) then
						color = Color(255,255,255,60);
						if (self.IsCityDHD) then color.a = 180 end
					end
					if (self.IsCityDHD) then allowed_symbols = 8 end
					-- ################# Highlight current button aimed at orange or gray when already dialled
					if(v.button == btn and (buttonsmode or count <= allowed_symbols)) then
						if(count < allowed_symbols or buttonsmode or self.IsCityDHD and (v.button == "#" or v.button == "@")) then
							local sel = false;
							if(table.HasValue(address,tostring(btn))) then
								sel = true;
							end
							-- ################# Button already dialled - Make it white
							if(sel) then
								color = Color(255,255,255,60);
								if (self.IsCityDHD) then color.a = 180 end
							else
								local brightness = 55;
								color = (self.Color.chevron.." 80"):TrimExplode(" ");
								if (self.IsCityDHD) then color[4] = 180 end
								color[1] = color[1]+brightness;
								color[2] = color[2]+brightness;
								color[3] = color[3]+brightness;
								color = Color(color[1],color[2],color[3],color[4]);
							end
						end
					end
					-- ################# Make C7 blink!
					if(not buttonsmode and count >= 6 and count <= 8 and not table.HasValue(address,"#")) then
						if(v.button == "#") then
							self.StartedBlinking = self.StartedBlinking or CurTime();
							color.a = math.Clamp(255*(1+math.cos((CurTime()-self.StartedBlinking)*math.pi))/2,20,120);
						end
					else
						self.StartedBlinking = nil;
					end
					-- ################# Draw the buttons
					d:Normalize()
					cam.Start3D2D(p+d*0.5,a,.05);
						draw.SimpleText(v.button,"DHD_font",0,0,color,1,1);
					cam.End3D2D();
				end
			elseif (v.button == "IRIS") then
				local a = self.Entity:GetAngles();
				local vc = Vector(0,0,-0.1);
				local p = self.Entity:LocalToWorld(ChevronPositions[v.button]-vc); -- Position of chevron
				local d = self.Entity:LocalToWorld(ChevronPositions[v.button]-ChevronPositions.DIAL)-self.Entity:GetPos(); -- Direction from the DHD's center to the chevron
				a:RotateAroundAxis(self.Entity:GetUp(),90);
				d:Normalize()
				local color = Color(255,255,255,180);
				cam.Start3D2D(p+d*0.5,a,.05);
					draw.SimpleText(v.button,"DHD_font",0,0,color,1,1);
				cam.End3D2D();
			end
		end
	end
end

/*
-- ugly workaround
local properties_HaloThink = properties.HaloThink;
properties.HaloThink = function()
	if (!IsValid(LocalPlayer())) then return end
	local ent = properties.GetHovered(LocalPlayer():EyePos(), LocalPlayer():GetAimVector())
	if (!IsValid( ent ) or ent.IsDHD) then return end
	properties_HaloThink();
end    */

hook.Add("OnGamemodeLoaded","FixDHDHalos",function()
	hook.Add( "PreDrawHalos", "PropertiesHover", function()
		if ( vgui.GetHoveredPanel() != vgui.GetWorldPanel() && vgui.GetHoveredPanel() != g_ContextMenu ) then return end

		local ent = properties.GetHovered( EyePos(), LocalPlayer():GetAimVector() )
		if ( !IsValid( ent ) or ent.IsDHD) then return end

		local c = Color( 255, 255, 255, 255 )
		c.r = 200 + math.sin( RealTime() * 50 ) * 55
		c.g = 200 + math.sin( RealTime() * 20 ) * 55
		c.b = 200 + math.cos( RealTime() * 60 ) * 55

		halo.Add( { ent }, c, 2, 2, 2, true, false )
	end )
end)

-- fix for content menu not opens sometimes without halo effect somewhy.
hook.Add( "GUIMousePressed", "StarGate.DHD.GUIMousePressed", function()
	local ply = LocalPlayer()
	if ( !IsValid( ply ) ) then return end
	if ( input.IsButtonDown(MOUSE_RIGHT)) then
		local hovered = properties.GetHovered( ply:EyePos(), ply:GetAimVector() )
		if ( IsValid( hovered ) and hovered.IsDHD ) then
			properties.OpenEntityMenu(hovered.Entity,hovered)
		end
	end
end );

-- fix for attack when press left mouse button on dhd
hook.Add( "PreventScreenClicks", "StarGate.DHD.PropertiesPreventClicks", function()
	local ply = LocalPlayer()
	if ( !IsValid( ply ) ) then return end
	if ( input.IsButtonDown( MOUSE_LEFT ) ) then
		local hovered = properties.GetHovered( ply:EyePos(), ply:GetAimVector() )
		if ( IsValid( hovered ) and hovered.IsDHD ) then
			return true
		end
	end
end );