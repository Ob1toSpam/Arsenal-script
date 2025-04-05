local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "🔥 Mod Menu | Criado por ObitoSpam",
    LoadingTitle = "Carregando...",
    LoadingSubtitle = "Dev ObitoSpam",
    ConfigurationSaving = {Enabled = false}
})

-- // Criando as abas
local PvpTab = Window:CreateTab("⚔️ PvP", 4483362458)
local GunModsTab = Window:CreateTab("💥 Gun Mods", 4483362458)
local VisualTab = Window:CreateTab("👁️ Visual", 4483362458)
local OutrosTab = Window:CreateTab("📌 Outros", 4483362458)
local StatusTab = Window:CreateTab("📊Status", 7733960981)
local CreditosTab = Window:CreateTab("🎭Créditos", 4483362458) 

--// CONFIGURAÇÕES GLOBAIS
local tracerEnabled = false
local tracers = {}
local username = game.Players.LocalPlayer.Name
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
-- Criando a pasta de ESP
local Holder = Instance.new("Folder")
Holder.Name = "ESP"
Holder.Parent = game:GetService("CoreGui")

-- Aimbot
getgenv().legitAimbotEnabled = false     -- Ativa o Aimbot legítimo
getgenv().aimSmoothness = 0.15           -- Suavidade do Aimbot (quanto menor, mais "snapado")
-- Silent Aim
getgenv().silentAimEnabled = false       -- Mira silenciosa (atira automaticamente no inimigo certo)
-- Hitbox Expander
getgenv().hitboxEnabled = false          -- Expande a hitbox dos inimigos
-- Recoil e Spread
getgenv().noRecoilEnabled = false        -- Remove o recuo das armas
getgenv().noSpreadEnabled = false        -- Remove o espalhamento dos tiros
-- ESP (Visual)
getgenv().espEnabled = false       
getgenv().boxEsp = false
getgenv().healthEsp = false
getgenv().distanceEsp = false
getgenv().tracerEnabled = false
-- Checks (Verificações)
getgenv().teamCheck = true               -- Evita mirar em colegas de equipe
getgenv().wallCheck = true               -- Não mira através das paredes
--// Valores padrão
getgenv().speedValue = 16
getgenv().jumpValue = 50
getgenv().speedEnabled = false
getgenv().jumpEnabled = false
-- Variáveis globais
getgenv().chatSpamEnabled = false
getgenv().chatMessage = "ObitoSpam no comando!"
getgenv().chatDelay = 2 -- segundos
-- // Configurações
local range = 10 -- Distância para ativar a KillAura
local delay = 0.2 -- Delay entre ataques
-- Função de Spammer
task.spawn(function()
    while true do
        if getgenv().chatSpamEnabled then
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(getgenv().chatMessage, "All")
        end
        task.wait(getgenv().chatDelay)
    end
end)

-- Detecta o executor mobile mais comum
local function detectExecutor()
    if identifyexecutor then
        return identifyexecutor()
    elseif isexecutorclosure then
        return "Executor Desconhecido"
    elseif syn then
        return "Synapse X"
    elseif is_sirhurt_closure then
        return "SirHurt"
    elseif KRNL_LOADED then
        return "KRNL"
    elseif getexecutorname then
        return getexecutorname()
    elseif hookmetamethod and getmenv then
        return "Hydrogen"
    elseif get_hidden_gui or getconnections then
        return "Arceus X"
    elseif isfluxus then
        return "Fluxus"
    elseif getrenv and (not syn) and (not KRNL_LOADED) then
        return "Provável: Delta / Codex / Kitten"
    else
        return "Desconhecido"
    end
end
-- Labels de informações
-- Seção: Informações do Usuário
StatusTab:CreateLabel("=== INFORMAÇÕES DE USUÁRIO ===")
StatusTab:CreateLabel("Usuário: " .. username)
StatusTab:CreateLabel("Executor: " .. detectExecutor())
-- FPS e Ping
local fpsLabel = StatusTab:CreateLabel("FPS: ...")
local pingLabel = StatusTab:CreateLabel("Ping: ...")

