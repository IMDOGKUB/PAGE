local _ENV = (getgenv or getrenv or getfenv)()

local RunService = game:GetService("RunService")

local MODULE = {}

MODULE.OPTIONS = {}
MODULE.CONNECTIONS = _ENV.Connections or {}

for I = #MODULE.CONNECTIONS, 1, -1 do
    local Connection = MODULE.CONNECTIONS[I]

    if Connection then
        pcall(function()
            Connection:Disconnect()
        end)
    end

    MODULE.CONNECTIONS[I] = nil
end

_ENV.Connections = MODULE.CONNECTIONS


function MODULE.CONNECT(Event, Callback)
    local Connection = Event:Connect(Callback)

    table.insert(MODULE.CONNECTIONS, Connection)

    return Connection
end


function MODULE.NEWOPTION(Callback, Interval)
    Interval = Interval or 0.1

    local Option = {
        Callback = Callback,
        Interval = Interval,
        Time = 0,
        Enabled = true,
        Busy = false
    }

    table.insert(MODULE.OPTIONS, Option)

    return Option
end


MODULE.CONNECT(RunService.Heartbeat, function(DeltaTime)

    for I = 1, #MODULE.OPTIONS do

        local Option = MODULE.OPTIONS[I]

        if Option.Enabled and not Option.Busy then

            Option.Time += DeltaTime

            if Option.Time >= Option.Interval then

                Option.Time = 0
                Option.Busy = true

                task.spawn(function()

                    local Success, Error = pcall(Option.Callback)

                    if not Success then
                        warn(Error)
                    end

                    Option.Busy = false

                end)

            end
        end
    end

end)

return MODULE
