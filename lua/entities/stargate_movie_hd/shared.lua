ENT.Type = "anim"
ENT.Base = "stargate_base"
ENT.PrintName = "Stargate (Movie HD)"
ENT.Author = "☠Junko Enoshima❤"
ENT.Category = "Stargate Carter Addon Pack: Gates and Rings"

ENT.WireDebugName = "Stargate Movie HD"
list.Set("CAP.Entity", ENT.PrintName, ENT);

ENT.IsNewSlowDial = true; // this gate use new slow dial (with chevron lock on symbol)

ENT.EventHorizonDataBak = {
	OpeningDelay = 0.15,
	OpenTime = 2.5,
	Type = "sgmhd",
	NNFix = 0,
	Kawoosh = "movie",
}

ENT.EventHorizonDataClassic = {
	OpeningDelay = 1.5,
	OpenTime = 2.2,
	NNFix = 1,
}

StarGate.RegisterEventHorizon("sgmhd",{
	ID=6,
	Name=SGLanguage.GetMessage("SGM-HD"),
	Material="event_horizon_movie/effect_01.vmt",
	UnstableMaterial="event_horizon_movie/effect_shock.vmt",
	LightColor={
		r = Vector(20,40),
		g = Vector(60,80),
		b = Vector(150,230),
		sync = false, -- sync random (for white), will be used only first value from this table (r)
	},
	Color=Color(255,255,255),
})

ENT.DialSlowDelay = 2.0
ENT.EventHorizonData = ENT.EventHorizonDataBak

ENT.StargateRingRotate = true
ENT.StargateHasSGCType = true
ENT.StargateTwoPoO = true

function ENT:GetRingAng()
	if not IsValid(self.EntRing) then self.EntRing=self:GetNWEntity("EntRing") if not IsValid(self.EntRing) then return end end   -- Use this trick beacause NWVars hooks not works yet...
	local angle = tonumber(math.NormalizeAngle(self.EntRing:GetLocalAngles().r));
	return (angle<0) and angle+360 or angle
end

properties.Add( "Stargate.MChevL.On",
{
	MenuLabel	=	SGLanguage.GetMessage("stargate_c_tool_16"),
	Order		=	-145,
	MenuIcon	=	"icon16/plugin_disabled.png",

	Filter		=	function( self, ent, ply )
						if ( !IsValid( ent ) || !IsValid( ply ) || !ent.IsStargate || ent:GetClass()!="stargate_movie_hd" || ent:GetNWBool("GateSpawnerProtected",false) || ent:GetNWBool("ActMChevL",false)) then return false end
						if ( !gamemode.Call( "CanProperty", ply, "stargatemodify", ent ) ) then return false end
						return true

					end,

	Action		=	function( self, ent )

						self:MsgStart()
							net.WriteEntity( ent )
						self:MsgEnd()

					end,

	Receive		=	function( self, length, player )

						local ent = net.ReadEntity()
						if ( !self:Filter( ent, player ) ) then return false end

						ent:TriggerInput("Chevron Light",1);
					end

});

properties.Add( "Stargate.MChevL.Off",
{
	MenuLabel	=	SGLanguage.GetMessage("stargate_c_tool_16d"),
	Order		=	-145,
	MenuIcon	=	"icon16/plugin.png",

	Filter		=	function( self, ent, ply )
						if ( !IsValid( ent ) || !IsValid( ply ) || !ent.IsStargate || ent:GetClass()!="stargate_movie_hd" || ent:GetNWBool("GateSpawnerProtected",false) || !ent:GetNWBool("ActMChevL",false)) then return false end
						if ( !gamemode.Call( "CanProperty", ply, "stargatemodify", ent ) ) then return false end
						return true

					end,

	Action		=	function( self, ent )

						self:MsgStart()
							net.WriteEntity( ent )
						self:MsgEnd()

					end,

	Receive		=	function( self, length, player )

						local ent = net.ReadEntity()
						if ( !self:Filter( ent, player ) ) then return false end

						ent:TriggerInput("Chevron Light",0);
					end

});

properties.Add( "Stargate.MCl.On",
{
	MenuLabel	=	SGLanguage.GetMessage("stargate_c_tool_15"),
	Order		=	-144,
	MenuIcon	=	"icon16/plugin_disabled.png",

	Filter		=	function( self, ent, ply )
						if ( !IsValid( ent ) || !IsValid( ply ) || !ent.IsStargate || ent:GetClass()!="stargate_movie_hd" || ent:GetNWBool("GateSpawnerProtected",false) || ent:GetNWBool("ActMCl",false)) then return false end
						if ( !gamemode.Call( "CanProperty", ply, "stargatemodify", ent ) ) then return false end
						return true

					end,

	Action		=	function( self, ent )

						self:MsgStart()
							net.WriteEntity( ent )
						self:MsgEnd()

					end,

	Receive		=	function( self, length, player )

						local ent = net.ReadEntity()
						if ( !self:Filter( ent, player ) ) then return false end

						ent:TriggerInput("Classic Mode",1);
					end

});

properties.Add( "Stargate.MCl.Off",
{
	MenuLabel	=	SGLanguage.GetMessage("stargate_c_tool_15d"),
	Order		=	-144,
	MenuIcon	=	"icon16/plugin.png",

	Filter		=	function( self, ent, ply )
                        local vg = {"stargate_movie_hd","stargate_sg1","stargate_infinity"}
						if ( !IsValid( ent ) || !IsValid( ply ) || !ent.IsStargate || ent:GetClass()!="stargate_movie_hd" || ent:GetNWBool("GateSpawnerProtected",false) || !ent:GetNWBool("ActMCl",false)) then return false end
						if ( !gamemode.Call( "CanProperty", ply, "stargatemodify", ent ) ) then return false end
						return true

					end,

	Action		=	function( self, ent )

						self:MsgStart()
							net.WriteEntity( ent )
						self:MsgEnd()

					end,

	Receive		=	function( self, length, player )

						local ent = net.ReadEntity()
						if ( !self:Filter( ent, player ) ) then return false end

						ent:TriggerInput("Classic Mode",0);
					end

});