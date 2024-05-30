script:name("OpenLink") -- Имя скрипта
script:devs({"ConeTin"}) -- Разработчики
script:desc("ClickGui Example") -- Описание

ClickGui = module.new("OpenLink", "Новое кликгуи")

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
            
            render:rect(x + width / 2 - 50, y + height / 2 - 10, 100, 20, 3, client:theme_second())
            render:text("Открыть", x + width / 2 - render:text_width("Открыть") / 2, y + height / 2 - 6.5, color.new(1,1,1))
        end,

        mouseClicked = function(mouseX, mouseY, button)
            if hovered(x + width / 2 - 50, y + height / 2 - 10, 100, 20, mouseX, mouseY) and button == 0 then
                local url = "https://www.youtube.com/watch?v=LrAsvGhqeXM"
                os.execute("cmd.exe /c start " .. url)  
            end
        end,
    }
end

ClickGui:on_enable(function()
    local screen = create_screen()
    client:display(screen)
end)