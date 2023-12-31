MAIN_MENU = 1
IN_GAME = 2

LMB = 1
RMB = 2

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

    -- score and timer
    love.graphics.setFont(gameFont)
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.print("Time: " .. math.ceil(timer), 300, 10)

    -- main menu message
    if gameState == MAIN_MENU then
        love.graphics.printf("Click anywhere to begin!", 0, 250, love.graphics.getWidth(), "center")
    end

    -- fps counter
    love.graphics.setFont(fpsFont)
    love.graphics.print(love.timer.getFPS())
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == LMB then
        if gameState == MAIN_MENU then
            gameState = IN_GAME
            timer = 10
            score = 0
        elseif gameState == IN_GAME then
            if withinTheTarget(x, y) then
                score = score + 1
                moveTheTarget()
            else
                if score > 0 then
                    score = score - 1
                end
            end
        end
    elseif button == RMB then
        if gameState == IN_GAME and withinTheTarget(x, y) then
            score = score + 2
            timer = timer - 1
            moveTheTarget()
        end
    end
end

function dist(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function withinTheTarget(x, y)
    return dist(x, y, target.x, target.y) < target.radius
end

function moveTheTarget()
    target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
    target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
end
