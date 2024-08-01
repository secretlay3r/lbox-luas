-- Original script https://github.com/Habnone/Lmaobox-Luas/blob/main/random_sentence.lua
-- The idea by lnx00 in thread https://lmaobox.net/forum/v/discussion/24261/realese-random-sentence-lua/p1
-- Preview https://imgur.com/a/qSuZiYg

-- Define a list of words
local words = {"drunk", "men", "fucker", "is", "are", "I", "them", "if", "after", "before", "then", "because", "that", "and", "or", "when", "where", "kill", "someone", "scout", "demoman", "pyro", "heavy", "sniper", "spy", "fucking", "fuck", "help", "attack", "defend", "point", "cart", "cap", "stop", "killing"}

    local killCount = 0
    
    local triggerKey = KEY_5 -- Change if you need to
    local lastButton = 0
    local anyButtonDown = false
    
    local function ButtonPressed(button)
        if input.IsButtonDown(button) and button ~= lastButton then
            lastButton = button
            anyButtonDown = true
        end
    
        if input.IsButtonDown(button) == false and button == lastButton then
            lastButton = 0
            anyButtonDown = false
            return true
        end
    
        if anyButtonDown == false then
            lastButton = 0
        end
        return false
    end
    
    -- Markov Chain stuff
    local statetab = {}
    local NOWORD = "\n"
    
    local function prefix(w1, w2)
        return w1 .. ' ' .. w2
    end
    
    -- Inserting words into the table
    local function insert(index, value)
        if not statetab[index] then
            statetab[index] = {}
        end
        table.insert(statetab[index], value)
    end
    
    -- Word iterator
    local function allwords()
        local text = table.concat(words, " ")
        local pos = 1
        return function()
            local s, e = string.find(text, "%S+", pos)
            if s then
                pos = e + 1
                return string.sub(text, s, e)
            end
        end
    end
    
    local function buildTable()
        local w1, w2 = NOWORD, NOWORD
        for w in allwords() do
            insert(prefix(w1, w2), w)
            w1 = w2
            w2 = w
        end
        insert(prefix(w1, w2), NOWORD)
    end
    
    local function getRandomStartingPrefix()
        local keys = {}
        for key in pairs(statetab) do
            if key ~= prefix(NOWORD, NOWORD) then
                table.insert(keys, key)
            end
        end
        return keys[math.random(#keys)]
    end
    
    local function generateRandomSentence()
        local startPrefix = getRandomStartingPrefix()
        local w1, w2 = startPrefix:match("(%S+) (%S+)")
        local sentence = {}
        for i = 1, math.random(4, 12) do
            local list = statetab[prefix(w1, w2)]
            local r = math.random(#list)
            local nextword = list[r]
            if nextword == NOWORD then break end
            table.insert(sentence, nextword)
            w1 = w2
            w2 = nextword
        end
        return table.concat(sentence, " ")
    end
    
    buildTable()
    
    -- Function to check if a value is in a table
    local function hasValue(tab, val)
        if type(val) == "table" then
            for _, v in ipairs(val) do
                if hasValue(tab, v) then
                    return true
                end
            end
            return false
        else
            for _, value in ipairs(tab) do
                if value == val then
                    return true
                end
            end
            return false
        end
    end
    
    -- List of blacklisted words
    local blacklist = {"Dexter", "bot", "f1", "f2", "kick", "aimbot", "wallhack", "walls", "hacking", "hack", "cheat", "cheating", "cheater", "sus", "bots", "kicking", "botting"}
    
    -- Function to split a string into words
    local function splitWords(str)
        local words = {}
        print("==================================")
        for word in str:gmatch("%S+") do
            if not hasValue(blacklist, word) then
                print("+ " .. word)
                table.insert(words, word)
            else
                print("- " .. word)
            end
        end
        print("==================================")
        return words
    end
    
    local function updateWordsTable(wordsTable, newWords)
        for _, word in ipairs(newWords) do
            table.insert(wordsTable, word)
        end
    end
    
    local function myCoolMessageHook(msg)
        if msg:GetID() == SayText2 then
            msg:SetCurBit(8) -- skip 2 bytes of padding
            local chatType = msg:ReadString(256)
            local playerName = msg:ReadString(256)
            local message = msg:ReadString(256)
            local randomSentence = generateRandomSentence()
            local start_timer = false
            if message ~= "TF_CHAT_ALL" and playerName ~= "Schizophrenia Gaming" then
                print(message)
                local rnd = math.random()
                if rnd > 0.5 then
                    client.ChatSay(string.lower(randomSentence))
                end
                local newWords = splitWords(message)
                updateWordsTable(words, newWords)
                buildTable()
            end
        end
    end
    
    callbacks.Register("DispatchUserMessage", myCoolMessageHook)
    
    local function sendMessage(cmd, timer)
        if ButtonPressed(triggerKey) then
            local randomSentence = generateRandomSentence()
            client.ChatSay(string.lower(randomSentence))
        end
        local time = 0
    end
    
    -- Register the sendMessage callback
    callbacks.Register("CreateMove", "messagesend", sendMessage)
    