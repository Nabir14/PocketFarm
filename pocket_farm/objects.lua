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