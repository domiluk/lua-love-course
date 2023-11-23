MAIN_MENU = 1
IN_GAME = 2

LMB = 1

function love.load()
    math.randomseed(os.time())

    sprites = {}
    sprites.background = love.graphics.newImage("sprites/background.png")
    sprites.bullet = love.graphics.newImage("sprites/bullet.png")
    sprites.player = love.graphics.newImage("sprites/player.png")
    sprites.zombie = love.graphics.newImage("sprites/zombie.png")

    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.speed = 180

    font = love.graphics.newFont(30)
    love.graphics.setFont(font)

    zombies = {}
    bullets = {}

    gameState = MAIN_MENU
    score = 0
    maxTime = 2
    timer = maxTime
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        spawnZombie()
    end
end

function love.mousepressed(x, y, button)
    if button == LMB and gameState == IN_GAME then
        spawnBullet()
    elseif button == LMB and gameState == MAIN_MENU then
        gameState = IN_GAME
        score = 0
        maxTime = 2
        timer = maxTime
    end
end

function love.update(dt)
    -- player movement
    if gameState == IN_GAME then
        if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
            player.y = math.max(0, player.y - player.speed * dt)
        end
        if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
            player.y = math.min(love.graphics.getHeight(), player.y + player.speed * dt)
        end
        if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
            player.x = math.max(0, player.x - player.speed * dt)
        end
        if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
            player.x = math.min(love.graphics.getWidth(), player.x + player.speed * dt)
        end
    end

    -- move zombies
    for _, zombie in ipairs(zombies) do
        zombie.x = zombie.x + math.cos(zombieFacingPlayerAngle(zombie)) * zombie.speed * dt
        zombie.y = zombie.y + math.sin(zombieFacingPlayerAngle(zombie)) * zombie.speed * dt
        if zombieTouchedThePlayer(zombie) then
            zombies = {}
            gameState = MAIN_MENU
            player.x = love.graphics.getWidth() / 2
            player.y = love.graphics.getHeight() / 2
        end
    end

    -- move bullets
    for _, bullet in ipairs(bullets) do
        bullet.x = bullet.x + math.cos(bullet.direction) * bullet.speed * dt
        bullet.y = bullet.y + math.sin(bullet.direction) * bullet.speed * dt
    end

    -- bullet-zombie collision detection
    for _, zombie in ipairs(zombies) do
        for _, bullet in ipairs(bullets) do
            if bulletHitAZombie(bullet, zombie) then
                zombie.dead = true
                bullet.dead = true
                score = score + 1
            end
        end
    end

    -- remove dead zombies
    for i = #zombies, 1, -1 do
        local zombie = zombies[i]
        if zombie.dead then
            table.remove(zombies, i)
        end
    end

    -- remove dead bullets
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        if bullet.dead or bullet.x < 0 or bullet.y < 0 or bullet.x > love.graphics.getWidth() or bullet.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end

    -- update spawn timer
    if gameState == IN_GAME then
        timer = timer - dt
        if timer <= 0 then
            spawnZombie()
            maxTime = 0.95 * maxTime
            timer = maxTime
        end
    end
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0)

    if gameState == MAIN_MENU then
        love.graphics.printf("Click anywhere to begin!", 0, 50, love.graphics.getWidth(), "center")
    end
    love.graphics.printf("Score: " .. score, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center")

    love.graphics.draw(sprites.player, player.x, player.y, playerFacingMouseAngle(), nil, nil,
        sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)

    for _, zombie in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, zombie.x, zombie.y, zombieFacingPlayerAngle(zombie), nil, nil,
            sprites.zombie:getWidth() / 2, sprites.zombie:getHeight() / 2)
    end

    for _, bullet in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, bullet.x, bullet.y, nil, 0.5, nil,
            sprites.bullet:getWidth() / 2, sprites.bullet:getHeight() / 2)
    end
end

function playerFacingMouseAngle()
    return math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
end

function zombieFacingPlayerAngle(zombie)
    return math.atan2(player.y - zombie.y, player.x - zombie.x)
end

function spawnZombie()
    local zombie = {}
    zombie.speed = 100
    zombie.dead = false

    local side = math.random(1, 4)
    if side == 1 then -- left side
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then -- right side
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 3 then -- top side
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    elseif side == 4 then -- bottom side
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30
    end

    table.insert(zombies, zombie)
end

function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 500
    bullet.dead = false
    bullet.direction = playerFacingMouseAngle()
    table.insert(bullets, bullet)
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function zombieTouchedThePlayer(zombie)
    return distanceBetween(zombie.x, zombie.y, player.x, player.y) < 30
end

function bulletHitAZombie(bullet, zombie)
    return distanceBetween(zombie.x, zombie.y, bullet.x, bullet.y) < 20
end
