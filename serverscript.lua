-- credit: https://github.com/VioPaige


-- Services
local http = game:GetService("HttpService")
local rStorage = game:GetService("ReplicatedStorage")



-- Instances
	-- Folders
local remoteFolder = rStorage:WaitForChild("Remotes")
	-- Other
local getRemote = remoteFolder:WaitForChild("GetData")
local postRemote = remoteFolder:WaitForChild("PostData")


-- Variables
local api = "https://rocordbackend.herokuapp.com"




-- Functions
function getGuild()
	local res = http:GetAsync(api ..'/get/guild')
	res = http:JSONDecode(res)
	return res
end

function getChannel(id)
	local res = http:GetAsync(api ..'/get/channel/'.. id)
	res = http:JSONDecode(res)
	return res
end

function getMessages(channelid)
	local res = http:GetAsync(api ..'/get/channelmessages/'.. channelid)
	res = http:JSONDecode(res)
	return res
end

function getAuthor(channelid, messageid)
	local res = http:GetAsync(api ..'/get/messageauthor/'.. channelid ..'/'.. messageid)
	res = http:JSONDecode(res)
	return res
end


function postMessage(user, content, channelid)
	local res = http:GetAsync(api ..'/post/message/'.. user ..'/'.. channelid ..'/'.. content)
	--res = http:JSONDecode(res)
	return res
end







function getRemote.OnServerInvoke(plr, reqtype, id, id2)
	--print(plr, reqtype, id)	
	local result = nil
	
	if reqtype == "guild" then
		local res = getGuild()
		result = res
	elseif reqtype == "channel" then
		local res = getChannel(id)
		result = res
	elseif reqtype == "messages" then
		local res = getMessages(id)
		for i, v in pairs(res) do
			local author = getAuthor(v["channelId"], v["id"])
			v["author"] = author
		end
		result = res		
	end
	--print("success")
	return result
end


function postRemote.OnServerInvoke(plr, message, channelid)
	print(plr, message)
	local result = nil
	
	
	result = postMessage(plr.Name, message, channelid)
	
	
	return result
end










-- Events
