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
end