task.spawn(function()
    while true do
        local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
        local pingStat = game:GetService("Stats"):FindFirstChild("Network"):FindFirstChild("Ping")
        local ping = pingStat and math.floor(pingStat.Value) or 0
        fpsLabel:Set("FPS: " .. fps)
        pingLabel:Set("Ping: " .. ping .. "ms")
        task.wait(1)
    end
end)
-- Separador visual
StatusTab:CreateLabel(" ")
-- Seção: Funções Ativadas/Desativadas
StatusTab:CreateLabel("=== ATIVOS / DESATIVADOS ===")
-- Labels principais: PvP e Visuais
local labels = {
    SilentAim = StatusTab:CreateLabel("Silent Aim: Desativado"),
    Aimbot = StatusTab:CreateLabel("Aimbot (Legit): Desativado"),
    KnifeAura = StatusTab:CreateLabel("KillAura: Desativado"),
    Hitbox = StatusTab:CreateLabel("Hitbox Expander: Desativado"),
    ESP = StatusTab:CreateLabel("ESP: Desativado"),
    Tracer = StatusTab:CreateLabel("ESP Tracer: Desativado"),
}

-- Atualizador automático de status (a cada 1 segundo)
task.spawn(function()
    while true do
        pcall(function()
            labels.SilentAim:Set("Silent Aim: " .. (getgenv().silentAimEnabled and "Ativado" or "Desativado"))
            labels.Aimbot:Set("Aimbot (Legit): " .. (getgenv().legitAimbotEnabled and "Ativado" or "Desativado"))
            labels.KnifeAura:Set("KillAura: " .. (getgenv().knifeAuraEnabled and "Ativado" or "Desativado"))
            labels.Hitbox:Set("Hitbox Expander: " .. (getgenv().hitboxEnabled and "Ativado" or "Desativado"))
            labels.ESP:Set("ESP: " .. (getgenv().espEnabled and "Ativado" or "Desativado"))
            labels.Tracer:Set("ESP Tracer: " .. (getgenv().tracerEnabled and "Ativado" or "Desativado"))
        end)
        task.wait(1)
    end
end)
-- // Funções úteis
local function isEnemy(player)
    return player and player ~= LocalPlayer and player.Team ~= LocalPlayer.Team
end

local function isKnifeEquipped()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    return tool and tool:FindFirstChild("Handle") and tool.Name:lower():find("knife")
end

-- // KillAura Loop
task.spawn(function()
    while task.wait(delay) do
        if not getgenv().knifeAuraEnabled then continue end
        if not isKnifeEquipped() then continue end

        for _, player in ipairs(Players:GetPlayers()) do
            if isEnemy(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local enemyRoot = player.Character.HumanoidRootPart
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                if myRoot and (myRoot.Position - enemyRoot.Position).Magnitude <= range then
                    -- Simula clique para atacar
                    mouse1click()
                end
            end
        end
    end
end)

--// Função para obter o Humanoid
local function getHumanoid()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return character:WaitForChild("Humanoid", 5)
end

--// Aplica as configurações
local function applySettings()
    local humanoid = getHumanoid()
    if not humanoid then return end

    if getgenv().speedEnabled then
        humanoid.WalkSpeed = getgenv().speedValue or 16
    else
        humanoid.WalkSpeed = 16
    end

    if getgenv().jumpEnabled then
        humanoid.JumpPower = getgenv().jumpValue or 50
    else
        humanoid.JumpPower = 50
    end
end

--// Aplica ao respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applySettings()
end)

-- Corrigindo a função isVisible
local function isVisible(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).unit * (targetPart.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil or result.Instance:IsDescendantOf(targetPart.Parent)
end
task.spawn(function()
    while task.wait() do
        if getgenv().legitAimbotEnabled then
            local targetPart = getClosestPlayer()
            if targetPart then
                local direction = (targetPart.Position - Camera.CFrame.Position).Unit
                local newLook = Camera.CFrame.Position + direction * 100
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, newLook), getgenv().aimSmoothness)
            end
        end
    end
end)
-- Definição das cores globais
_G.FriendColor = Color3.fromRGB(0, 0, 255)
_G.EnemyColor = Color3.fromRGB(255, 0, 0)
_G.UseTeamColor = true

