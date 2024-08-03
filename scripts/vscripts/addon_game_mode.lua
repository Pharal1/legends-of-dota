-- Generated from template

if GameMode == nil then
	GameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = GameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function GameMode:InitGameMode()
	print( "Template addon is loaded." )
    ListenToGameEvent('entity_hurt', Dynamic_Wrap(self, 'OnEntityHurt'), self)
    ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityCast'), GameMode)
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end

-- Evaluate the state of the game
function GameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function blinkKD(blink_item)
    if (blink_item:GetCooldownTimeRemaining() <= 3) then
        blink_item:EndCooldown()
        blink_item:StartCooldown(3.0)
    end
end

function GameMode:OnEntityHurt(data)
    local attaked = EntIndexToHScript(data.entindex_killed)
    if (EntIndexToHScript(data.entindex_attacker):GetPlayerOwnerID() > -1) then
        if (attaked:GetPlayerOwnerID() > -1) then
            if (attaked:FindItemInInventory('item_blink') ~= nil) then
                local blink_item = attaked:FindItemInInventory('item_blink')
                blinkKD(blink_item)
            elseif (attaked:FindItemInInventory('item_arcane_blink2') ~= nil) then
                local blink_item = attaked:FindItemInInventory('item_arcane_blink2')
                blinkKD(blink_item)
            end
        end
    end
end