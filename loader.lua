--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║              PSALM UI LIBRARY - CIPHER.WIN TEMPLATE          ║
    ║   Source: https://raw.githubusercontent.com/Miguel2tuffallday142011/wining/refs/heads/main/loader.lua
    ╚═══════════════════════════════════════════════════════════════╝
    
    This template demonstrates all Psalm UI components:
    • Window with animated title
    • Pages (with Weapons support)
    • Weapon tabs (sub-pages with icons)
    • Sections (Left/Right sides)
    • Toggle (with Keybind/Colorpicker chaining)
    • Slider
    • List (Dropdown)
    • Textbox
    • Colorpicker
    • Keybind
    • Button
    • Divider
    • Label
    • Watermark
    • Notifications
]]--

-- ═══════════════════════════════════════════════════════════════
-- LOAD LIBRARY
-- ═══════════════════════════════════════════════════════════════
-- Add timestamp to force bypass GitHub cache
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Miguel2tuffallday142011/wining/refs/heads/main/loader.lua?cache=" .. os.time()))()

-- Set default accent color to brighter purple
Library:ChangeAccent(Color3.fromRGB(180, 120, 255))  -- Brighter purple

-- ═══════════════════════════════════════════════════════════════
-- CREATE WINDOW
-- ═══════════════════════════════════════════════════════════════
local RealColor = "#" .. Library.Accent:ToHex()

local Window = Library:Window({
    Name = 'CIPHER<font color="' .. RealColor .. '">.WIN</font>',  -- Removed spaces, will center with alignment
    Amount = 4  -- Max number of pages
})

-- ═══════════════════════════════════════════════════════════════
-- ANIMATED TITLE (Centered with dynamic .WIN color)
-- ═══════════════════════════════════════════════════════════════
local TitleElement = nil
local AnimationRunning = true

task.spawn(function()
    task.wait(0.5) -- Wait for UI to fully load
    TitleElement = Window.Elements.Base:FindFirstChild("Inline"):FindFirstChild("Title")
    if not TitleElement then
        warn("Title element not found")
        return
    end
    
    while AnimationRunning and task.wait() do
        local Name = 'CIPHER'
        local PlaceHolder = '                                        '  -- Centering spaces
        for i = 1, #Name do
            if not AnimationRunning then break end
            local Character = string.sub(Name, i, i)
            PlaceHolder = PlaceHolder .. Character
            local CurrentColor = "#" .. Library.Accent:ToHex()
            TitleElement.Text = PlaceHolder .. '<font color="' .. CurrentColor .. '">.WIN</font>'
            task.wait(0.25)
        end
        if not AnimationRunning then break end
        task.wait(3) -- Wait before restarting animation
        if TitleElement then
            TitleElement.Text = '                                        <font color="#' .. Library.Accent:ToHex() .. '">.WIN</font>'
        end
        task.wait(0.5)
    end
end)

-- Function to update .WIN color when accent changes
local function UpdateTitleColor()
    if TitleElement then
        local currentText = TitleElement.Text
        local cipherPart = currentText:match("^(.-)%<font") or currentText:match("^(.-).WIN") or ""
        TitleElement.Text = cipherPart .. '<font color="#' .. Library.Accent:ToHex() .. '">.WIN</font>'
    end
end

-- ═══════════════════════════════════════════════════════════════
-- WATERMARK
-- ═══════════════════════════════════════════════════════════════
local Watermark = Library:Watermark({Name = "CIPHER.WIN | Premium"})

-- ═══════════════════════════════════════════════════════════════
-- CONFIG SYSTEM
-- ═══════════════════════════════════════════════════════════════
local HttpService = game:GetService("HttpService")
local ConfigName = "default"

local function SaveConfig(name)
    local configData = {
        Flags = Library.Flags,
        Settings = Settings
    }
    local success, err = pcall(function()
        writefile("cipher_" .. name .. ".json", HttpService:JSONEncode(configData))
    end)
    if success then
        Library:Notification("Config '" .. name .. "' saved successfully!", 3)
    else
        Library:Notification("Failed to save config: " .. tostring(err), 5)
    end
end

local function LoadConfig(name)
    local success, err = pcall(function()
        if isfile("cipher_" .. name .. ".json") then
            local configData = HttpService:JSONDecode(readfile("cipher_" .. name .. ".json"))
            
            -- Load flags
            if configData.Flags then
                for flag, value in pairs(configData.Flags) do
                    if Library.Flags[flag] ~= nil then
                        Library.Flags[flag] = value
                    end
                end
            end
            
            -- Load settings
            if configData.Settings then
                Settings = configData.Settings
            end
            
            Library:Notification("Config '" .. name .. "' loaded successfully!", 3)
        else
            Library:Notification("Config '" .. name .. "' not found!", 3)
        end
    end)
    if not success then
        Library:Notification("Failed to load config: " .. tostring(err), 5)
    end