-- Função para criar ESP no jogador
local function criarESP(player)
    if not player.Character then return end
    local character = player.Character

    -- Verifica se já tem ESP para evitar duplicação
    if character:FindFirstChild("ESPBox") then return end

    -- Cria um Highlight (caixa ao redor do jogador)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPBox"
    highlight.Parent = character
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0.4
    highlight.Adornee = character

    -- Cria a tag de nome (menor e mais elegante)
    local nameTag = Instance.new("BillboardGui")
    nameTag.Name = "ESPName"
    nameTag.Parent = character
    nameTag.Adornee = character:FindFirstChild("Head") or character:FindFirstChildOfClass("Part")
    nameTag.Size = UDim2.new(0, 100, 0, 20) -- Tamanho menor
    nameTag.StudsOffset = Vector3.new(0, 2, 0) -- Posição ajustada
    nameTag.AlwaysOnTop = true

    local nameLabel = Instance.new("TextLabel", nameTag)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamMedium -- Fonte mais elegante
    nameLabel.TextStrokeTransparency = 0.5 -- Contorno suave
    nameLabel.TextSize = 14 -- Texto menor

    -- Define a cor do Highlight e do nome do jogador com base no time
    if _G.UseTeamColor and player.Team then
        highlight.FillColor = player.TeamColor.Color
        nameLabel.TextColor3 = player.TeamColor.Color
    else
        highlight.FillColor = (player.Team == game.Players.LocalPlayer.Team) and _G.FriendColor or _G.EnemyColor
        nameLabel.TextColor3 = (player.Team == game.Players.LocalPlayer.Team) and _G.FriendColor or _G.EnemyColor
    end

    -- Define o nome do jogador
    nameLabel.Text = player.Name
end
-- Função para remover ESP
local function removerESP(player)
    if player.Character then
        if player.Character:FindFirstChild("ESPBox") then player.Character.ESPBox:Destroy() end
        if player.Character:FindFirstChild("ESPName") then player.Character.ESPName:Destroy() end
    end
end

-- Ativar/Desativar ESP
local function ToggleESP(enable)
    if enable then
        for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
            if v ~= game.Players.LocalPlayer then
                criarESP(v)
            end
        end

        game:GetService("Players").PlayerAdded:Connect(function(v)
            task.wait(2) -- Espera o jogador carregar
            criarESP(v)
        end)

        game:GetService("Players").PlayerRemoving:Connect(removerESP)
    else
        for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
            removerESP(v)
        end
    end
end

local function createTracer(player)
    if player == Players.LocalPlayer then return end
    if tracers[player] then return end

    local tracer = Drawing.new("Line")
    tracer.Thickness = 2
    tracer.Transparency = 1
    tracer.Color = Color3.fromRGB(255, 0, 0) -- padrão vermelho
    tracer.Visible = false

    tracers[player] = tracer
end

local function updateTracers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == Players.LocalPlayer then continue end

        if getgenv().teamCheck and player.Team == Players.LocalPlayer.Team then
            if tracers[player] then tracers[player].Visible = false end
            continue
        end

        if not tracers[player] then
            createTracer(player)
        end

        local tracer = tracers[player]
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)

            if onScreen and getgenv().tracerEnabled then
                tracer.Visible = true
                tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                tracer.Color = player.Team == Players.LocalPlayer.Team and Color3.fromRGB(0, 0, 255) or Color3.fromRGB(255, 0, 0)
            else
                tracer.Visible = false
            end
        else
            tracer.Visible = false
        end
    end
end

local function enableTracer()
    getgenv().tracerEnabled = true
    for _, player in ipairs(Players:GetPlayers()) do
        createTracer(player)
    end

    if not tracerConnection then
        tracerConnection = RunService.RenderStepped:Connect(updateTracers)
    end
end

local function disableTracer()
    getgenv().tracerEnabled = false
    if tracerConnection then
        tracerConnection:Disconnect()
        tracerConnection = nil
    end

    for _, tracer in pairs(tracers) do
        if tracer then tracer:Remove() end
    end
    tracers = {}
end

-- Limpa ESP anterior

--// Legit Aimbot Compatível com Mobile
local function getClosestPlayer()
    local closestHead = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        -- Ignora o jogador local e verifica se o player tem cabeça
        if player == LocalPlayer then continue end
        if getgenv().teamCheck and player.Team == LocalPlayer.Team then continue end

        local character = player.Character
        local head = character and character:FindFirstChild("Head")
        if not head then continue end

        -- Converte posição da cabeça para coordenadas de tela
        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
        if not onScreen then continue end

        -- Calcula a distância do centro da tela até a cabeça do inimigo
        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Camera.ViewportSize / 2).Magnitude
        if distance < shortestDistance then
            shortestDistance = distance
            closestHead = head
        end
    end

    return closestHead
