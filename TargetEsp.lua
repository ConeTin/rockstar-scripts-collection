script:name("TargetEsp")
script:devs({"qrk.lua"})
script:desc("xyz")

rotating = 0.0
rotationSpeed = 6
interpolatedSpeed = 0.0
interpolateDirection = 0.1
initialSize = 100.0
size = 100
rotationDirection = 1.1
border = 365
anim = animation.new()
pos = vector.new(0,0,0)
distance = 1

events.render_2d:set(function(event)
    if client:aura_target() ~= nil then
        anim:animate(1, 100)
        pos = client:aura_target():pos()
        distance = player:distance(client:aura_target())
    else
        anim:animate(0, 100)
    end

    cords = render:world_to_screen(pos.x, pos.y + 1, pos.z)
    if cords ~= nil then
        print(1)
        gl11:pushMatrix()
        gl11:translate(cords[1], cords[2], 0)
        gl11:rotate(rotating, 0, 0, 1)

        render:image("targetesp.png", -size/2, -size/2, size, size, render:alpha(client:client_color(), 0.5 * anim:get()))

        gl11:popMatrix()
    end
end)