local function Ragdoll_Death_expression_Settings( CPanel )

    local Ragdoll_Death_expression_Settings = {Options = {}, CVars = {}, Label = "#Presets", MenuButton = "1", Folder = "Ragdoll Ragdoll Death expression"}

   

    -- Npc_Ragdoll_Death_expression_Settings.CVars = {
        -- "sv_npcdeath_enable",
		-- "sv_npcragdoll_physic",
        -- "sv_npcragdolls_speed",
        -- "sv_npcragdolls_weight",
    -- }

    CPanel:AddControl("ComboBox", Ragdoll_Death_expression_Settings)

    
		
    
	-- CPanel:AddControl("Slider", {
        -- Label  = "How many ragdolls kept at most? 0 for no limit",
        -- Command  = "sv_playerragdolls_max",
        -- Type   = "Integer",
        -- Min   = "0",
        -- Max   = "50"
        -- })	
	CPanel:AddControl("Slider", {
        Label  = "eyelid min",
        Command  = "sv_npcdeath_Tmin",
        Type   = "Float",
        Min   = "-1",
        Max   = "1"
        })	
	CPanel:AddControl("Slider", {
        Label  = "eyelid max",
        Command  = "sv_npcdeath_Tmax",
        Type   = "Float",
        Min   = "-1",
        Max   = "1"
        })	
	CPanel:AddControl("Slider", {
        Label  = "eyerolling min",
        Command  = "sv_npcdeath_EUmin",
        Type   = "Float",
        Min   = "-1",
        Max   = "1"
        })		
	CPanel:AddControl("Slider", {
        Label  = "eyerolling max",
        Command  = "sv_npcdeath_EUmax",
        Type   = "Float",
        Min   = "-1",
        Max   = "1"
        })		
	CPanel:AddControl("Slider", {
        Label  = "mouth open min",
        Command  = "sv_npcdeath_AHmin",
        Type   = "Float",
        Min   = "-1",
        Max   = "1"
        })
	CPanel:AddControl("Slider", {
        Label  = "mouth open max",
        Command  = "sv_npcdeath_AHmax",
        Type   = "Float",
        Min   = "-1",
        Max   = "1"
        })	
	CPanel:AddControl("Slider", {
        Label  = "sad face min",
        Command  = "sv_npcdeath_SAmin",
        Type   = "Float",
        Min   = "-1",
        Max   = "1"
        })	
		CPanel:AddControl("Slider", {
        Label  = "sad face max",
        Command  = "sv_npcdeath_SAmax",
        Type   = "Float",
        Min   = "-1",
        Max   = "1"
        })		
end

hook.Add( "PopulateToolMenu", "PopulateServerFedRagdollMenus", function()

	spawnmenu.AddToolMenuOption( "Utilities", "Fedhoria","Ragdoll Death expression","Ragdoll Death expression", "", "", Ragdoll_Death_expression_Settings )

end );
