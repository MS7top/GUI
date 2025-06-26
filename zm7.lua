-- ZM2 GUI Library by ChatGPT & User
local ZM2 = {} local Players = game:GetService("Players") local TweenService = game:GetService("TweenService") local LocalPlayer = Players.LocalPlayer

function ZM2:MakeWindow(settings) local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) gui.Name = "ZM2_GUI" gui.ResetOnSpawn = false

-- Splash Screen like Orion
local splash = Instance.new("TextLabel", gui)
splash.Size = UDim2.new(1, 0, 1, 0)
splash.BackgroundColor3 = Color3.new(0, 0, 0)
splash.Text = settings.Hub.Animation or "مرحبًا"
splash.TextColor3 = Color3.fromRGB(255, 0, 0)
splash.Font = Enum.Font.SourceSansBold
splash.TextScaled = true
splash.ZIndex = 10

task.delay(2, function()
    splash:Destroy()
end)

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 600, 0, 400)
main.Position = UDim2.new(0.5, -300, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0

local uiCorner = Instance.new("UICorner", main)
uiCorner.CornerRadius = UDim.new(0, 8)

local uiStroke = Instance.new("UIStroke", main)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(255, 0, 0)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = settings.Hub.Title or "ZM2 GUI"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 24

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local window = {}

function window:MakeTab(tabSettings)
    local tabFrame = Instance.new("Frame", content)
    tabFrame.Size = UDim2.new(1, 0, 0, 300)
    tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local corner = Instance.new("UICorner", tabFrame)
    local stroke = Instance.new("UIStroke", tabFrame)
    stroke.Color = Color3.fromRGB(255, 0, 0)

    local layout = Instance.new("UIListLayout", tabFrame)
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local tab = {}

    function tab:AddSection(titleText)
        local label = Instance.new("TextLabel", tabFrame)
        label.Size = UDim2.new(1, -10, 0, 30)
        label.Text = titleText[1] or "قسم"
        label.TextColor3 = Color3.new(1, 1, 1)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 18
    end

    function tab:AddButton(btnSettings)
        local btn = Instance.new("TextButton", tabFrame)
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.Text = btnSettings.Name or "زر"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16
        btn.MouseButton1Click:Connect(function()
            pcall(btnSettings.Callback)
        end)
    end

    function tab:AddToggle(tglSettings)
        local frame = Instance.new("Frame", tabFrame)
        frame.Size = UDim2.new(1, -20, 0, 40)
        frame.BackgroundTransparency = 1

        local toggle = Instance.new("TextButton", frame)
        toggle.Size = UDim2.new(1, 0, 1, 0)
        toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        toggle.TextColor3 = Color3.new(1, 1, 1)
        toggle.Font = Enum.Font.Gotham
        toggle.TextSize = 16

        local state = tglSettings.Default or false
        local function updateText()
            toggle.Text = (state and "[تشغيل] " or "[ايقاف] ") .. (tglSettings.Name or "Toggle")
        end
        updateText()
        toggle.MouseButton1Click:Connect(function()
            state = not state
            updateText()
            pcall(tglSettings.Callback, state)
        end)
    end

    function tab:AddTextBox(txtSettings)
        local box = Instance.new("TextBox", tabFrame)
        box.Size = UDim2.new(1, -20, 0, 40)
        box.PlaceholderText = txtSettings.PlaceholderText or "اكتب هنا"
        box.Text = txtSettings.Default or ""
        box.TextColor3 = Color3.new(1, 1, 1)
        box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        box.Font = Enum.Font.Gotham
        box.TextSize = 16
        box.FocusLost:Connect(function()
            pcall(txtSettings.Callback, box.Text)
            if txtSettings.ClearText then box.Text = "" end
        end)
    end

    function tab:AddDropdown(dropSettings)
        local btn = Instance.new("TextButton", tabFrame)
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.Text = dropSettings.Default or dropSettings.Options[1]
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16

        btn.MouseButton1Click:Connect(function()
            local next = table.find(dropSettings.Options, btn.Text) + 1
            if next > #dropSettings.Options then next = 1 end
            btn.Text = dropSettings.Options[next]
            pcall(dropSettings.Callback, btn.Text)
        end)
    end

    function tab:AddSlider(slSettings)
        local sliderFrame = Instance.new("Frame", tabFrame)
        sliderFrame.Size = UDim2.new(1, -20, 0, 40)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        local label = Instance.new("TextLabel", sliderFrame)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = slSettings.Name .. ": " .. slSettings.Default
        label.TextColor3 = Color3.new(1, 1, 1)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        
        local value = slSettings.Default
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local conn
                conn = game:GetService("UserInputService").InputChanged:Connect(function(m)
                    if m.UserInputType == Enum.UserInputType.MouseMovement then
                        local x = math.clamp((m.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                        value = math.floor((slSettings.MinValue + (slSettings.MaxValue - slSettings.MinValue) * x) / slSettings.Increase + 0.5) * slSettings.Increase
                        label.Text = slSettings.Name .. ": " .. value
                        pcall(slSettings.Callback, value)
                    end
                end)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        conn:Disconnect()
                    end
                end)
            end
        end)
    end

    function tab:AddColorPicker(cpSettings)
        local btn = Instance.new("TextButton", tabFrame)
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.BackgroundColor3 = cpSettings.Default or Color3.fromRGB(255, 255, 0)
        btn.Text = cpSettings.Name
        btn.TextColor3 = Color3.new(0, 0, 0)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16
        btn.MouseButton1Click:Connect(function()
            pcall(cpSettings.Callback, btn.BackgroundColor3)
        end)
    end

    function tab:AddImageLabel(imgSettings)
        local img = Instance.new("ImageLabel", tabFrame)
        img.Size = UDim2.new(1, -20, 0, 120)
        img.Image = imgSettings.Image or "rbxassetid://"
        img.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    end

    function tab:AddDiscord(disSettings)
        local btn = Instance.new("TextButton", tabFrame)
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
        btn.Text = disSettings.DiscordTitle or "Join Discord"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16
        btn.MouseButton1Click:Connect(function()
            setclipboard(disSettings.DiscordLink)
        end)
    end

    return tab
end

function window:MakeNotifi(notif)
    local n = Instance.new("TextLabel", gui)
    n.Size = UDim2.new(0, 300, 0, 50)
    n.Position = UDim2.new(0.5, -150, 0.1, 0)
    n.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    n.Text = notif.Title .. " - " .. notif.Text
    n.TextColor3 = Color3.new(1, 1, 1)
    n.Font = Enum.Font.Gotham
    n.TextSize = 16
    n.ZIndex = 5
    game:GetService("Debris"):AddItem(n, notif.Time or 5)
end

function window:MinimizeButton(minSettings)
    local btn = Instance.new("ImageButton", main)
    btn.Size = UDim2.new(0, minSettings.Size[1], 0, minSettings.Size[2])
    btn.Position = UDim2.new(1, -minSettings.Size[1] - 10, 0, 5)
    btn.Image = minSettings.Image or ""
    btn.BackgroundColor3 = minSettings.Color or Color3.fromRGB(10, 10, 10)
    if minSettings.Corner then Instance.new("UICorner", btn) end
    if minSettings.Stroke then
        local s = Instance.new("UIStroke", btn)
        s.Color = minSettings.StrokeColor or Color3.fromRGB(255, 0, 0)
    end
    btn.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)
end

return window

end

return ZM2

