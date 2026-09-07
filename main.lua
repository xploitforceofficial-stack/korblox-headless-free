-- [[ KORBLOX R6 FLOATING + MINIMIZE GUI ]] --
local Player = game.Players.LocalPlayer
local IsActive = false
local KorbloxGui = nil

-- 1. FUNCTIONS (LOGIC SAMA PERSIS DENGAN PINATHUB)
local function ApplyKorblox()
    local Character = Player.Character
    if not Character or not IsActive then return end

    -- Headless Logic (sama persis dengan PinatHub)
    if Character:FindFirstChild("Head") then
        Character.Head.Transparency = 1
        if Character.Head:FindFirstChild("face") then 
            Character.Head.face:Destroy() 
        end
    end

    -- Right Leg Logic (sama persis dengan PinatHub)
    local RightLeg = Character:FindFirstChild("Right Leg")
    if RightLeg then
        RightLeg.Transparency = 1
        
        -- Cleanup (sama persis dengan PinatHub)
        if Character:FindFirstChild("KorlessHead") then
            Character.KorlessHead:Destroy()
        end

        -- Buat MeshPart KORLESS (sama persis dengan PinatHub)
        local mesh = Instance.new("MeshPart")
        mesh.Name = "KorlessHead"  -- Nama sama persis dengan PinatHub
        mesh.Size = Vector3.new(1.5, 1.5, 1.5)
        mesh.CanCollide = false
        mesh.MeshId = "rbxassetid://902942096"  -- Sama persis dengan PinatHub
        mesh.TextureID = "rbxassetid://902843398"  -- Sama persis dengan PinatHub
        mesh.CFrame = RightLeg.CFrame * CFrame.new(0, 0.5, 0)  -- Sama persis dengan PinatHub
        mesh.Parent = Character

        -- WeldConstraint (sama persis dengan PinatHub)
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = RightLeg
        weld.Part1 = mesh
        weld.Parent = mesh
    end
end

local function RemoveKorblox()
    local Character = Player.Character
    if not Character then return end
    
    -- Restore Head (sama persis dengan PinatHub)
    if Character:FindFirstChild("Head") then
        Character.Head.Transparency = 0
    end
    
    -- Restore Right Leg (sama persis dengan PinatHub)
    local RightLeg = Character:FindFirstChild("Right Leg")
    if RightLeg then
        RightLeg.Transparency = 0
    end
    
    -- Hapus KorlessHead (sama persis dengan PinatHub)
    if Character:FindFirstChild("KorlessHead") then
        Character.KorlessHead:Destroy()
    end
end

-- 2. SETUP GUI (FLOATING + MINIMIZE)
local function SetupGUI()
    -- Hapus GUI lama jika ada
    if KorbloxGui then
        KorbloxGui:Destroy()
        KorbloxGui = nil
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KorbloxManager"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Player.PlayerGui
    KorbloxGui = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 140, 0, 70)
    MainFrame.Position = UDim2.new(0.5, -70, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -25, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseBtn.TextSize = 14
    CloseBtn.Parent = MainFrame

    -- Toggle Button
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 110, 0, 30)
    ToggleBtn.Position = UDim2.new(0, 15, 0, 25)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleBtn.Text = "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 14
    ToggleBtn.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = ToggleBtn

    -- 3. INTERAKSI & EVENTS
    ToggleBtn.MouseButton1Click:Connect(function()
        IsActive = not IsActive
        if IsActive then
            ToggleBtn.Text = "ON"
            ToggleBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
            ApplyKorblox()
        else
            ToggleBtn.Text = "OFF"
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
            RemoveKorblox()
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        if IsActive then
            IsActive = false
            RemoveKorblox()
        end
        ScreenGui:Destroy()
        KorbloxGui = nil
    end)
end

-- 4. CHARACTER RESPAWN (sama persis dengan PinatHub)
Player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Right Leg")
    task.wait(0.8)
    if IsActive then
        ApplyKorblox()
    end
end)

-- 5. INITIALIZE
SetupGUI()
