function TooDrunk:OnCommReceived(prefix, msg, dist, sender)
    if (prefix == "drunkComm") then
        TooDrunk:OnDrunkenCommRecieved(msg, dist, sender);
    elseif (prefix == "drunkGChat") then
        TooDrunk:OnGuildChatCommRecieved(msg, dist, sender);
    elseif (prefix == "drunkGolds") then
        TooDrunk:OnBankGoldLogCommRecieved(msg, dist, sender);
    elseif (prefix == "drunkEvents") then
        TooDrunk:OnGuildEventsCommRecieved(msg, dist, sender);
    end
end

function TooDrunk:OnDrunkenCommRecieved(msg, dist, sender)
    local status, msgtype, rcvd = TooDrunk:Deserialize(msg);
    if (status) then
        if (msgtype == "eventKeys") then
            for i=0,#rcvd do
                if (self.db.global.eventLog[rcvd[i]] == nil) then
                    TooDrunk:SendCommMessage("drunkComm", TooDrunk:Serialize("reqEvent", rcvd[i]), 
                                             "WHISPER", sender);
                end
            end
        elseif (msgtype == "reqEvent") then
            TooDrunk:SendCommMessage("drunkEvents", 
                                     TooDrunk:Serialize("fullEvent", self.db.global.eventLog[rcvd]), 
                                     "WHISPER", sender);
        elseif (msgtype == "getChatLog") then
            TooDrunk:SendGuildChat(rcvd, sender);
        end
    else
        TooDrunk:Print(rcvd);
    end
end

function TooDrunk:OnGuildChatCommRecieved(msg, dist, sender)
    local status, msgtype, rcvd = TooDrunk:Deserialize(msg);
    if (status) then
        for key, value in pairs(rcvd) do
            if (self.db.global.guildChatLog[key] == nil) then
                self.db.global.guildChatLog[key] = value;
            elseif (self.db.global.guildChatLog[key] < value) then
                self.db.global.guildChatLog[key] = value;
            end
        end
    else
        TooDrunk:Print(rcvd);
    end
end

function TooDrunk:OnBankGoldLogCommRecieved(msg, dist, sender)

end

function TooDrunk:OnGuildEventsCommRecieved(msg, dist, sender)

end

function TooDrunk:SendSync()
    return;
end

function TooDrunk:SendReq()
    return;
end

function TooDrunk:SendGuildChat(afterStamp, reciever)
    if (afterStamp == nil) then
        TooDrunk:SendCommMessage("drunkGChat", TooDrunk:Serialize("guildchat", self.db.global.guildChatLog), "GUILD");
    else
        local sendList = {};
        for key, value in pairs(self.db.global.guildChatLog) do
            if (value >= afterStamp) then
                sendList[key] = value;
            end
        end
        if (reciever) then
            TooDrunk:SendCommMessage("drunkGChat", TooDrunk:Serialize("guildchat", self.db.global.guildChatLog), "WHISPER", reciever);
        else
            TooDrunk:SendCommMessage("drunkGChat", TooDrunk:Serialize("guildchat", self.db.global.guildChatLog), "GUILD");
        end
    end
end

function TooDrunk:SendListOfEventsStamps()
    local eventlist = {};
    for key, value in pairs(self.db.global.eventLog) do
        eventlist:insert(key);
    end
    TooDrunk:SendCommMessage("drunkComm", TooDrunk:Serialize("eventKeys", eventlist), "GUILD");
end