end

local function DeleteConfig(name)
    local success, err = pcall(function()
        if isfile("cipher_" .. name .. ".json") then
            delfile("cipher_" .. name .. ".json")
            Library:Notification("Config '" .. name .. "' deleted!", 3)
        else
            Library:Notification("Config '" .. name .. "' not found!", 3)
        end
    end)
    if not success then
        Library:Notification("Failed to delete config: " .. tostring(err), 5)
    end
end

local function ListConfigs()
    local configs = {}
    local success, err = pcall(function()
        if isfolder and listfiles then
            local files = listfiles("")
            for _, file in ipairs(files) do
                if file:match("cipher_(.+)%.json$") then
                    local name = file:match("cipher_(.+)%.json$")
                    table.insert(configs, name)
                end
            end
        end
    end)
    return configs
end

-- ═══════════════════════════════════════════════════════════════
-- STATE STORAGE
-- ═══════════════════════════════════════════════════════════════
local Settings = {
    Combat = {
        Aimbot = {
            Enabled = false,
            FOV = 100,
            Smoothness = 5,
            HitPart = "Head",
            Prediction = 0.135,
            TeamCheck = true,
            WallCheck = false,
        },
        Silent = {
            Enabled = false,
            Hitchance = 100,
        }
    },
    Visuals = {
        ESP = {
            Enabled = false,
            BoxColor = Color3.fromRGB(255, 255, 255),
        },
        Crosshair = {
            Enabled = false,
            Color = Color3.fromRGB(255, 0, 0),
        }
    },
    Misc = {
        Speed = {
            Enabled = false,
            Value = 50,
        }
    }
}

-- ═══════════════════════════════════════════════════════════════
-- CREATE PAGES
-- ═══════════════════════════════════════════════════════════════
local MainPage = Window:Page({Name = "Main", Weapons = true})
local RagePage = Window:Page({Name = "Rage", Weapons = true})
local VisualsPage = Window:Page({Name = "Visuals", Weapons = false})
local SettingsPage = Window:Page({Name = "Settings", Weapons = false})

-- ═══════════════════════════════════════════════════════════════
-- CREATE WEAPON TABS (SUB-PAGES)
-- For pages with Weapons = true, you can create weapon tabs with icons
-- You can use any rbxassetid or lucide icons
-- ═══════════════════════════════════════════════════════════════
local WeaponTab1 = MainPage:Weapon({Icon = "rbxassetid://7733920644"})   -- Crosshair icon
local WeaponTab2 = MainPage:Weapon({Icon = "rbxassetid://7743871002"})   -- Target/Aim icon  
local WeaponTab3 = RagePage:Weapon({Icon = "rbxassetid://7733920644"})   -- Shield/Defense icon

-- ═══════════════════════════════════════════════════════════════
-- MAIN PAGE - WEAPON TAB 1
-- ═══════════════════════════════════════════════════════════════

-- Section on LEFT side
local AimbotSection = WeaponTab1:Section({Name = "Aimbot", Side = "Left"})

-- Toggle with Flag
AimbotSection:Toggle({
    Name = "Enabled",
    Flag = "aimbot_enabled",
    Callback = function(value)
        Settings.Combat.Aimbot.Enabled = value
        print("Aimbot:", value)
    end
})

-- Slider
AimbotSection:Slider({
    Name = "FOV",
    Flag = "aimbot_fov",
    Min = 10,
    Max = 500,
    Default = 100,
    Suffix = " studs",
    Callback = function(value)
        Settings.Combat.Aimbot.FOV = value
    end
})

AimbotSection:Slider({
    Name = "Smoothness",
    Flag = "aimbot_smooth",
    Min = 0.1,
    Max = 10,
    Default = 5,
    Decimals = 0.1,
    Callback = function(value)
        Settings.Combat.Aimbot.Smoothness = value
    end
})

-- Textbox
AimbotSection:Textbox({
    Name = "Prediction",
    Flag = "aimbot_prediction",
    Default = "0.135",
    Callback = function(value)
        Settings.Combat.Aimbot.Prediction = tonumber(value) or 0.135
    end
})

-- List (Dropdown)
AimbotSection:List({
    Name = "Hit Part",
    Flag = "aimbot_hitpart",
    Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
    Default = "Head",
    Callback = function(value)
        Settings.Combat.Aimbot.HitPart = value
    end
})

-- Divider with Name
AimbotSection:Divider({Name = "Checks"})

