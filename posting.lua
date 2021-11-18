-- Services
local rStorage = game:GetService("ReplicatedStorage")



-- Instaces
	-- Folders
local remotesFolder = rStorage:WaitForChild("Remotes")
	-- Other
local plr = game.Players.LocalPlayer
local postRemote = remotesFolder:WaitForChild("PostData")
local MainGui = plr.PlayerGui:WaitForChild("Rocord")


-- Functions
function focuslost(enterpressed)
	if enterpressed then
		if string.len(script.Parent.Text) > 0 and string.len(script.Parent.Text) < 200 then
			print("enterpressed")
			
			local activeId = MainGui.ActiveChannel.Value
			local res = postRemote:InvokeServer(script.Parent.Text, activeId)
			
			if res then
				script.Parent.Text = "Start typing!"
			end
		end
	end
end






--Events
script.Parent.FocusLost:Connect(focuslost)
