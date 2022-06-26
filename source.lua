-- Will edit later
-- Thanks network for allowing me to steal (https://github.com/networktraffic/blaze)

local job_queue = {}
local Players = game:GetService('Players')

local function create(class, parent, properties)
	local obj = Instance.new(class, parent)
	
	for i, v in pairs(properties) do
		obj[i] = v
	end
	
	return obj
end

local container = create('Frame', create('ScreenGui', gethui and gethui() or game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'),{
    Name = math.random(),
    ResetOnSpawn = false}
), 
    {Name = math.random(),
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 0, 100)
})

local throwaway_thread = Instance.new('BindableEvent')
throwaway_thread.Event:Connect(function()
    while true do
        local curr_job = job_queue[1]

        if curr_job then
            local text = curr_job[1]
            local expiration = curr_job[2]
            local color = curr_job[3]

            if text and expiration and color then
		color = color or Color3.new(47, 32, 66)
                local label = create('TextLabel', container, {
                    Name = math.random(),
                    AnchorPoint = Vector2.new(1, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 1, 20),
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Code,
                    RichText = true,
                    Text = text,
                    TextColor3 = color,
                    TextSize = 16,
                    TextWrapped = true,
                    TextStrokeTransparency = 0,
                })

                for _, msg in next, container:GetChildren() do
                    msg:TweenPosition(msg.Position - UDim2.new(0, 0, 0, 20), 'Out', 'Sine', 0.3, true)
                end

                table.remove(job_queue, 1)
                task.delay(expiration, function()
                    game:GetService('TweenService'):Create(label, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
                    task.wait(1.25)
                    label:Destroy()
                end)
                
                task.wait(0.35)
            end
        end

        task.wait()
    end
end)

throwaway_thread:Fire()
throwaway_thread:Destroy()

return function(...)
    table.insert(job_queue, {...}) 
end
