pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

function player_gfx_controller(p)

    -- f,x,y,h,v
       local pickaxe_frames = {
        [0] = { {6,8,0,false,false},{5,6,6,false,true},{4,0,8,false,true} },
        [1] = { {4,0,-8,false,false},{5,6,-6,false,false},{6,8,0,false,false} },
        [2] = { {6,-8,0,true,false},{5,-6,-6,true,false},{4,0,-8,true,false} },
        [3] = { {4,0,-8,true,false},{5,-6,-6,true,false},{6,-8,0,true,false} },
       }
   
       local player_dir = 0
       local step_state = 0
       local step_timer = 0
       local pickaxe_frame_timer = 0
   
       local triforce_timer = 0
   
   
       local damage_timer = 0
   
       local dmg = function()
           damage_timer = 15
           sfx(24)
       end
       local f = function()
       
           step_timer -= 1
           damage_timer -= 1
           pickaxe_frame_timer -= pickaxe_frame_timer > 1 and 0.7 or 0.2
           if step_timer <= 0 then step_state = 0 else step_state = 16 end 
       
           if (btnp(⬇️)) player_dir = 0 step_timer = 6
           if (btnp(➡️)) player_dir = 1 step_timer = 6
           if (btnp(⬆️)) player_dir = 2 step_timer = 6
           if (btnp(⬅️)) player_dir = 3 step_timer = 6
       
   
           if (triforce_timer > 0) then
               local inv_triforce_timer = 15-triforce_timer
               local qq = 16
               if pavuk_active then
                   local xb, yb = player.x+4, player.y+4
                   spr(31, player.x+16*sin((triforce_timer    ) / qq)      , player.y+16*cos((triforce_timer    ) / qq))
                   spr(31, player.x+16*sin((triforce_timer)     / qq + 1/3), player.y+16*cos((triforce_timer)     / qq + 1/3))
                   spr(31, player.x+16*sin((triforce_timer)     / qq + 2/3), player.y+16*cos((triforce_timer)     / qq + 2/3))
                   rectfill(xb - triforce_timer/4, yb, xb + triforce_timer / 4, 0,7)
                   spr(4,player.x,player.y-8)
               end
               
               spr(20,player.x,player.y)
           else
               if (damage_timer > 0) then
                   for i=1,15 do
                       pal(i,1+flr(rnd(15)))
                   end
               end
               spr(player_dir+step_state,player.x, player.y)
               pal()
           end
   
           if pickaxe_frame_timer >= 0 then
               local animation_set = pickaxe_frames[player_dir]
               local pickaxe_animation_duration = 3
               local current_pickaxe_frame = ceil(pickaxe_animation_duration - pickaxe_frame_timer)
               local cpfd = animation_set[current_pickaxe_frame]
   
               if cpfd then
                   if (pickaxe_double_flag) then
                       pal(6,12)
                   end
                   spr(cpfd[1], player.x + cpfd[2], player.y + cpfd[3], 1,1, cpfd[4], cpfd[5])
                   pal()
               else
                   print(cpfd)
                   print(animation_set)
                   print(current_pickaxe_frame)
               end
           end
   
           
           triforce_timer -= 1
           
   
       end
       
       local s = function() pickaxe_frame_timer = 3	end
   
       local g = function()
           return player_dir
       end
   
       
       function do_triforce(s)
           triforce_timer = 15
       end
   
       local get_triforce_timer = function()
           return triforce_timer
       end
       
       return f,s,g,dmg,do_triforce,get_triforce_timer
       
   end
   
   game_won = false
   
   stable_win_timer = 0
   wtimer = 0
   wtd = 0.1
   function win_game()
       music(-1)
       camera_speed = 0
       enable_win_sequence = true
   end
   
   function end_game_win()
       music(37)
       while true do
           stable_win_timer += 1
           wtd *= 1.3
           wtimer += wtd
           rectfill(64-wtimer*2,0,64+wtimer*2,128,1)
           rectfill(64-wtimer*1.5,0,64+wtimer*1.5,128,2)
           rectfill(64-wtimer*1.3,0,64+wtimer*1.3,128,13)
           rectfill(64-wtimer,0,64+wtimer,128,7)
           
           if (stable_win_timer > 90) then
               if (stable_win_timer == 91) sfx(37)
               print('yOU WIN!',12,32,1)
               print('tHANK YOU FOR PLAYING!')
               print('')
               if not is_hard_mode then
                   print('tO ENABLE HARD MODE,')
                   print('HIT THE STARTING CHEST')
                   print('3 TIMES FROM THE TOP')
                   print('AND WAIT 3 SECONDS')
               else
                   print('you have done well!')
                   print('')
                   print('iN THE COMMENTS,')
                   print('SAY THE MAGIC WORD')
                   print('"cucumber"')
                   print('TO PROVE YOUR WORTH!')
               end
           end
           if (stable_win_timer > 120 and btn() > 0) then
               reload()
               reset()
               run()
           end
           flip()
       end
   end
   
   
   function spider_gfx_controller(p)
       local pavuk_health = 100
       local pavuk_timer = 0
       local pavuk_damage_timer = 0
       pavuk_descend = 64
       local pavuk_shoot_timer = -1
   
       local boss_phase_2 = false
   
       
       local d = function(n)
           local dmg_to_deal = n
           if is_hard_mode then dmg_to_deal*=0.75 end
           pavuk_damage_timer = 15
           pavuk_health -= dmg_to_deal
   
           if (pavuk_health < 1) then win_game() end
       end
   
       local f = function()
   
           if (pavuk_health < 50 and not boss_phase_2) camera_speed += 0.1 boss_phase_2 = true sfx(44)
   
           fk_arms = {
               {-32,16},
               {-32,6},
               {-24,10},
               {-24,22},
               
               {32,16},
               {32,6},
               {24,10},
               {24,22},
           }
   
           
   
           pavuk_timer += tmp_camera_speed or 0
   
           
           pavuk_damage_timer -= 1
           
           if (pavuk_shoot_timer == 0) then
               build_spider_projectile(player)
               sfx(19)
           end
           
           if (pavuk_shoot_timer < -30*(is_hard_mode and 5 or 7)) pavuk_shoot_timer = 30
           
           
           
           
           local pavuk_base_color = 5
           
           if (pavuk_damage_timer > 0) pal(pavuk_base_color,flr(rnd(15))+1)
           
           local c_bak = peek4(0x5f28)
           camera(-64,pavuk_descend)
           
           if pavuk_descend > 0 and pavuk_active then
               pavuk_descend -= 1
               pavuk_timer += 1
           end
           if pavuk_descend <= 0 then
               pavuk_shoot_timer -= 1
           end
           
           local function draw_fk_arms(c,a,b)
               for i=1,#fk_arms do
                   local arm = fk_arms[i]
                   local offset_x = sin((i>4 and pavuk_timer or -pavuk_timer) /40+i/4 + (i>4 and 0.2 or 0))*8
                   local offset_y = cos((i>4 and pavuk_timer or -pavuk_timer) /40+i/4 + (i>4 and 0.2 or 0))*8
                   for vi = a,b do
                       line(0,24+vi,arm[1]+offset_x,arm[2]+offset_y+vi,c)
                       
                       line(
                           arm[1]+offset_x,
                           arm[2]+offset_y+vi,
                           arm[1]+offset_x+(arm[1]+offset_x)/2,
                           arm[2]+offset_y+(arm[2]+offset_y)/2+vi,
                           c
                       )
                   end
               end
           end
           
   
           
           draw_fk_arms(0,-1,5)
           ovalfill(-21,-1,21,33,0)
           
           spr(47,-12,24,1,2)
           spr(47,4,  24,1,2,true)
           
           fillp(0b1010010110100101)
           draw_fk_arms(pavuk_base_color,0,4)
           fillp()
           ovalfill(-20,0,20,32,pavuk_base_color)
           
           pal()
           local eye_anchor_x = 0
           local eye_anchor_y = 24
           
           circfill(0,24,7,7)
           
           local phi = atan2(eye_anchor_y-player.y,eye_anchor_x-player.x+64)
           
           if (pavuk_damage_timer > 0) then
               phi = pavuk_timer*0.9
           end
           local pdx = -sin(phi)*4
           local pdy = -cos(phi)*4
           
           
           global_spider_eye_pos_x=eye_anchor_x+pdx
           global_spider_eye_pos_y=eye_anchor_y+pdy
   
   
           local eye_color = 8
           if (pavuk_shoot_timer > 0) then
               if (pavuk_shoot_timer%2==0) eye_color = 9
               fillp(0b01011010010110100101)
               circ(global_spider_eye_pos_x,global_spider_eye_pos_y,pavuk_shoot_timer,0x81)
               fillp()
           end
           
           circfill(global_spider_eye_pos_x,global_spider_eye_pos_y,3,eye_color)
           
           spr(9,-12,-2,3,3)
           spr(28,-22,6,2,2)
           spr(28,6,6,2,2,true)
   
           spider_gun.x = global_spider_eye_pos_x+60
           spider_gun.y = global_spider_eye_pos_y-4
           
           poke4(0x5f28,c_bak)
           
           pavuk_health = mid(0,pavuk_health,100)
           if (pavuk_descend <= 0) then
               rectfill(3,3,125,6,0)
               rectfill(3,3,3+(pavuk_health/100)*125,6,8)
               
               print('🐱 gIANT ENEMY SPIDER',4,4,0)
               print('🐱 gIANT ENEMY SPIDER',3,3,7)
           end
   
       end
   
       return f,d
   end
   
   local draw_p, atk_p = player_gfx_controller()
   local s_gfx = spider_gfx_controller()
