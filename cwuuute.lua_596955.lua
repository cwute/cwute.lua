ffi.cdef[[
    typedef int(__fastcall* clantag_t)(const char*, const char*);
	bool PlaySound(const char *pszSound, void *hmod, uint32_t fdwSound);
]]

local fn_change_clantag = utils.PatternScan("engine.dll", "53 56 57 8B DA 8B F9 FF 15")
local set_clantag = ffi.cast("clantag_t", fn_change_clantag)
local Winmm = ffi.load("Winmm")

--menu elements
local clantagc = menu.Switch("cwute.lua", "Enable cwute clantag", false)
local openable = menu.Switch("cwute.lua", "Enable cwute openings", false)
local cursongc = menu.Switch("cwute.lua", "Enable currently played cwute song", true)
local pathToFiles = menu.TextBox("Files", "Path", 128, " ", "Example path: C:/Program Files (x86)/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/sound/ ")

-- https://docs.microsoft.com/en-us/previous-versions/dd743680(v=vs.85)
local function PlaySound(file)
    Winmm.PlaySound(file, nil, 0x00020003)   -- SND_ASYNC  | SND_NODEFAULT | SND_FILENAME
end    
--clantag animation
local animation = {
    "cwute",
    "cwut",
    "cwu",
    "cw",
    "c",
	"",
	"c",
    "cw",
    "cwu",
    "cwut",
    "cwute",
}
--openings
local curSong = {
    "Cagayake! GIRLS by Sakurakou Keion-bu",
    "Bon Appétit S by Blend A",
    "crossing field by LiSA",
    "Ren'ai Circulation by Kana Hanazawa",
    "Seven Doors by ZAQ",
    "Redo by Konomi Suzuki",
    "Katyusha from Girls und Panzer",
    "Black Rover by Vickeblanka",
    "Goya no Machiawase by Hello Sleepwalkers",
    "My Soul, Your Beats! by Lia",
    "Deal with the devil by Tia",
    "JUSTadICE by Seiko Oomori",
    "oath sign by LiSA",
    "Silhouette by KANA-BOON",
    "Centimeter by the peggies",
    "RESISTER by ASCA",
    "Spatto! Spy & Spyce by Tsukikage",
    "CLICK by ClariS ",
    "Kira Kira Days By Ho-kago Tea Time",
    "Bravely You by Lia",
    "Date A Live by sweet ARMS",
    "unravel by TK from Ling Tosite Sigure",
    "Chance! & Revenge! by Riko Azuna",
    "DreamRiser by Choucho",
    "Seishun Satsubatsu-ron by 3-nen E-gumi Utatan",
    "Shinzou wo Sasageyo! by Linked Horizon",
    "Zenzenzense by Radwimps",
    "Ring of Fortune by Eri Sasaki",
    "3-pun 29-byou by hitorie",
    "ADAMAS by LiSA ",
    "Gotoubun no Kimochi by Nakanoke no Itsuzugo",
    "the WORLD by Nightmare",
    "Yasashisa no Riyuu by ChouCho",
    "Mikansei Stride by Saori Kodama",
    "Non-Fantasy by LIP x LIP",
    "Zankoku na Yume to Nemure by Minami Kuribayashi",
    "Hikari no Hahen by Yu Takahashi",
    "HON-NO by EMPiRE",
    "Higher's High by Akari Nanawo",
    "Kimiiro Signal by Luna Haruna",
    "Koi-iro ni Sake  by CHiCO with HoneyWorks",
    "Dreamer by AiRI",
    "silky heart by Yui Horie",
    "Sincerely by TRUE",
    "Yukitoki by Nagi Yanagi",
    "This game by Konomi Suzuki",
}

local songName = {
    "kon.wav",
    "blends.wav",
    "sao.wav",
    "Bakemonogatari.wav",
    "trinityseven.wav",
    "rezero.wav",
    "katyusha.wav",
    "blackclover.wav",
    "noragami.wav",
    "angelbeats.wav",
    "kakegurui.wav",
    "blackclover2.wav",
    "fatezero.wav",
    "naruto.wav",
    "rentagirlfriend.wav",
    "saoalicization.wav",
    "releasethespyce.wav",
    "nisekoi.wav",
    "kirakiradays.wav",
    "charlotte.wav",
    "datealive.wav",
    "TokyoGhoul.wav",
    "Osamake.wav",
    "DreamRiser.wav",
    "AnsatsuKyoushitsu.wav",
    "AttackonTitan.wav",
    "AMV.wav",
    "PlasticMemories.wav",
    "TV.wav",
    "saoal2.wav",
    "quint.wav",
    "deathnote.wav",
    "hyouka.wav",
    "hyouka2.wav",
    "itsu.wav",
    "redo.wav",
    "orange.wav",
    "highrise.wav",
    "highers.wav",
    "kimiiro.wav",
    "koi.wav",
    "dreamer.wav",
    "toradora.wav",
    "violet.wav",
    "oregairu.wav",
    "nogame.wav",
}

cheat.RegisterCallback("events", function(event)
    if event:GetName() == "round_start" then
            rand = utils.RandomInt(1, 46) 
        if openable:GetBool() then
              folderPath = pathToFiles:GetString() .. songName[rand + 0]
              PlaySound(folderPath) 
        end
         if cursongc:GetBool() then
              cheat.AddNotify("cwute.lua playing:", curSong[rand])  
         end
    end
end)

local old_time = 0
cheat.RegisterCallback("draw", function()
    cursongc:SetVisible(openable:GetBool())
   local curtime = math.floor(g_GlobalVars.curtime)
     if clantagc:GetBool() then
        if old_time ~= curtime then 
            set_clantag(animation[curtime % #animation+1], animation[curtime % #animation+1])
        end
           old_time = curtime
    end
end)