script:name("NeverLose") -- Имя скрипта
script:devs({"ConeTin"}) -- Разработчики
script:desc("0_0") -- Описание

info = {
    display_name = "NEVERLOSE"
}

paths = {
    bold_font = "NeverLose/nl900.ttf",
    regular_font = "NeverLose/nl500.ttf"
}

colors = {
    split = color.new(0.02, 0.10, 0.15, 1),
    outline = color.new(0.01, 0.11, 0.18, 1),
    accent = color.new(0.01, 0.66, 0.96,1),
    panel = color.new(0.01, 0.05, 0.10, 0.90196078431),
    background = color.new(0.03, 0.03, 0.05, 1),
    mod_bg = color.new(0.01, 0.05, 0.10, 1),
    text = color.new(1, 1, 1, 1),
    notaccent_text = color.new(0.20, 0.28, 0.33, 1),
    checkbox = {
        active = color.new(0.27, 0.60, 0.75, 1),
        active_bg = color.new(0.01, 0.05, 0.11, 1),
        notactive = color.new(0.49, 0.54, 0.58, 1),
        notactive_bg = color.new(0.01, 0.02, 0.05, 1),
    },
}

ClickGui = module.new("Menu", "Кастомное меню скрипта")

width = 420
height = 310
x = 0
y = 0
scroll = 0
mouseX1 = 0
mouseY1 = 0

categories = {
    {key = "fight", value = "Fight", name = "Сражение"},
    {key = "move", value = "Move", name = "Движение"},
    {key = "display", value = "Display", name = "Отображение"},
    {key = "player", value = "Player", name = "Игрок"},
    {key = "other", value = "Other", name = "Остальное"},
    {key = "scripts", value = "Scripts", name = "Скрипты"}
}

currentCategory = categories[1]

draw = {
    glow = function(x, y, width, height, round, off, alpha)
        render:init_stencil()
        render:rect(x, y, width, height, round, color.new(1,1,1))
        render:read_stencil(0)
        render:glow(
            x - off, 
            y- off, 
            width + off * 2, 
            height-0.5 + off * 2, 
            round+2,
            5+off/2, 
            render:alpha(colors.accent, alpha),
            render:alpha(colors.accent, alpha),
            render:alpha(colors.accent, alpha),
            render:alpha(colors.accent, alpha)
            --render:alpha(client:client_color(0), alpha), 
            --render:alpha(client:client_color(90), alpha), 
            --render:alpha(client:client_color(180), alpha), 
            --render:alpha(client:client_color(360), alpha)
        )
        render:finish_stencil()
    end
}

