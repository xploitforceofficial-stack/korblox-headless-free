local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ============================================================
-- MENDAFTARKAN SCRIPT OTOMATIS SAAT BERPINDAH GAME (QUEUE TELEPORT)
-- ============================================================
local TeleportService = game:GetService("TeleportService")
local queue_teleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

if queue_teleport then
    Player.OnTeleport:Connect(function(teleportState)
        if teleportState == Enum.TeleportState.Started then
            -- Script akan otomatis di-load ulang dari GitHub setelah pindah server
            queue_teleport([[
                loadstring(game:HttpGet("https://raw.githubusercontent.com/xploitforceofficial-stack/korblox-headless-free/refs/heads/main/main.lua"))()
            ]])
        end
    end)
end
-- ============================================================

-- Mode status: "None", "Both", "Korblox", "Headless"
local CurrentMode = "None"

-- Auto Execute & Auto Both status
local AutoExecute = true
local AutoBoth = true

local R15LegParts = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}

-- 1. CORE FUNCTIONS
local function ApplyCustoms()
    local Character = Player.Character
    if not Character or CurrentMode == "None" then return end

    -- HEADLESS LOGIC
    if Character:FindFirstChild("Head") then
        if CurrentMode == "Both" or CurrentMode == "Headless" then
            Character.Head.Transparency = 1
            if Character.Head:FindFirstChild("face") then
                Character.Head.face:Destroy()
            end
        else
            Character.Head.Transparency = 0
        end
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end

    -- KORBLOX LOGIC
    if CurrentMode == "Both" or CurrentMode == "Korblox" then

        -- R6 LOGIC (POSISI DINAIKKAN, UKURAN TETAP)
        if Humanoid.RigType == Enum.HumanoidRigType.R6 then
            local RightLeg = Character:FindFirstChild("Right Leg")
            if RightLeg then
                RightLeg.Transparency = 1

                if Character:FindFirstChild("KorlessHead") then
                    Character.KorlessHead:Destroy()
                end

                local mesh = Instance.new("MeshPart")
                mesh.Name = "KorlessHead"
                mesh.Size = Vector3.new(1, 1, 1) -- Ukuran tetap dipertahankan
                mesh.CanCollide = false
                mesh.MeshId = "rbxassetid://902942096"
                mesh.TextureID = "rbxassetid://902843398"

                -- Naik sedikit tepat ke dasar jas/pinggul
                mesh.CFrame = RightLeg.CFrame * CFrame.new(0, 0.68, 0)
                mesh.Parent = Character

                local weld = Instance.new("WeldConstraint")
                weld.Part0 = RightLeg
                weld.Part1 = mesh
                weld.Parent = mesh
            end

        -- R15 LOGIC
        elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then
            for _, partName in ipairs(R15LegParts) do
                local part = Character:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end

            local UpperLeg = Character:FindFirstChild("RightUpperLeg")
            if UpperLeg and not Character:FindFirstChild("KorlessHead") then
                local mesh = Instance.new("MeshPart")
                mesh.Name = "KorlessHead"
                mesh.Size = Vector3.new(1, 1.3, 1)
                mesh.CanCollide = false
                mesh.MeshId = "rbxassetid://902942096"
                mesh.TextureID = "rbxassetid://902843398"
                mesh.CFrame = UpperLeg.CFrame * CFrame.new(0, 0.1, 0)
                mesh.Parent = Character

                local weld = Instance.new("WeldConstraint")
                weld.Part0 = UpperLeg
                weld.Part1 = mesh
                weld.Parent = mesh
            end
        end

    else
        -- KORBLOX OFF (RESTORE LEGS)
        local RightLeg = Character:FindFirstChild("Right Leg")
        if RightLeg then RightLeg.Transparency = 0 end

        for _, partName in ipairs(R15LegParts) do
            local part = Character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then part.Transparency = 0 end
        end

        if Character:FindFirstChild("KorlessHead") then
            Character.KorlessHead:Destroy()
        end
    end
end

local function RemoveAll()
    CurrentMode = "None"
    local Character = Player.Character
    if not Character then return end

    if Character:FindFirstChild("Head") then
        Character.Head.Transparency = 0
    end

    local RightLeg = Character:FindFirstChild("Right Leg")
    if RightLeg then RightLeg.Transparency = 0 end

    for _, partName in ipairs(R15LegParts) do
        local part = Character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then part.Transparency = 0 end
    end

    if Character:FindFirstChild("KorlessHead") then
        Character.KorlessHead:Destroy()
    end

    print("Korblox/Headless: OFF")
end

-- 2. HOTKEY HANDLER
local function HandleHotkey(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode

        if key == Enum.KeyCode.B then
            if CurrentMode == "Both" then
                RemoveAll()
            else
                RemoveAll()
                CurrentMode = "Both"
                ApplyCustoms()
                print("Korblox/Headless: BOTH ON")
            end

        elseif key == Enum.KeyCode.K then
            if CurrentMode == "Korblox" then
                RemoveAll()
            else
                RemoveAll()
                CurrentMode = "Korblox"
                ApplyCustoms()
                print("Korblox/Headless: KORBLOX ONLY ON")
            end

        elseif key == Enum.KeyCode.H then
            if CurrentMode == "Headless" then
                RemoveAll()
            else
                RemoveAll()
                CurrentMode = "Headless"
                ApplyCustoms()
                print("Korblox/Headless: HEADLESS ONLY ON")
            end

        elseif key == Enum.KeyCode.Equals then
            AutoExecute = not AutoExecute
            AutoBoth = AutoExecute
            print("Auto Execute & Auto Both: " .. (AutoExecute and "ON" or "OFF"))
        end
    end
end

UserInputService.InputBegan:Connect(HandleHotkey)

-- 3. PROTECTION & RESPAWN EVENTS
-- Loop proteksi agresif: mengunci tampilan tanpa mengubah mode pilihan user
RunService.RenderStepped:Connect(function()
    if CurrentMode ~= "None" then
        ApplyCustoms()
    end
end)

Player.CharacterAdded:Connect(function(char)
    local Hum = char:WaitForChild("Humanoid")
    if Hum.RigType == Enum.HumanoidRigType.R6 then
        char:WaitForChild("Right Leg")
        task.wait(0.8)
        if CurrentMode ~= "None" then
            ApplyCustoms()
        elseif AutoExecute and AutoBoth then
            CurrentMode = "Both"
            ApplyCustoms()
        end
    else
        char.ChildAdded:Connect(function()
            if CurrentMode ~= "None" then
                ApplyCustoms()
            elseif AutoExecute and AutoBoth then
                CurrentMode = "Both"
                ApplyCustoms()
            end
        end)
    end
end)

-- 4. INITIALIZE
print("Korblox/Headless Manager Loaded!")
print("Hotkeys: [B] Both | [K] Korblox Only | [H] Headless Only")
print("[=] Toggle Auto Execute & Auto Both")
print("Auto Execute & Auto Both: ON")

-- Eksekusi awal saat script dijalankan
task.spawn(function()
    task.wait(0.5)
    if Player.Character and AutoExecute and AutoBoth then
        CurrentMode = "Both"
        ApplyCustoms()
        print("Auto Both applied on execute!")
    end
end)
