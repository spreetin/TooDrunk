TooDrunk = LibStub("AceAddon-3.0"):NewAddon("TooDrunk", "AceConsole-3.0", "AceComm-3.0", "AceConfig-3.0",
                                            "AceEvent-3.0", "AceSerializer-3.0", "AceTimer-3.0");


local options = {
    name = "TooDrunk",
    handler = TooDrunk
    type = 'group',
    args = {
    },
}

function TooDrunk:OnEnable()

end

function TooDrunk:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("TooDrunkDB");
    TooDrunk:RegisterOptionsTable("Too Drunk To Fight", options, {"drunkconfig"});
    TooDrunk:RegisterChatCommand("drunk", TooDrunk:slashHandler);

    if (self.db.global.goldLog == nil) then self.db.global.goldLog = {} end
    if (self.db.global.eventLog == nil) then self.db.global.eventLog = {} end
    if (self.db.global.guildChatLog == nil) then self.db.global.guildChatLog = {} end
    if (self.db.global.mainList == nil) then self.db.global.mainList = {} end
    if (self.db.global.altList == nil) then self.db.global.altList = {} end

    TooDrunk:RegisterComm("drunkGChat");
    TooDrunk:RegisterComm("drunkComm");
    TooDrunk:RegisterComm("drunkGolds");
    TooDrunk:RegisterComm("drunkEvents");
    self:RegisterEvent("CHAT_MSG_GUILD");
    self:RegisterEvent("GUILDBANKFRAME_OPENED");

    TooDrunk:SendCommMessage("drunkComm", TooDrunk:Serialize("getChatLog"), "GUILD");
end

function TooDrunk:slashHandler(input)
    local tokenized = {};
    for str in input:gmatch("([^%s]+)") do
        t:insert(str);
    end
    if (#tokenized == 0) then
        return;
    end
    if (tokenized[1] == "alt") then
        if (#tokenized < 3) then
            return;
        end
        for i=3,#tokenized do
            self.db.global.mainList[tokenized[i]] = tokenized[2];
            self.db.global.altList[tokenized[2]] = tokenized[i];
        end
    end
end
