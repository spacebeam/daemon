-- The Siege Tank, or simply Tank, is a Terran mechanical unit. 
-- Tanks are built from the Factory once it has an attached Machine Shop. 

-- Our unit function table
local this_unit = {}

-- The standard local variables

-- Where we are and fast we move
local x, y, dx, dy
-- Our name
local name = "Terran_Siege_Tank_Tank_Mode"
-- Our color               
local color = "blue"
-- Our BWAPI unit type           
local type = 5

-- Note1: tank turrent (probably a tank in seage mode?) is type 6

-- Note2: no a tank siege mode is type 30-31 the last one also called "turrent".

-- Size of a clock tick msec
local tick

-- This is me              
local me = unit.self()

-- and now for something completely different
local label = "large_ground"
local hitpoints,shield = 150,1
local ground_damage,air_damage = 30,0
local ground_cooldown, air_cooldown = 1.554,0
local ground_range, air_range = 7,0
local sight = 10
local supply = 2
local cooldown = 32
local mineral = 150
local gas = 100

-- The size of the region
local xsize,ysize = region.size()

-- The unit interface.

function this_unit.start() end

function this_unit.get_position() return x,y end

function this_unit.set_position(a1, a2) x,y = a1,a2 end

function this_unit.get_speed() return dx,dy end

function this_unit.set_speed(a1, a2) dx,dy = a1,a2 end

function this_unit.set_tick(a1) tick = a1 end

local function move_xy_bounce(x, y, dx, dy, valid_x, valid_y)
   local nx = x + dx
   local ny = y + dy
   -- Bounce off the edge
   if (not valid_x(nx)) then
      nx = x - dx
      dx = -dx
   end
   -- Bounce off the edge
   if (not valid_y(ny)) then
      ny = y - dy
      dy = -dy
   end
   return nx, ny, dx, dy
end

local function move(x, y, dx, dy)
   local nx,ny,ndx,ndy = move_xy_bounce(x, y, dx, dy,
               region.valid_x, region.valid_y)
   -- Where we were and where we are now.
   local osx,osy = region.sector(x, y)
   local nsx,nsy = region.sector(nx, ny)
   if (osx ~= nsx or osy ~= nsy) then
      -- In new sector, move us to the right sector
      region.rem_sector(x, y)
      region.add_sector(nx, ny)
   end
   return nx,ny,ndx,ndy
end

function this_unit.tick()
   x,y,dx,dy = move(x, y, dx, dy)
end

function this_unit.attack()
   -- The unit has been zapped and will die
   region.rem_sector(x, y)
end

-- Return the unit table
return this_unit