end
--// Função para obter o inimigo mais próximo do centro da tela
local function getTarget()
    local closestDistance = 150
    local closestHitPart = nil

    for _, player in ipairs(Players:GetPlayers()) do
        -- Ignora o jogador local
        if player == LocalPlayer then continue end

        -- Verificação de equipe
        if getgenv().teamCheck and player.Team == LocalPlayer.Team then continue end

        -- Verifica se o jogador possui um personagem com cabeça
        local character = player.Character
        if not character or not character:FindFirstChild("Head") then continue end

        local hitPart = character.Head

        -- Verifica se a cabeça está visível (sem parede na frente)
        if getgenv().wallCheck and not isVisible(hitPart) then continue end

        -- Converte posição 3D em 2D na tela
        local screenPosition = Camera:WorldToViewportPoint(hitPart.Position)
        if screenPosition.Z < 0 then continue end

        -- Calcula a distância do centro da tela
        local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - Camera.ViewportSize / 2).Magnitude

        -- Se for o mais próximo até agora, atualiza
        if distance < closestDistance then
            closestDistance = distance
            closestHitPart = hitPart
        end
    end

    return closestHitPart
end

--// Hook para modificar o comportamento do Silent Aim
local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
    -- Silent Aim: redireciona o tiro para o inimigo mais próximo do centro
    if getgenv().silentAimEnabled and self == Camera and index == "CoordinateFrame" then
        local hitPart = getTarget()
        if hitPart then
            return CFrame.new(Camera.CFrame.Position, hitPart.Position)
        end
    end

    return oldIndex(self, index)
end))
-- Toggle no menu
VisualTab:CreateToggle({
    Name = "Ativar ESP Tracer",
    CurrentValue = false,
    Callback = function(state)
        pcall(function()
            if state then
                enableTracer()
            else
                disableTracer()
            end
        end)
    end
})

-- Botão no Menu
VisualTab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Callback = function(state)
        getgenv().espEnabled = state
        ToggleESP(state)
    end
})
PvpTab:CreateToggle({
    Name = "Ativar Silent Aim",
    CurrentValue = false,
    Callback = function(state)
        getgenv().silentAimEnabled = state
        Rayfield:Notify({
            Title = "Silent Aim",
            Content = state and "Ativado!" or "Desativado!",
            Duration = 2
        })
    end
})

PvpTab:CreateToggle({
    Name = "Ativar Team Check",
    CurrentValue = true,
    Callback = function(state)
        getgenv().teamCheck = state
    end
})


-- // GUN MODS ATUALIZADOS

GunModsTab:CreateToggle({
    Name = "Munição Infinita",
    CurrentValue = false,
    Callback = function(state)
        for _, weapon in pairs(game:GetService("ReplicatedStorage").Weapons:GetChildren()) do
            if weapon:FindFirstChild("Ammo") then
                weapon.Ammo.Changed:Connect(function()
                    if state then weapon.Ammo.Value = 999 end
                end)
                weapon.Ammo.Value = state and 999 or 30 -- Define o valor inicial
            end
        end
    end
})

GunModsTab:CreateToggle({
    Name = "Recarregar Instantaneamente",
    CurrentValue = false,
    Callback = function(state)
        getgenv().instantReloadEnabled = state
        for _, weapon in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
            if weapon:IsA("NumberValue") and weapon.Name == "ReloadTime" then
                weapon.Value = state and 0 or 1.5 -- Define tempo de recarga para instantâneo ou normal
            end
        end
    end
})
GunModsTab:CreateToggle({
    Name = "Sem Recuo",
    CurrentValue = false,
    Callback = function(state)
        for _, weapon in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
            if weapon:IsA("NumberValue") and (weapon.Name:match("Recoil")) then
                weapon.Value = state and 0 or 1
            end
        end
    end
})
GunModsTab:CreateToggle({
    Name = "Sem Spread",
    CurrentValue = false,
    Callback = function(state)
        for _, weapon in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
            if weapon:IsA("NumberValue") and weapon.Name:match("Spread") then
                weapon.Value = state and 0 or 1
            end
        end
    end
})
GunModsTab:CreateToggle({
    Name = "Tiro Rápido",
    CurrentValue = false,
    Callback = function(state)
        for _, weapon in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
            if weapon:IsA("NumberValue") and weapon.Name == "FireRate" then
                weapon.Value = state and 0.05 or 1 -- Diminui o tempo entre tiros
            end
        end
    end
})
GunModsTab:CreateToggle({
    Name = "Wall Bang (Atravessa paredes)",
    CurrentValue = false,
    Callback = function(state)
        for _, weapon in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
            if weapon:IsA("BoolValue") and weapon.Name == "CanPenetrate" then
                weapon.Value = state
            end
        end
    end
})
-- Aimbot (Legit)
PvpTab:CreateToggle({
    Name = "Aimbot (Legit)",
    CurrentValue = false,
    Callback = function(state)
        getgenv().legitAimbotEnabled = state

        Rayfield:Notify({
            Title = "Aimbot (Legit)",
            Content = state and "Aimbot suave ativado!" or "Aimbot desativado.",
            Duration = 3,
            Image = "rbxassetid://7734068321" -- Ícone opcional
        })
    end
})
PvpTab:CreateToggle({
    Name = "Knife KillAura",
    CurrentValue = false,
    Callback = function(state)
        getgenv().knifeAuraEnabled = state
        Rayfield:Notify({
            Title = "KillAura",
            Content = state and "Auto faca ativado!" or "Auto faca desativado.",
            Duration = 2
        })
    end
})
-- Hitbox Expander
PvpTab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Callback = function(state)
        getgenv().hitboxEnabled = state

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hitbox = player.Character:FindFirstChild("HumanoidRootPart")

                -- Segurança extra: só aplica se não for nulo
                if hitbox then
                    hitbox.Size = state and Vector3.new(10, 10, 10) or Vector3.new(2, 2, 1)
                    hitbox.Transparency = state and 0.6 or 1
                    hitbox.Material = state and Enum.Material.ForceField or Enum.Material.Plastic
                    hitbox.Color = state and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
                end
            end
        end

        Rayfield:Notify({
            Title = "Hitbox",
            Content = state and "Hitbox expandido nos inimigos!" or "Hitbox normalizado.",
            Duration = 3,
            Image = "rbxassetid://7734077854"
        })
    end
})