-- A* pathfinding
-- by @richy486

function astar(startx, starty, goalx, goaly)
    printh("---------------")
    printh("starting a star")

    local start = { startx, starty }
    local goal = { goalx, goaly }

    printh("start...")

    local frontier = {}
    insert(frontier, start, 0)
    local came_from = {}
    came_from[vectoindex(start)] = nil
    local cost_so_far = {}
    cost_so_far[vectoindex(start)] = 0

    local found = false
    while #frontier > 0 and #frontier < 1000 do
        local current = popEnd(frontier)

        if vectoindex(current) == vectoindex(goal) then
            found = true
            break
        end

        local neighbours = getNeighbours(current)
        for next in all(neighbours) do
            local nextIndex = vectoindex(next)
            local new_cost = cost_so_far[vectoindex(current)] + 1

            if not cost_so_far[nextIndex] or new_cost < cost_so_far[nextIndex] then
                cost_so_far[nextIndex] = new_cost
                local priority = new_cost + heuristic(goal, next)
                insert(frontier, next, priority)
                came_from[nextIndex] = current
            end
        end
    end

    printh("find goal..")
    if not found then
        printh("no path found.")
        return nil
    end

    local current = came_from[vectoindex(goal)]
    if not current then
        printh("path incomplete.")
        return nil
    end

    local path = {}
    local sindex = vectoindex(start)
    local cindex = vectoindex(current)

    while current and cindex != sindex do
        add(path, current)
        current = came_from[cindex]
        if current then
            cindex = vectoindex(current)
        else
            break
        end
    end

    if cindex != sindex then
        printh("path incomplete.")
        return nil
    end

    reverse(path)

    path[#path + 1] = goal

    printh("..done")
    if #path == 0 then
        return nil
    end

    return { x = path[1][1], y = path[1][2] }
end

function heuristic(a, b)
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function getNeighbours(pos)
    local neighbours = {}
    local x = pos[1]
    local y = pos[2]

    if x > 0 and not fget(mget(x - 1, y), 0) then
        add(neighbours, { x - 1, y })
    end
    if x < 15 and not fget(mget(x + 1, y), 0) then
        add(neighbours, { x + 1, y })
    end
    if y > 0 and not fget(mget(x, y - 1), 0) then
        add(neighbours, { x, y - 1 })
    end
    if y < 15 and not fget(mget(x, y + 1), 0) then
        add(neighbours, { x, y + 1 })
    end

    if (x + y) % 2 == 0 then
        reverse(neighbours)
    end

    return neighbours
end

function insert(t, val, p)
    if #t >= 1 then
        add(t, {})
        for i = #t, 2, -1 do
            local next = t[i - 1]
            if p < next[2] then
                t[i] = { val, p }
                return
            else
                t[i] = next
            end
        end
        t[1] = { val, p }
    else
        add(t, { val, p })
    end
end

function popEnd(t)
	local top = t[#t]
	del(t, t[#t])
	return top[1]
end

function reverse(t)
    for i = 1, (#t / 2) do
        local temp = t[i]
        local oppindex = #t - (i - 1)
        t[i] = t[oppindex]
        t[oppindex] = temp
    end
end

function vectoindex(vec)
    return maptoindex(vec[1], vec[2])
end

function maptoindex(x, y)
    return ((x + 1) * 16) + y
end
-- reload(0,0,0x4300,'assets.p8')

tile_size = 8

step = 0

local player_gfx_draw, player_swing_pick, get_player_dir, player_hurt_anim, do_triforce, get_triforce_timer = player_gfx_controller(player)
local spider_gfx_draw, spider_damage = spider_gfx_controller(player)

world_seed = rnd(9999)
world_vertical_position = 0


map_offset_x = 2
map_offset_y = 1
map_size_x = 13
map_size_y = 18

camera_offset = 0 
camera_speed = 0--0.2

GEM_POWER = 12
GEM_UPGRADE = 13
GEM_PROJECTILE = 14
GEM_HP = 15

gem_power_count = 0
gem_upgrade_count = 5
gem_projectile_count = 3
health = 3
extra_dig_chance = 0
boss_health = 100

spider_collider_y = 4 * tile_size
push_size = 4

pickaxe_double_flag = false

gem_drop = {[160] = 12,[161] = 13,[162] = 14,[163] = 15}

floor_tile = 145

player = {}

enemies = {}
projectiles = {}
puffs = {}
puffs_top = {}

spider_gun = {x = 7 * tile_size, y = 2 * tile_size}
spider_attack_speed = 5
spider_projectiles = {}

spider_projectiles_speed = 2

global_timer = 0

intro_sequence_timer = -1
hard_mode_timer = 0
hard_mode_punch_counter = 0
is_hard_mode = false

function spider_proj_draw()
    for i=1,#spider_projectiles,1 do
        local proj = spider_projectiles[i]
        if proj !=nil then 
            circfill(proj.x+4, proj.y+4, 4+sin(global_timer/4),2)
            circfill(proj.x+4, proj.y+4, 3+sin(global_timer/4),8) 
            circfill(proj.x+4, proj.y+4, 2+sin(global_timer/4),9) 
            circfill(proj.x+4, proj.y+4, sin(global_timer/4),10) 
        end
    end
end

function spider_proj_update()
    for i=1,#spider_projectiles,1 do
        local proj = spider_projectiles[i]
        if proj != nil then 
            if proj.x <= player.x + 4 and proj.x >= player.x - 4 and 
                proj.y <= player.y + 4 and proj.y >= player.y - 4 then
                del(spider_projectiles, proj)
                health -= 1
                player_hurt_anim()
            elseif proj.y >= 144 then
                del(spider_projectiles, proj)
            else 
                proj.x += proj.dx 
                proj.y += proj.dy
            end
        end
    end
end


function build_spider_projectile(p)
    local tx = player.x - spider_gun.x
    local ty = player.y - spider_gun.y
    
    if tx != 0 or ty != 0 then
        local angle = atan2(ty, tx)
        
        local dx = sin(angle) * spider_projectiles_speed
        local dy = cos(angle) * spider_projectiles_speed

        spider_projectiles[#spider_projectiles+1] = {
            x = spider_gun.x,
            y = spider_gun.y,
            dx = dx,
            dy = dy,
        }
    end
end



projectiles_speed = 4

function make_puff(x,y,n,m) 
    return {
        x = x,
        y = y,
        life = 0,
        n=n or 55,
        m=m or 6
    }
end

function proj_draw()
    for i=1,#projectiles,1 do
        local proj = projectiles[i]
        if proj !=nil then spr(30, proj.x, proj.y) end
    end
end

function proj_update()
    for i=1,#projectiles,1 do
        local proj = projectiles[i]
        if proj != nil then 
            local curr_tile_n = mget((proj.x + proj.dx) / tile_size, (proj.y + proj.dy) / tile_size)
            if fget(curr_tile_n, 0) and not fget(curr_tile_n, 1) then
                del(projectiles, proj)
            end
            proj.x += proj.dx 
            proj.y += proj.dy
        end
    end
end

function proj_enemy_collide()
    for i=1,#projectiles,1 do
        local proj = projectiles[i]
        if proj != nil then
            for i=1,#enemies,1 do
                local em = enemies[i]
                if em != nil and em.x / tile_size == proj.x / tile_size and em.y / tile_size == proj.y / tile_size then
                    puffs[#puffs+1] = make_puff(em.x, em.y)
                    del(projectiles, proj)
                    del(enemies, em)
                    sfx(28)
                end
            end
        end
    end
end

function proj_spider_collide()
    if not pavuk_active then return end
    for i=1,#projectiles,1 do
        local proj = projectiles[i]
        if proj != nil then
            if proj.y < spider_collider_y + 1 and proj.x > 5 * tile_size and proj.x < 10 * tile_size then
                del(projectiles, proj)
                spider_damage(2)
                sfx(38)
            end
        end
    end
end


function build_projectile(p)
    local v = get_player_dir()
    
    local dx = 0
    local dy = 0

    if v == 0 then 
        dx = 0
        dy = projectiles_speed
    end
    if v == 1 then 
        dx = projectiles_speed
        dy = 0
    end
    if v == 2 then 
        dx = 0
        dy = -projectiles_speed
    end
    if v == 3 then 
        dx = -projectiles_speed
        dy = 0
    end
    
    projectiles[#projectiles+1] = {
        x = p.x,
        y = p.y,
        dx = dx,
        dy = dy,
    }
end

vectors = {
    [0] = {0, -1},
    [1] = {1, 0},
    [2] = {0, -1},
    [3] = {-1, 0}
}



en_builds = {
    [1] = build_snake,
    [2] = build_flame,
    [3] = build_bat,
}

function build_snake(x, y) 
    local function draw(self)
        spr(self.sprites[self.curr_spr], self.x, self.y, 1, 1, self.flip)
    end

    local function next_step(self)
        local move = tile_size * self.dir
        curr_tile_n = mget((self.x + move) / tile_size, self.y / tile_size)
        
        if fget(curr_tile_n, 0) then
            self.dir *= -1
            self.flip = not self.flip
            move = 0
        end
        
        self.x += move

        self.curr_spr += 1
        if self.curr_spr > #self.sprites then self.curr_spr = 1 end
    end

    return {
        x=x,
        y=y,
        draw=draw,
        next_step=next_step,
        flip=false,
        dir=1,
        sprites={23, 24},
        curr_spr=1,
    }
end

function sign(n)
    if n == 0 then
        return 0
    else
        return n / abs(n)
    end
end


function build_bat(x, y) 
    local function draw(self)
        spr(self.sprites[self.curr_spr], self.x-4, self.y, 1, 1, self.flip)
        spr(self.sprites[self.curr_spr], self.x+4, self.y, 1, 1, not self.flip)
    end

    local function next_step(self)
        local next_move = astar(self.x / tile_size, self.y / tile_size, player.x / tile_size, player.y / tile_size)
        if next_move != nil and next_move.x != nil and next_move.y != nil then
            self.x = next_move.x * tile_size
            self.y = next_move.y * tile_size
        end
        -- local dir = {x = (player.x - self.x), y = (player.y - self.y)}
        -- local move = {x = sign(dir.x) * tile_size, y = sign(dir.y) * tile_size}

        -- if dir.x != 0 and dir.y != 0 then
        --     if fget(mget((self.x + move.x) / tile_size, self.y / tile_size), 0) then 
        --         move.y = 0
        --     else 
        --         move.x = 0
        --     end
        -- end

        -- if abs(dir.x) >= abs(dir.y) and fget(mget((self.x + move.x) / tile_size, (self.y + move.y) / tile_size), 0) then 
        --     move.x = 0
        --     move.y = sign(dir.y) * tile_size
        -- end
        
        -- if move.x != 0 and move.y != 0 then
        --     move.y = 0
        --     move.x = sign(dir.x) * tile_size
        -- end

        -- if abs(player.y - self.y) > 0 and move.x == 0 and fget(mget(self.x / tile_size, (self.y + sign(dir.y) * tile_size) / tile_size), 0) then 
        --     move.x = 0
        --     move.y = sign(dir.y) * tile_size
        -- end


        -- curr_tile_n = mget((self.x + move.x) / tile_size, (self.y + move.y) / tile_size)
        
        -- if fget(curr_tile_n, 0) then
        --     move.x = 0
        --     move.y = 0
        -- end
        
        
        -- self.x += move.x
        -- self.y += move.y

        self.curr_spr += 1
        if self.curr_spr > #self.sprites then self.curr_spr = 1 end
    end

    return {
        x=x,
        y=y,
        draw=draw,
        next_step=next_step,
        flip=false,
        dir=1,
        sprites={7, 8},
        curr_spr=1,
    }
end

function build_flame(x, y) 
    local function draw(self)
        spr(39, self.x, self.y, 1, 1, self.flip)
    end

    local function next_step(self)
        local move = tile_size * self.dir
        curr_tile_n = mget(self.x / tile_size, (self.y + move) / tile_size)
        
        if fget(curr_tile_n, 0) then
            self.dir *= -1
            move = 0
        end
        
        self.y += move
        self.flip = not self.flip
    end

    return {
        x=x,
        y=y,
        draw=draw,
        next_step=next_step,
        flip=false,
        dir=-1,
    }
end

function enemies.draw(self)
    for i=1,#enemies,1 do
        enemies[i].draw(enemies[i])
    end
end

function enemies.next_step(self)
    for i=1,#enemies,1 do
        enemies[i].next_step(enemies[i])
    end
end


menuitem(1,'win game', win_game)



function player.draw(self) 
    player_gfx_draw()
end

function _init()
    player.x = 4 * tile_size
    player.y = 3 * tile_size
    gem_power_count = 0
    gem_upgrade_count = 0
    gem_projectile_count = 5
    health = 3
    extra_dig_chance = 0
    boss_health = 100

end

game_started = false
music(33)

hit_count = 0

function updategame()
    global_timer += 1

    if hard_mode_punch_counter > 0 then
        hard_mode_timer += 1
    end

    if hard_mode_timer == 90 then
        if hard_mode_punch_counter == 3 then
            is_hard_mode = true
        else
            hard_mode_punch_counter = 0
            hard_mode_timer = 0
        end
    end
    if (not game_started) then
        if (btnp()>0) then
            -- music(1)
            game_started = 1
        else
            return
        end
    end
    move = {x = 0, y = 0}
    if (get_triforce_timer() < 0) then
        
        if btnp(0) then
            sfx(23)
            move.x = -tile_size
        end
        if btnp(1) then
            sfx(23)
            move.x = tile_size
        end
        if btnp(2) then
            sfx(23)
            move.y = -tile_size
        end
        if btnp(3) then 
            sfx(23)
            move.y = tile_size
        end
        if btnp(4) and gem_projectile_count > 0 then 
            sfx(27)
            gem_projectile_count -= 1 
            build_projectile(player)
        end
        -- debug spider proj
        -- if btnp(5) then
        --     build_spider_projectile(player)
        -- end

        if ( gem_power_count > 2 and btnp(❎)) then
			do_triforce()

		    sfx(26) sfx(25)
            gem_power_count = 0

            if player.x > 64-32 and player.x < 64+32 then
                spider_damage(25)
            end
		end

    end

    curr_tile_n = mget((player.x + move.x) / tile_size, (player.y + move.y) / tile_size)

    if fget(curr_tile_n, 0) and not fget(curr_tile_n, 1) then --dig
        
        if (curr_tile_n == 189 or curr_tile_n == 190) then
            do_triforce()
            intro_sequence_timer = 0
            music(-1)
            sfx(25)
            mset(7,9, 171)
            mset(8,9, 172)
            mset(7,10, 187)
            mset(8,10, 188)
            move.x = 0
            move.y = 0
        elseif (curr_tile_n == 173 or curr_tile_n == 174) then
            hard_mode_punch_counter += 1
            sfx(46) 
            move.x = 0
            move.y = 0
        else
            if gem_drop[curr_tile_n] then 
                mset((player.x + move.x) / tile_size, (player.y + move.y) / tile_size, gem_drop[curr_tile_n])
            else 
                local tile_offset = 16
                if (pickaxe_double_flag) then
                    tile_offset = 32
                end
                mset((player.x + move.x) / tile_size, (player.y + move.y) / tile_size, curr_tile_n+tile_offset)
            end
            move.x = 0
            move.y = 0
            player_swing_pick()
            sfx(22)
        end
    end
    if fget(curr_tile_n, 1) then --stop
        move.x = 0
        move.y = 0
    end
    if fget(curr_tile_n, 3) then --pick
        sfx(21)
        mset((player.x + move.x) / tile_size, (player.y + move.y) / tile_size, floor_tile)
        flash_timer = 15
        if (curr_tile_n == GEM_POWER) gem_power_count += 1  flash_colors_current = flash_colors_power
        if (curr_tile_n == GEM_UPGRADE) gem_upgrade_count += 1  flash_colors_current = flash_colors_upgrade
        if (curr_tile_n == GEM_PROJECTILE) gem_projectile_count += 3 flash_colors_current = flash_colors_projectile
        if (curr_tile_n == GEM_HP) health += 1
        if (curr_tile_n == 45) health += 3

        if (gem_power_count > 3) gem_power_count = 3
        if (gem_upgrade_count > 6) gem_upgrade_count = 6
        if (health > 3) health = 3
    end

    if player.y > 15 * tile_size then move.y = 0 end

    player.x += move.x
    player.y += move.y

    enemy_collide()

    tmp_camera_speed = camera_speed

    if player.y > tile_size * 11 then tmp_camera_speed *= 5 end

    if health <= 0 then gameover() end

    camera_offset += tmp_camera_speed
    if camera_offset > 8 then 
        camera_offset -= 8
        next_step() 
    end 

    if (gem_power_count == 3) then
        -- gem power trigger here
        flash_colors_current = flash_colors_power
        flash_timer = 3
    end
    if flash_timer == 2 then

        if (gem_upgrade_count > 5) then
            -- gem upgrade trigger here
            if(pickaxe_double_flag == false) sfx(20)
            pickaxe_double_flag = true
            
        end
    end

    proj_update()
    proj_spider_collide()
    proj_enemy_collide()

    spider_proj_update()
    player.y = mid(0,player.y,120)

    if (enable_win_sequence and global_timer%2 == 0) then
        puffs_top[#puffs_top+1] = make_puff(64+rnd(30)-15, rnd(28), 48)
        sfx(45)
        explo_count += 1
        if (explo_count > 32) then
            end_game_win()
        end
    end

    if global_timer % 20 == 0 then
        enemies:next_step()
    end
end

explo_count = 0

function enemy_collide()
    for i=1,#enemies,1 do
        local em = enemies[i]
        if em != nil and player.x / tile_size == em.x / tile_size and player.y / tile_size== em.y / tile_size then
            del(enemies, em)
            health -= 1
            player_hurt_anim()
        end
    end
end

flash_timer = 0
flash_colors_upgrade = {12, 13}
flash_colors_power = {10, 9, 8}
flash_colors_projectile = {11, 3, 5}

flash_colors_current = {}
function drawgame()
    cls(0)
    camera(0, camera_offset)
    map(0, 0, 0, 0, 16, 17)
    player:draw()
    pal(15,0)
    enemies:draw()
    for p in all(puffs) do
        spr(p.n+p.life,p.x,p.y)
        if p.life >= p.m then del(puffs,p) end
        p.life += 1
    end
    proj_draw()

    -- hud
    camera()
    map(16, 0, 0, 0, 16, 16)
    spider_gfx_draw()
    spider_proj_draw()
    
    for i=1,3 do
        if i<=health then
            spr(GEM_HP,120,24+i*9)
        else
            spr(GEM_HP+64,120,24+i*9)
        end
    end


    if (flash_timer > 0) then
        flash_timer -= 1
        for n in all(flash_colors_current) do
            pal(n,1+flr(rnd(14)))
        end
    end

    if (flash_timer == 1) then
        for n in all(flash_colors_current) do
            pal(n,n)
        end
    end

    for i=1,6 do
        if i<=gem_upgrade_count then
            spr(GEM_UPGRADE,0,24+i*9)
        else
            spr(GEM_UPGRADE+64,0,24+i*9)
        end
    end

    for i=1,3 do
        if i<=gem_power_count then
            spr(GEM_POWER,120,32+24+i*9)
        else
            spr(GEM_POWER+64,120,32+24+i*9)
        end
    end



    if (gem_projectile_count < 1) then 
        spr(GEM_PROJECTILE+64,0,100)
    else
        print(gem_projectile_count,2,94,6)
        spr(GEM_PROJECTILE,0,100)
    end

    pal()
    --debug
    -- print(#enemies, 0, 0, 7)
    -- print(want_spawn_gem,16,0)

    wtf_timer+=0.02
    if (not game_started) then
        local d = function(wtf_timer,c)
            print('   mINER vITALYA ii',24+cos(wtf_timer*1.1)*3,64+cos(wtf_timer/3.3)*4,c)
            print('sPIDER cAVE oFFENSIVE')
        end

        d(wtf_timer-0.12,2)
        d(wtf_timer-0.08,13)
        d(wtf_timer-0.04,6)
        d(wtf_timer,7)
    end

    
    if (intro_sequence_timer >= 0) then
        intro_sequence_timer += 1
        if (intro_sequence_timer < 60) then
            local ii = (intro_sequence_timer*intro_sequence_timer)/18
            local iii = ii/6
            -- INTRO SEQUENCE
            pal(1,0)
            palt(1,true)
            spr(12, 60 + sin(iii/16      ) * ii, 78 + cos(iii/16       )  * ii)
            spr(13, 60 + sin(iii/16 + 1/4) * ii, 78 + cos(iii/16 + 1/4 )  * ii)
            spr(14, 60 + sin(iii/16 + 2/4) * ii, 78 + cos(iii/16 + 2/4 )  * ii)
            spr(15, 60 + sin(iii/16 + 3/4) * ii, 78 + cos(iii/16 + 3/4 )  * ii)
            palt(1,false)
            pal()
        end

        if intro_sequence_timer == 30*3 then
            music()
            pavuk_active = true
        end

        if intro_sequence_timer == 30*4 then
            sfx(43)
            camera_speed= is_hard_mode and 0.3 or 0.2
        end
    end

    
    for p in all(puffs_top) do
        spr(p.n+p.life,p.x,p.y)
        if p.life >= p.m then del(puffs_top,p) end
        p.life += 1
    end

    if (not pavuk_active and game_started and intro_sequence_timer < 0) camera(-1,-1) print('',0,0,0) print_tutorial() camera()  print('',0,0,7) print_tutorial()

end

function print_tutorial()
    print('⬅️⬆️⬅️➡️ move',51,10)
    print('')
    print('when charged:')
    print('🅾️/(Z) shoot')
    print('❎/(X) big blast')
    print('⬅️⬆️⬅️➡️ dig',32,46)
    print('⬆️ open',60,90)

    if is_hard_mode then print("nYT EI OLE PALUUTA",28,98) end
end
wtf_timer = 0



want_spawn_gem = 2
function _generate_next_line()
    world_vertical_position += 1
    want_spawn_gem -= 1

    gaps = { 131, 131, 131, 145, 146, 147, 148, 149, 149, 149, 145, 145, 145, 145, 145}
    gems = { 160, 161, 161, 162, 162, 163 }
    tiles = { 'gap', 'gap', 135, 136, 137 }
    for i=map_offset_x,map_size_x,1 do
        -- from 0 to 1
        local n_x = i
        local n_y = world_vertical_position
        local tile_idx = ((noise(n_x/3,n_y/3,world_seed)+1)/2)*6

        --[[
        for x=0,16 do
            for y=0,128 do
                local fun_noise = (noise(0,y/16)+1)
                pset(x,y,flr(fun_noise*16))
            end
        end
        ]]

        local max_density = is_hard_mode and 3 or 1.3
        local density_noise = mid(0.7,(noise(0,world_vertical_position/10,world_seed)+1),max_density)
        tile_idx = flr(tile_idx*density_noise)

        tile = tiles[mid(1,round(tile_idx),#tiles)] or 46
        if tile == 'gap' then
            tile = gaps[1+flr(rnd(#gaps))]
        end
        if tile == 131 and (mget(i, 17) == 131 or mget(i, 17) == 132) then tile = 132 end

        if want_spawn_gem < 0 and tile == 136 and rnd(2) < 1 then
            want_spawn_gem = rnd(2)
            tile = gems[ceil(rnd(#gems))] or 13
        end
        mset(i, map_size_y, tile)
        if not fget(tile, 0) and rnd(15) < 1 and i > map_offset_x and i < map_size_x then 
            tp = flr(rnd(4))
            if tp == 1 then
                enemies[#enemies+1] = build_snake(i * tile_size, map_size_y * tile_size)    
            end
            if tp == 2 then
                enemies[#enemies+1] = build_bat(i * tile_size, map_size_y * tile_size)    
            end
            if tp == 3 then
                enemies[#enemies+1] = build_flame(i * tile_size, map_size_y * tile_size)    
            end
        end
    end
end

function _move_map()
    for i=map_offset_x,map_size_x,1 do
        for j=map_offset_y,map_size_y+1,1 do
            mset(i,j-1, mget(i, j)) 
        end
    end
end

function spider_colide()
    if player.y < spider_collider_y then 
        health -= 1
        for i=1,push_size,1 do
            local t = flr(rnd(5) + 145)
            mset(player.x / tile_size, (player.y / tile_size) + i, t) 
        end
        player.y = player.y + push_size * tile_size
        player_hurt_anim()
    end
end

function spider_eat_enemies()
    for i=1,#enemies,1 do
        local em = enemies[i]
        if em != nil and em.y < spider_collider_y then
            del(enemies, em)
        end
    end
end

function next_step()
    step += 1

    _generate_next_line()
    _move_map()

    player.y -= tile_size
    spider_colide()
    for i=1,#enemies,1 do
        enemies[i].y -= tile_size
    end
    spider_eat_enemies()
    for i=1,#projectiles,1 do
        projectiles[i].y -= tile_size
    end
    for i=1,#puffs,1 do
        puffs[i].y -= tile_size
    end

end


function printo(str,startx,
    starty,col,
    col_bg)
    print(str,startx+1,starty,col_bg)
    print(str,startx-1,starty,col_bg)
    print(str,startx,starty+1,col_bg)
    print(str,startx,starty-1,col_bg)
    print(str,startx+1,starty-1,col_bg)
    print(str,startx-1,starty-1,col_bg)
    print(str,startx-1,starty+1,col_bg)
    print(str,startx+1,starty+1,col_bg)
    print(str,startx,starty,col)
end

--print string centered with 
--outline.
function printc(
	str,x,y,
	col,col_bg,
	special_chars)

	local len=(#str*4)+(special_chars*3)
	local startx=x-(len/2)
	local starty=y-2
	printo(str,startx,starty,col,col_bg)
end

function gameoverdraw()
	for x=0,127 do
		for y=0,127 do
			if rnd(20)<1 then
				pset(x,y,pget(x,y-1))
			end
		end
	end
	if gameovertime > 15 then
		printc("game over",64,64,8,1,0)
	end
	flip()
end

function gameoverupdate()
    if btnp(4) then 
        reload()
        -- _init()
        reset()
        run()
        setgamestate("game")
    end

    gameovertime +=1
end

gamestates = {
	gameover = {
		draw = gameoverdraw,
		update = gameoverupdate
	},
	game = {
		draw = drawgame,
		update = updategame
	}
}
function setgamestate(state)
	_update = gamestates[state].update
	_draw = gamestates[state].draw
end



gameoverscore = 0
gameovertime = 0
function gameover()
	gameovertime += 1
    music(-1)
	setgamestate("gameover")
end


setgamestate("game")


--- kitao/pico8-libs -> perlin.lua
 local f={}
 local p={}
 local permutation={151,160,137,91,90,15,
  131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
  190,6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
  88,237,149,56,87,174,20,125,136,171,168,68,175,74,165,71,134,139,48,27,166,
  77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
  102,143,54,65,25,63,161,1,216,80,73,209,76,132,187,208,89,18,169,200,196,
  135,130,116,188,159,86,164,100,109,198,173,186,3,64,52,217,226,250,124,123,
  5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
  223,183,170,213,119,248,152,2,44,154,163,70,221,153,101,155,167,43,172,9,
  129,22,39,253,19,98,108,110,79,113,224,232,178,185,112,104,218,246,97,228,
  251,34,242,193,238,210,144,12,191,179,162,241,81,51,145,235,249,14,239,107,
  49,192,214,31,181,199,106,157,184,84,204,176,115,121,50,45,127,4,150,254,
  138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
 }

 for i=0,255 do
  local t=shr(i,8)
  f[t]=t*t*t*(t*(t*6-15)+10)

  p[i]=permutation[i+1]
  p[256+i]=permutation[i+1]
 end

 local function lerp(t,a,b)
  return a+t*(b-a)
 end

 local function grad(hash,x,y,z)
  local h=band(hash,15)
  local u,v,r

  if h<8 then u=x else u=y end
  if h<4 then v=y elseif h==12 or h==14 then v=x else v=z end
  if band(h,1)==0 then r=u else r=-u end
  if band(h,2)==0 then r=r+v else r=r-v end

  return r
 end

 function noise(x,y,z)
  y=y or 0
  z=z or 0

  local xi=band(x,255)
  local yi=band(y,255)
  local zi=band(z,255)

  x=band(x,0x0.ff)
  y=band(y,0x0.ff)
  z=band(z,0x0.ff)

  local u=f[x]
  local v=f[y]
  local w=f[z]

  local a =p[xi  ]+yi
  local aa=p[a   ]+zi
  local ab=p[a+1 ]+zi
  local b =p[xi+1]+yi
  local ba=p[b   ]+zi
  local bb=p[b+1 ]+zi

  return lerp(w,lerp(v,lerp(u,grad(p[aa  ],x  ,y  ,z  ),
                              grad(p[ba  ],x-1,y  ,z  )),
                       lerp(u,grad(p[ab  ],x  ,y-1,z  ),
                              grad(p[bb  ],x-1,y-1,z  ))),
                lerp(v,lerp(u,grad(p[aa+1],x  ,y  ,z-1),
                              grad(p[ba+1],x-1,y  ,z-1)),
                       lerp(u,grad(p[ab+1],x  ,y-1,z-1),
                              grad(p[bb+1],x-1,y-1,z-1))))
 end

function round(a)
    return flr(a+0.5)
end

function noistest()
    for n_x=0,16 do
        for n_y=0,16 do
            local tile = ((noise(n_x/4,n_y/4,world_seed)+1)/2)*5
            pset(n_x,n_y,round(tile))
        end
    end
end

__gfx__
00000000000000000000000000000000000000000000000000007000000000000f6f0000000000000000000000000000110a7011110c70111110011108800770
00a88a00000aa80000aaaa00008aa00000776600077760000000070000f00000f6d6f0ff00000000000000000000000010aa701110cc7701110b701188887777
098778a0009a877009aaaaa00778aa000766666000066700000006700f6ff0ff6ddd6f660000000000000000000000000aaa00000ccc777010bb770188887777
09866890009986600999999006689900700210060001666022222670f6d66f66ddddd6dd000000000111111000000000aaaa7777cccc77770bbb777088887777
06177170006771700677777007177700000210000012166011111660fdddd6ddddfffd8d000001111111111111100000888899991111ddddbbbb777711112222
06777770006777700677777007777700000210000121006000000660fddd0d8ddf000d8d000011111111111111110000000099900111ddd05555333301112220
01111110001111100111111001111100000210001210006000000600fdd00d8df00000dd000111111111111111111000110899011011dd015555333310112201
09a009a0009a09a009a009a009a09a00000210002100000000006000fd0000dd00000000000111100111111001111000110890111101d0110555333011012011
000000000000000000aaaa000000000066a88a6600000000ffffffff000ffff000000000000111100011110001111000000000000000000000000000000a7000
000000000000aa8009aaaaa008aa00006787786700000000ffffffff00f1585f000ffff000011111001111001111100000000000000000000000000000aa7000
00a88a000009a87709999990778aa0000986689000000000ffffffff0f15555500f1585f0001111111111111111110000000000000000000000ff0000aaa0000
098778a00009986606777770668990000617717000000000ffffffff0f155fdf0f155555000111111111111111111000000000000000000000fb7f00aaaa7777
0986689000067717067779a0717770000677777000000000ffffffff0f1554f00f1550df000011111111111111110000000000011000000000f53f0088889999
0617717000a67777011119a077777a000677777000000000ffffffff00ff154f0f1545f00000111111111111111100000000000110000000000ff00000009990
067777700099111109a00000111199000111111000000000ffffffff00f1545ff15554f000000011111111111100000000000001110000000000000000089900
09a111100000009a000000009a00000009a009a000000000fffffffff155554f15554f0000000000000000000000000000000001110000000000000000089000
000000000000000000070000000700000000000000000000000000000000f90000000000000000011001100110000000000000001110000010777701000f555f
00000000000000000007000000000000000000000000000000000000000f9f000000000000000001100110011000000000000000111100000666666000f5555f
0000000000070000000000000000000000000000000000000000000000f99f000000000000000000000000000000000000000000011110000066660000f5555f
000700000070700077000770700000700000000000000000000000000f9799f0000000000000000000000000000000000000001100000000080000800f5555f0
000000000007000000000000000000000000000000000000000000000f9a79f0000000000000000000000000000000000000001100000000087888800f5555f0
00000000000000000007000000000000000000000000000000000000f91aa19f000000000000000000000000000000000000001111000000087888800f555f00
00000000000000000007000000070000000000000000000000000000f91a919f00000000000000000000000000000000000000011100000008888880f555f000
000000000000000000000000000000000000000000000000000000000f9999f000000000000000000000000000000000000000000000000010888801f555f000
00000000000000000000000000aaaa0000aaaa0000700700000000000000000000000000000000000077770000777700007007000000000000000000f555f000
0000000000000000000aa0000a9999a00a0000a0000000000000000000000000000000000007700007777770070000700000000000000000000000000f555f00
00000000000aa00000a99a00a990099aa000000a700000070000000000000000000770000077770077700777700000077000000700000000000000000f555f00
0008800000a99a000a9009a0a900009aa000000a0000000000000000000770000077770007700770770000777000000700000000000000000000000000f55f00
0008800000a99a000a9009a0a900009aa000000a0000000000000000000770000077770007700770770000777000000700000000000000000000000000f555f0
00000000000aa00000a99a00a990099aa000000a70000007000000000000000000077000007777007770077770000007700000070000000000000000000f55f0
0000000000000000000aa0000a9999a00a0000a0000000000000000000000000000000000007700007777770070000700000000000000000000000000000ff5f
00000000000000000000000000aaaa0000aaaa0000700700000000000000000000000000000000000077770000777700007007000000000000000000000000ff
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000011110000111110011110011001
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000011100000011100001100000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000100000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000001100000010000000010000001
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000011110000111000000111000011
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000101010100000000000000000000000001000000110000001111111110000000000000000f1f1112222111f1f0000000000000000
000000000000000000000000010101010000000000000000000000001d16d60006666660121828000000000000000000ff1f11222211f1ff0000000000000000
00000000000000000000000000000000000000100000000000000000d1dd6d61dd666666212282810000000000000000f1f1112222111f1f0000000000000000
000000000000000000000000101010100000000000000000000000001d1dd6d1ddd66666121228210000000000000000ff1f11222211f1ff0000000000000000
0000000000000000000000000000000000000000000000000000000000001000dddd6666000010000000000000000000f1f1112222111f1f0000000000000000
000000000000000000000000000000000010000000000000000000001d6001ddddddd666128001220000000000000000ff1f11222211f1ff0000000000000000
00000000000000000000000000000000000000000000000000000000d6d61d1ddddddd66282812120000000000000000f1f1112222111f1f0000000000000000
000000000000000000000000000000000000000000000000000000006d6d11d11dddddd1228211210000000000000000ff1f11222211f1ff0000000000000000
10000001101111111111111111111111111111111111111100000000101111111000000110111111000000000000000000000000000000000000000000000000
08282820110111111111111111111111111111101111111100000000110111110661666001000001000000000000000000000000000000000000000000000000
2082828211111101111111111111101111111111111111110000000011111101dd66666620228280000000000000000000000000000000000000000000000000
0208282811111110110111111111111110111111111111110000000011111110ddd6166612122821000000000000000000000000000000000000000000000000
20208282101111111111111111111111111111111111111100000000000010001ddd616100001000000000000000000000000000000000000000000000000000
020208281101111111111111110111111111111111111111000000001d6001dddd1dd61612800122000000000000000000000000000000000000000000000000
20202080111111011111111111111111111101111111111100000000d6d61d1dd1dd1d6628281212000000000000000000000000000000000000000000000000
120202011111111011111111111111111111111111111111000000006d6d11d11dd1d1d122821121000000000000000000000000000000000000000000000000
100000011000000110000001100000010000000000000000000000001011111111111111101111110000000011aaa111111aaa11111111111111111100000000
0d6666600d6666600d6666600d666660000000000000000000000000110111110111110011011111000000001aaa11155111aaa1111111111111111100000000
da766666dc766666db766666d876666600000000000000000000000011111101d011106611111101000000001aaa1a5785a1aaa1111111111111111100000000
d8966666d1d66666d5366666d126666600000000000000000000000011111110dd010606111111100000000019991958759199a1119991111119991100000000
dddd6666dddd6666dddd6666dddd6666000000000000000000000000101111110dd06060100011000000000019991915519199a119aa11111111aa9100000000
ddddda76dddddc76dddddb76ddddd87600000000000000000000000011011111dd0dd606028000220000000019991915519199a119aa1aa11aa1aa9100000000
ddddd896ddddd1d6ddddd536ddddd12600000000000000000000000011111101d0dd0d6628281212000000001000000000000001199919999991999100000000
1dddddd11dddddd11dddddd11dddddd1000000000000000000000000111111101dd0d0d122821121000000001000000000000001199919955991999100000000
00000000000000000000000000000000000000000000000000000000101111111011111110111111000000001000000000000001199919578591999100000000
00000000000000000000000000000000000000000000000000000000110111111101111111011111000000001000000000000001111111587511111100000000
000000000000000000000000000000000000000000000000000000001111110111111101111111010000000019aa1aa11aa1aa9119aa1aa55aa1aa9100000000
00000000000000000000000000000000000000000000000000000000111111101111111011111110000000001999199aa9919991199919955991999100000000
00000000000000000000000000000000000000000000000000000000101111111011111110111111000000001999199999919991199919999991999100000000
00000000000000000000000000000000000000000000000000000000110111111101111111011111000000001999199999919991199919999991999100000000
00000000000000000000000000000000000000000000000000000000111111011111110100001101000000001999199999919991199919999991999100000000
00000000000000000000000000000000000000000000000000000000111111101111111022820020000000001999999999999991199999999999999100000000
00000000000000000000000000000000000000000000000000000000000000001011111110111111000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001101111111011111000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001111110111111101000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001111111011111110000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001011111110111111000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001101111111011111000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001111110111111101000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000001111111011111110000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000010111111000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000011011111000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000011111101000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000011111110000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000010111111000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000011011111000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000011111101000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000011111110000000000000000000000000000000000000000000000000
__label__
0000000001011122d6d61d1dd6d61d1dd6d61d1dd6d61d1dd6d61d1d000044444444400006d61d1dd6d61d1dd60404040404040404040d1d2211101000000000
00000000001011226d6d11d16d6d11d16d6d11d16d6d11d16d6d11004444411111144444400d11d16d6d11d10040404040404040404041d12211010000000000
00000000010111221000000110000001100000011000000110000044411111111111111444400001100000000404040404040000000000012211101000000000
00078888878888887788888888888888888888888888888888888888888888888888888888888888888888888888888880000000000000000000000000000000
00077777770888878007778877877887778888877787788777877787878888887788778777877887778778888888888880000000000000000000000000000000
00070777070888870888700787070788700888877007078770077707770888878007870870070787700707888888888880000000000000000000000000000000
00070777070888870788708777070708708888870087070700870708070888880787770870870707008778088888888880000000000000000000000000000000
0000777770001127770777d7070707007040404077470704774707077101441771070007774774047707074000600000400001dd1d6001dd2211010000000000
00000000000111220006000d0604040400040404000400044004040100111111001101110004004440040400d6d004040404000006d61d1d2211101000000000
00000000001011226d6d110000404040404040404040404444444441111111111111111114444444444040016000404040404040400001d12211010000000000
00000000010111221000000404040404040404000404044441144444111111111111111144444114444400000404040404040404040400002211101000000000
00000000001011200040404040404040404040400040444441144444111111111111111144444114444400004040404040404040404040402211010000000000
00000000010111240404040404040404040404040004044441114444441111111111114444441114444404040404040004040404040404042211101000000000
00000000001011204040404040404000004040404040444441114444444444444444444444441114444440404040400110000040404040402211010000000000
00000000010111240404040404000000000404040404444444111444444114411441144444411144444444040400000000001000040404042211101000000000
000000000010112040404000006001dd1d600040404044444411114444411441144114444411114444444040400001dd1d6001dd100000402211010000000000
00000000010111240400001dd6d61d1dd6d6100404044444444111144444444444444444411114444444440006d61d1dd6d61d1dd6d610002211101000000000
0000000000101120006d11d16d6d11d16d6d11d04040444411444444444444777774444444444411444440000d6d11d16d6d11d16d6d11d12211010000000000
00000000010111221011111111111111101010040404444411444444444477777777744444444411444440040000000111111111101010102211101000000000
00000000001011221101111111111111010100404040444411114444444777777788874444441111444440404000d60011111111010101012211010000000000
000000000101112211111101111111110000040404040444411144444477777778888874444411144444040404040d6111111011000000002211101000000000
0000000000101122111111101111111100004040404044444444444444777777888888844444444444444040404040d111111111101010102211010000000000
00000000010111221011111111111100040404040004044444444444477777778888888744444444444404040404040011111111000000002211101000000000
00000000001011221101111111111040404040404040404444444444477777778888888744444444444040400040404001011111000000002211010000000000
000000000101112211111101111004040404040404040404444444444777777778888877444444444400000dd004040400111111000000002211101000000000
00000000001011221111111011004040404040404040404444444444477777777788877744444444440d11d16d00404040001111000000002211010000000000
00000000010111221010101010040404040404040404040444444444477777777777777744444444400010101011040404040111100000012211101000000000
000000000010112201010100004040404000000040404040444444444477777777777774444444444040000011011040404041111d16d6002211010000000000
00000000010111220000000404040404000000100000000000044444447777777777777444444404040404040001110004040101d1dd6d612211101000000000
000000000010112210100040404040400000000010101010100044444447777777777744444440404040404040401110004041101d1dd6d12211010000000000
00000000010111220000040404000001000000000000000000000444444477777777744444440404040404040404011110040111000010002211101000000000
000000000010112200004040400101110010000000000000000004444444447777744444444000404040404040404011110041111d6001dd2211010000000000
00000000010111220404040400111111000000000000000000000444000044444444400044401d00000404040404040111110101d6d61d1d2211101000000000
110000110010112240404040011111110000000000000000000000444010000000000004440d11d10000000040404000111111106d6d11d12211010008800770
10000001010111220404040110111111100000011000000110111044401111111777770444000001101111110004040010111111100000012211101088887777
000000000010112240400010110111111d16d6001d16d6001101110440011111077777044016d6001101111111104040010111111d16d6002211010088887777
00000000010111220400111111111101d1dd6d61d1dd6d611111110444011101d777704440dd6d61111111011111040400111101d1dd6d612211101088887777
000000000010112240011111111111101d1dd6d11d1dd6d11111111044011110d77770440d1dd6d11111111011111040400111101d1dd6d12211010011112222
0000000001011122011111111011111100001000000010001011111100401111d777040000001000101111111111100404001111000010002211101001112220
100000010010112211111111110111111d6001dd1d6001dd1101111111001111d77700761d6001dd1101111111111100404001111d6001dd2211010010112201
11000011010111221111011111111101d6d61d1dd6d61d1d1111110111111101d7777776d6d61d1d111111011111111004040101d6d61d1d2211101011012011
000000000010112211111111111111106d6d11d16d6d11d11111111011111110177777716d6d11d11111111011111111004040106d6d11d12211010000000000
11000011010111221000000110000001100000011000000110000001101111111777777110000001111111111011111110040401100000012211101008800770
10000001001011221d16d60006666660066666600d6666601d16d60011011111077777701d16d60011111111110111111d0040401d16d6002211010088887777
0000000001011122d1dd6d61dd666666dd666666dc766666d1dd6d6111111101d7777776d1dd6d611111111111111101d1d00404d1dd6d612211101088887777
00000000001011221d1dd6d1ddd66666ddd66666d1d666661d1dd6d111111110d77777761d1dd6d111111111111111101d1d40401d1dd6d12211010088887777
000000000101112200001000dddd6666dddd6666dddd66660000100010111111d777777600001000111111111011111100000404000010002211101011112222
00000000001011221d6001ddddddd666ddddd666dddddc761d6001dd11011111d77777761d6001dd11111111110111111d6000401d6001dd2211010001112220
1000000101011122d6d61d1ddddddd66dddddd66ddddd1d6d6d61d1d11111101d7777776d6d61d1d1111111111111101d6d61d04d6d61d1d2211101010112201
11000011001011226d6d11d11dddddd11dddddd11dddddd16d6d11d111111110177777716d6d11d111111111111111106d6d11d06d6d11d12211010011012011
00000000010111221000000110000001100000011000000111111111111111111777777110000001100000011000000110000001101111112211101000000000
110000110010112206666660066666600d6666601d16d6001111111011111111177777701d16d6001d16d6001d16d6001d16d600110111112211010008800770
1000000101011122dd666666dd666666db766666d1dd6d611111111111111111d7777771d1dd6d61d1dd6d61d1dd6d61d1dd6d61111111012211101088887777
0000000000101122ddd66666ddd66666d53666661d1dd6d11011111111111111177777711d1dd6d11d1dd6d11d1dd6d11d1dd6d1111111102211010088887777
0000000001011122dddd6666dddd6666dddd66660000100011111111111111110777777000001000000010000000100000001000101111112211101088887777
0000000000101122ddddd666ddddd666dddddb761d6001dd11111111111111111777777d1d6001dd1d6001dd1d6001dd1d6001dd110111112211010011112222
0000000001011122dddddd66dddddd66ddddd536d6d61d1d1111011111111111d777777dd6d61d1dd6d61d1dd6d61d1dd6d61d1d111111012211101001112220
10000001001011221dddddd11dddddd11dddddd16d6d11d11111111111111111677777716d6d11d16d6d11d16d6d11d16d6d11d1111111102211010010112201
11000011010111221000000110000001100000011011111111111111101010101777777110111111100000011000000110000001101111112211101011012011
00000000001011221d16d6001d16d6001d16d60011011111111111110101010117777771110111111d16d6001d16d6001d16d600110111112211010000000000
1100001101011122d1dd6d61d1dd6d61d1dd6d611111110111111011000000001777777111111101d1dd6d61d1dd6d61d1dd6d61111111012211101000000000
10000001001011221d1dd6d11d1dd6d11d1dd6d111111110111111111010101017777771111111101d1dd6d11d1dd6d11d1dd6d1111111102211010000000000
00000000010111220000100000001000000010001011111111111111000000001777777110111111000010000000100000001000101111112211101000000000
00000000001011221d6001dd1d6001dd1d6001dd11011111110111110000000017777771110111111d6001dd1d6001dd1d6001dd110111112211010000000000
0000000001011122d6d61d1dd6d61d1dd6d61d1d1111110111111111000000001777777111111101d6d61d1dd6d61d1dd6d61d1d111111012211101000000000
00000000001011226d6d11d16d6d11d16d6d11d111111110111111110000000017777771111111106d6d11d16d6d11d16d6d11d1111111102211010011000011
10000001010111221010101010111111111111111011111110101010111111111777777110111111111111111000000110000001111111112211101010000011
1100001100101122010101011101111111111111110111110101010111111111177000011a711111111111111d16d6001d16d600111111112211010000000000
000000000101112200000000111111011111101111111101000000001111111117015850aa71110111111111d1dd6d61d1dd6d61111111112211101000000000
110000110010112210101010111111101111111111111110101010101111111110155555aa111110111111111d1dd6d11d1dd6d1111111112211010000000000
1000000101011122000000001011111111111111101111110000000011111111101557d0aa777711111111110000100000001000111111112211101000000000
00000000001011220000000011011111110111111101111100000000111111111015450888999911111111111d6001dd1d6001dd111111112211010011000001
0000000001011122000000001111110111111111111111010000000011111111015554011199910111111111d6d61d1dd6d61d1d111111112211101011000011
00000000001011220000000011111110111111111111111000000000111111111555407018991110111111116d6d11d16d6d11d1111111112211010000000000
00000000010111221000000110000001100000011011111110111111101010101777777118911111111111111000000110000001100000012211101011000011
10000001001011221d16d6001d16d6001d16d6001101111111011111010101011777667111011111111111111d16d6001d16d6001d16d6002211010010000011
1100001101011122d1dd6d61d1dd6d61d1dd6d61111111011111110100000000176666611111110111111111d1dd6d61d1dd6d61d1dd6d612211101000000000
00000000001011221d1dd6d11d1dd6d11d1dd6d11111111011111110101010107772177611111110110111111d1dd6d11d1dd6d11d1dd6d12211010000000000
11000011010111220000100000001000000010001011111110111111000000001772177110111111111111110000100000001000000010002211101000000000
10000001001011221d6001dd1d6001dd1d6001dd1101111111011111000000001772177111011111111111111d6001dd1d6001dd1d6001dd2211010000000000
0000000001011122d6d61d1dd6d61d1dd6d61d1d111111011111110100000000177217711111110111111111d6d61d1dd6d61d1dd6d61d1d2211101011000001
00000000001011226d6d11d16d6d11d16d6d11d11111111011111110000000001772177011111110111111116d6d11d16d6d11d16d6d11d12211010011000011
000000000101112210111111100000011000000110000001101111111011111166a88a6611111111111111111111111110000001100000012211101000000000
0000000000101122110111111d16d6001d16d6001d16d6001101111111011111678778671111111111111110111111111d16d6001d16d6002211010011000011
100000010101112211111101d1dd6d61d1dd6d61d1dd6d61111a71011111110119866891111111111111111111111111d1dd6d61d1dd6d612211101010000011
1100001100101122111111101d1dd6d11d1dd6d11d1dd6d111aa711011111110161771711111111110111111111111111d1dd6d11d1dd6d12211010000000000
0000000001011122101111110000100000001000000010001aaa1111101111111677777111111111111111111111111100001000000010002211101000000000
0000000000101122110111111d6001dd1d6001dd1d6001ddaaaa777711011111167777711111111111111111111111111d6001dd1d6001dd2211010000000000
000000000101112211111101d6d61d1dd6d61d1dd6d61d1d888899991111110111111111111111111111011111111111d6d61d1dd6d61d1d2211101000000000
0000000000101122111111106d6d11d16d6d11d16d6d11d1111199901111111019a119a11111111111111111111111116d6d11d16d6d11d12211010011000001
00000000010111221111111110000111101111111111111110189911111111111000000110000001100000011111111111111111111111112211101011000011
00000000001011221111111105851011110111111111111111089111111111111d16d6000d6666601d16d6001111111111111111111111112211010000000000
0000000001011122111111115555510111111101111110111111110111111011d1dd6d61d8766666d1dd6d611111111111111111111111112211101000000000
0000000000101122111111110d055101111111101111111111111110111111111d1dd6d1d12666661d1dd6d11111111111111111111111112211010000000000
006660000101112211111111104551011011111111111111101111111111111100001000dddda766000010001111111111111111111111112211101000000000
00600000001011221111111104510011110111111101111111011111110111111d6001dddddaa7761d6001dd1111111111111111111111112211010000000000
0066600001011122111111110545101111111101111111111111110111111111d6d61d1dddaaa126d6d61d1d1111111111111111111111112211101000000000
00006000001011221111111104555510111111101111111111111110111111116d6d11d11aaaa7777d6d11d11111111111111111111111112211010000000000
00666000010111221000000110000001100000011000000110000001100000011000000118888999900000011111111110111111111111112211101000000000
00000000001011220d6666601d16d6001d16d6001d16d6001d16d6001d16d6000666666006666999066666601111111111011111111111112211010000000000
1110011101011122dc766666d1dd6d61d1dd6d61d1dd6d61d1dd6d61d1dd6d61dd666666dd668996dd6666661111111111111101111111112211101000000000
110b701100101122d1d666661d1dd6d11d1dd6d11d1dd6d11d1dd6d11d1dd6d1ddd66666ddd68966ddd666661111111111111110111111112211010000000000
10bb770101011122dddd66660000100000001000000010000000100000001000dddd6666dddd6666dddd66661111111110111111111111112211101000000000
0bbb777000101122dddddc761d6001dd1d6001dd1d6001dd1d6001dd1d6001ddddddd666ddddd666ddddd6661111111111011111111111112211010000000000
bbbb777701011122ddddd1d6d6d61d1dd6d61d1dd6d61d1d22261d1dd6d61d1ddddddd66dddddd66dddddd661111111111111101111111112211101000000000
55553333001011221dddddd16d6d11d16d6d11d16d6d1122888221d16d6d11d11dddddd11dddddd11dddddd11111111111111110111111112211010000000000
55553333010111221111111110000001100000011000002899982001111111111000000110000001100000011000000110000001100000012211101000000000
0555333000101122121828000d6666601d16d6000666628999998200111111111d16d600066666601d16d6001d16d6001d16d6001d16d6002211010000000000
000000000101112221228281dc766666d1dd6d61dd6662899a99826111111111d1dd6d61dd666666d1dd6d61d1dd6d61d1dd6d61d1dd6d612211101000000000
000000000010112212122821d1d666661d1dd6d1ddd66289999982d1111111111d1dd6d1ddd666661d1dd6d11d1dd6d11d1dd6d11d1dd6d12211010000000000
000000000101112200001000dddd666600001000dddd6628999820001111111100001000dddd6666000010000000100000001000000010002211101000000000
000000000010112212800122dddddc761d6001ddddddd622888221dd111111111d6001ddddddd6661d6001dd1d6001dd1d6001dd1d6001dd2211010000000000
000000000101112228281212ddddd1d6d6d61d1ddddddd6622261d1d11111111d6d61d1ddddddd66d6d61d1dd6d61d1dd6d61d1dd6d61d1d2211101000000000
0000000000101122228211211dddddd16d6d11d11dddddd16d6d11d1111111116d6d11d11dddddd16d6d11d16d6d11d16d6d11d16d6d11d12211010000000000
00000000010111221111111110000001100000011000000110000001101111111000000110000001100000011000000110000001111111112211101000000000
00000000001011221218280006666660066666601d16d6001d16d600110111111d16d6001d16d6001d16d6000666666006666660121828002211010000000000
000000000101112221228281dd666666dd666666d1dd6d61d1dd6d6111111101d1dd6d61d1dd6d61d1dd6d61dd666666dd666666212282812211101000000000
000000000010112212122821ddd66666ddd666661d1dd6d11d1dd6d1111111101d1dd6d11d1dd6d11d1dd6d1ddd66666ddd66666121228212211010000000000
000000000101112200001000dddd6666dddd6666000010000000100010111111000010000000100000001000dddd6666dddd6666000010002211101000000000
000000000010112212800122ddddd666ddddd6661d6001dd1d6001dd110111111d6001dd1d6001dd1d6001ddddddd666ddddd666128001222211010000000000
000000000101112228281212dddddd66dddddd66d6d61d1dd6d61d1d11111101d6d61d1dd6d61d1dd6d61d1ddddddd66dddddd66282812122211101000000000
0000000000101122228211211dddddd11dddddd16d6d11d16d6d11d1111111106d6d11d16d6d11d16d6d11d11dddddd11dddddd1228211212211010000000000
00000000010111221000000110000001111111111000000110000001100000011000000110000001100000011111111111111111100000012211101000000000
00000000001011221d16d6000666666012182800066666601d16d6001d16d6001d16d6001d16d600066666601218280012182800066666602211010000000000
0000000001011122d1dd6d61dd66666621228281dd666666d1dd6d61d1dd6d61d1dd6d61d1dd6d61dd6666662122828121228281dd6666662211101000000000
00000000001011221d1dd6d1ddd6666612122821ddd666661d1dd6d11d1dd6d11d1dd6d11d1dd6d1ddd666661212282112122821ddd666662211010000000000
000000000101112200001000dddd666600001000dddd666600001000000010000000100000001000dddd66660000100000001000dddd66662211101000000000
00000000001011221d6001ddddddd66612800122ddddd6661d6001dd1d6001dd1d6001dd1d6001ddddddd6661280012212800122ddddd6662211010000000000

__gff__
0000000000000000000000000808080800000000000000000000000000000008000000000000000000000000000008000000000000000000000000000000000001000000000000000000000008080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000303000001010100000000000000000000000003010101000000000000010101010000000001010003038181000000000000000000000100030381810000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
96968787919487878787878787879696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968791949494959595949391879696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968791949494959494919193879696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968791949495949494949493879696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968795919595939491919493879696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968787878787878787878787879696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968787878787878787878787879696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968788919393919494949188879696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968891949595959595939393889696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968891949191adae93949393889696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968894949494bdbe93939193889696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968891919195939493949193889696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968788919594949194949188879696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968787878787878787878787879696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968787878787878787878787879696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
96968787878787878787878787879696968c0000000000000000000000008d96000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000878787878787878787878787000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000878787878787878787878787000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010800001005010050040500050004050005000405000500100501005004050005000405000500100501005004050005000405000500040500000010050005001005010050040500000004050000000405000000
010800000e0500e0500205000000020500000002050000000e0500e050020500000002050000000e0500e0500205000000020500000002050000000e050000000e0500e050020500000002050000000205000000
010800000c0500c0500005000000000500000000050000000c0500c050000500000000050000000c0500c0500005000000000500000000050000000c050000000c0500c050000500000000050000000005000000
0108000011053000001c613000001c613000001c61300000136221362215613000001c6130000011053000001c6130000011053000001c613000001105300000136221362215613000001c613000001c61300000
0008000000500005000050000500005000050000500005001c5521c5521c5521c5522355223552005020050221552215522155221552215522155221552215521f5521f55200502005021e5521e5520050200502
000800001f5521f5521f5521f5521f5521f5521e5521e552000000000000000000001c5521c5521c5521c5521c5521c5521c5521c5521c5521c5521c5521c5521a5521a5521a5521a5521a5521a5521a5521a552
000800000000000000000000000000000000000000000000185521855218552185521f5521f55200000000001f5521f5521f5521f5521f5521f5521f5521f5521e5521e55200000000001c5521c5520000000000
000800001e5521e5521e5521e5521e5521e5521f5521f552000000000000000000002155221552215522155221552215522155221552215522155200000000002355223552235522355223552235522355223552
000800001f5521f5521f5521f55218552185520000000000185521855200000000002355223552000000000021552215522155221552215522155221552215521f5521f55200000000001e5521e5520000000000
000800001e5521e5521e5521e5521e5521e5521f5521f552000000000000000000002155221552215522155221552215522155221552215522155200000000002355223552235522355223552235522355223552
010800001f5521f5521f5521f55218552185520000000000185521855200000000002355223552000000000021552215522155221552215522155221552215521f5521f552000000000023552235520000000000
010800002655226552265522655223552235520000000000265522655200000000002b5522b5522b5522b5522b5522b5522b5522b5522a5522a5522a5522a5522a5522a552000000000023552235520000000000
000800002455224552245522455224552245522455224552245522455224552245522355223552005000050024552245520050000500235522355200500005002455224552005000050026552265522655226552
01080000265522655226552265522b5522b55200500005002a5522a55200500005002655226552265522655226552265522655226552285522855228552285522855228552005000050026552265522655226552
010800002855228552285522855228552285522855228552005000050000500005002f5522f55200500005002d5522d55200500005002b5522b55200500005002a5522a55200500005002a5522a5522a5522a552
010800002a5522a5522a5522a5522b5522b55200500005002a5522a55200500005002455224552245522455224552245522455224552265522655226552265522655226552265522655224552245522450224502
01080000285522855228552285522855228552285522855200500005000050000500245522455228552285522f5522f55200500005002d5522d55200500005002b5522b552005000050032552325523255232552
010800003255232552325523255230552305522f5522f552005000050000500005002b5522b5522b5522b5522b5522b5522b5522b5522a5522a5522a5522a5522a5522a5522a5522a55223552235522355223552
010800002855228552285522855228552285522855228552285522855228552285522855228552285522855228542285422854228542285322853228532285322852228522285222852228512285122851228512
00010000270502605023050230502405022050200501d050200501a05019050160501505018050130601206015060100500d05010040100400a0300e0300b0300802007020050100001000000000000500004000
91030000063700237008370033700a370063700f37008370123700d370153701237018370143701c37018370203701b370223701c3702337025300273002a3002d3002f300323003430029300233002b30025300
000200001e0501e05027050270502a0502a0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010500001661032630370253000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010500001307300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300000
00010000200501f0501d0501b050190501405012050100500c0503505033050300502c0502a050270502505022050200501d05019050180500000000000000000000000000000000000000000000000000000000
00020000130500d05017050110501b05015050200501a050230501d050270502105029050240502e050270502c050230502a05020050270501d050250501b050220501903020020170201e020140101c01011010
000200000000025650236502365022650206501f6501e6501d6501c6501a6501a65019650166501565015650146501365012650106500f6400d6400c6400b6300a63009630086200762005620036100261001600
00010000251502415023150231502215021150201501f1501d1501c1501b1501a1501915017150151501415012140101400d1300c1300b1200912007110061100510002100001000010000100001000010000100
000100002d1502a15024150221501c15017150101500a15037150321502e15029150231501f1501c1503f1503b15036150311502e1502a1500000000000000000000000000000000000000000000000000000000
000100001415011150101500d1500b150091500715006150061500515000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d11500001d00011010110101101011010110201102011020110201103011030110301103011040110401104011040110401103011030110301103011030110201102011020110201102011010110101101011010
d11500001300013010130101301013010130201302013020130201303013030130301303013040130401304013040130401303013030130301303013030130201302013020130201302013010130101301013010
d11500001d00015010150101501015010150201502015020150201503015030150301503015040150401504015040150401503015030150301503015030150201502015020150201502015010150101501015010
311500000000511035000051d0350000529035000051d0350000511035000051d0350000529035000051d0350000511035000051d0350000529035000051d0350000511035000051d0350000529035000051d035
311500000000513035000051f035000052b035000051f0350000513035000051f035000052b035000051f0350000513035000051f035000052b035000051f0350000513035000051f035000052b035000051f035
3115000000005150350000521035000052d035000052103500005150350000521035000052d035000052103500005150350000521035000052d035000052103500005150350000521035000052d0350000521035
311500000000013030000001f030000002b030000001f0300000013030000001f030000002b030000001f0300000013030000001f030000002b030000001f0300000013030000001f030000002b030000001f030
10090000280700000028070000002807000000290700000000000000002b070000002d0702d0702d0702d0702d0702d0702d0502d0502d0502d0502d0402d0402d0402d0302d0302d0202d0202d0102d0002d000
00020000110500705012050070500b0500e0501805019050130501c0501c050170502b05029050260502405022050200501f0501e0501c0501b0501a050190501805017050150501305012050100500e0500e050
00020000100501105014050110501d05012050130501405015050170501f0501405018050190501905021050230501a0501c0501e050240501d050260501f05021050250502305024050250502b050270502e050
0001000020650206501f6501e6501e6501c6501b6501a6501965019650186501765016650166501c05014050100501e0501f0500f050100500f0500e0500c0500f05005050030500305002050010500005005050
000100001505015050130501305012050110501105010050100500f0500e0500d0500d0500b0500a0500a0500a050090400804008040060400703006030060300503004020030200202001010010100101001000
010800001101300003110130000311013000031101300003110130000311013000031101300003110130000311013110131101300000110231102311023000001103311033110330000011043110431104311003
4509000001101011510315107151091510b1510b1510b1510b1510b15112151111511115110141101410f1410e1310d1310c1210c1210a1110a11109111091110811106111061110411100101001010010100101
440900000110111151191511d15121151211511c1510e1510e1510f151101411014111131111311213113121141211412115111161111711118111191011a1011b1011d101201012210100101001010010100101
000100001b051190511805115051130510e0510d0510b0510905106051050510305101051000511300112001110010f0010e0010d0010c0010c0010b0010a0010900108001070010600105001040010300102001
010300003a0503a0503a0403a0303a0303a0203a0103a0003a0303a0303a0203a0103a0153a0003a0003a0003a0203a0203a0203a0253a0003a0003a0003a0003a0103a0103a0103a0153a0003a0003a0003a000
__music__
00 4040402a
01 00034344
00 01034344
00 02034344
00 01034044
00 00030444
00 01030544
00 02030644
00 01030744
00 00030444
00 01030544
00 02030844
00 01030944
00 00030444
00 01030544
00 02030644
00 01030744
00 00030444
00 01030544
00 02030a44
00 01030b44
00 02030c44
00 01030d44
00 00030e44
00 01030f44
00 02030c44
00 01030d44
00 00031044
00 01031144
00 02030c44
00 01030d44
00 00031244
02 00034f44
01 1e214344
00 1f224344
00 20234344
02 1f224344
01 26594344
04 2c1a4344

