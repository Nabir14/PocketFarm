function PocketEngineInit()
    love.graphics.setDefaultFilter("nearest", "nearest")
    time = 0
end

function PocketEngineUpdate(dt)
    time = time + dt
end

function CallEverySecond(s, callback)
    if time >= s then
        callback()
        time = time - s
    end
end

function Vector2D(x, y)
    local data = {
        x = x,
        y = y
    }

    return data
end

function Rect(position, rotation, scale, origin)
    local data = {
        position = position,
        rotation = rotation,
        scale = scale,
        origin = origin
    }

    return data
end

function Texture2D(path)
    local data = {
        image_data = love.graphics.newImage(path)
    }

    return data
end

function GameObject(sprite, rect)
    local rectangle = rect

    if rectangle == nil then
        rectangle = Rect(Vector2D(0, 0), 0, Vector2D(1, 1), Vector2D(0, 0))
    end

    local data = {
        rect = rectangle,
        sprite = Sprite(sprite)
    }

    return data
end

function Sprite(argument)
    local texture = nil
    local cell_size = nil
    local cell_position = nil
    local sheet_size = nil

    if type(argument) == "table" then
        texture = argument.texture_data
        cell_size = argument.cell_size
        cell_position = argument.cell_position
        sheet_size = argument.sheet_size
    else
        texture = Texture2D(argument)
        local texture_size = Vector2D(texture.image_data:getWidth(), texture.image_data:getHeight())
        cell_size = texture_size
        cell_position = Vector2D(0, 0)
        sheet_size = texture_size
    end

    local data = {
        texture_data = texture,
        sheet_size = sheet_size,
        cell_size = cell_size,
        cell_position = cell_position
    }

    return data
end

function DrawGameObject(game_object)
    local object_rect = game_object.rect
    local object_sprite = game_object.sprite
    
    if object_sprite == nil then
        love.graphics.rectangle(
            "fill",
            object_rect.position.x - object_rect.origin.x,
            object_rect.position.y - object_rect.origin.y,
            object_rect.scale.x,
            object_rect.scale.y
        )
    else
        local object_quad = love.graphics.newQuad(
            object_sprite.cell_position.x * object_sprite.cell_size.x,
            object_sprite.cell_position.y * object_sprite.cell_size.y,
            object_sprite.cell_size.x, 
            object_sprite.cell_size.y,
            object_sprite.sheet_size.x, 
            object_sprite.sheet_size.y
        )
    
        love.graphics.draw(
            object_sprite.texture_data.image_data, 
            object_quad,
            object_rect.position.x,
            object_rect.position.y,
            object_rect.rotation,
            object_rect.scale.x,
            object_rect.scale.y,
            object_rect.origin.x,
            object_rect.origin.y
        )
    end
end

function GridPosition(grid_size, position)
    local snappedPosition = Vector2D(position.x, position.y)
    snappedPosition.x = math.floor(snappedPosition.x / grid_size) * grid_size
    snappedPosition.y = math.floor(snappedPosition.y / grid_size) * grid_size
    return snappedPosition
end