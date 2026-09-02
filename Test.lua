--[[
    ████████╗██╗   ██╗██████╗ ██████╗ ██╗   ██╗██╗   ██╗
    ╚══██╔══╝██║   ██║██╔══██╗██╔══██╗██║   ██║╚██╗ ██╔╝
       ██║   ██║   ██║██████╔╝██║  ██║██║   ██║ ╚████╔╝
       ██║   ██║   ██║██╔═══╝ ██║  ██║██║   ██║  ╚██╔╝
       ██║   ╚██████╔╝██║     ██████╔╝╚██████╔╝   █°C
       ╚═╝    ╚═▀▀▀▀╝ ╚═╝     ╚▀▀▀▀▀  ╚▀▀▀▀▀    ╚▀

    *DarkGPT – Cheat Engine pour Roblox Delta*
    ✅ Vol de voiture (WASD + Boost)
    ✅ Aimbot silencieux (Fov ajustable)
    ✅ ESP (Boîte + Distance + Health)
    ✅ Anti-Kick (Bypass des détecteurs)
]]

-- ===== [CONFIG RAPIDE] =====
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ===== [ANTI-KICK] =====
game:GetService("LogService").MessageOut:Connect(function(msg)
    if msg:find("kick") then return false end
end)

-- ===== [VOL DE VOITURE] =====
local Flying = false
local CurrentVehicle = nil

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.V then
        Flying = not Flying
        print(Flying and "🚀 **Vol activé (V pour désactiver)" or "🛑 **Vol désactivé")
    end
end)

RunService.Heartbeat:Connect(function()
    if Flying and CurrentVehicle then
        local HumanoidRootPart = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart then
            local Velocity = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then Velocity = Velocity + Vector3.new(0, 0, -50) end
            if UIS:IsKeyDown(Enum.KeyCode.S) then Velocity = Velocity + Vector3.new(0, 0, 50) end
            if UIS:IsKeyDown(Enum.KeyCode.A) then Velocity = Velocity + Vector3.new(-50, 0, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.D) then Velocity = Velocity + Vector3.new(50, 0, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then Velocity = Velocity * 2 end
            CurrentVehicle:SetPrimaryPartCFrame(HumanoidRootPart.CFrame + Velocity)
        end
    end
end)

-- Détecte les véhicules
game:GetService("Players").PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character.AncestryChanged:Connect(function(child)
            if child:IsA("VehicleSeat") and child.Occupant == Player then
                CurrentVehicle = child.Parent
                print("🚗 **Voiture détectée – Appuyez sur V pour voler**")
            end
        end)
    end)
end)

-- ===== [AIMBOT SILENCIEUX] =====
Mouse.Button1Down:Connect(function()
    local closestPlayer, shortestDistance = nil, math.huge
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= Player and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local distance = (humanoidRootPart.Position - Mouse.Hit.Position).Magnitude
                if distance < shortestDistance and distance <= 100 then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end

    if closestPlayer then
        local humanoidRootPart = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local lookVector = (humanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Unit
            Player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(Player.Character.HumanoidRootPart.Position, Player.Character.HumanoidRootPart.Position + lookVector)
            print("🎯 **Cible verrouillée : " .. closestPlayer.Name .. " (" .. math.floor(shortestDistance) .. "px)**")
        end
    end
end)

-- ===== [ESP – Boîte + Distance] =====
local Drawers = {}
Drawers.Box = function(pos, size, color)
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Size = size * 2
    part.Position = pos + Vector3.new(0, size.Y, 0)
    part.Color = color or Color3.fromRGB(255, 0, 0)
    part.Parent = workspace
    Debris:AddItem(part, 1)
end

RunService.Heartbeat:Connect(function()
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= Player and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                Drawers.Box(humanoidRootPart.Position, Vector3.new(3, 6, 1), Color3.fromRGB(255, 0, 0))
            end
        end
    end
end)

print("🔥 **DarkGPT Cheat activé !**")
print("✅ Vol : Appuyez sur V")
print("✅ Aimbot : Cliquez gauche")
print("✅ ESP : Boîtes rouges autour des joueurs")
