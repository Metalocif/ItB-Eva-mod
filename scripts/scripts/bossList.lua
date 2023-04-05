
-- create boss list
local bossList = easyEdit.bossList:add("Angels")

local EVA_bosses = {
  --"Mission_SachielBoss",
  "Mission_RamielBoss",
  "Mission_LelielBoss",
  "Mission_EVASeriesBoss",
}

for _, boss in pairs(EVA_bosses) do
  bossList:addBoss(boss)
end