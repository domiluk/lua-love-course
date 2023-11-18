function love.load()
end

function love.update(dt)
end

function love.draw()
    love.graphics.rectangle("fill", 100, 50, 150, 100)
    love.graphics.rectangle("line", 300, 100, 200, 100)
    love.graphics.circle("fill", 300, 200, 60)

    love.graphics.print(love.timer.getFPS())
end
