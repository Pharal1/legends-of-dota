-- Generated from template

if GameMode == nil then
	GameMode = class({})
end

require("Events")

function Precache( context )
	
    print("something")
    
    --[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
    
end

-- Create the game mode when we activate
function Activate ()
	GameRules.GameMode = GameMode()
	GameMode:InitGameMode()
end

function GameMode:InitGameMode()
    GameRules:SetSameHeroSelectionEnabled(false)
	GameRules:SetHeroRespawnEnabled(true)

	GameRules:SetPreGameTime(90)

    GameRules:SetGoldTickTime(10)
	GameRules:SetFirstBloodActive(true)
	GameRules:SetHideKillMessageHeaders(false)
    
    GameRules:GetGameModeEntity():SetFreeCourierModeEnabled( true )
    GameRules:GetGameModeEntity():SetUseDefaultDOTARuneSpawnLogic( true )
    print( "Template addon is loaded." )

    --ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
	--ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
	--ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
	--ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
	--ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
	--ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
	--ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
	--ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
	--ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)

	--ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
	--ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
	--ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
	--ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
	--ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)
	--ListenToGameEvent("player_chat", Dynamic_Wrap(GameMode, 'OnPlayerChat'), self)

	--ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(GameMode, 'OnTowerKill'), self)
	--ListenToGameEvent("dota_player_selected_custom_team", Dynamic_Wrap(GameMode, 'OnPlayerSelectedCustomTeam'), self)
	--ListenToGameEvent("dota_npc_goal_reached", Dynamic_Wrap(GameMode, 'OnNPCGoalReached'), self)
    --ListenToGameEvent('dota_game_state_change', Dynamic_Wrap(GameMode 'OnStateChanged', GameMode))
    ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
    ListenToGameEvent("entity_hurt", Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end


function GameMode:OnGameInProgress()
	GameRules:SetTimeOfDay(0.5)
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
function GameMode:OnAbilityUsed( data )
    print("1")
    if (data.abilityname == 'techies_suicide') then
        print("2")
        local player = EntIndexToHScript(data.caster_entindex)
        local damage = 0    --"damage"                        "250 500 750 1000"
        local ability_lvl = player:FindAbilityByName('techies_suicide'):GetLevel()
        if (ability_lvl == 1) then
            damage = 250
        elseif (ability_lvl == 2) then
            damage = 500
        elseif (ability_lvl == 3) then
            damage = 750
        elseif (ability_lvl == 4) then
            damage = 1000
        end
        if (player:GetHealth() <= damage) then
            player:Kill(nil, player)
            print("3")
        end
    end
end

function blinkKD(blink_item)
    if (blink_item:GetCooldownTimeRemaining() <= 3) then
        blink_item:EndCooldown()
        blink_item:StartCooldown(3.0)
    end
end

function GameMode:OnEntityHurt(data)
    local attacked = EntIndexToHScript(data.entindex_killed)
    local attacker = EntIndexToHScript(data.entindex_attacker)

    if attacker:GetPlayerOwnerID() > -1 then
        if attacked:GetPlayerOwnerID() > -1 then
            local blink_items = {
                'item_blink',
                'item_arcane_blink',
                'item_overwhelming_blink',  -- Corrected spelling
                'item_swift_blink'
            }

            for _, item_name in ipairs(blink_items) do
                local blink_item = attacked:FindItemInInventory(item_name)
                if blink_item then
                    blinkKD(blink_item)
                    break  -- Exit loop after the first found item
                end
            end
        end
    end
end