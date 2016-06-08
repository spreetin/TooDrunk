function TooDrunk:GUILDBANKFRAME_OPENED()
    local numT = GetNumGuildBankMoneyTransactions();
    for i=1, numT do
        print(GetGuildBankMoneyTransaction(i));
        local kind, name, year, month, day, hour = GetGuildBankMoneyTransaction(i);
    end
end

function appendToDatabaseIfNotExist(mode, ...)

end
