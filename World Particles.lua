script:name("WorldParticles") -- Имя скрипта
script:devs({"ConeTin"}) -- Разработчики
script:desc("Красивые партиклы в мире") -- Описание

particles = {
    {
        pos = player:pos(),
        anim = 0
    }
}

events.render_3d:set(function(event)
    local to_remove = {}  -- Список индексов партиклов, которые нужно удалить

    for i, particle in ipairs(particles) do
        speed = 0.005 -- 0.035 / math:max(client:fps(),5) * 75
        particle.anim = math:min(particle.anim + speed, 2)
        size = 2*math:min(particle.anim,1)

        gl11:pushMatrix()
        gl11:enable(gl11.GL_BLEND)
        gl11:translate(
            particle.pos.x - gl11:pos().x, 
            particle.pos.y - gl11:pos().y, 
            particle.pos.z - gl11:pos().z
        )
        
        gl11:rotate(player:yaw(), 0, -1, 0)
        gl11:rotate(player:pitch(), 1, 0, 0)
    
        render:image("glow.png", -size/2, -size/2, size, size, render:alpha(client:client_color(), particle.anim > 1 and 2 - particle.anim or particle.anim))
        
        gl11:popMatrix()

        if particle.anim > 2 then
            table.insert(to_remove, i)
        end
    end

    for _, index in ipairs(to_remove) do
        table.remove(particles, index)
    end

    if player:ticks() % 5 == 0 then
        size = 30
        table.insert(particles, {
            pos = vector.new(
                player:pos().x + gl11:pos().x + math:random(-size,size),
                player:pos().y + gl11:pos().y + math:random(-size,size), 
                player:pos().z + gl11:pos().z + math:random(-size,size)
            ),
            anim = 0
        })
    end

end)