-- Multiple Toggles
AimbotSection:Toggle({
    Name = "Team Check",
    Flag = "aimbot_team",
    Callback = function(value)
        Settings.Combat.Aimbot.TeamCheck = value
    end
})

AimbotSection:Toggle({
    Name = "Wall Check",
    Flag = "aimbot_wall",
    Callback = function(value)
        Settings.Combat.Aimbot.WallCheck = value
    end
})

-- Section on RIGHT side
local PredictionSection = WeaponTab1:Section({Name = "Prediction", Side = "Right"})

-- Toggle
PredictionSection:Toggle({
    Name = "Auto Prediction",
    Flag = "auto_pred",
    Callback = function(value)
        print("Auto Prediction:", value)
    end
})

-- Textbox examples
PredictionSection:Textbox({
    Name = "Horizontal (X)",
    Flag = "pred_x",
    Default = "0.1",
    Callback = function(value)
        print("Horizontal:", value)
    end
})

PredictionSection:Textbox({
    Name = "Vertical (Y)",
    Flag = "pred_y",
    Default = "0.1",
    Callback = function(value)
        print("Vertical:", value)
    end
})

-- Colorpicker standalone
PredictionSection:Colorpicker({
    Name = "Tracer Color",
    Flag = "tracer_color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        print("Color changed:", color)
    end
})

-- ═══════════════════════════════════════════════════════════════
-- MAIN PAGE - WEAPON TAB 2
-- ═══════════════════════════════════════════════════════════════

local SilentSection = WeaponTab2:Section({Name = "Silent Aim", Side = "Left"})

SilentSection:Toggle({
    Name = "Enabled",
    Flag = "silent_enabled",
    Callback = function(value)
        Settings.Combat.Silent.Enabled = value
    end
})

SilentSection:Slider({
    Name = "Hit Chance",
    Flag = "silent_hitchance",
    Min = 0,
    Max = 100,
    Default = 100,
    Suffix = "%",
    Callback = function(value)
        Settings.Combat.Silent.Hitchance = value
    end
})

-- Button example
SilentSection:Button({
    Name = "Reset Settings",
    Callback = function()
        print("Settings reset!")
        Library:Notification("Settings have been reset!", 3)
    end
})

-- Keybind standalone
SilentSection:Keybind({
    Name = "Toggle Key",
    Flag = "silent_keybind",
    Default = Enum.KeyCode.Q,
    Mode = "Toggle", -- "Toggle", "Hold", or "Always"
    Callback = function(key)
        print("Keybind changed to:", key)
    end
})

-- ═══════════════════════════════════════════════════════════════
-- VISUALS PAGE (Non-weapon page)
-- ═══════════════════════════════════════════════════════════════

local ESPSection = VisualsPage:Section({Name = "ESP", Side = "Left"})

ESPSection:Toggle({
    Name = "Enabled",
    Flag = "esp_enabled",
    Callback = function(value)
        Settings.Visuals.ESP.Enabled = value
    end
})

ESPSection:Toggle({
    Name = "Boxes",
    Flag = "esp_boxes",
    Callback = function(value)
        print("ESP Boxes:", value)
    end
})

ESPSection:Toggle({
    Name = "Names",
    Flag = "esp_names",
    Callback = function(value)
        print("ESP Names:", value)
    end
})

-- Toggle with Colorpicker chained
ESPSection:Toggle({
    Name = "Tracers",
    Flag = "esp_tracers",
    Callback = function(value)
        print("Tracers:", value)
    end
}):Colorpicker({
    Name = "Color",
    Flag = "esp_tracer_color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        print("Tracer Color:", color)
    end
})

local CrosshairSection = VisualsPage:Section({Name = "Crosshair", Side = "Right"})

-- Toggle with chained Colorpicker
CrosshairSection:Toggle({
    Name = "Enable",
    Flag = "crosshair_enabled",
    Callback = function(value)
        Settings.Visuals.Crosshair.Enabled = value
    end
}):Colorpicker({
    Name = "Color",
    Flag = "crosshair_color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        Settings.Visuals.Crosshair.Color = color
    end
})

CrosshairSection:Slider({
    Name = "Size",
    Flag = "crosshair_size",
    Min = 5,
    Max = 30,
    Default = 10,
    Callback = function(value)
        print("Crosshair Size:", value)
    end
})

CrosshairSection:List({
    Name = "Position",
    Flag = "crosshair_pos",
    Options = {"Center", "Mouse", "Target"},
    Default = "Center",
    Callback = function(value)
        print("Crosshair Position:", value)
    end
})

-- ═══════════════════════════════════════════════════════════════
-- SETTINGS PAGE
-- ═══════════════════════════════════════════════════════════════

