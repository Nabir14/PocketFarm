require("pocket_farm.engine")
require("pocket_farm.constants")

function IsMouseAboveFarmland(farm_land, mouse_position)
    local grid_mouse_position = GridPosition(16, mouse_position)

    if grid_mouse_position.x == farm_land.position.x and grid_mouse_position.y == farm_land.position.y then
        return true
    else
        return false
    end
end

function UpdateFarmLand(farm_land)
    if farm_land.is_occupied then
        if IsCropFullyGrown(farm_land.occupied_by) then
            farm_land.occupied_by.object.sprite = farm_land.occupied_by.age_sprites[2]
        else
            farm_land.occupied_by.age = farm_land.occupied_by.age + farm_land.occupied_by.growth
            farm_land.occupied_by.object.sprite = farm_land.occupied_by.age_sprites[1]
        end
    end
end

function DrawFarmLand(farm_land)
    if farm_land.is_occupied then
        DrawGameObject(farm_land.occupied_by.object)
    end
end


function IsCropFullyGrown(crop)
    if crop.age >= CROP_MAX_AGE then
        return true
    else
        return false
    end
end

function HarvestCrop(farm_land, crop)
    if farm_land.is_occupied then
        if IsCropFullyGrown(farm_land.occupied_by) then
            farm_land.is_occupied = false
            farm_land.occupied_by = {}
        end
    else
        crop.object.rect.position = farm_land.position
        farm_land.is_occupied = true
        farm_land.occupied_by = Crop(crop.object, crop.age_sprites)
    end
end