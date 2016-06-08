local upcoming = {};
local updateInterval = 0.2;

-- List used as queue
TooDrunk_List = {}
function TooDrunk_List.new()
    return {first = 0, last = -1}
end

function TooDrunk_List.pushleft(list, value)
    local first = list.first - 1;
    list.first = first;
    list[first] = value;
end

function TooDrunk_List.pushright(list, value)
    local last = list.last + 1;
    list.last = last;
    list[last] = value;
end

function TooDrunk_List.popleft(list)
    local first = list.first;
    if first > list.last then
        return;
    end
    local value = list[first];
    list[first] = nil;
    list.first = first + 1;
    return value;
end

function TooDrunk_List.popright(list)
    local last = list.last;
    if list.first > last then
        return;
    end
    local value = list[last];
    list[last] = nil;
    list.last = last - 1;
    return value;
end
-- End list

function TooDrunk_timeAction(secs, func, ...)
    local tbl = {...};
    tbl.function = func;
    tbl.time = GetTime()+time;
    upcoming:insert(tbl);
end

local queue = TooDrunk_List.new();

function TooDrunk_queueAction(func, ...)
    local tbl = {...};
    tbl.function = func;
    queue:pushright(tbl);
end

local function onUpdateHandler(self, elapsed)
    for i=#upcoming, 1, -1 do
        local c = upcoming[i];
        if (c.time <= GetTime()) then
            upcoming:remove(i);
            c.func(unpack(c));
        end
    end
    self.whenLast = self.whenLast + elapsed;
    while (self.whenLast > updateInterval) do
        if (#queue > 0) then
            local c = queue:popleft();
            c.func(unpack(c));
        end
        self.whenLast = self.whenLast - updateInterval;
    end
end

local UpdateFrame = CreateFrame("Frame");
UpdateFrame:SetScript("OnUpdate", UpdateFrame);
UpdateFrame.whenLast = 0;
