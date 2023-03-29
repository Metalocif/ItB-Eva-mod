
-- create boss list
local bossList = easyEdit.bossList:add("Angels")

local EVA_bosses = {
  --"Mission_SachielBoss",
  "Mission_RamielBoss",
}

for _, boss in pairs(EVA_bosses) do
  bossList:addBoss(boss)
end