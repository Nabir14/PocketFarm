require("pocket_farm.engine")
require("pocket_farm.functions")
require("pocket_farm.objects")

function love.load()
    PocketEngineInit()

    local window_center = Vector2D(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
    local map_sprite = Sprite("assets/map.png")
    local items_spritesheet = Sprite("assets/items.png")
    
    map = GameObject(map_sprite)
    map.rect.position = Vector2D(window_center.x, window_center.y)
    map.rect.origin = Vector2D(
        map.sprite.texture_data.image_data:getWidth() * 0.5, 
        map.sprite.texture_data.image_data:getHeight() * 0.5
    )
    map.rect.scale = Vector2D(4, 4)

    items_spritesheet.cell_size = Vector2D(16, 16)

    local carrot = GameObject(items_spritesheet)
    carrot.sprite.cell_position = Vector2D(3, 2)
    carrot.rect.scale = Vector2D(3, 3)
    carrot.rect.origin = Vector2D(carrot.sprite.cell_size.x * 0.5, carrot.sprite.cell_size.y * 0.5)
    
    carrot_seeds = GameObject(items_spritesheet)
    carrot_seeds.sprite.cell_position = Vector2D(4, 0)
    carrot_seeds.rect.scale = Vector2D(3, 3)
    carrot_seeds.rect.origin = Vector2D(carrot_seeds.sprite.cell_size.x * 0.5, carrot_seeds.sprite.cell_size.y * 0.5)

    carrot_sprite_1 = Sprite(items_spritesheet)
    carrot_sprite_1.cell_position = Vector2D(3, 2)

    carrot_sprite_2 = Sprite(items_spritesheet)
    carrot_sprite_2.cell_position = Vector2D(4, 2)
    
    carrot_crop = Crop(carrot, {
        carrot_sprite_1,
        carrot_sprite_2
    })
    
    farm_land = FarmLand(GridPosition(16, Vector2D(window_center.x, window_center.y)))
    farm_land1 = FarmLand(GridPosition(16, Vector2D(window_center.x+32, window_center.y)))
end

function love.mousepressed(x, y, button)
    if IsMouseAboveFarmland(farm_land, Vector2D(x, y)) then
        HarvestCrop(farm_land, carrot_crop)
    elseif IsMouseAboveFarmland(farm_land1, Vector2D(x, y)) then
        HarvestCrop(farm_land1, carrot_crop)
    end
end

function love.update(dt)
    PocketEngineUpdate(dt)

    local grid_mouse_position = GridPosition(16, Vector2D(love.mouse.getPosition()))    
    carrot_seeds.rect.position = grid_mouse_position

    CallEverySecond(1, UpdateGameTick)
end

function love.draw()
    DrawGameObject(map)
    DrawFarmLand(farm_land)
    DrawFarmLand(farm_land1)
    DrawGameObject(carrot_seeds)
end

function UpdateGameTick()
    UpdateFarmLand(farm_land)
    UpdateFarmLand(farm_land1)
end