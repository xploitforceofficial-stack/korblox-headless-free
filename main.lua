-- [[ KORBLOX R6 FLOATING + MINIMIZE GUI ]] --
local Player = game.Players.LocalPlayer
local IsActive = false

-- 1. FUNCTIONS (LOGIC UTAMA)
local function ApplyKorblox()
    local Character = Player.Character
    if not Character or not IsActive then return end

    -- Headless Logic
    if Character:FindFirstChild("Head") then
        Character.Head.Transparency = 1
        if Character.Head:FindFirstChild("face") then Character.Head.face:Destroy() end
    end

    -- Right Leg Logic
    local RightLeg = Character:FindFirstChild("Right Leg")
    if RightLeg then
        RightLeg.Transparency = 1
        
        -- Cleanup lama
        if Character:FindFirstChild("FixedKorbloxBoneR6") then
            Character.FixedKorbloxBoneR6:Destroy()
        end

        -- Buat Tulang
        local Bone = Instance.new("Part")
        Bone.Name = "FixedKorbloxBoneR6"
        Bone.Size = Vector3.new(0.2, 2, 0.2) 
        Bone.Color = Color3.fromRGB(20, 20, 20)
        Bone.Material = Enum.Material.SmoothPlastic
        Bone.CanCollide = false
        Bone.Parent = Character

        local Mesh = Instance.new("SpecialMesh")
        Mesh.MeshType = Enum.MeshType.FileMesh
        Mesh.MeshId = "rbxassetid://1033714" 
        Mesh.Scale = Vector3.new(0.08, 1.25, 0.08) 
        Mesh.Parent = Bone

        -- Floating Weld (Logic 0.75 sesuai permintaan)
        local Weld = Instance.new("Weld")
        Weld.Name = "KorbloxWeld"
        Weld.Part0 = RightLeg
        Weld.Part1 = Bone
        Weld.C0 = CFrame.new(0, 0.75, 0) * CFrame.Angles(math.rad(180), 0, 0)
        Weld.Parent = Bone
    end
end

local function RemoveKorblox()
    local Character = Player.Character
    if Character then
        if Character:FindFirstChild("Head") then Character.Head.Transparency = 0 end
        local RightLeg = Character:FindFirstChild("Right Leg")
        if RightLeg then RightLeg.Transparency = 0 end
        if Character:FindFirstChild("FixedKorbloxBoneR6") then
            Character.FixedKorbloxBoneR6:Destroy()
        end
    end
end

-- 2. SETUP GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KorbloxManager"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 140, 0, 70)
MainFrame.Position = UDim2.new(0.5, -70, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser bebas
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -25, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.TextSize = 14
CloseBtn.Parent = MainFrame

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
    ScreenGui:Destroy()
end)

Player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Right Leg")
    task.wait(0.8)
    if IsActive then ApplyKorblox() end
end)
