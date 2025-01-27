pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- razmery igrovogo polya
local cols, rows = 16, 11
local grid = {}
local score = 0
local timer = 120 -- vremya v sekundakh
local cursor = {x = 1, y = 1} -- poziciya kursora
local selected = nil -- vybrannaya kletka

-- cveta dlya chisel
local colors = {7, 8, 9, 10, 11, 12, 13, 14, 15}

-- inicializaciya igrovogo polya
function init_grid()
  for y = 1, rows do
    grid[y] = {}
    for x = 1, cols do
      grid[y][x] = flr(rnd(9)) + 1 -- sluchaynoe chislo ot 1 do 9
    end
  end
end

-- otrisovka igrovogo polya
function draw_grid()
  for y = 1, rows do
    for x = 1, cols do
      local num = grid[y][x]
      if num then
        if selected and selected.x == x and selected.y == y then
          rectfill((x - 1) * 8, (y - 1) * 8, (x - 1) * 8 + 7, (y - 1) * 8 + 7, 5) -- seriy fon
        end
        color(colors[num])
        print(num, (x - 1) * 8 + 2, (y - 1) * 8 + 1) -- sdvig chisla v kletke
      end
    end
  end
end

-- otrisovka kursora
function draw_cursor()
  rect((cursor.x - 1) * 8, (cursor.y - 1) * 8, (cursor.x - 1) * 8 + 7, (cursor.y - 1) * 8 + 7, 6)
end

-- obnovlenie taymera
function update_timer()
  if timer > 0 then
    timer -= 1/30
  else
    -- igra okonchena
    timer = 0
  end
end

-- obrabotka vybora kletok
function select_cell()
  if not selected then
    selected = {x = cursor.x, y = cursor.y}
  else
    local x1, y1 = selected.x, selected.y
    local x2, y2 = cursor.x, cursor.y

    if (abs(x1 - x2) == 1 and y1 == y2) or (abs(y1 - y2) == 1 and x1 == x2) then
      local num1 = grid[y1][x1]
      local num2 = grid[y2][x2]

      if num1 and num2 and num1 + num2 == 10 then
        grid[y1][x1] = nil
        grid[y2][x2] = nil
        score += 1
      end
    end

    selected = nil
  end
end

-- upravlenie kursorom
function update_cursor()
  if btnp(0) then cursor.x = max(1, cursor.x - 1) end
  if btnp(1) then cursor.x = min(cols, cursor.x + 1) end
  if btnp(2) then cursor.y = max(1, cursor.y - 1) end
  if btnp(3) then cursor.y = min(rows, cursor.y + 1) end

  if btnp(4) then select_cell() end
end

-- osnovnye funkcii pico-8
function _init()
  init_grid()
end

function _update()
  update_timer()
  update_cursor()
end

function _draw()
  cls()
  if timer > 0 then
    draw_grid()
    draw_cursor()

    -- otrisovka taymera i ochkov
    color(7)
    print("time: " .. flr(timer), 0, 96)
    print("score: " .. score, 0, 104)
  else
    -- igra okonchena, ochistka ekrana i vyvod ochkov
    cls()
    color(7)
    print("game over", 48, 50)
    print("score: " .. score, 48, 58)
  end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
