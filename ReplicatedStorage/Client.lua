-- Client.lua
-- Senko
-- 5/16/2021

local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Dialogue = require(ReplicatedStorage:WaitForChild("Dialogue"))
local UI = script.Parent:WaitForChild("NPC")

local Interacting = false

ProximityPromptService.PromptTriggered:Connect(function(prompt, plr)
	local model = prompt.Parent
	if (model:GetAttribute("NPC") == true) then
		if (Interacting == true) then
			return
		end
		
		local new_dialogue = Dialogue.new(model.Name, UI)
		Interacting = true
		
		new_dialogue.DialogueChanged:Connect(function()
			new_dialogue:update()
		end)
		new_dialogue.DialogueFinished:Connect(function()
			Interacting = false
			new_dialogue = nil
		end)
	end
end)
