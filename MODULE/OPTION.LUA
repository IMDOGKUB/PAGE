local _ENV = (getgenv or getrenv or getfenv)()

local RUNSERVICE = game:GetService("RunService")
local HEARTBEAT = RUNSERVICE.Heartbeat

local MODULE = {}

MODULE.CONNECTIONS = _ENV.Connections or {}

for I = #MODULE.CONNECTIONS, 1, -1 do
    local CONNECTION = MODULE.CONNECTIONS[I]

    if CONNECTION then
        pcall(function()
            CONNECTION:Disconnect()
        end)
    end

    MODULE.CONNECTIONS[I] = nil
end

_ENV.Connections = MODULE.CONNECTIONS

function MODULE.CONNECT(INSTANCE, CALLBACK)
    local CONNECTION = INSTANCE:Connect(CALLBACK)

    table.insert(MODULE.CONNECTIONS, CONNECTION)

    return CONNECTION
end

function MODULE.NEWOPTION(FUNCTION, INTERVAL)
    INTERVAL = INTERVAL or 0.1

    local ELAPSED = 0

    return MODULE.CONNECT(HEARTBEAT, function(DELTA)
        ELAPSED += DELTA

        if ELAPSED < INTERVAL then
            return
        end

        ELAPSED = 0

        if FUNCTION then
            local SUCCESS, ERROR = pcall(FUNCTION)

            if not SUCCESS then
                warn(ERROR)
            end
        end
    end)
end

return MODULE
