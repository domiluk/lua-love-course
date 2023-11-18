MAIN_MENU = 1
IN_GAME = 2

function love.load()
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    score = 0
    timer = 0
    gameState = MAIN_MENU

    fpsFont = love.graphics.getFont()
    gameFont = love.graphics.newFont(40)

    sprites = {}
    sprites.sky = love.graphics.newImage("sprites/sky.png")
    sprites.target = love.graphics.newImage("sprites/target.png")
    sprites.crosshairs = love.graphics.newImage("sprites/crosshairs.png")

    love.mouse.setVisible(false)
end

function love.update(dt)
    timer = timer - dt
    if timer < 0 then
        timer = 0
        gameState = MAIN_MENU
    end
end

function love.draw()
    -- background
    love.graphics.draw(sprites.sky, 0, 0)

    -- target
    if gameState == IN_GAME then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end

    -- crosshairs
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)

    -- score
    love.graphics.setFont(gameFont)
    love.graphics.print(score, 10, 10)
    love.graphics.print(math.ceil(timer), 300, 10)

    -- fps counter
    love.graphics.setFont(fpsFont)
    love.graphics.print(love.timer.getFPS())
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if gameState == MAIN_MENU then
            gameState = IN_GAME
            timer = 10
            score = 0
        elseif gameState == IN_GAME then
            if dist(x, y, target.x, target.y) < target.radius then
                score = score + 1
                target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
                target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
            end
        end
    end
end

function dist(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
