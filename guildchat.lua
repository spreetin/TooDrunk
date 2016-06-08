function TooDrunk:CHAT_MSG_GUILD(eventName, msg, sender, ...)
    name = TooDrunk:removeRealmFromName(sender);
    self.db.global.guildChatLog[name] = GetTime();
end