local ConfigSection = SettingsPage:Section({Name = "Configuration", Side = "Left"})

-- Textbox for config name
ConfigSection:Textbox({
    Name = "Config Name",
    Flag = "config_name",
    Default = "default",
    Callback = function(value)
        ConfigName = value
        print("Config name set to:", value)
    end
})

ConfigSection:Button({
    Name = "Save Config",
    Callback = function()
        local name = Library.Flags["config_name"] or "default"
        SaveConfig(name)
    end
})

ConfigSection:Divider({Name = "Load/Delete"})

-- Dropdown list of existing configs
ConfigSection:List({
    Name = "Select Config",
    Flag = "config_select",
    Options = ListConfigs(),
    Default = "default",
    Callback = function(value)
        print("Selected config:", value)
    end
})

ConfigSection:Button({
    Name = "Load Selected",
    Callback = function()
        local name = Library.Flags["config_select"] or "default"
        LoadConfig(name)
    end
})

ConfigSection:Button({
    Name = "Delete Selected",
    Callback = function()
        local name = Library.Flags["config_select"] or "default"
        if name ~= "default" then
            DeleteConfig(name)
            -- Refresh the config list
            Library.Flags["config_select"] = "default"
        else
            Library:Notification("Cannot delete default config!", 3)
        end
    end
})

ConfigSection:Button({
    Name = "Refresh List",
    Callback = function()
        -- This would need to update the dropdown - notify user to reload
        Library:Notification("Restart script to see updated config list", 3)
    end
})

ConfigSection:Divider({Name = "UI Settings"})

-- Theme selector
ConfigSection:List({
    Name = "Accent Color",
    Flag = "ui_accent",
    Options = {"Purple", "Light Blue", "Sky Blue", "Blue", "Red", "Green", "Pink", "Orange", "Cyan"},
    Default = "Purple",
    Callback = function(value)
        local colors = {
            Purple = Color3.fromRGB(150, 100, 200),
            ["Light Blue"] = Color3.fromRGB(100, 200, 255),
            ["Sky Blue"] = Color3.fromRGB(135, 206, 250),
            Blue = Color3.fromRGB(48, 143, 167),
            Red = Color3.fromRGB(167, 48, 48),
            Green = Color3.fromRGB(48, 167, 48),
            Pink = Color3.fromRGB(255, 105, 180),
            Orange = Color3.fromRGB(255, 140, 0),
            Cyan = Color3.fromRGB(0, 255, 255)
        }
        if colors[value] then
            Library:ChangeAccent(colors[value])
            UpdateTitleColor()  -- Update .WIN color when accent changes
        end
    end
})

local MiscSection = SettingsPage:Section({Name = "Misc", Side = "Right"})

MiscSection:Toggle({
    Name = "Watermark",
    Flag = "watermark_enabled",
    Callback = function(value)
        if Watermark and Watermark.SetVisible then
            Watermark:SetVisible(value)
        end
    end
})

MiscSection:Button({
    Name = "Unload UI",
    Callback = function()
        AnimationRunning = false  -- Stop animation
        task.wait(0.1)
        
        -- Destroy the UI
        if Library.ScreenGUI then
            Library.ScreenGUI:Destroy()
        end
        
        Library:Notification("UI Unloaded!", 2)
    end
})

-- ═══════════════════════════════════════════════════════════════
-- CHAINING EXAMPLES
-- ═══════════════════════════════════════════════════════════════

-- You can chain Toggle with Keybind:
-- SomeSection:Toggle({...}):Keybind({...})

-- You can chain Toggle with Colorpicker:
-- SomeSection:Toggle({...}):Colorpicker({...})

-- ═══════════════════════════════════════════════════════════════
-- ACCESSING FLAGS
-- ═══════════════════════════════════════════════════════════════

--[[
    Access any flag value using Library.Flags:
    
    local aimbotEnabled = Library.Flags["aimbot_enabled"]
    local fovValue = Library.Flags["aimbot_fov"]
    local tracerColor = Library.Flags["esp_tracer_color"]
    
    This is how you read values in your main script logic!
]]--

-- ═══════════════════════════════════════════════════════════════
-- STARTUP NOTIFICATION
-- ═══════════════════════════════════════════════════════════════
Library:Notification("CIPHER.WIN loaded successfully!", 5)

print("════════════════════════════════════════════════════")
print("     CIPHER.WIN UI TEMPLATE LOADED")
print("════════════════════════════════════════════════════")
print("Pages: Main, Rage, Visuals, Settings")
print("Config System: Save/Load/Delete configs with custom names")
print("All settings stored in Settings table")
print("Access flags via: Library.Flags['flag_name']")
print("════════════════════════════════════════════════════")
