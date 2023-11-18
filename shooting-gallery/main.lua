function love.load()
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    score = 0
    timer = 10

    fpsFont = love.graphics.getFont()
    gameFont = love.graphics.newFont(40)
end

function love.update(dt)
    timer = timer - dt
    if timer < 0 then
        timer = 0
    end
end

function love.draw()
    -- target
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", target.x, target.y, target.radius)

    -- score
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)
    love.graphics.print(score, 10, 10)
    love.graphics.print(math.ceil(timer), 300, 10)

    -- fps
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fpsFont)
    love.graphics.print(love.timer.getFPS())
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if dist(x, y, target.x, target.y) < target.radius then
            score = score + 1
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        end
    end
end

function dist(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
