function Farm(grid_size, size, position)
    local farm_lands = {}
    
    for x = 1, size.x do
        for y = 1, size.y do
            table.insert(farm_lands, FarmLand(Vector2D((x+position.x)*grid_size, (y+position.y)*grid_size)))
        end
    end
    
    local data = {
        farm_lands = farm_lands
    }

    return data
end

function FarmLand(position)
    local data = {
        position = position,
        is_occupied = false,
        occupied_by = {}
    }

    return data
end

function Crop(game_object, sprites)
    local data = {
        object = GameObject(game_object.sprite, Rect(game_object.rect.position, game_object.rect.rotation, game_object.rect.scale, game_object.rect.origin)),
        age_sprites = sprites,
        age = 0,
        growth = 0.2,
    }

    return data
end