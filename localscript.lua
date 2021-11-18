-- Services
local rStorage = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")


-- Instances
	-- Folders
local remoteFolder = rStorage:WaitForChild("Remotes")
local guiPresets = rStorage:WaitForChild("GuiPresets")
	-- Other
local dataRemote = remoteFolder:WaitForChild("GetData")
local plr = game.Players.LocalPlayer
local MainGui = plr.PlayerGui:WaitForChild("Rocord")
local background, channels, messages = MainGui.Background, MainGui.Background.Channels, MainGui.Background.Messages
local categorypreset, channelpreset, messagepreset = guiPresets.Category, guiPresets.Channel, guiPresets.Message






-- Functions
function getData()
	--print('init')
	local data = dataRemote:InvokeServer("guild")
	--print(data)
	
	for i, v in pairs(data.channels) do
		local channel = dataRemote:InvokeServer("channel", v)
		--print(channel)
		
		if channel["type"] == "GUILD_CATEGORY" then
			local preset = categorypreset:Clone()
			preset.TextButton.Text = channel["name"]
			preset.Id.Value = channel["id"]
			preset.Parent = channels
		elseif channel["type"] == "GUILD_TEXT" then
			local preset = channelpreset:Clone()
			preset.Text = channel["name"]
			preset.Id.Value = channel["id"]
			if channel["parentId"] then
				--print("channel[parentid] exists")
				for _, v in pairs(channels:GetChildren()) do
					if v:FindFirstChild("Id") then
						--print(v:FindFirstChild("Id").Value)
						if v:FindFirstChild("Id").Value == channel["parentId"] then
							v.Channels.Size = UDim2.new(v.Channels.Size.X, UDim.new(0, v.Channels.Size.Y.Offset + 35))
							v.Size = UDim2.new(v.Size.X, UDim.new(0, v.Size.Y.Offset + 35))
							preset.Parent = v.Channels
						end
					end
				end
			end
		end
	end
end


function getMessages()
	if MainGui.ActiveChannel.Value then
		local activeId = MainGui.ActiveChannel.Value
		local data = dataRemote:InvokeServer("messages", activeId)
		print(data)
		for _, v in pairs(messages:GetChildren()) do
			if v.Name == "Message" then
				v:Destroy()
			end
		end
		for i = #data, 1, -1 do
			local v = data[i]
			local message = messagepreset:Clone()
			if v.authorId == "908060826567589889" then
				print("author is the bot")
				print("message from roblox!")
				print(v.content:split(' '))
				local fixedcontent = string.gsub(v.content, "says:**", "says:** ;:;")
				print(fixedcontent)
				print(fixedcontent.split(' ;:;'))
				local actualcontentarr = v.content:split(' ')
				print(actualcontentarr)
				local actualcontent = ""
				for i = 3, #actualcontentarr do
					if actualcontent ~= "" then actualcontent = actualcontent.." " end
					print(actualcontent, actualcontentarr[i])
					actualcontent = actualcontent .. actualcontentarr[i]
				end
				
				print(actualcontent)
				local authortag = string.sub(actualcontentarr[1], 3)
				print(authortag)
				
				
				message.Content.Text = actualcontent
				message.Member.Text = authortag
				message.Parent = messages
			else
				message.Content.Text = v.content
				message.Member.Text = v.author.tag
				message.Parent = messages
			end

		end
	end
end










-- Events
uis.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Zero then
		getData()
	elseif input.KeyCode == Enum.KeyCode.LeftAlt then
		getMessages()
	end
end)
