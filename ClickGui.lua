script:name("ClickGui") -- Имя скрипта
script:devs({"ConeTin"}) -- Разработчики
script:desc("ClickGui Example") -- Описание

ClickGui = module.new("NewClickGui", "Новое кликгуи")

width = 445
height = 250
x = 0
y = 0
scroll = 0

function hovered(x1, y1, width1, height1, mouseX, mouseY)
    return mouseX > x1 and mouseY > y1 and mouseX < x1 + width1 and mouseY < y1 + height1
end

function create_screen() 
    return {
        init = function()
            x = client:screen_width()/2 - width/2
            y = client:screen_height()/2 - height/2
        end,

        render = function(mouseX, mouseY) 
            render:rect(x, y, width, height, 10, client:theme_main())
            render:text(25, "Rockstar", x + 7, y + 6, client:theme_text())

            render:init_stencil()
            render:rect(x, y, width, height, 10, client:theme_main())
            render:read_stencil(1)
            local modules = client:modules()
            local yOffset = scroll
            local xOffset = 0
            for i = 1, #modules do
                mod = modules[i]

                if yOffset < height and yOffset > -20 then
                    render:rect(x + 7 + xOffset, y + 25 + yOffset, 100, 20, 5, mod:get() and color.new(0,0,0) or client:theme_second())
                    render:text(17, mod:name(), x + 9 + xOffset, y + 26 + yOffset, client:theme_text())
                end

                xOffset = xOffset + 110
                if xOffset + 110 > width then
                    yOffset = yOffset + 25
                    xOffset = 0
                end
            end
            render:finish_stencil()
        end,

        mouseClicked = function(mouseX, mouseY, button)
            if hovered(x,y,width,height,mouseX,mouseY) then
                local modules = client:modules()
                local yOffset = scroll
                local xOffset = 0
                for i = 1, #modules do
                    mod = modules[i]

                    if yOffset < height and yOffset > -20 then
                        if hovered(x + 7 + xOffset, y + 25 + yOffset, 100, 20,mouseX,mouseY) then
                            mod:toggle()
                        end
                    end

                    xOffset = xOffset + 110
                    if xOffset + 110 > width then
                        yOffset = yOffset + 25
                        xOffset = 0
                    end
                end
            end
        end,

        mouseDragged = function(dragX, dragY, button)
            x = x + dragX
            y = y + dragY
        end,

        mouseScrolled = function(mouseX, mouseY, delta)
            scroll = scroll + delta * 15
        end,
    }
end

ClickGui:on_enable(function()
    local screen = create_screen()
    client:display(screen)
end)