-- Menu do Spammer
OutrosTab:CreateToggle({
    Name = "Ativar Chat Spammer",
    CurrentValue = false,
    Callback = function(state)
        getgenv().chatSpamEnabled = state
        Rayfield:Notify({
            Title = "Chat Spammer",
            Content = state and "Spammer ativado!" or "Spammer desativado.",
            Duration = 2
        })
    end
})

OutrosTab:CreateInput({
    Name = "Mensagem para Spammar",
    PlaceholderText = "Digite sua mensagem...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        getgenv().chatMessage = text
    end
})

OutrosTab:CreateSlider({
    Name = "Delay entre mensagens (segundos)",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 2,
    Callback = function(value)
        getgenv().chatDelay = value
    end
})
--// Toggle: Speed Hack
OutrosTab:CreateToggle({
    Name = "Ativar Speed Hack",
    CurrentValue = false,
    Callback = function(state)
        getgenv().speedEnabled = state
        applySettings()
    end
})

--// Slider: Velocidade
OutrosTab:CreateSlider({
    Name = "Velocidade",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        getgenv().speedValue = value
        if getgenv().speedEnabled then applySettings() end
    end
})

--// Toggle: Super Pulo
OutrosTab:CreateToggle({
    Name = "Ativar Super Pulo",
    CurrentValue = false,
    Callback = function(state)
        getgenv().jumpEnabled = state
        applySettings()
    end
})

--// Slider: Altura do Pulo
OutrosTab:CreateSlider({
    Name = "Altura do Pulo",
    Range = {50, 200},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(value)
        getgenv().jumpValue = value
        if getgenv().jumpEnabled then applySettings() end
    end
})

OutrosTab:CreateToggle({
    Name = "Ativar No Clip",
    CurrentValue = false,
    Callback = function(state)
        getgenv().noClipEnabled = state
        task.spawn(function()
            while getgenv().noClipEnabled do
                for _, part in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                task.wait()
            end
        end)
    end
})

OutrosTab:CreateToggle({
    Name = "Ativar Anti-AFK",
    CurrentValue = true,
    Callback = function(state)
        getgenv().antiAfkEnabled = state
        if state then
            task.spawn(function()
                local VirtualUser = game:GetService("VirtualUser")
                local Player = game:GetService("Players").LocalPlayer

                while getgenv().antiAfkEnabled do
                    -- Simula movimentação e interação a cada 30 segundos
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new()) 
                    Player.Character:Move(Vector3.new(0, 0, 0.1), true)

                    task.wait(30) -- Aguarda 30 segundos antes de repetir
                end
            end)
        end
    end
})
CreditosTab:CreateLabel("Script criado por: ObitoSpam")
CreditosTab:CreateLabel("YouTube: @obitospam")
CreditosTab:CreateLabel("Versão: 1.0")
CreditosTab:CreateLabel("Do Not Remove Credits⚠️")

CreditosTab:CreateButton({
    Name = "Copiar YouTube",
    Callback = function()
        setclipboard("https://youtube.com/@obitospam")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Créditos",
            Text = "Link do YouTube copiado!",
            Duration = 3
        })
    end
})

Rayfield:LoadConfiguration()