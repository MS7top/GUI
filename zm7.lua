-- ZM2 GUI Library - Orion Style Full Version
local ZM2 = {} local Players = game:GetService("Players") local TweenService = game:GetService("TweenService") local UserInputService = game:GetService("UserInputService") local LocalPlayer = Players.LocalPlayer

function ZM2:MakeWindow(settings) local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) gui.Name = "ZM2" gui.ResetOnSpawn = false

local splash = Instance.new("TextLabel", gui)
splash.Size = UDim2.new(1, 0, 1, 0)
splash.BackgroundColor3 = Color3.new(0, 0, 0)
splash.Text = settings.Hub.Animation or "Welcome"
splash.TextColor3 = Color3.fromRGB(255, 0, 0)
splash.Font = Enum.Font.GothamBlack
splash.TextScaled = true
splash.ZIndex = 10

task.spawn(function()
    TweenService:Create(splash, TweenInfo.new(1), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    task.wait(2)
    splash:Destroy()
end)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 640, 0, 420)
main.Position = UDim2.new(0.5, -320, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2

local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = settings.Hub.Title or "ZM2 Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

local minimize = Instance.new("TextButton", titleBar)
minimize.Size = UDim2.new(0, 40, 0, 40)
minimize.Position = UDim2.new(1, -45, 0, 0)
minimize.Text = "-"
minimize.TextColor3 = Color3.fromRGB(255, 0, 0)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 20
minimize.BackgroundTransparency = 1
local minimized = false

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, v in pairs(main:GetChildren()) do
        if v ~= titleBar then
            v.Visible = not minimized
        end
    end
end)

local tabsHolder = Instance.new("Frame", main)
tabsHolder.Size = UDim2.new(0, 140, 1, -40)
tabsHolder.Position = UDim2.new(0, 0, 0, 40)
tabsHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", tabsHolder)
local tabLayout = Instance.new("UIListLayout", tabsHolder)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -140, 1, -40)
content.Position = UDim2.new(0, 140, 0, 40)
content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", content)

local pages, currentPage = {}, nil
local firstTab = true

local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local window = {}

function window:MakeTab(tabSettings)
    local tabBtn = Instance.new("TextButton", tabsHolder)
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.Text = tabSettings.Name
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextSize = 16

    local page = Instance.new("ScrollingFrame", content)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 10, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.Visible = false
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    tabBtn.MouseButton1Click:Connect(function()
        if currentPage then currentPage.Visible = false end
        currentPage = page
        page.Visible = true
    end)

    if firstTab then
        currentPage = page
        page.Visible = true
        firstTab = false
    end

    local tab = {}
    tab.Button = tabBtn

    function tab:AddSection(titleText)
        local label = Instance.new("TextLabel", page)
        label.Size = UDim2.new(1, -10, 0, 30)
        label.Text = titleText[1] or "قسم"
        label.TextColor3 = Color3.fromRGB(255, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 18
    end

    function tab:AddButton(btnSettings)
        local btn = Instance.new("TextButton", page)
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.Text = btnSettings.Name or "زر"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16
        btn.MouseButton1Click:Connect(function()
            pcall(btnSettings.Callback)
        end)
    end

    function tab:AddToggle(tgl)
        local toggle = Instance.new("TextButton", page)
        toggle.Size = UDim2.new(1, -10, 0, 40)
        toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        toggle.Font = Enum.Font.Gotham
        toggle.TextSize = 16
        toggle.TextColor3 = Color3.new(1, 1, 1)
        local state = tgl.Default or false
        local function update()
            toggle.Text = (state and "[تشغيل] " or "[ايقاف] ") .. (tgl.Name or "Toggle")
        end
        update()
        toggle.MouseButton1Click:Connect(function()
            state = not state
            update()
            pcall(tgl.Callback, state)
        end)
    end

    function tab:AddTextBox(txt)
        local box = Instance.new("TextBox", page)
        box.Size = UDim2.new(1, -10, 0, 40)
        box.PlaceholderText = txt.PlaceholderText or "اكتب هنا"
        box.Text = txt.Default or ""
        box.TextColor3 = Color3.new(1, 1, 1)
        box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        box.Font = Enum.Font.Gotham
        box.TextSize = 16
        box.FocusLost:Connect(function()
            pcall(txt.Callback, box.Text)
            if txt.ClearText then box.Text = "" end
        end)
    end

    function tab:AddDropdown(dd)
        local btn = Instance.new("TextButton", page)
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.Text = dd.Default or dd.Options[1]
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16
        btn.MouseButton1Click:Connect(function()
            local i = table.find(dd.Options, btn.Text) or 1
            i = i + 1
            if i > #dd.Options then i = 1 end
            btn.Text = dd.Options[i]
            pcall(dd.Callback, btn.Text)
        end)
    end

    function tab:AddSlider(sl)
        local holder = Instance.new("Frame", page)
        holder.Size = UDim2.new(1, -10, 0, 40)
        holder.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(0.3, 0, 1, 0)
        label.Text = sl.Name
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left

        local slider = Instance.new("TextBox", holder)
        slider.Size = UDim2.new(0.7, 0, 1, 0)
        slider.Position = UDim2.new(0.3, 0, 0, 0)
        slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        slider.Text = tostring(sl.Default or 0)
        slider.Font = Enum.Font.Gotham
        slider.TextColor3 = Color3.new(1, 1, 1)
        slider.TextSize = 14
        slider.ClearTextOnFocus = false
        slider.FocusLost:Connect(function()
            local value = tonumber(slider.Text)
            if value then
                local clamped = math.clamp(value, sl.MinValue, sl.MaxValue)
                pcall(sl.Callback, clamped)
                slider.Text = tostring(clamped)
            end
        end)
    end

    return tab
end

function window:MakeNotifi(nf)
    local note = Instance.new("TextLabel", gui)
    note.Size = UDim2.new(0, 250, 0, 50)
    note.Position = UDim2.new(1, -260, 1, -100)
    note.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    note.TextColor3 = Color3.new(1, 1, 1)
    note.Text = nf.Title .. "\n" .. nf.Text
    note.TextWrapped = true
    note.Font = Enum.Font.Gotham
    note.TextSize = 14
    note.ZIndex = 10
    Instance.new("UICorner", note)
    TweenService:Create(note, TweenInfo.new(0.5), {Position = UDim2.new(1, -260, 1, -150)}):Play()
    task.delay(nf.Time or 3, function()
        TweenService:Create(note, TweenInfo.new(0.5), {Position = UDim2.new(1, 10, 1, 0)}):Play()
        task.wait(0.5)
        note:Destroy()
    end)
end

return window

end

return ZM2