menu = {
    init = function()
        -- Вычисляем середину экрана и вычитаем половину из размера меню
        x = client:screen_width()/2 - width/2
        y = client:screen_height()/2 - height/2
    end,

    render = function(mouseX, mouseY) 
        mouseX1 = mouseX
        mouseY1 = mouseY

        -- Свечение
        draw.glow(x, y, width, height, 4, 2, 0.5)
        
        -- Панель слева
        render:blur(x, y, 100, height, 4, 10)
        render:rect(x, y, 100, height, 4, colors.panel)

        -- Фон справа
        render:rect(x+96, y, width-96, height, 4, colors.background)
        render:rect(x+95.5, y, 3, height, 0, colors.background)

        --render:rect(x+95.5, y, width-96, 35, 0, color.new(1, 1, 1, 0.5))

        -- Текст с названием
        render:text(paths.bold_font, 28, info.display_name, x + 46.5 - render:text_width(paths.bold_font, 28, info.display_name)/2, y+9.5, colors.accent)
        render:text(paths.bold_font, 28, info.display_name, x + 47 - render:text_width(paths.bold_font, 28, info.display_name)/2, y+10, colors.text)

        -- Разделения
        render:rect(x, y + height - 31, 94, 0.3, 0, colors.split)
        render:rect(x + 94.5, y, 0.3, height, 0, colors.split)
        render:rect(x+95.5, y + 35, width-96, 0.3, 0, colors.split)
        
        -- То, что находится на левой панельке

        render:init_stencil()
        render:rect(x + 6, y + height - 24, 18, 18, 9, color.new(1,1,1))
        render:read_stencil(1)
        render:image("NeverLose/avatar.jpg", x + 5, y + height - 25, 20, 20, color.new(1,1,1))
        render:finish_stencil()

        render:text(paths.regular_font, 14, client:name(), x + 30, y + height - 30 + 6, colors.text)
        render:text(paths.regular_font, 14, client:surname(), x + 30, y + height - 30 + 15, colors.text)

        render:text(paths.bold_font, 12, "Клиент", x + 10, y + 35, colors.notaccent_text)
        
        render:text(paths.bold_font, 12, "Другое", x + 10, y + 150, colors.notaccent_text)

        yOff = 0
        for _, category in ipairs(categories) do
            if category == currentCategory then
                render:rect(x + 7, y + 45.5 + yOff, 80, 15, 4, color.new(0.02, 0.27, 0.40, 0.5))
            end
            render:image("NeverLose/" .. category.key .. ".png", x + 11, y + 48 + yOff, 10, 10, colors.accent)
            render:text(paths.regular_font, 15, category.name, x + 28, y + 48.5 + yOff, colors.text)
            yOff = yOff + (category.key == "other" and 35 or 20)
        end

        -- То, что находится на правой панельке
        render:init_stencil()
        render:rect(x+96, y+35, width-96, height-35, 4, color.new(1,1,1))
        render:read_stencil(1)
        local modules = client:modules()
        local column = 0
        local left = 0 + scroll
        local right = 0 + scroll
        for i = 1, #modules do
            mod = modules[i]
            
            if mod:type() == currentCategory.value then
                
                local settings = mod:settings()
                local mod_height = #settings * 18 + 18
                local xOff = (column == 0 and -1 or 157)
                
                render:text(paths.bold_font, 12, mod:name(), x + 105 + xOff, y + 46 + (column == 0 and left or right), colors.notaccent_text)
                render:rect(x + 104.5 + xOff, y + 55.5 + (column == 0 and left or right), 151, mod_height+1, 3, colors.outline)
                render:rect(x + 105 + xOff, y + 56 + (column == 0 and left or right), 150, mod_height, 3, colors.mod_bg)
    
                render:text(paths.regular_font, 15, "Активен", x + 111 + xOff, y + 60.5 + (column == 0 and left or right), colors.text)
                render:rect(x + 250-15 + xOff, y + 61 + (column == 0 and left or right), 14, 8, 4, colors.outline)
                render:rect(x + 250-14.5 + xOff, y + 61.5 + (column == 0 and left or right), 13, 7, 3, mod:get() and colors.checkbox.active_bg or colors.checkbox.notactive_bg)
                render:rect(x + 250-15 + (mod:get() and 8 or 0) + xOff, y + 61.5 + (column == 0 and left or right), 7, 7, 3.5, mod:get() and colors.checkbox.active or colors.checkbox.notactive)
                
                local setY = 18
                for i = 1, #settings do
                    set = settings[i]

                    -- Разделение между сеттингами
                    render:rect(x + 110 + xOff, y + 56 + setY + (column == 0 and left or right), 140, 0.5, 0, colors.split)

                    render:text(paths.regular_font, 15, set:name(), x + 111 + xOff, y + 61 + setY + (column == 0 and left or right), colors.text)

                    if set:getClass() == checkbox then
                        render:rect(x + 250-15 + xOff, y + 61 + setY + (column == 0 and left or right), 14, 8, 4, colors.outline)
                        render:rect(x + 250-14.5 + xOff, y + 61.5 + setY + (column == 0 and left or right), 13, 7, 3, mod:get() and colors.checkbox.active_bg or colors.checkbox.notactive_bg)
                        render:rect(x + 250-15 + (set:get() and 8 or 0) + xOff, y + 61.5 + setY + (column == 0 and left or right), 7, 7, 3.5, set:get() and colors.checkbox.active or colors.checkbox.notactive)
                    end
                   
                    setY = setY + 18
                end

                column = column == 0 and 1 or 0
                if column == 1 then
                    left = left + mod_height + 20
                else
                    right = right + mod_height + 20
                end
            end
        end
        render:finish_stencil()
    end,

    mouseClicked = function(mouseX, mouseY, button)
        yOff = 0
        for _, category in ipairs(categories) do
            if math:hovered(x + 7, y + 43 + yOff, 80, 20, mouseX, mouseY) then
                currentCategory = category
            end
            
            yOff = yOff + (category.key == "other" and 35 or 20)
        end

        if math:hovered(x+96, y+35, width-96, height-35, mouseX, mouseY) then
            local modules = client:modules()
            local column = 0
            local left = 0 + scroll
            local right = 0 + scroll
            for i = 1, #modules do
                mod = modules[i]
                
                if mod:type() == currentCategory.value then
                    
                    local settings = mod:settings()
                    local mod_height = #settings * 18 + 18
                    local xOff = (column == 0 and -1 or 157)
                    
                    if math:hovered(x + 105 + xOff, y + 56 + (column == 0 and left or right), 150, 18, mouseX, mouseY) then
                        mod:toggle()
                    end

                    local setY = 18
                    for i = 1, #settings do
                        set = settings[i]

                        if math:hovered(x + 105 + xOff, y + 56 + setY + (column == 0 and left or right), 150, 18, mouseX, mouseY) then
                            if set:getClass() == checkbox then
                                set:set(not set:get())
                            end
                        end

                        --render:text(paths.regular_font, 15, set:name(), x + 111 + xOff, y + 60 + setY + (column == 0 and left or right), colors.text)
                        --render:rect(x + 250-15 + xOff, y + 61 + setY + (column == 0 and left or right), 14, 8, 4, mod:get() and colors.checkbox.active_bg or colors.checkbox.notactive_bg)
                        --render:rect(x + 250-15 + (mod:get() and 8 or 0) + xOff, y + 61.5 + setY + (column == 0 and left or right), 7, 7, 3.5, mod:get() and colors.checkbox.active or colors.checkbox.notactive)
                    
                        setY = setY + 18
                    end

                    column = column == 0 and 1 or 0
                    if column == 1 then
                        left = left + mod_height + 20
                    else
                        right = right + mod_height + 20
                    end
                end
            end
        end
    end,

    mouseDragged = function(dragX, dragY, button)
        -- Прибавляем позицию перетаскивания к текущему x и y
        if math:hovered(x,y,width,height,mouseX1,mouseY1) then
            
            x = x + dragX
            y = y + dragY
        end
    end,

    mouseScrolled = function(mouseX, mouseY, delta)
        scroll = scroll + delta * 15
        if scroll > 0 then
            scroll = 0
        end
    end,
}

-- При включении модуля открываем меню
ClickGui:on_enable(function()
    client:display(menu)
end)

if player:in_game() then
    client:display(menu)
end