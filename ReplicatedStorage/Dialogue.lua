-- Dialogue.lua
-- Senko
-- 5/16/2021

local Dialogue = require(script:WaitForChild("NPCs"))
local Signal = require(script:WaitForChild("Signal"))

local Configuration = {
	Interval = .005,
}

local module = {}
module.__index = module

function module.new(npcName, ui)
	if (npcName == nil) then warn("Dialogue; npcName argument passed is nil.") return end
	if (Dialogue[npcName] == nil) then warn("Dialogue; ".. npcName.." was not found in the Dialogue module.") return end

	local self = setmetatable({}, module)

	self.NPCName = npcName
	self.Info = Dialogue[npcName]
	self.DialogueOn = Instance.new("IntValue")

	self.Connections = {
		YesClick = nil,
		NoClick = nil,
	}

	self.DialogueOn.Value = 1
	self.UI = ui

	self.DialogueChanged = Signal.new()
	self.DialogueFinished = Signal.new()
	
	self.resetMaxGraphemes = function()
		self.UI.Holder.Dialogue.Label.MaxVisibleGraphemes = 0
		self.UI.Holder.Responses.Yes.Label.MaxVisibleGraphemes = 0
		self.UI.Holder.Responses.No.Label.MaxVisibleGraphemes = 0	
	end
	self.DisconnectConnections = function()
		for _,connection in pairs(self.Connections) do
			if (connection ~= nil) then
				connection:Disconnect()
				connection = nil
			end 
		end
	end

	self.DialogueOn.Changed:Connect(function()
		self.DialogueChanged:Fire()
	end)
	
	coroutine.resume(coroutine.create(function()
		-- start dialogue
		self:update()		
	end))

	return self
end
function module:update()
	-- checking if finished
	if (self.DialogueOn.Value == #self.Info+1) then
		-- finished, do function on finished
		self.Info[#self.Info].Finished()
		self:destroy()
		return
	end
	
	-- disconnecting events
	warn(self.DialogueFinished)
	self.DisconnectConnections()
	
	local holder = self.UI.Holder
	-- tweening
	holder:TweenPosition(UDim2.new(0.5,0,0.872,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5, true)

	-- animating
	local onTable = self.Info[self.DialogueOn.Value]

	local dialogueHolder = holder.Dialogue
	local responsesHolder = holder.Responses
	
	local yes = onTable.Responses[1]
	local no = onTable.Responses[2]
	
	self.resetMaxGraphemes()
	
	dialogueHolder.Label.Text = onTable.Dialogue
	responsesHolder.Yes.Label.Text = yes
	responsesHolder.No.Label.Text = no

	-- animating text
	-- dialogue
	for i = 1, string.len(onTable.Dialogue), 1 do
		dialogueHolder.Label.MaxVisibleGraphemes = i
		wait(Configuration.Interval)
	end
	-- yes/no 

	for i = 1, string.len(onTable.Responses[1]), 1 do
		responsesHolder.Yes.Label.MaxVisibleGraphemes = i
		wait(Configuration.Interval)
	end
	for i = 1, string.len(onTable.Responses[2]), 1 do
		responsesHolder.No.Label.MaxVisibleGraphemes = i
		wait(Configuration.Interval)
	end
	wait(.5)

	-- handling click connections
	self.Connections.YesClick = responsesHolder.Yes.Label.MouseButton1Click:Connect(function()		
		self.DialogueOn.Value += 1
	end)
	self.Connections.NoClick = responsesHolder.No.Label.MouseButton1Click:Connect(function()
		self:destroy()
	end)
end
function module:destroy()
	self.DialogueOn:Destroy()
	
	self.UI.Holder.Dialogue.Label.Text = ""
	self.UI.Holder.Responses.Yes.Label.Text = ""
	self.UI.Holder.Responses.Yes.Label.Text = ""

	self.resetMaxGraphemes()
	self.DisconnectConnections()
	self.DialogueFinished:Fire()
	
	self.DialogueChanged:Destroy()
	self.DialogueFinished:Destroy()
		
	self.UI.Holder:TweenPosition(UDim2.new(0.5,0,1.4,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.8, true)
end


return module
