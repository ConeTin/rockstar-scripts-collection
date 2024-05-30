script:name("Jump Circles") -- Имя скрипта
script:devs({"ConeTin"}) -- Разработчики
script:desc("Testing Script") -- Описание


prev_ground = false

circles = {
    {
        pos = player:pos(),
        anim = 0
    }
}

events.render_3d:set(function(event)
    for i, circle in ipairs(circles) do
        speed = 0.025 / math:max(client:fps(),5) * 75
        circle.anim = math:min(circle.anim + speed, 2)
        size = 4*math:min(circle.anim,1)

        gl11:pushMatrix()
        gl11:translate(
            circle.pos.x - gl11:pos().x, 
            circle.pos.y - gl11:pos().y, 
            circle.pos.z - gl11:pos().z
        )
        gl11:rotate(90, 1, 0, 0)
    
        render:image("pentagram.png", -size/2, -size/2, size, size, render:alpha(client:client_color(), circle.anim > 1 and 2 - circle.anim or circle.anim))
        
        gl11:popMatrix()
    end

    if prev_ground and not player:ground() then
        table.insert(circles, {
            pos = vector.new(
                player:pos().x + gl11:pos().x,
                player:pos().y + gl11:pos().y, 
                player:pos().z + gl11:pos().z
            ),
            anim = 0
        })
    end

    prev_ground = player:ground()
end)
