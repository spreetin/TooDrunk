
function TooDrunk:removeRealmFromName(name)
    return name:match("^[%-]+");
end

function pairsByKeys(t, f)
    local a = {};
    for n in pairs(t) do a:insert(n) end
    a:sort(f);
    local i = 0;
    local iter = function()
        i = i+1;
        if (a[i] == nil) then
            return nil;
        else
            return a[i], t[a[i]];
        end
    end
    return iter;
end
