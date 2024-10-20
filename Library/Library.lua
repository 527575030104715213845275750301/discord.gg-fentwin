
--[[

could also save it in your workspace and do
local library = loadfile(library.lua)
--]]
local Library

do 
    local UIs = game:GetService("UserInputService")
    local Rs = game:GetService("RunService")
    local Hs = game:GetService("HttpService")
    local Plrs = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local Ts = game:GetService("TweenService")

    local LPlr = Plrs.LocalPlayer
    local Mouse = LPlr:GetMouse()

    Library = {
        Accent = Color3.fromRGB(255, 131, 168);  -- edit as u like 
        CustomMouse  = true;
        UIKey = Enum.KeyCode.End; -- edit as u like  
        UseBlur = true;-- edit as u like  

        Open = true;  -- ignore  
        TabAmount = {}; -- ignore 
        Tabs = {}; -- ignore 
        Sections = {}; -- ignore 
        Flags = {};
        UnNamedFlags = 0; -- ignore 
        Holder = nil; -- ignore 
        dragging = false, -- ignore 

        Keys = {-- edit as u like  
            [Enum.KeyCode.LeftShift] = "LShift",
            [Enum.KeyCode.RightShift] = "RShift",
            [Enum.KeyCode.LeftControl] = "LCtrl",
            [Enum.KeyCode.RightControl] = "RCtrl",
            [Enum.KeyCode.LeftAlt] = "LAlt",
            [Enum.KeyCode.RightAlt] = "RAlt",
            [Enum.KeyCode.CapsLock] = "Caps",
            [Enum.KeyCode.One] = "1",
            [Enum.KeyCode.Two] = "2",
            [Enum.KeyCode.Three] = "3",
            [Enum.KeyCode.Four] = "4",
            [Enum.KeyCode.Five] = "5",
            [Enum.KeyCode.Six] = "6",
            [Enum.KeyCode.Seven] = "7",
            [Enum.KeyCode.Eight] = "8",
            [Enum.KeyCode.Nine] = "9",
            [Enum.KeyCode.Zero] = "0",
            [Enum.KeyCode.KeypadOne] = "Num1",
            [Enum.KeyCode.KeypadTwo] = "Num2",
            [Enum.KeyCode.KeypadThree] = "Num3",
            [Enum.KeyCode.KeypadFour] = "Num4",
            [Enum.KeyCode.KeypadFive] = "Num5",
            [Enum.KeyCode.KeypadSix] = "Num6",
            [Enum.KeyCode.KeypadSeven] = "Num7",
            [Enum.KeyCode.KeypadEight] = "Num8",
            [Enum.KeyCode.KeypadNine] = "Num9",
            [Enum.KeyCode.KeypadZero] = "Num0",
            [Enum.KeyCode.Minus] = "-",
            [Enum.KeyCode.Equals] = "=",
            [Enum.KeyCode.Tilde] = "~",
            [Enum.KeyCode.LeftBracket] = "[",
            [Enum.KeyCode.RightBracket] = "]",
            [Enum.KeyCode.RightParenthesis] = ")",
            [Enum.KeyCode.LeftParenthesis] = "(",
            [Enum.KeyCode.Semicolon] = ",",
            [Enum.KeyCode.Quote] = "'",
            [Enum.KeyCode.BackSlash] = "\\",
            [Enum.KeyCode.Comma] = ",",
            [Enum.KeyCode.Period] = ".",
            [Enum.KeyCode.Slash] = "/",
            [Enum.KeyCode.Asterisk] = "*",
            [Enum.KeyCode.Plus] = "+",
            [Enum.KeyCode.Period] = ".",
            [Enum.KeyCode.Backquote] = "`",
            [Enum.UserInputType.MouseButton1] = "MB1",
            [Enum.UserInputType.MouseButton2] = "MB2",
            [Enum.UserInputType.MouseButton3] = "MB3"
        };
        Connections = {};
        KeyList = nil;
        Notifs = 0;
        Blur = nil; -- ignore 
        MainFrame = nil; -- ignore
    }

    do 
        local mouselib = { -- mouse lib made by  samet.exe
            objects = {
                v2new = Vector2.new; 
                draw = Drawing.new;
            }
        };

        local user_input_service = game:GetService("UserInputService");
        local runservice = game:GetService("RunService");

        function mouselib:draw(class,properties)
            local drawing = mouselib.objects.draw(class);

            for property, value in properties do
                drawing[property] = value;
            end

            return drawing
        end

        function mouselib:create(props)
            user_input_service.MouseIconEnabled = false
            local mouse = {
                color = props.Color or Color3.fromRGB(255,255,255);
                outline = props.OutlineColor or Color3.fromRGB(0,0,0);
            }

            local triangleoutline = mouselib:draw("Triangle", {
                Thickness = 1;
                Filled = false;
                Color = mouse.outline;
                Visible = true;
            });

            local triangleinline = mouselib:draw("Triangle", {
                Thickness = 1;
                Filled = true;
                Color = mouse.color;
                Visible = true;
            })

            do
                runservice.Heartbeat:Connect(function()
                    local position = user_input_service:GetMouseLocation();

                    triangleinline.PointA = mouselib.objects.v2new(position.X, position.Y);
                    triangleinline.PointB = mouselib.objects.v2new(position.X + 14, position.Y + 6);
                    triangleinline.PointC = mouselib.objects.v2new(position.X + 6, position.Y + 14);

                    triangleoutline.PointA = triangleinline.PointA
                    triangleoutline.PointB = triangleinline.PointB
                    triangleoutline.PointC = triangleinline.PointC

                    runservice.RenderStepped:Wait()
                end);
            end;

            function mouselib:setvisiblity(v)
                triangleoutline.Visible = v;
                triangleinline.Visible = v;
            end

            return mouselib
        end

        local mouse = mouselib:create({Color = Color3.fromRGB(255,255,255), OutlineColor = Color3.fromRGB(0,0,0)})
        mouse:setvisiblity(false)
        if Library.CustomMouse then
            mouse:setvisiblity(true)
            UIs.MouseIconEnabled = false
        end

        local Pages = Library.Tabs;
        local Sections = Library.Sections;

        if isfile("minecraftia.font") then
            delfile("minecraftia.font");
        end
        
        if not isfile("minecraftiaregular.ttf") then
            writefile("minecraftiaregular.ttf", game:HttpGet("https://github.com/epicdude99/ui_testing/raw/refs/heads/main/minecraftia.ttf"));
        end
        
        function Library:Round(number,float)
            return float * math.floor(number / float)
        end

        function Library:Connect(signal, callback)
            local Con = signal:Connect(callback)
            table.insert(Library.Connections, Con)
            return Con
        end

        function Library:Disconnect(signal)
            signal:Disconnect()
            table.remove(Library.Connections, table.find(Library.Connections, signal))
        end

        function Library:NextFlag()
            Library.UnNamedFlags += 1
            return string.format("%.19g", Library.UnNamedFlags)
        end

        function Library:SetOpen(bool)
            Library.Open = bool 
            if Library.Open then
                Library.MainFrame.Visible = true
                if Library.CustomMouse then
                    mouse:setvisiblity(true)
                end
                UIs.MouseIconEnabled = false
                if Library.UseBlur then 
                Ts:Create(Library.Blur, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = 56;}):Play()
                end
            else
                Library.MainFrame.Visible = false
                if Library.CustomMouse then
                    mouse:setvisiblity(false)
                end
                UIs.MouseIconEnabled = true
                if Library.UseBlur then 
                    Ts:Create(Library.Blur, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = 0;}):Play()
                end
            end
        end

        function Library:Unload()
            for _, con in Library.Connections do
                if con then
                    con:Disconnect()
                end
            end

            if Library.Holder then
                Library.Holder:Destroy()
            end
        end

        function Library:UpdateNotificationPositions(position)
            local i = Library.Notifs
             local Position = Vector2.new(20, 0)
             return UDim2.new(0,Position.X,0,Position.Y + (i * 25))
         end         
        
        do
            getsynasset = getcustomasset or getsynasset
            Font = setreadonly(Font, false);
            function Font:Register(Name, Weight, Style, Asset)
                if not isfile(Name .. ".font") then
                    if not isfile(Asset.Id) then
                        writefile(Asset.Id, Asset.Font);
                    end;
                    --
                    local Data = {
                        name = Name,
                        faces = {{
                            name = "Regular",
                            weight = Weight,
                            style = Style,
                            assetId = getsynasset(Asset.Id);
                        }}
                    };
                    --
                    writefile(Name .. ".font", Hs:JSONEncode(Data));
                    return getsynasset(Name .. ".font");
                else 
                    warn("Font already registered");
                end;
            end;
            --
            function Font:GetRegistry(Name)
                if isfile(Name .. ".font") then
                    return getsynasset(Name .. ".font");
                end;
            end;
        
            Font:Register("minecraftia", 400, "normal", {Id = "minecraftia.ttf", Font = ""});
        end
        
        local realfont = Font.new(Font:GetRegistry("minecraftia"));

        Library.__index = Library
        Library.Tabs.__index = Library.Tabs 
        Library.Sections.__index = Library.Sections

        local instance = {objects = {}}
        function instance.new(class, properties)
            local inst = Instance.new(class);

            for property, value in next, properties do
                inst[property] = value;
            end
            
            table.insert(instance.objects, inst);
            return inst;
        end
        
        local screenGUI = instance.new("ScreenGui", {
            Parent = Rs:IsStudio() and LPlr.PlayerGui or game:GetService("CoreGui");
            ZIndexBehavior = Enum.ZIndexBehavior.Global;
            ResetOnSpawn = false;
        })

        local BlurEffect = instance.new("BlurEffect", {
            Parent = Lighting;
            Enabled = true;
            Size = 0;
        })

        Library.Blur = BlurEffect
        Library.Holder = screenGUI;

        function Library:KeyList()
            local Nkeylist = {};
            Library.KeyList = Nkeylist

            local keybindlist = instance.new("Frame", {
                Name = "keybindlist";
                Parent = Library.Holder;
                AnchorPoint = Vector2.new(0, 0.5);
                BackgroundColor3 = Color3.fromRGB(21, 21, 21);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 2;
                Position = UDim2.new(0, 20, 0.5, 0);
                Size = UDim2.new(0, 0, 0, 18);
                AutomaticSize = Enum.AutomaticSize.XY
            })
            
            local value = instance.new("TextLabel", {
                Name = "value";
                Parent = keybindlist;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 4, 0, 0);
                Size = UDim2.new(0, 100, 0, 20);
                FontFace = realfont;
                Text = "Keybinds";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            
            local accent = instance.new("Frame", {
                Name = "accent";
                Parent = keybindlist;
                BackgroundColor3 = Library.Accent;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 6, 0, 1);
            })
            
            local content = instance.new("Frame", {
                Name = "content";
                Parent = keybindlist;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 10, 0, 20);
                Size = UDim2.new(0, 100, 0, 0);
                AutomaticSize = Enum.AutomaticSize.XY
            })
            local uistroke2 = instance.new("UIStroke", {
                Parent = keybindlist,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(0,0,0)
            })
            
            
            local UIListLayout = instance.new("UIListLayout", {
                Parent = content;
                SortOrder = Enum.SortOrder.LayoutOrder;
            })

            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(17, 17, 17))};
                Rotation = 90;
                Parent = keybindlist;
            })

            function Nkeylist:SetVisibility(v)
                keybindlist.Visible = v
            end

            function Nkeylist:NewKey(Name, Key)
                local NewKey = {}

                local newkey = instance.new("TextLabel", {
                    Name = "newkey";
                    Parent = content;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = UDim2.new(0, 100, 0, 20);
                    FontFace = realfont;
                    Text = `{Name}: [{Key}]`;
                    TextColor3 = Library.Accent;
                    TextSize = 10.000;
                    TextStrokeTransparency = 0.000;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    Visible = false;
                    TextTransparency = 1
                })

                function NewKey:SetVisible(v)
                    newkey.Visible = v
                    Ts:Create(newkey, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = v and 0 or 1}):Play()
                end

                function NewKey:SetKey(a,v)
                    newkey.Text = `{a}: [{v}]`
                end

                return NewKey
            end

            return Nkeylist
        end

        function Library:Watermark(Name, Size)
            local watermark = instance.new("Frame", {
                Name = "watermark";
                Parent = Library.Holder;
                BackgroundColor3 = Color3.fromRGB(35, 35, 35);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 2;
                Position = UDim2.new(0, 25, 0, 0);
                Size = UDim2.new(0, Size, 0, 20);
            })

            local uistroke2 = instance.new("UIStroke", {
                Parent = watermark,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(0,0,0)
            })
            
            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(143, 143, 143))};
                Rotation = 90;
                Parent = watermark;
            })
            
            local text = instance.new("TextLabel", {
                Name = "text";
                Parent = watermark;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 5, 0, 0);
                Size = UDim2.new(1, 0, 1, 0);
                FontFace = realfont;
                Text = Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            
            local liner = instance.new("Frame", {
                Name = "liner";
                Parent = watermark;
                BackgroundColor3 = Library.Accent;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 1);
            })
        end

        function Library:Notification(options)
            local Notification = {
                Name = options.Name or options.name or 'Notification',
                Duration = options.Duration or options.duration or 3,
                Color = options.color or options.Color or self.Accent
            }
        
            Library.Notifs += 1
        
            local notification = instance.new("Frame", {
                Name = "notification";
                Parent = Library.Holder;
                BackgroundColor3 = Color3.fromRGB(30, 30, 30);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 2;
                Position = UDim2.new(0, 11, 0, 5);
                AutomaticSize = Enum.AutomaticSize.XY;
                BackgroundTransparency = 1
            })
        
            local UIStroke1 = instance.new("UIStroke", {
                Parent = notification,
                Color = Color3.fromRGB(35,35,35),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Transparency = 1
            })
        
            local notificationtitle = instance.new("TextLabel", {
                Name = "text";
                Parent = notification;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 5, 0, 0);
                Size = UDim2.new(0, 0, 0, 17);
                FontFace =realfont;
                Text = Notification.Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextWrapped = true;
                TextXAlignment = Enum.TextXAlignment.Left;
                AutomaticSize = Enum.AutomaticSize.X;
                TextTransparency = 1
            })
        
            notification.Size = UDim2.new(0, notification.Size.X.Offset + notificationtitle.TextBounds.X + 25, 0 ,0)
        
            local Accent = instance.new("Frame", {
                Name = "liner";
                Parent = notification;
                BackgroundColor3 = Notification.Color;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(0, 0, 0, 1);
                BackgroundTransparency = 1
            })
        
            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(143, 143, 143))};
                Rotation = 90;
                Parent = notification;
            })
        
            task.spawn(function()
                local tween1 = game:GetService("TweenService"):Create(notification, TweenInfo.new(0.41, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0})
                local tween2 = game:GetService("TweenService"):Create(UIStroke1, TweenInfo.new(0.41, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0})
                tween1:Play()
                tween2:Play()
                tween2.Completed:Wait()
                task.wait(0.3)
                Accent.BackgroundTransparency = 0
                task.wait(0.1)
                local tween3 = game:GetService("TweenService"):Create(Accent, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(1,0,0,1)})
                tween3:Play()
                tween3.Completed:Wait()
                local tween4 = game:GetService("TweenService"):Create(notificationtitle, TweenInfo.new(0.41, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 0})
                tween4:Play()
        
                task.delay(Notification.Duration, function()
                    local tween14 = game:GetService("TweenService"):Create(notificationtitle, TweenInfo.new(0.41, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 1})
                    tween14:Play()
                    tween14.Completed:Wait()
                    local tween344 = game:GetService("TweenService"):Create(Accent, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0,0,0,1)})
                    task.wait(0.1)
                    tween344:Play()
                    tween344.Completed:Wait()
                    task.wait(0.3)
                    local tween144 = game:GetService("TweenService"):Create(notification, TweenInfo.new(0.41, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 1})
                    local tween244 = game:GetService("TweenService"):Create(UIStroke1, TweenInfo.new(0.41, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 1})
                    tween144:Play()
                    tween144.Completed:Wait()
                    tween244:Play()
                    --
                    notification:Destroy()
                end)
            end)
        
            local pos = Vector2.new(20, 0)
            notification.Position = Library:UpdateNotificationPositions(pos)
        end

        function Library:Window(Options)
            if Library.UseBlur then
            Ts:Create(Library.Blur, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = 56;}):Play()
            end
            local Window = {
                Name = Options.Name or Options.name or 'Window';
                Properties = {};
            };

            local mainframe = instance.new("Frame", {
                Name = "mainframe";
                Parent = Library.Holder;
                AnchorPoint = Vector2.new(0.5, 0.5);
                BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 2;
                Position = UDim2.new(0.5, 0, 0.5, 0);
                Size = UDim2.new(0, 671, 0, 494);
            })

            Library.MainFrame = mainframe;

            local uistroke = instance.new("UIStroke", {
                Parent = mainframe,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Accent
            })

            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(17, 17, 17))};
                Rotation = 90;
                Parent = mainframe;
            })

            local title = instance.new("TextLabel", {
                Name = "title";
                Parent = mainframe;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 5, 0, 0);
                Size = UDim2.new(1, 0, 0, 20);
                FontFace = realfont;
                Text = Window.Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })

            local inline = instance.new("Frame", {
                Name = "inline";
                Parent = mainframe;
                BackgroundColor3 = Color3.fromRGB(17, 17, 17);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 5, 0, 52);
                Size = UDim2.new(1, -10, 1, -57);
            })

            local uistroke2 = instance.new("UIStroke", {
                Parent = inline,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(34,34,34)
            })
            
            local content = instance.new("Frame", {
                Name = "content";
                Parent = inline;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 0, 0, 3);
                Size = UDim2.new(1, 0, 1, -3);
            })

            local dropshadow = instance.new("ImageLabel", {
                Name = "dropshadow";
                Parent = mainframe;
                AnchorPoint = Vector2.new(0.5, 0.5);
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0.487084478, 0, 0.488945603, 0);
                Size = UDim2.new(1.09587288, 0, 1.09693885, 0);
                Image = "rbxassetid://103305741565784";
            })
            
            local tabholder = instance.new("Frame", {
                Name = "tab holder";
                Parent = mainframe;
                BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 5, 0, 21);
                Size = UDim2.new(1, -10, 0, 25);
            })
            
            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(149, 149, 149))};
                Rotation = 90;
                Parent = tabholder;
            })
            
            local realholder = instance.new("Frame", {
                Name = "realholder";
                Parent = tabholder;
                AnchorPoint = Vector2.new(0, 0.5);
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 5, 0.5, 0);
                Size = UDim2.new(1, -10, 1, -5);
            })
            
            local UIListLayout = instance.new("UIListLayout", {
                Parent = realholder;
                FillDirection = Enum.FillDirection.Horizontal;
                SortOrder = Enum.SortOrder.LayoutOrder;
                VerticalAlignment = Enum.VerticalAlignment.Center;
                HorizontalFlex = Enum.UIFlexAlignment.Fill;
                Padding = UDim.new(0, 4);
            })

            local uistroke3 = instance.new("UIStroke", {
                Parent = tabholder,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(34,34,34)
            })

            do
                Window.Properties = {
                    Content = content;
                    Tabs = realholder;
                }

                UIs.InputBegan:Connect(function(input,gpe)
                    if not gpe then
                        if input.KeyCode == Library.UIKey then
                            Library:SetOpen(not Library.Open)
                        end
                    end
                end)

                local gui = mainframe
                local dragInput, dragStart, startPos
            
                local function update(input)
                    local delta = input.Position - dragStart
                    gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            
                gui.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Library.dragging = true
                        dragStart = input.Position
                        startPos = gui.Position
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                Library.dragging = false
                            end
                        end)
                    end
                end)
            
                gui.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        dragInput = input
                    end
                end)
            
                UIs.InputChanged:Connect(function(input)
                    if input == dragInput and Library.dragging then
                        update(input)
                    end
                end)
            end

            return setmetatable(Window, Library);
        end

        function Library:Page(Options)
            local Page = {
                Window = self;
                Name = Options.Name or Options.name or 'Tab';
                Properties = {};
                Active = false;
                Hovered = false;
            };

            local content = Page.Window.Properties.Content

            local inactive = instance.new("TextButton", {
                Name = "inactive";
                Parent = Page.Window.Properties.Tabs;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                AutoButtonColor = false;
                FontFace = realfont;
                Text = Page.Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextTransparency = 0.500;
            })
            
            local liner = instance.new("Frame", {
                Name = "liner";
                Parent = inactive;
                AnchorPoint = Vector2.new(0, 1);
                BackgroundColor3 = Color3.fromRGB(61, 61, 61);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 0, 1, 0);
                Size = UDim2.new(1, 0, 0, 1);
            })
            
            local glow = instance.new("Frame", {
                Name = "glow";
                Parent = inactive;
                AnchorPoint = Vector2.new(0, 1);
                BackgroundColor3 = Library.Accent;
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 0, 1, 0);
                Size = UDim2.new(1, 0, 0, 15);
            })
            
            local UIGradient = instance.new("UIGradient", {
                Rotation = -90;
                Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.59), NumberSequenceKeypoint.new(0.35, 0.90), NumberSequenceKeypoint.new(0.70, 1.00), NumberSequenceKeypoint.new(1.00, 0.99)};
                Parent = glow;
            })

            local tab = instance.new("Frame", {
                Name = Page.Name;
                Parent = content;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                Visible = false;
            })
            
            local sectionholders = instance.new("ScrollingFrame", {
                Name = "sectionholders";
                Parent = tab;
                Active = true;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                ScrollBarThickness = 0;
                AutomaticCanvasSize = Enum.AutomaticSize.Y
            })
            
            local left = instance.new("Frame", {
                Name = "left";
                Parent = sectionholders;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 7, 0, 8);
                Size = UDim2.new(0.314999998, 0, 1, 0);
            })
            
            local UIListLayout = instance.new("UIListLayout", {
                Parent = left;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Padding = UDim.new(0, 10);
            })

            local right = instance.new("Frame", {
                Name = "right";
                Parent = sectionholders;
                AnchorPoint = Vector2.new(1, 0);
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(1, -7, 0, 8);
                Size = UDim2.new(0.314999998, 0, 1, 0);
            })
            
            local UIListLayout = instance.new("UIListLayout", {
                Parent = right;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Padding = UDim.new(0, 10);
            })
            
            local center = instance.new("Frame", {
                Name = "center";
                Parent = sectionholders;
                AnchorPoint = Vector2.new(0.5, 0);
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0.5, 0, 0, 8);
                Size = UDim2.new(0.314999998, 0, 1, 0);
            })

            local UIListLayout = instance.new("UIListLayout", {
                Parent = center;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Padding = UDim.new(0, 10);
            })

            function Page:Switch(bool)
                Page.Active = bool 
                tab.Visible = bool 

                if bool then
                    tab.Visible = true 
                    Ts:Create(liner, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Library.Accent}):Play();
                    Ts:Create(glow, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}):Play();
                    Ts:Create(inactive, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play();
                elseif not Page.Hovered then
                    tab.Visible = false 
                    Ts:Create(liner, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(61,61,61)}):Play();
                    Ts:Create(glow, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play();
                    Ts:Create(inactive, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 0.5}):Play();
                end
            end

            Library:Connect(inactive.InputBegan, function(inp, gpe)
                if gpe then return end 

                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    for _, v in Library.TabAmount do
                        v:Switch(v == Page);
                    end
                end
            end)

            Page.Properties = {
                Main = sectionholders;
                Left = left;
                Right = right;
                Center = center;
            }

            table.insert(Library.TabAmount, Page)
            return setmetatable(Page, Library.Tabs)
        end

        function Pages:Section(Options)
            local Section = {
                Page = self;
                Name = Options.Name or Options.name or 'Section';
                Side = Options.Side or Options.side or 'Left';
                Properties = {};
            }

            local sectionside = 
            Section.Side:lower() == "left" and Section.Page.Properties.Left
            or Section.Side:lower() == "center" and Section.Page.Properties.Center 
            or Section.Side:lower() == "right" and Section.Page.Properties.Right

            local section = instance.new("Frame", {
                Name = "section";
                Parent = sectionside;
                BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 25);
                AutomaticSize = Enum.AutomaticSize.Y
            })

            local uistroke = instance.new("UIStroke", {
                Parent = section,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(34,34,34)
            })
            
            local text = instance.new("TextLabel", {
                Name = "text";
                Parent = section;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 8, 0, -8);
                Size = UDim2.new(1, 0, 0, 15);
                FontFace = realfont;
                Text = Section.Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            
            local content = instance.new("Frame", {
                Name = "content";
                Parent = section;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 5, 0, 10);
                Size = UDim2.new(1, -10, 1, -5);
            })
            
            local UIListLayout = instance.new("UIListLayout", {
                Parent = content;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Padding = UDim.new(0, 6);
            })

            Section.Properties = {
                Main = content 
            }

            return setmetatable(Section, Sections)
        end

        function Sections:Toggle(Options)
            local Toggle = {
                Section = self;
                Name = Options.Name or Options.name or 'Toggle';
                Flag = Options.Flag or Options.flag or Library:NextFlag();
                State = Options.State or Options.state or false;
                Callback = Options.Callback or Options.callback or function() end;
                Colorpickers = 0;
                Toggled = false;
            }

            local content = Toggle.Section.Properties.Main

            local toggle = instance.new("TextButton", {
                Name = "toggle";
                Parent = content;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 10);
                Font = Enum.Font.SourceSans;
                Text = "";
                TextColor3 = Color3.fromRGB(0, 0, 0);
                TextSize = 14.000;
            })
            
            local indicator = instance.new("Frame", {
                Name = "indicator";
                Parent = toggle;
                AnchorPoint = Vector2.new(0, 0.5);
                BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 0, 0.5, 0);
                Size = UDim2.new(0, 9, 0, 9);
            })

            local uistroke = instance.new("UIStroke", {
                Parent = indicator,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(0,0,0)
            })
            
            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
                Rotation = 90;
                Parent = indicator;
            })
            
            local text = instance.new("TextLabel", {
                Name = "text";
                Parent = toggle;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 15, 0, 0);
                Size = UDim2.new(1, 0, 1, 0);
                FontFace = realfont;
                Text = Toggle.Name;
                TextColor3 = Color3.fromRGB(175, 175, 175);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })

            Library:Connect(toggle.MouseEnter, function()
                Ts:Create(uistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Library.Accent}):Play()
            end)

            Library:Connect(toggle.MouseLeave, function()
                Ts:Create(uistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(0,0,0)}):Play()
            end)

            local function SetState()
                Toggle.Toggled = not Toggle.Toggled
                Ts:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Toggle.Toggled and Library.Accent or Color3.fromRGB(24,24,24)}):Play()
                Ts:Create(text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Toggle.Toggled and Color3.fromRGB(255,255,255) or Color3.fromRGB(175,175,175)}):Play()
                Library.Flags[Toggle.Flag] = Toggle.Toggled
                Toggle.Callback(Toggle.Toggled)
            end

            function Toggle:Colorpicker(Options)
                local Colorpicker = {
                    Section = self;
                    Name = Options.name or Options.Name or 'Colorpicker';
                    State = Options.state or Options.State or Color3.fromRGB(255,0,0);
                    Flag = Options.flag or Options.Flag or Library:NextFlag();
                    Alpha = Options.Alpha or Options.alpha or 0;
                    Callback = Options.Callback or Options.callback or function() end;
                }

                Toggle.Colorpickers += 1
                local count = Toggle.Colorpickers
                
                local colorbutton = instance.new("TextButton", {
                    Name = "colorbutton";
                    Parent = toggle;
                    AnchorPoint = Vector2.new(1, 0);
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = UDim2.new(1, 0, 0, 0);
                    Size = UDim2.new(0, 22, 0, 10);
                    AutoButtonColor = false;
                    Font = Enum.Font.SourceSans;
                    Text = "";
                    TextColor3 = Color3.fromRGB(0, 0, 0);
                    TextSize = 14.000;
                })

                if count == 1 then
                    colorbutton.Position = UDim2.new(1, - (count * 2),0,0)
                else
                    colorbutton.Position = UDim2.new(1, - (count * 10) - (count * 4),0,0)
                end
    
                local uistroke = instance.new("UIStroke", {
                    Parent = colorbutton;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = Color3.fromRGB(0,0,0);
                })
                
                local UIGradient3 = instance.new("UIGradient", {
                    Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
                    Rotation = 90;
                    Parent = colorbutton;
                })
                
                local window = instance.new("Frame", {
                    Name = "window";
                    Parent = toggle;
                    AnchorPoint = Vector2.new(1, 0);
                    BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = UDim2.new(1, 0, 0, 17);
                    Size = UDim2.new(0, 170, 0, 155);
                    Visible = false;
                })
    
                local uistroke2 = instance.new("UIStroke", {
                    Parent = window;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = Color3.fromRGB(0,0,0);
                })
                
                local color = instance.new("TextButton", {
                    Name = "color";
                    Parent = window;
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 7, 0, 7);
                    Size = UDim2.new(0, 135, 0, 100);
                    AutoButtonColor = false;
                    Font = Enum.Font.SourceSans;
                    Text = "";
                    TextColor3 = Color3.fromRGB(0, 0, 0);
                    TextSize = 14.000;
                })
    
                local uistroke3 = instance.new("UIStroke", {
                    Parent = color;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = Color3.fromRGB(0,0,0);
                })
                
                local sat = instance.new("ImageLabel", {
                    Name = "sat";
                    Parent = color;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 1, 0);
                    Image = "http://www.roblox.com/asset/?id=14684562507";
                })
                
                local val = instance.new("ImageLabel", {
                    Name = "val";
                    Parent = color;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 1, 0);
                    Image = "http://www.roblox.com/asset/?id=14684563800";
                })
                
                local dragger = instance.new("Frame", {
                    Name = "dragger";
                    Parent = color;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = UDim2.new(0, 2, 0, 2);
                })
    
                local uistroke4 = instance.new("UIStroke", {
                    Parent = dragger;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = Color3.fromRGB(0,0,0);
                })
                
                local hue = instance.new("ImageButton", {
                    Name = "hue";
                    Parent = window;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = UDim2.new(1, -21, 0, 7);
                    Size = UDim2.new(0, 16, 0, 100);
                    Image = "http://www.roblox.com/asset/?id=14684557999";
                })
    
                local uistroke5 = instance.new("UIStroke", {
                    Parent = hue;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = Color3.fromRGB(0,0,0);
                })
                
                local dragger2 = instance.new("Frame", {
                    Name = "dragger";
                    Parent = hue;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 0, 1);
                })
    
                local uistroke6 = instance.new("UIStroke", {
                    Parent = dragger2;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = Color3.fromRGB(0,0,0);
                })
                
                local alpha = instance.new("TextButton", {
                    Name = "alpha";
                    Parent = window;
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 7, 1, -40);
                    Size = UDim2.new(0, 158, 0, 12);
                    AutoButtonColor = false;
                    Font = Enum.Font.SourceSans;
                    Text = "";
                    TextColor3 = Color3.fromRGB(0, 0, 0);
                    TextSize = 14.000;
                })
    
                local uistroke7 = instance.new("UIStroke", {
                    Parent = alpha;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = Color3.fromRGB(0,0,0);
                })
                
                local dragger3 = instance.new("Frame", {
                    Name = "dragger";
                    Parent = alpha;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = UDim2.new(0, 1, 1, 0);
                })
    
                local uistroke8 = instance.new("UIStroke", {
                    Parent = dragger3;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = Color3.fromRGB(0,0,0);
                })
                
                local UIGradient4 = instance.new("UIGradient", {
                    Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))};
                    Parent = alpha;
                })
                
                local checkers = instance.new("ImageLabel", {
                    Name = "checkers";
                    Parent = alpha;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 1, 0);
                    Image = "http://www.roblox.com/asset/?id=18274452449";
                    ScaleType = Enum.ScaleType.Tile;
                    TileSize = UDim2.new(0, 6, 0, 6);
                })
                
                local UIGradient5 = instance.new("UIGradient", {
                    Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)};
                    Parent = checkers;
                })
                
                local rgb = instance.new("TextLabel", {
                    Name = "rgb";
                    Parent = window;
                    BackgroundColor3 = Color3.fromRGB(17, 17, 17);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 7, 1, -20);
                    Size = UDim2.new(0, 89, 0, 15);
                    FontFace = realfont;
                    Text = "255,0,0";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 10.000;
                    TextStrokeTransparency = 0.000;
                })
                
                local uistroke9 = instance.new("UIStroke", {
                    Parent = rgb;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = Color3.fromRGB(0,0,0);
                })
    
                local copy = instance.new("TextButton", {
                    Name = "copy";
                    Parent = window;
                    BackgroundColor3 = Color3.fromRGB(17, 17, 17);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 105, 1, -20);
                    Size = UDim2.new(0, 60, 0, 15);
                    AutoButtonColor = false;
                    FontFace = realfont;
                    Text = "Copy";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 10.000;
                    TextStrokeTransparency = 0.000;
                })
    
                local uistroke10 = instance.new("UIStroke", {
                    Parent = copy;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = Color3.fromRGB(0,0,0);
                })
                
                Library:Connect(colorbutton.MouseEnter, function()
                    Ts:Create(uistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Library.Accent}):Play()
                end)
    
                Library:Connect(colorbutton.MouseLeave, function()
                    Ts:Create(uistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(0,0,0)}):Play()
                end)
    
                Library:Connect(colorbutton.MouseButton1Down, function()
                    window.Visible = not window.Visible 
    
                    if window.Visible then
                        for i,v in toggle:GetDescendants() do
                            if not v.Name:find("UI") then
                                v.ZIndex = 15
                            end
                        end
                    else
                        for i,v in toggle:GetDescendants() do
                            if not v.Name:find("UI") then
                                v.ZIndex = 1
                            end
                        end
                    end
                end)
    
                local SlidingPalette = false;
                local SlidingHue = false;
                local SlidingAlpha = false;
    
                local Saturation, Hue, Value = Colorpicker.State:ToHSV()
                local Hsv = Colorpicker.State:ToHSV()
                local Alpha = Colorpicker.Alpha
                local R, G, B
    
                local function SetState()
                    local MousePos = UIs:GetMouseLocation()
                    local RealPos = Vector2.new(MousePos.X, MousePos.Y - 55)
    
                    local Palette = (RealPos - color.AbsolutePosition)
                    local PaletteY = (RealPos.Y - color.AbsolutePosition.Y)
                    local PaletteX = (RealPos.X - color.AbsolutePosition.X)
    
                    local HueY = (RealPos.Y - hue.AbsolutePosition.Y)
    
                    local AlphaX = (RealPos.X - alpha.AbsolutePosition.X)
    
                    if SlidingPalette then
                        Saturation = math.clamp(1 - Palette.X / color.AbsoluteSize.X, 0, 1)
                        Value = math.clamp(1 - Palette.Y / color.AbsoluteSize.Y, 0, 1)
                    end
    
                    if SlidingHue then
                        Hue = math.clamp(HueY / hue.AbsoluteSize.Y,0,1)
                    end
    
                    if SlidingAlpha then
                        Alpha = math.clamp(AlphaX / alpha.AbsoluteSize.X, 0, 1)
                    end
                    
                    Hsv = Color3.fromHSV(Hue, Saturation, Value)
                    R, G, B = math.round(Hsv.R * 255), math.round(Hsv.G * 255), math.round(Hsv.B * 255)
                    color.BackgroundColor3 = Color3.fromHSV(Hue,1,1)
                    alpha.BackgroundColor3 = Hsv 
                    colorbutton.BackgroundColor3 = Hsv
                    rgb.TextColor3 = Hsv
    
                    dragger.Position = UDim2.new(math.clamp(1 - Saturation, 0.000, 1 - 0.030), 0, math.clamp(1 - Value, 0.000, 1 - 0.030), 0)
                    dragger2.Position = UDim2.new(0,0,math.clamp(Hue, 0.005, 0.990),0)
                    dragger3.Position = UDim2.new(math.clamp(Alpha, 0.005, 0.990),0,0,0)
    
                    rgb.Text = `{R}, {G}, {B}`
    
                    Library.Flags[Colorpicker.Flag] = Hsv
                    Colorpicker.Callback(Hsv)
                end
    
                local function Set(colora, a)
                    if type(colora) == "table" then
                        a = colora[4]
                        colora = Color3.fromHSV(colora[1], colora[2], colora[3])
                    end
                    if type(colora) == "string" then
                        colora = Color3.fromHex(colora)
                    end
    
                    local oldcolor = Hsv
                    local oldalpha = Alpha
    
                    Hue, Saturation, Value = colora:ToHSV()
                    Alpha = a or 1
                    Hsv = Color3.fromHSV(Hue, Saturation, Value)
    
                    if Hsv ~= oldcolor then
                        R, G, B = math.round(Hsv.R * 255), math.round(Hsv.G * 255), math.round(Hsv.B * 255)
                        color.BackgroundColor3 = Color3.fromHSV(Hue,1,1)
                        alpha.BackgroundColor3 = Hsv 
                        colorbutton.BackgroundColor3 = Hsv
                        rgb.TextColor3 = Hsv
            
                        dragger.Position = UDim2.new(math.clamp(1 - Saturation, 0.000, 1 - 0.030), 0, math.clamp(1 - Value, 0.000, 1 - 0.030), 0)
                        dragger2.Position = UDim2.new(0,0,math.clamp(Hue, 0.005, 0.990),0)
                        dragger3.Position = UDim2.new(math.clamp(Alpha, 0.005, 0.990),0,0,0)
            
                        rgb.Text = `{R}, {G}, {B}`
            
                        Library.Flags[Colorpicker.Flag] = Hsv
                        Colorpicker.Callback(Hsv)
                    end
                end
                
                Set(Colorpicker.State, Colorpicker.Alpha)
    
                Library:Connect(copy.MouseButton1Down, function()
                    if (setclipboard) then
                        setclipboard(rgb.Text)
                        Ts:Create(copy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Library.Accent}):Play()
                        task.wait(0.2)
                        Ts:Create(copy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                    end
                end)
    
                Library:Connect(color.InputBegan, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        SlidingPalette = true 
                        SetState()
                    end
                end)
    
                Library:Connect(color.InputEnded, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        SlidingPalette = false 
                    end
                end)
    
                Library:Connect(hue.InputBegan, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        SlidingHue = true 
                        SetState()
                    end
                end)
    
                Library:Connect(hue.InputEnded, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        SlidingHue = false 
                    end
                end)
    
                Library:Connect(alpha.InputBegan, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        SlidingAlpha = true 
                        SetState()
                    end
                end)
    
                Library:Connect(alpha.InputEnded, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        SlidingAlpha = false 
                    end
                end)
    
                Library:Connect(UIs.InputChanged, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseMovement then
                        if SlidingPalette then
                            SetState()
                        end
    
                        if SlidingAlpha then
                            SetState()
                        end
    
                        if SlidingHue then
                            SetState()
                        end
                    end
                end)
    
                function Colorpicker:GetTransparency()
                    return Alpha
                end
    
                return Colorpicker
            end
    
            function Toggle:Keybind(Options)
                local Keybind = {
                    Section = self,
                    State = Options.Default or Options.default or nil,
                    Mode = Options.Mode or Options.mode or 'Toggle',
                    UseKey = Options.UseKey or Options.usekey or false,
                    Callback = Options.Callback or Options.callback or function() end,
                    Flag = Options.Flag or Options.flag or Library:NextFlag(),
                    Ignore = Options.Ignore or Options.ignore or false,
                    Binding = nil
                }
    
                local Key
                local State = false
                local ListValue;
                if not Keybind.Ignore then
                    ListValue = Library.KeyList:NewKey(Toggle.Name, "None")
                end
                local c
    
                local key = instance.new("TextButton", {
                    Name = "key";
                    Parent = toggle;
                    AnchorPoint = Vector2.new(1, 0);
                    BackgroundColor3 = Color3.fromRGB(27, 27, 27);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = UDim2.new(1, 0, 0, 0);
                    Size = UDim2.new(0, 0, 0, 15);
                    AutoButtonColor = false;
                    FontFace = realfont;
                    Text = "None";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 10.000;
                    TextStrokeTransparency = 0.000;
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextXAlignment = Enum.TextXAlignment.Center
                })
    
                local padding = instance.new("UIPadding", {
                    Parent = key;
                    PaddingLeft = UDim.new(0,2)
                })
    
                key.Size = UDim2.new(0,key.Size.X.Offset + key.TextBounds.X, 0, 15)
    
                local uistroke = instance.new("UIStroke", {
                    Parent = key;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = Color3.fromRGB(0,0,0)
                })
                
                local UIGradient = instance.new("UIGradient", {
                    Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
                    Rotation = 90;
                    Parent = key;
                })

                local keywindow = instance.new("Frame", {
                    Name = "window";
                    Parent = toggle;
                    AnchorPoint = Vector2.new(1, 0);
                    BackgroundColor3 = Color3.fromRGB(21, 21, 21);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = UDim2.new(1, 0, 0, 18);
                    Size = UDim2.new(0, 55, 0, 60);
                    Visible = false;
                })
        
                local uistroke32 = instance.new("UIStroke", {
                    Parent = keywindow,
                    Color = Color3.fromRGB(0,0,0),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                
                local UIGradient = instance.new("UIGradient", {
                    Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))};
                    Rotation = 90;
                    Parent = keywindow;
                })
                
                local togglebuttonnn = instance.new("TextButton", {
                    Name = "toggle";
                    Parent = keywindow;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 0, 20);
                    FontFace = realfont;
                    Text = "Toggle";
                    TextColor3 = Library.Accent;
                    TextSize = 10.000;
                    TextStrokeTransparency = 0.000;
                })
                
                local hold = instance.new("TextButton", {
                    Name = "hold";
                    Parent = keywindow;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 0, 0, 20);
                    Size = UDim2.new(1, 0, 0, 20);
                    FontFace = realfont;
                    Text = "Hold";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 10.000;
                    TextStrokeTransparency = 0.000;
                })
                
                local alwyys = instance.new("TextButton", {
                    Name = "alwyys";
                    Parent = keywindow;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 0, 0, 40);
                    Size = UDim2.new(1, 0, 0, 20);
                    FontFace = realfont;
                    Text = "Always";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 10.000;
                    TextStrokeTransparency = 0.000;
                })
    
                local function set(newkey)
                    if string.find(tostring(newkey), "Enum") then
                        if c then
                            c:Disconnect()
                            if Keybind.Flag then
                                Library.Flags[Keybind.Flag] = false
                            end
                            Keybind.Callback(false)
                        end
                        if tostring(newkey):find("Enum.KeyCode.") then
                            newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                        elseif tostring(newkey):find("Enum.UserInputType.") then
                            newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                        end
                        if newkey == Enum.KeyCode.Backspace then
                            Key = nil
                            if Keybind.UseKey then
                                if Keybind.Flag then
                                    Library.Flags[Keybind.Flag] = Key
                                end
                                Keybind.Callback(Key)
                            end
                            local text = "None"
    
                            key.Text = text
                            ListValue:SetKey(Toggle.Name, text)
                        elseif newkey ~= nil then
                            Key = newkey
                            if Keybind.UseKey then
                                if Keybind.Flag then
                                    Library.Flags[Keybind.Flag] = Key
                                end
                                Keybind.Callback(Key)
                            end
                            local text = (Library.Keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
    
                            key.Text = `[{text}]`
                        end
    
                        Library.Flags[Keybind.Flag .. "_KEY"] = newkey
                    elseif table.find({ "Always", "Toggle", "Hold" }, newkey) then
                        if not Keybind.UseKey then
                            Library.Flags[Keybind.Flag .. "_KEY STATE"] = newkey
                            Keybind.Mode = newkey
                            if Keybind.Mode == "Always" then
                                State = true
                                if Keybind.Flag then
                                    Library.Flags[Keybind.Flag] = State
                                end
                                Keybind.Callback(true)
                                if not Keybind.Ignore then
                                    ListValue:SetVisible(true)
                                    local text = (Library.Keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
                                    ListValue:SetKey(Toggle.Name, `[{text}]`)
                                end
                            elseif Keybind.Mode == "Hold" then
                                State = false
                                if Keybind.Flag then
                                    Library.Flags[Keybind.Flag] = State
                                end
                                Keybind.Callback(false)
                                if not Keybind.Ignore then
                                    ListValue:SetVisible(false)
                                end
                            end
                        end
                    else
                        State = newkey
                        if Keybind.Flag then
                            Library.Flags[Keybind.Flag] = newkey
                        end
                        Keybind.Callback(newkey)
                    end
                end
                --
                set(Keybind.State)
                set(Keybind.Mode)
                key.MouseButton1Click:Connect(function()
                    if not Keybind.Binding then
    
                        key.Text = "..."
    
                        Keybind.Binding = Library:Connect(
                            UIs.InputBegan,
                            function(input, gpe)
                                set(
                                    input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode
                                        or input.UserInputType
                                )
                                ListValue:SetKey(Toggle.Name, Key.Name)
                                Library:Disconnect(Keybind.Binding)
                                task.wait()
                                Keybind.Binding = nil
                            end
                        )
                    end
                end)
                --
                Library:Connect(UIs.InputBegan, function(inp)
                    if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
                        if Keybind.Mode == "Hold" then
                            if Keybind.Flag then
                                Library.Flags[Keybind.Flag] = true
                            end
                            c = Library:Connect(game:GetService("RunService").RenderStepped, function()
                                if Keybind.Callback then
                                    Keybind.Callback(true)
                                end
                            end)
                            if not Keybind.Ignore then
                                ListValue:SetVisible(true)
                            end
                        elseif Keybind.Mode == "Toggle" then
                            State = not State
                            if Keybind.Flag then
                                Library.Flags[Keybind.Flag] = State
                            end
                            Keybind.Callback(State)
                            if not Keybind.Ignore then
                                ListValue:SetVisible(State)
                            end
                        end
                    end
                end)
                --
                Library:Connect(game:GetService("UserInputService").InputEnded, function(inp)
                    if Keybind.Mode == "Hold" and not Keybind.UseKey then
                        if Key ~= "" or Key ~= nil then
                            if inp.KeyCode == Key or inp.UserInputType == Key then
                                if c then
                                    c:Disconnect()
                                    if Keybind.Flag then
                                        Library.Flags[Keybind.Flag] = false
                                    end
                                    if Keybind.Callback then
                                        Keybind.Callback(false)
                                    end
                                    if not Keybind.Ignore then
                                        ListValue:SetVisible(false)
                                    end
                                end
                            end
                        end
                    end
                end)

                key.MouseButton2Click:Connect(function()
                    keywindow.Visible = not keywindow.Visible 

                    if keywindow.Visible then
                        for _, child in toggle:GetDescendants() do
                            if not child.Name:find("UI") then
                                child.ZIndex = 15
                            end
                        end
                    else
                        for _, child in toggle:GetDescendants() do
                            if not child.Name:find("UI") then
                                child.ZIndex = 1
                            end
                        end
                    end
                end)

                togglebuttonnn.MouseButton1Click:Connect(function()
                    set("Toggle")
                    game:GetService("TweenService"):Create(togglebuttonnn, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Library.Accent}):Play()
                    game:GetService("TweenService"):Create(hold, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                    game:GetService("TweenService"):Create(alwyys, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                end)

                hold.MouseButton1Click:Connect(function()
                    set("Hold")
                    game:GetService("TweenService"):Create(togglebuttonnn, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                    game:GetService("TweenService"):Create(hold, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Library.Accent}):Play()
                    game:GetService("TweenService"):Create(alwyys, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                end)
                
                alwyys.MouseButton1Click:Connect(function()
                    set("Always")
                    game:GetService("TweenService"):Create(togglebuttonnn, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                    game:GetService("TweenService"):Create(hold, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                    game:GetService("TweenService"):Create(alwyys, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 =Library.Accent}):Play()
                end)
    
                return Keybind
            end

            function Toggle:Set(bool)
                bool = type(bool) == "boolean" and bool or false
                if Toggle.Toggled ~= bool then
                    SetState()
                end
            end

            Library:Connect(toggle.MouseButton1Down, SetState)

            Toggle:Set(Toggle.State)
            return Toggle
        end

        function Sections:Button(Options)
            local Button = {
                Section = self;
                Name = Options.Name or Options.name or 'Button';
                Callback = Options.Callback or Options.callback or function () end;
                Hovered = false;
            }

            local content = Button.Section.Properties.Main

            local button = instance.new("TextButton", {
                Name = "button";
                Parent = content;
                BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 15);
                AutoButtonColor = false;
                Font = Enum.Font.SourceSans;
                Text = "";
                TextColor3 = Color3.fromRGB(0, 0, 0);
                TextSize = 14.000;
            })

            local uistroke = instance.new("UIStroke", {
                Parent = button,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(0,0,0)
            })
            
            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
                Rotation = 90;
                Parent = button;
            })
            
            local text = instance.new("TextLabel", {
                Name = "text";
                Parent = button;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                FontFace = realfont;
                Text = Button.Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
            })

            function Button:Sub(Options)
                local SubButton = {
                    Name = Options.Name or Options.name or 'SubButton';
                    Callback = Options.Callback or Options.callback or function () end;
                    Hovered = false;
                }

                button.Size = UDim2.new(0.48,0,0,15)

                local subbutton = instance.new("TextButton", {
                    Name = "button";
                    Parent = button;
                    BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 0, 15);
                    AutoButtonColor = false;
                    Font = Enum.Font.SourceSans;
                    Text = "";
                    TextColor3 = Color3.fromRGB(0, 0, 0);
                    TextSize = 14.000;
                    Position = UDim2.new(1,7,0,0)
                })
        
                local subuistroke = instance.new("UIStroke", {
                    Parent = subbutton,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Color3.fromRGB(0,0,0)
                })
                
                local subUIGradient = instance.new("UIGradient", {
                    Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
                    Rotation = 90;
                    Parent = subbutton;
                })
                
                local subtext = instance.new("TextLabel", {
                    Name = "text";
                    Parent = subbutton;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = Color3.fromRGB(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 1, 0);
                    FontFace = realfont;
                    Text = SubButton.Name;
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 10.000;
                    TextStrokeTransparency = 0.000;
                })

                Library:Connect(subbutton.MouseEnter, function()
                    Ts:Create(subuistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Library.Accent}):Play()
                    SubButton.Hovered = true
                end)
        
                Library:Connect(subbutton.MouseLeave, function()
                    Ts:Create(subuistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(0,0,0)}):Play()
                    SubButton.Hovered = false
                end)
        

                Library:Connect(subbutton.MouseButton1Down, function()
                    Button.Callback()
                    Ts:Create(subuistroke,TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),{Color = Library.Accent}):Play()
                    task.wait(0.1)
                    if not SubButton.Hovered then 
                    Ts:Create(subuistroke,TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),{Color = Color3.fromRGB(0,0,0)}):Play()
                    end
                end)

                return SubButton
            end

            Library:Connect(button.MouseEnter, function()
                Ts:Create(uistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Library.Accent}):Play()
                Button.Hovered = true 
            end)

            Library:Connect(button.MouseLeave, function()
                Ts:Create(uistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(0,0,0)}):Play()
                Button.Hovered = false
            end)


            Library:Connect(button.MouseButton1Down, function()
                Button.Callback()
                Ts:Create(uistroke,TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),{Color = Library.Accent}):Play()
                task.wait(0.1)
                if not Button.Hovered then
                Ts:Create(uistroke,TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),{Color = Color3.fromRGB(0,0,0)}):Play()
                end
            end)

            return Button
        end 

        function Sections:Slider(Options)
            local Slider = {
                Section = self;
                Name = Options.name or Options.Name or 'Slider';
                Min = Options.min or Options.Min or 1;
                State = Options.state or Options.State or 10;
                Max = Options.Max or Options.max or 100;
                Suffix = Options.Suffix or Options.suffix or "";
                Decimals = Options.Decimals or Options.decimals or 1;
                Callback = Options.Callback or Options.callback or function() end;
                Flag = Options.flag or Options.flag or Library:NextFlag();
                Compact = Options.compact or Options.Compact or false;
            }

            local content = Slider.Section.Properties.Main

            local slider = instance.new("Frame", {
                Name = "slider";
                Parent = content;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 21);
            })
            
            local text = instance.new("TextLabel", {
                Name = "text";
                Parent = slider;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 13);
                FontFace = realfont;
                Text = Slider.Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            
            local realslider = instance.new("Frame", {
                Name = "realslider";
                Parent = slider;
                AnchorPoint = Vector2.new(0, 1);
                BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 0, 1, 0);
                Size = UDim2.new(1, 0, 0, 7);
            })
            
            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
                Rotation = 90;
                Parent = realslider;
            })
            
            local indicator = instance.new("Frame", {
                Name = "indicator";
                Parent = realslider;
                BackgroundColor3 = Library.Accent;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(0.5, 0, 1, 0);
            })
            
            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
                Rotation = 90;
                Parent = indicator;
            })

            local uistroke = instance.new("UIStroke", {
                Parent = realslider,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(0,0,0)
            })
            
            local valuetext = instance.new("TextLabel", {
                Name = "value";
                Parent = realslider;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                FontFace = realfont;
                Text = "50st";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
            })

            Library:Connect(realslider.MouseEnter, function()
                Ts:Create(uistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Library.Accent}):Play()
            end)

            Library:Connect(realslider.MouseLeave, function()
                Ts:Create(uistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(0,0,0)}):Play()
            end)

            local TextValue = ("[value]" .. Slider.Suffix)

            if Slider.Compact then
                slider.Size = UDim2.new(1,0,0,7)
                text:Destroy()
                TextValue = (Slider.Name .. ": [value]" .. Slider.Suffix)
            end

            local Sliding = false
            local Val = Slider.State

            local function Set(value)
                value = math.clamp(Library:Round(value, Slider.Decimals), Slider.Min, Slider.Max)

                local sizeX = ((value - Slider.Min) / (Slider.Max - Slider.Min))
                game:GetService("TweenService"):Create(indicator, TweenInfo.new(0.021, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(sizeX,0,1,0)}):Play()
                valuetext.Text = TextValue:gsub("%[value%]", string.format("%.14g", value))
                Val = value

                Library.Flags[Slider.Flag] = value
                Slider.Callback(value)
            end	

            local function ISlide(input)
                local sizeX = (input.Position.X - realslider.AbsolutePosition.X) / realslider.AbsoluteSize.X
                local value = ((Slider.Max - Slider.Min) * sizeX) + Slider.Min
                Set(value)
            end

            Library:Connect(indicator.InputBegan, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = true 
                    Library.dragging = nil
                    ISlide(inp)
                end
            end)

            Library:Connect(indicator.InputEnded, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = false 
                end
            end)
            
            Library:Connect(realslider.InputBegan, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = true 
                    Library.dragging = nil
                    ISlide(inp)
                end
            end)

            Library:Connect(realslider.InputEnded, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = false 
                end
            end)

            Library:Connect(UIs.InputChanged, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement then
                    if Sliding then
                        Library.dragging = nil
                        ISlide(inp)
                    end
                end
            end)

            function Slider:Set(value)
                Set(value)
            end
            
            Library.Flags[Slider.Flag] = Slider.State
            Set(Slider.State)
            return Slider
        end
        
        function Sections:Dropdown(Options)
            local Dropdown = {
                Section = self;
                Name = Options.Name or Options.name or 'Dropdown';
                State = Options.State or Options.state or nil;
                Flag = Options.Flag or Options.flag or Library:NextFlag();
                Options = Options.Options or Options.options or {"One","Two","Three"};
                Multi = Options.Multi or Options.multi or false;
                Callback = Options.Callback or Options.callback or function() end;
            }

            local OptionCount = 0;
            local OptionInstances = {};
            local Chosen = Dropdown.Multi and {} or nil;
            local content = Dropdown.Section.Properties.Main; 

            local dropdown = instance.new("Frame", {
                Name = "dropdown";
                Parent = content;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 32);
            })
            
            local text = instance.new("TextLabel", {
                Name = "text";
                Parent = dropdown;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 15);
                FontFace = realfont;
                Text = Dropdown.Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            
            local realdropdown = instance.new("TextButton", {
                Name = "realdropdown";
                Parent = dropdown;
                AnchorPoint = Vector2.new(0, 1);
                BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 0, 1, 0);
                Size = UDim2.new(1, 0, 0, 16);
                AutoButtonColor = false;
                Font = Enum.Font.SourceSans;
                Text = "";
                TextColor3 = Color3.fromRGB(0, 0, 0);
                TextSize = 14.000;
            })

            local uistroke = instance.new("UIStroke", {
                Parent = realdropdown;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0);
            })
            
            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
                Rotation = 90;
                Parent = realdropdown;
            })
            
            local valuetext = instance.new("TextLabel", {
                Name = "value";
                Parent = realdropdown;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 5, 0, 0);
                Size = UDim2.new(1, 0, 1, 0);
                FontFace = realfont;
                Text = "option";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextTruncate = Enum.TextTruncate.AtEnd;
            })
            
            local open = instance.new("TextLabel", {
                Name = "open";
                Parent = realdropdown;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, -5, 0, 0);
                Size = UDim2.new(1, 0, 1, 0);
                FontFace = realfont;
                Text = "+";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextWrapped = true;
                TextXAlignment = Enum.TextXAlignment.Right;
            })
            
            local optionholder = instance.new("Frame", {
                Name = "optionholder";
                Parent = dropdown;
                BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 0, 1, 1);
                Size = UDim2.new(1, 0, 0, 15);
                Visible = false;
                AutomaticSize = Enum.AutomaticSize.Y;
            })
            
            local uistroke2 = instance.new("UIStroke", {
                Parent = optionholder;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0);
            })

            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
                Rotation = 90;
                Parent = optionholder;
            })
            
            local UIListLayout = instance.new("UIListLayout", {
                Parent = optionholder;
                SortOrder = Enum.SortOrder.LayoutOrder;
            })

            Library:Connect(realdropdown.MouseEnter, function()
                Ts:Create(uistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Library.Accent}):Play()
            end)

            Library:Connect(realdropdown.MouseLeave, function()
                Ts:Create(uistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(0,0,0)}):Play()
            end)

            Library:Connect(realdropdown.MouseButton1Down, function()
                optionholder.Visible = not optionholder.Visible 
        
                if optionholder.Visible then 
                    for _, child in dropdown:GetDescendants() do
                        if not child.Name:find("UI") then
                            child.ZIndex = 15
                        end
                    end
                    open.Text = "-"
                else
                    for _, child in dropdown:GetDescendants() do
                        if not child.Name:find("UI") then
                            child.ZIndex = 1
                        end
                    end
                    open.Text = "+"
                end
            end)

            local function HandleOptionClick(option, button, text)
                Library:Connect(button.MouseButton1Down, function()
                    if Dropdown.Multi then
                        local Index = table.find(Chosen, option);

                        if Index then
                            table.remove(Chosen, Index);
                        else
                            table.insert(Chosen, option);
                        end

                        valuetext.Text = table.concat(Chosen, ", ")
                        Ts:Create(text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 =Index and Color3.fromRGB(255,255,255) or Library.Accent}):Play()
                        Library.Flags[Dropdown.Flag] = Chosen 
                        Dropdown.Callback(Chosen)
                    else
                        for i,v in OptionInstances do
                            if i ~= option then
                                Ts:Create(v.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                            end
                        end

                        Chosen = option 
                        valuetext.Text = option 
                        Ts:Create(text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Library.Accent}):Play()
                        Library.Flags[Dropdown.Flag] = option 
                        Dropdown.Callback(option)
                    end
                end)
            end

            local function CreateOptions(table)
                for _, option in table do
                    OptionInstances[option] = {}

                    local option1 = instance.new("TextButton", {
                        Name = "option1";
                        Parent = optionholder;
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        BorderColor3 = Color3.fromRGB(0, 0, 0);
                        BorderSizePixel = 0;
                        Size = UDim2.new(1, 0, 0, 15);
                        Font = Enum.Font.SourceSans;
                        Text = "";
                        TextColor3 = Color3.fromRGB(0, 0, 0);
                        TextSize = 14.000;
                    })
                    
                    local text = instance.new("TextLabel", {
                        Name = "text";
                        Parent = option1;
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        BorderColor3 = Color3.fromRGB(0, 0, 0);
                        BorderSizePixel = 0;
                        Position = UDim2.new(0, 5, 0, 0);
                        Size = UDim2.new(1, 0, 1, 0);
                        FontFace = realfont;
                        Text = option;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 10.000;
                        TextStrokeTransparency = 0.000;
                        TextXAlignment = Enum.TextXAlignment.Left;
                    })

                    OptionInstances[option].text = text

                    HandleOptionClick(option, option1, text)
                end
            end

            local function Set(option)
                table.clear(Chosen);

                option = type(option) == "table" and option or {}

                for i,v in OptionInstances do
                    if not table.find(option, i) then
                        Ts:Create(v.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                    end
                end

                for i,v in option do
                    if table.find(Dropdown.Options, i) and Dropdown.Multi then
                        Ts:Create(v.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Library.Accent}):Play()
                    end
                end

                local TextChosen = {}

                for _, v in Chosen do
                    table.insert(TextChosen, v)
                end

                valuetext.Text = table.concat(TextChosen, ", ")
                Library.Flags[Dropdown.Flag] = Chosen 
                Dropdown.Callback(Chosen)
            end

            function Dropdown:Set(option)
                if Dropdown.Multi then
                    Set(option)
                else
                    for i,v in OptionInstances do
                        if i ~= option then
                            Ts:Create(v.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                        end
                    end

                    if table.find(Dropdown.Options, option) then
                        Ts:Create(OptionInstances[option].text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Library.Accent}):Play()
                        valuetext.Text = option;
                        Chosen = option 
                        Library.Flags[Dropdown.Flag] = option 
                        Dropdown.Callback(option)
                    else
                        Chosen = nil;
                        valuetext.Text = "None";
                        Library.Flags[Dropdown.Flag] = Chosen 
                        Dropdown.Callback(Chosen)
                    end
                end
            end

            CreateOptions(Dropdown.Options)
            Dropdown:Set(Dropdown.State)
            return Dropdown
        end

        function Sections:Colorpicker(Options)
            local Colorpicker = {
                Section = self;
                Name = Options.name or Options.Name or 'Colorpicker';
                State = Options.state or Options.State or Color3.fromRGB(255,0,0);
                Flag = Options.flag or Options.Flag or Library:NextFlag();
                Alpha = Options.Alpha or Options.alpha or 0;
                Callback = Options.Callback or Options.callback or function() end;
            }

            local content = Colorpicker.Section.Properties.Main
            
            local colorpicker = instance.new("Frame", {
                Name = "colorpicker";
                Parent = content;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 10);
            })
            
            local text = instance.new("TextLabel", {
                Name = "text";
                Parent = colorpicker;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                FontFace = realfont;
                Text = Colorpicker.Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            
            local colorbutton = instance.new("TextButton", {
                Name = "colorbutton";
                Parent = colorpicker;
                AnchorPoint = Vector2.new(1, 0);
                BackgroundColor3 = Color3.fromRGB(255, 0, 0);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(1, 0, 0, 0);
                Size = UDim2.new(0, 22, 0, 10);
                AutoButtonColor = false;
                Font = Enum.Font.SourceSans;
                Text = "";
                TextColor3 = Color3.fromRGB(0, 0, 0);
                TextSize = 14.000;
            })

            local uistroke = instance.new("UIStroke", {
                Parent = colorbutton;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0);
            })
            
            local UIGradient3 = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
                Rotation = 90;
                Parent = colorbutton;
            })
            
            local window = instance.new("Frame", {
                Name = "window";
                Parent = colorpicker;
                AnchorPoint = Vector2.new(1, 0);
                BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(1, 0, 0, 17);
                Size = UDim2.new(0, 170, 0, 155);
                Visible = false;
            })

            local uistroke2 = instance.new("UIStroke", {
                Parent = window;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0);
            })
            
            local color = instance.new("TextButton", {
                Name = "color";
                Parent = window;
                BackgroundColor3 = Color3.fromRGB(255, 0, 0);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 7, 0, 7);
                Size = UDim2.new(0, 135, 0, 100);
                AutoButtonColor = false;
                Font = Enum.Font.SourceSans;
                Text = "";
                TextColor3 = Color3.fromRGB(0, 0, 0);
                TextSize = 14.000;
            })

            local uistroke3 = instance.new("UIStroke", {
                Parent = color;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0);
            })
            
            local sat = instance.new("ImageLabel", {
                Name = "sat";
                Parent = color;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                Image = "http://www.roblox.com/asset/?id=14684562507";
            })
            
            local val = instance.new("ImageLabel", {
                Name = "val";
                Parent = color;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                Image = "http://www.roblox.com/asset/?id=14684563800";
            })
            
            local dragger = instance.new("Frame", {
                Name = "dragger";
                Parent = color;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(0, 2, 0, 2);
            })

            local uistroke4 = instance.new("UIStroke", {
                Parent = dragger;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0);
            })
            
            local hue = instance.new("ImageButton", {
                Name = "hue";
                Parent = window;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(1, -21, 0, 7);
                Size = UDim2.new(0, 16, 0, 100);
                Image = "http://www.roblox.com/asset/?id=14684557999";
            })

            local uistroke5 = instance.new("UIStroke", {
                Parent = hue;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0);
            })
            
            local dragger2 = instance.new("Frame", {
                Name = "dragger";
                Parent = hue;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 1);
            })

            local uistroke6 = instance.new("UIStroke", {
                Parent = dragger2;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0);
            })
            
            local alpha = instance.new("TextButton", {
                Name = "alpha";
                Parent = window;
                BackgroundColor3 = Color3.fromRGB(255, 0, 0);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 7, 1, -40);
                Size = UDim2.new(0, 158, 0, 12);
                AutoButtonColor = false;
                Font = Enum.Font.SourceSans;
                Text = "";
                TextColor3 = Color3.fromRGB(0, 0, 0);
                TextSize = 14.000;
            })

            local uistroke7 = instance.new("UIStroke", {
                Parent = alpha;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0);
            })
            
            local dragger3 = instance.new("Frame", {
                Name = "dragger";
                Parent = alpha;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(0, 1, 1, 0);
            })

            local uistroke8 = instance.new("UIStroke", {
                Parent = dragger3;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0);
            })
            
            local UIGradient4 = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))};
                Parent = alpha;
            })
            
            local checkers = instance.new("ImageLabel", {
                Name = "checkers";
                Parent = alpha;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                Image = "http://www.roblox.com/asset/?id=18274452449";
                ScaleType = Enum.ScaleType.Tile;
                TileSize = UDim2.new(0, 6, 0, 6);
            })
            
            local UIGradient5 = instance.new("UIGradient", {
                Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)};
                Parent = checkers;
            })
            
            local rgb = instance.new("TextLabel", {
                Name = "rgb";
                Parent = window;
                BackgroundColor3 = Color3.fromRGB(17, 17, 17);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 7, 1, -20);
                Size = UDim2.new(0, 89, 0, 15);
                FontFace = realfont;
                Text = "255,0,0";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
            })
            
            local uistroke9 = instance.new("UIStroke", {
                Parent = rgb;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0);
            })

            local copy = instance.new("TextButton", {
                Name = "copy";
                Parent = window;
                BackgroundColor3 = Color3.fromRGB(17, 17, 17);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 105, 1, -20);
                Size = UDim2.new(0, 60, 0, 15);
                AutoButtonColor = false;
                FontFace = realfont;
                Text = "Copy";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
            })

            local uistroke10 = instance.new("UIStroke", {
                Parent = copy;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0);
            })
            
            Library:Connect(colorpicker.MouseEnter, function()
                Ts:Create(uistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Library.Accent}):Play()
            end)

            Library:Connect(colorpicker.MouseLeave, function()
                Ts:Create(uistroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(0,0,0)}):Play()
            end)

            Library:Connect(colorbutton.MouseButton1Down, function()
                window.Visible = not window.Visible 

                if window.Visible then
                    for i,v in colorpicker:GetDescendants() do
                        if not v.Name:find("UI") then
                            v.ZIndex = 15
                        end
                    end
                else
                    for i,v in colorpicker:GetDescendants() do
                        if not v.Name:find("UI") then
                            v.ZIndex = 1
                        end
                    end
                end
            end)

            local SlidingPalette = false;
            local SlidingHue = false;
            local SlidingAlpha = false;

            local Saturation, Hue, Value = Colorpicker.State:ToHSV()
            local Hsv = Colorpicker.State:ToHSV()
            local Alpha = Colorpicker.Alpha
            local R, G, B

            local function SetState()
                local MousePos = UIs:GetMouseLocation()
                local RealPos = Vector2.new(MousePos.X, MousePos.Y - 55)

                local Palette = (RealPos - color.AbsolutePosition)
                local PaletteY = (RealPos.Y - color.AbsolutePosition.Y)
                local PaletteX = (RealPos.X - color.AbsolutePosition.X)

                local HueY = (RealPos.Y - hue.AbsolutePosition.Y)

                local AlphaX = (RealPos.X - alpha.AbsolutePosition.X)

                if SlidingPalette then
                    Saturation = math.clamp(1 - Palette.X / color.AbsoluteSize.X, 0, 1)
                    Value = math.clamp(1 - Palette.Y / color.AbsoluteSize.Y, 0, 1)
                end

                if SlidingHue then
                    Hue = math.clamp(HueY / hue.AbsoluteSize.Y,0,1)
                end

                if SlidingAlpha then
                    Alpha = math.clamp(AlphaX / alpha.AbsoluteSize.X, 0, 1)
                end
                
                Hsv = Color3.fromHSV(Hue, Saturation, Value)
                R, G, B = math.round(Hsv.R * 255), math.round(Hsv.G * 255), math.round(Hsv.B * 255)
                color.BackgroundColor3 = Color3.fromHSV(Hue,1,1)
                alpha.BackgroundColor3 = Hsv 
                colorbutton.BackgroundColor3 = Hsv
                rgb.TextColor3 = Hsv

                dragger.Position = UDim2.new(math.clamp(1 - Saturation, 0.000, 1 - 0.030), 0, math.clamp(1 - Value, 0.000, 1 - 0.030), 0)
                dragger2.Position = UDim2.new(0,0,math.clamp(Hue, 0.005, 0.990),0)
                dragger3.Position = UDim2.new(math.clamp(Alpha, 0.005, 0.990),0,0,0)

                rgb.Text = `{R}, {G}, {B}`

                Library.Flags[Colorpicker.Flag] = Hsv
                Colorpicker.Callback(Hsv)
            end

            local function Set(colora, a)
                if type(colora) == "table" then
                    a = colora[4]
                    colora = Color3.fromHSV(colora[1], colora[2], colora[3])
                end
                if type(colora) == "string" then
                    colora = Color3.fromHex(colora)
                end

                local oldcolor = Hsv
                local oldalpha = Alpha

                Hue, Saturation, Value = colora:ToHSV()
                Alpha = a or 1
                Hsv = Color3.fromHSV(Hue, Saturation, Value)

                if Hsv ~= oldcolor then
                    R, G, B = math.round(Hsv.R * 255), math.round(Hsv.G * 255), math.round(Hsv.B * 255)
                    color.BackgroundColor3 = Color3.fromHSV(Hue,1,1)
                    alpha.BackgroundColor3 = Hsv 
                    colorbutton.BackgroundColor3 = Hsv
                    rgb.TextColor3 = Hsv
        
                    dragger.Position = UDim2.new(math.clamp(1 - Saturation, 0.000, 1 - 0.030), 0, math.clamp(1 - Value, 0.000, 1 - 0.030), 0)
                    dragger2.Position = UDim2.new(0,0,math.clamp(Hue, 0.005, 0.990),0)
                    dragger3.Position = UDim2.new(math.clamp(Alpha, 0.005, 0.990),0,0,0)
        
                    rgb.Text = `{R}, {G}, {B}`
        
                    Library.Flags[Colorpicker.Flag] = Hsv
                    Colorpicker.Callback(Hsv)
                end
            end
            
            Set(Colorpicker.State, Colorpicker.Alpha)

            Library:Connect(copy.MouseButton1Down, function()
                if (setclipboard) then
                    setclipboard(rgb.Text)
                    Ts:Create(copy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Library.Accent}):Play()
                    task.wait(0.2)
                    Ts:Create(copy, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                end
            end)

            Library:Connect(color.InputBegan, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingPalette = true 
                    SetState()
                end
            end)

            Library:Connect(color.InputEnded, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingPalette = false 
                end
            end)

            Library:Connect(hue.InputBegan, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingHue = true 
                    SetState()
                end
            end)

            Library:Connect(hue.InputEnded, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingHue = false 
                end
            end)

            Library:Connect(alpha.InputBegan, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingAlpha = true 
                    SetState()
                end
            end)

            Library:Connect(alpha.InputEnded, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingAlpha = false 
                end
            end)

            Library:Connect(UIs.InputChanged, function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement then
                    if SlidingPalette then
                        SetState()
                    end

                    if SlidingAlpha then
                        SetState()
                    end

                    if SlidingHue then
                        SetState()
                    end
                end
            end)

            function Colorpicker:GetTransparency()
                return Alpha
            end

            return Colorpicker
        end

        function Sections:Keybind(Options)
            local Keybind = {
                Section = self,
                Name = Options.Name or Options.name or 'Keybind',
                State = Options.Default or Options.default or nil,
                Mode = Options.Mode or Options.mode or 'Toggle',
                UseKey = Options.UseKey or Options.usekey or false,
                Callback = Options.Callback or Options.callback or function() end,
                Flag = Options.Flag or Options.flag or Library:NextFlag(),
                Ignore = Options.Ignore or Options.ignore or false,
                Binding = nil
            }

            local Key
			local State = false
            local ListValue;
            if not Keybind.Ignore then
				ListValue = Library.KeyList:NewKey(Keybind.Name, "None")
			end
            local c

            local content = Keybind.Section.Properties.Main

            local keybind = instance.new("Frame", {
                Name = "keybind";
                Parent = content;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 15);
            })
            
            local text = instance.new("TextLabel", {
                Name = "text";
                Parent = keybind;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                FontFace = realfont;
                Text = Keybind.Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            
            local key = instance.new("TextButton", {
                Name = "key";
                Parent = keybind;
                AnchorPoint = Vector2.new(1, 0);
                BackgroundColor3 = Color3.fromRGB(27, 27, 27);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(1, 0, 0, 0);
                Size = UDim2.new(0, 0, 0, 15);
                AutoButtonColor = false;
                FontFace = realfont;
                Text = "None";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                AutomaticSize = Enum.AutomaticSize.X,
                TextXAlignment = Enum.TextXAlignment.Center
            })

            local padding = instance.new("UIPadding", {
                Parent = key;
                PaddingLeft = UDim.new(0,2)
            })

            key.Size = UDim2.new(0,key.Size.X.Offset + key.TextBounds.X, 0, 15)

            local uistroke = instance.new("UIStroke", {
                Parent = key;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0)
            })
            
            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
                Rotation = 90;
                Parent = key;
            })

            local function set(newkey)
				if string.find(tostring(newkey), "Enum") then
					if c then
						c:Disconnect()
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = false
						end
						Keybind.Callback(false)
					end
					if tostring(newkey):find("Enum.KeyCode.") then
						newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
					elseif tostring(newkey):find("Enum.UserInputType.") then
						newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
					end
					if newkey == Enum.KeyCode.Backspace then
						Key = nil
						if Keybind.UseKey then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = Key
							end
							Keybind.Callback(Key)
						end
						local text = "None"

						key.Text = text
                        ListValue:SetKey(Keybind.Name, text)
					elseif newkey ~= nil then
						Key = newkey
						if Keybind.UseKey then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = Key
							end
							Keybind.Callback(Key)
						end
						local text = (Library.Keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))

						key.Text = `[{text}]`
					end

					Library.Flags[Keybind.Flag .. "_KEY"] = newkey
				elseif table.find({ "Always", "Toggle", "Hold" }, newkey) then
					if not Keybind.UseKey then
						Library.Flags[Keybind.Flag .. "_KEY STATE"] = newkey
						Keybind.Mode = newkey
						if Keybind.Mode == "Always" then
							State = true
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = State
							end
							Keybind.Callback(true)
							if not Keybind.Ignore then
								ListValue:SetVisible(true)
                                local text = (Library.Keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
                                ListValue:SetKey(Keybind.Name, `[{text}]`)
							end
						elseif Keybind.Mode == "Hold" then
							State = false
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = State
							end
							Keybind.Callback(false)
							if not Keybind.Ignore then
								ListValue:SetVisible(false)
							end
						end
					end
				else
					State = newkey
					if Keybind.Flag then
						Library.Flags[Keybind.Flag] = newkey
					end
					Keybind.Callback(newkey)
				end
			end
			--
			set(Keybind.State)
			set(Keybind.Mode)
			key.MouseButton1Click:Connect(function()
				if not Keybind.Binding then

					key.Text = "..."

					Keybind.Binding = Library:Connect(
						UIs.InputBegan,
						function(input, gpe)
							set(
								input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode
									or input.UserInputType
							)
                            ListValue:SetKey(Keybind.Name, Key.Name)
							Library:Disconnect(Keybind.Binding)
							task.wait()
							Keybind.Binding = nil
						end
					)
				end
			end)
			--
			Library:Connect(UIs.InputBegan, function(inp)
				if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
					if Keybind.Mode == "Hold" then
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = true
						end
						c = Library:Connect(game:GetService("RunService").RenderStepped, function()
							if Keybind.Callback then
								Keybind.Callback(true)
							end
						end)
						if not Keybind.Ignore then
							ListValue:SetVisible(true)
						end
					elseif Keybind.Mode == "Toggle" then
						State = not State
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = State
						end
						Keybind.Callback(State)
						if not Keybind.Ignore then
							ListValue:SetVisible(State)
						end
					end
				end
			end)
			--
			Library:Connect(game:GetService("UserInputService").InputEnded, function(inp)
				if Keybind.Mode == "Hold" and not Keybind.UseKey then
					if Key ~= "" or Key ~= nil then
						if inp.KeyCode == Key or inp.UserInputType == Key then
							if c then
								c:Disconnect()
								if Keybind.Flag then
									Library.Flags[Keybind.Flag] = false
								end
								if Keybind.Callback then
									Keybind.Callback(false)
								end
								if not Keybind.Ignore then
									ListValue:SetVisible(false)
								end
							end
						end
					end
				end
			end)

            local keywindow = instance.new("Frame", {
                Name = "window";
                Parent = keybind;
                AnchorPoint = Vector2.new(1, 0);
                BackgroundColor3 = Color3.fromRGB(21, 21, 21);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(1, 0, 0, 18);
                Size = UDim2.new(0, 55, 0, 60);
                Visible = false;
            })
    
            local uistroke32 = instance.new("UIStroke", {
                Parent = keywindow,
                Color = Color3.fromRGB(0,0,0),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })
            
            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))};
                Rotation = 90;
                Parent = keywindow;
            })
            
            local togglebuttonnn = instance.new("TextButton", {
                Name = "toggle";
                Parent = keywindow;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 20);
                FontFace = realfont;
                Text = "Toggle";
                TextColor3 = Library.Accent;
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
            })
            
            local hold = instance.new("TextButton", {
                Name = "hold";
                Parent = keywindow;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 0, 0, 20);
                Size = UDim2.new(1, 0, 0, 20);
                FontFace = realfont;
                Text = "Hold";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
            })
            
            local alwyys = instance.new("TextButton", {
                Name = "alwyys";
                Parent = keywindow;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 0, 0, 40);
                Size = UDim2.new(1, 0, 0, 20);
                FontFace = realfont;
                Text = "Always";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
            })
            
            key.MouseButton2Click:Connect(function()
                keywindow.Visible = not keywindow.Visible 

                if keywindow.Visible then
                    for _, child in keybind:GetDescendants() do
                        if not child.Name:find("UI") then
                            child.ZIndex = 15
                        end
                    end
                else
                    for _, child in keybind:GetDescendants() do
                        if not child.Name:find("UI") then
                            child.ZIndex = 1
                        end
                    end
                end
            end)

            togglebuttonnn.MouseButton1Click:Connect(function()
                set("Toggle")
                game:GetService("TweenService"):Create(togglebuttonnn, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Library.Accent}):Play()
                game:GetService("TweenService"):Create(hold, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                game:GetService("TweenService"):Create(alwyys, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
            end)

            hold.MouseButton1Click:Connect(function()
                set("Hold")
                game:GetService("TweenService"):Create(togglebuttonnn, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                game:GetService("TweenService"):Create(hold, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Library.Accent}):Play()
                game:GetService("TweenService"):Create(alwyys, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
            end)
            
            alwyys.MouseButton1Click:Connect(function()
                set("Always")
                game:GetService("TweenService"):Create(togglebuttonnn, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                game:GetService("TweenService"):Create(hold, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                game:GetService("TweenService"):Create(alwyys, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 =Library.Accent}):Play()
            end)

            return Keybind
        end

        function Sections:Textbox(Options)
            local Textbox = {
                Section = self,
                Name = Options.Name or Options.name or 'Textbox',
                State = Options.State or Options.state or nil,
                Flag = Options.Flag or Options.flag or Library:Flag(),
                Placeholder = Options.Placeholder or  Options.placeholder or ". . .",
                Callback = Options.Callback or Options.callback or function() end
            }

            local content = Textbox.Section.Properties.Main

            local textbox = instance.new("Frame", {
                Name = "textbox";
                Parent = content;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 32);
            })
            
            local text = instance.new("TextLabel", {
                Name = "text";
                Parent = textbox;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 13);
                FontFace = realfont;
                Text = Textbox.Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            
            local outline = instance.new("Frame", {
                Name = "outline";
                Parent = textbox;
                AnchorPoint = Vector2.new(0, 1);
                BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 0, 1, 0);
                Size = UDim2.new(1, 0, 0, 15);
            })
            
            local inline = instance.new("TextBox", {
                Name = "inline";
                Parent = outline;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 1, 0);
                FontFace =realfont;
                PlaceholderText = Textbox.Placeholder;
                Text = "";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
                ClearTextOnFocus = false;
            })
            
            local UIGradient = instance.new("UIGradient", {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
                Rotation = 90;
                Parent = outline;
            }) 

            local uistroke = instance.new("UIStroke", {
                Parent = outline,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(0,0,0)
            })

            Library:Connect(inline.Focused, function()
                Ts:Create(inline, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Library.Accent}):Play()
            end)

            Library:Connect(inline.FocusLost, function()
                Ts:Create(inline, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                Library.Flags[Textbox.Flag] = inline.Text 
                Textbox.Callback(inline.Text)
            end)

            local function Set(str)
                inline.Text = str
                Library.Flags[Textbox.Flag] = inline.Text 
                Textbox.Callback(inline.Text)
            end

            function Textbox:Set(str)
                Set(str)
            end
            Set(Textbox.State)
            return Textbox
        end

        function Sections:Divider(Name)
            local content = self.Properties.Main 

            local divider = instance.new("Frame", {
                Name = "divider";
                Parent = content;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 12);
            })
            
            local real = instance.new("Frame", {
                Name = "real";
                Parent = divider;
                AnchorPoint = Vector2.new(0, 0.5);
                BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 0, 0.5, 0);
                Size = UDim2.new(1, 0, 0, 1);
                AutomaticSize = Enum.AutomaticSize.X
            })

            local stroke = instance.new("UIStroke", {
                Parent = real;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = Color3.fromRGB(0,0,0)
            })
            
            local text = instance.new("TextLabel", {
                Name = "text";
                Parent = divider;
                AnchorPoint = Vector2.new(0.5, 0);
                BackgroundColor3 = Color3.fromRGB(24, 24, 24);
                BorderColor3 = Color3.fromRGB(0, 0, 0);
                BorderSizePixel = 0;
                Position = UDim2.new(0.5, 0, 0, 0);
                Size = UDim2.new(0, 0, 1, 0);
                FontFace = realfont;
                Text = Name;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 10.000;
                TextStrokeTransparency = 0.000;
            })
        end
    end
end

return Library

