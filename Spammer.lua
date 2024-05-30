script:name("Spammer") -- Имя скрипта
script:devs({"ConeTin"}) -- Разработчики
script:desc("Спаммер для анархий FunTime") -- Описание

currentIndex = 1
sended = false
anarcy_tp = false

Spammer = module.new("Spammer", "Спаммер для анархий FunTime")
text = input.new(Spammer, "Текст"):set("Как дела?")

files:read_web("https://rockstarity.fun/api/utility/spammer/spam-text.php?spam=" .. client:hwid())
--[[
hwid = client:hwid()
if string.find(files:read_web("https://pastebin.com/raw/EpucSier"), hwid) then
    client:print("§aПодписка обнаружена. Запуск.")
    client:print("Ваш хвид:" .. hwid)
else
    client:print("§4Подписка не обнаружена.")
    client:print("Ваш хвид:" .. hwid)
    client:unload()
end
]]

anarcy = {
    101, 102, 103, 104, 105, 106, 107, 108, 109,
    201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231,
    301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320,
    501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511,
    601, 602, 603, 604, 605, 606, 607
}

events.update:set(function(event)
    if Spammer:get() then
        --if player:ground() then
        --    player:jump()
        --end

        --client:print(currentIndex)

        if currentIndex > #anarcy then
            currentIndex = 1
        end

        if player:ticks() == 40 then
            player:msg(Spammer:get())
        end

        if player:ticks() == 50 then
            player:msg("/an"..anarcy[currentIndex])
            currentIndex = currentIndex + 1
        end
    end
end)