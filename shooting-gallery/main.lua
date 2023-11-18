function love.load()
end

function love.update(dt)
end

function love.draw()
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(0.9, 0.6, 0.5)
    love.graphics.rectangle("line", 100, 50, 150, 100)
    love.graphics.rectangle("fill", 200, 200, 200, 200)
    love.graphics.rectangle("fill", 300, 300, 200, 200)

    love.graphics.setBlendMode("add")
    love.graphics.setColor(1, 0, 0, 0.9)
    love.graphics.circle("fill", 500, 360, 100)
    love.graphics.setColor(0, 1, 0, 0.9)
    love.graphics.circle("fill", 450, 450, 100)
    love.graphics.setColor(0, 0, 1, 0.9)
    love.graphics.circle("fill", 550, 450, 100)

    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(love.timer.getFPS())
end
