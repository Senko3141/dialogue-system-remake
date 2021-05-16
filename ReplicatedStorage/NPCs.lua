-- NPCs.lua
-- Senko
-- 5/16/2021

return{
	["Uzaki"] = {
		[1] = {
			Dialogue = "Hello, I'm Uzaki. Do you need anything?",
			Responses = {"Yeah, what is this place?", "Nah, I'm just looking around."}
		},
		[2] = {
			Dialogue = "This is the Town of Beginnings, a random place I thought about.",
			Responses = {"Give me a quest nerd.", "Bye."},
			Finished = function()
				print("Finished")
			end,
		}
	}
}
