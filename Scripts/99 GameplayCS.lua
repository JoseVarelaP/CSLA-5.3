
function CurGameName()
	return GAMESTATE:GetCurrentGame():GetName()
end

function CurSOSet()
	if GAMESTATE:IsCourseMode() then
		return GAMESTATE:GetCurrentCourse();
	else return GAMESTATE:GetCurrentSong();
	end
end

function CurSTSet(pn)
	if GAMESTATE:IsCourseMode() then
		return GAMESTATE:GetCurrentTrail(pn);
	else return GAMESTATE:GetCurrentSteps(pn);
	end
end

-- Check the active game mode against a string. Cut down typing this in metrics.
function IsGame(str) return CurGameName() == str end

-- GetExtraColorThreshold()
-- [en] returns the difficulty threshold in meter
-- for songs that should be counted as boss songs.
function GetExtraColorThreshold()
	local Modes = {
		dance = 999999,
		pump = 999999,
		beat = 999999,
		kb7 = 999999,
		para = 999999,
		techno = 999999,
		lights = 999999, -- lights shouldn't be playable
	}
	return Modes[CurGameName()]
end

function StyleSetting()
	local Modes = {
		dance = "1,2,3,4",
		pump = "1,3,5,4",
		beat = "1",
		kb7 = "1",
		para = "1",
		maniax = "1",
		-- todo: add versus modes for technomotion
		techno = "1",
		lights = "1" -- lights shouldn't be playable
	}
	return Modes[CurGameName()]
end

function StyleSetting2()
	local Modes = {
		dance = "1,2,4",
		pump = "1,5,4",
		beat = "1",
		kb7 = "1",
		para = "1",
		maniax = "1",
		-- todo: add versus modes for technomotion
		techno = "1",
		lights = "1" -- lights shouldn't be playable
	}
	return Modes[CurGameName()]
end

function ComboContinue()
	local Continue = {
		--dance = GAMESTATE:GetPlayMode() == "PlayMode_Oni" and "TapNoteScore_W2" or GetAdhocPref("GoodCombo"),
		dance = GetAdhocPref("GoodCombo"),
		pump = "TapNoteScore_W3",
		beat = "TapNoteScore_W3",
		kb7 = "TapNoteScore_W3",
		para = "TapNoteScore_W4"
	}
	return Continue[CurGameName()]
end

function ComboUnderField()
	return GetUserPrefB("UserPrefComboUnderField")
end

function JudgmentTransformCommand( self, params )
	local x = 0
	local y = -30
	if params.bReverse then y = 20 end
	
	if params.bCentered then
		if params.bReverse then
			y = y + 70
		else
			y = y - 30
		end
	end
	self:x( x )
	self:y( y )
end

function JudgmentTransformSharedCommand( self, params )
	local x = 0
	local y = -30
	--if params.Player == PLAYER_1 then x = 120 end
	if params.bReverse then y = 20 end
	
	if params.bCentered then
		if params.bReverse then
			y = y + 70
		else
			y = y - 30
		end
	end
	self:x( x )
	self:y( y )
end

function ComboTransformCommand( self, params )
	local x = 0
	local y = 30
	if params.bReverse then y = -58 end

	if params.bCentered then
		if params.bReverse then
			y = y + 190
		else
			y = y - 180
		end
	end
	self:x( x )
	self:y( y )
end

function ScoreMissedHoldsAndRolls()
	if not IsGame("pump") and (not (IsGame("dance") and GetAdhocPref("HoldArrowJudge") == "1Point")) then
		return true
	else
		return false
	end
end

--[ja] プレイヤーx位置
function OnePlayerSoloPlay(pn)
	local IsUsingCenterPlay = PREFSMAN:GetPreference('Center1Player');
if GAMESTATE:GetCurrentStyle(pn) then
	local stylemode = GAMESTATE:GetCurrentStyle(pn):GetStepsType();

	--[ja] (2015/04/04修正) 最近のバージョンだとここを指定してしまうとノートのスケーリングがおかしくなる上にすでにセンタリングが自動で行われておりましたのでコメントアウト
	--if stylemode == 'StepsType_Dance_Solo' then return SCREEN_CENTER_X; end;
end;
	if pn == PLAYER_1 then
		return math.floor(scale((0.72/3),0,1,SCREEN_LEFT,SCREEN_RIGHT));
	else return math.floor(scale((2.28/3),0,1,SCREEN_LEFT,SCREEN_RIGHT));
	end;
end

function OnePlayerBattlePlay(pn)
	local pm = GAMESTATE:GetPlayMode()
	if pm == 'PlayMode_Battle' or pm == 'PlayMode_Rave' then
		if pn == PLAYER_1 then
			return math.floor(scale((0.72/3),0,1,SCREEN_LEFT,SCREEN_RIGHT));
		else return math.floor(scale((2.28/3),0,1,SCREEN_LEFT,SCREEN_RIGHT));
		end;
	else return SCREEN_CENTER_X;
	end
end

function GetPosition(pn)
	local IsUsingSoloSingles = PREFSMAN:GetPreference('Center1Player');
	local NumPlayers = GAMESTATE:GetNumPlayersEnabled();
	local strSide = GAMESTATE:GetCurrentStyle():GetStyleType();
	local stylemode = GAMESTATE:GetCurrentStyle():GetStepsType();
	if IsUsingSoloSingles and NumPlayers == 1 then return SCREEN_CENTER_X; end;
	if stylemode == 'StepsType_Dance_Solo' then return SCREEN_CENTER_X; end;
	
	return THEME:GetMetric("ScreenGameplay","Player".. ToEnumShortString(pn) .. ToEnumShortString(strSide) .."X");
end;

function mplayerposition()
	local IsUsingSoloSingles = PREFSMAN:GetPreference('Center1Player');
	local NumPlayers = GAMESTATE:GetNumPlayersEnabled();
	local mplayer = GAMESTATE:GetMasterPlayerNumber();
	local setx = SCREEN_CENTER_X;
	local strSide = GAMESTATE:GetCurrentStyle():GetStyleType();
	local stylemode = GAMESTATE:GetCurrentStyle():GetStepsType();
	if IsUsingSoloSingles and NumPlayers == 1 then
		if mplayer == PLAYER_1 then
			setx = GetPosition(mplayer)+GetPosition(mplayer)*0.5;
		else setx = GetPosition(mplayer)-GetPosition(mplayer)*0.5;
		end;
	end;
	if strSide == 'StyleType_OnePlayerTwoSides' or stylemode == 'StepsType_Dance_Solo' then
		if mplayer == PLAYER_1 then
			setx = GetPosition(mplayer)+GetPosition(mplayer)*0.5;
		else setx = GetPosition(mplayer)-GetPosition(mplayer)*0.5;
		end;
	end;
	return setx;
end

function stylecheckposition()
	local IsUsingSoloSingles = PREFSMAN:GetPreference('Center1Player');
	local NumPlayers = GAMESTATE:GetNumPlayersEnabled();
	local mplayer = GAMESTATE:GetMasterPlayerNumber();
	local setx = 0;
	local strSide = GAMESTATE:GetCurrentStyle():GetStyleType();
	local stylemode = GAMESTATE:GetCurrentStyle():GetStepsType();
	if IsUsingSoloSingles and NumPlayers == 1 then
		if mplayer == PLAYER_1 then setx = WideScale(-46,-72);
		else setx = WideScale(46,72);
		end;
	end;
	if strSide == 'StyleType_OnePlayerTwoSides' or stylemode == 'StepsType_Dance_Solo' then
		if mplayer == PLAYER_1 then setx = WideScale(-46,-72);
		else setx = WideScale(46,72);
		end;
	end;
	return setx;
end

--[ja] プレイヤーx位置
--20160701
function ColumnChecker(styles)
	local cp;
	local width = 0;
	local one = tonumber(THEME:GetMetric("ArrowEffects","ArrowSpacing"));
	local cstyle = GAMESTATE:GetCurrentStyle();
	if styles then
		cp = {
			dance = {Single = 4,Solo = 6,Double = 8},
			pump = {Single = 5,Halfdouble = 6,Double = 10},
                         techno = {single4 = 4,single5 = 5,single8 = 8,single9 =9},
		};
if CurGameName() == "techno" then
		local styleset = "Single4";
elseif CurGameName() == "gdgf" then
	local styleset = "5 Frets";
else
		local styleset = "Single";
		if styles ~= "nil" then
			styleset = styles;
		end;
		width = cstyle:ColumnsPerPlayer()*one;
end;

		--[ja] オブジェがかぶるので横幅が縮む分の計算
		if CurGameName() == "pump" then
			if styleset == "Halfdouble" or styleset == "Double" then
				width = (cp[CurGameName()][styleset]*(one*0.8))+16;
			else width = cp[CurGameName()][styleset]*(one*0.8);
			end;
		end;
	elseif cstyle then
if GAMESTATE:GetCurrentStyle() then
		local st = GAMESTATE:GetCurrentStyle():GetStepsType();
end;
		if st then
			cp = tonumber(GAMESTATE:GetCurrentStyle():ColumnsPerPlayer());
			width = cp*one;
			local sts = split("_",st);
			--[ja] オブジェがかぶるので横幅が縮む分の計算
			if CurGameName() == "pump" then
				if sts[3] == "Halfdouble" or sts[3] == "Double" or sts[3] == "Routine" then
					width = (cp*(one*0.8))+16;
				else width = cp*(one*0.8);
				end;
			end;
		end;
	end;
	width = round(width + (width % 2),5);
	return width;
end;

function GetScoreKeeper()
	local ScoreKeeper = "ScoreKeeperNormal"
--[[
	if GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
		ScoreKeeper = "ScoreKeeperRave"
	end
]]
	-- guitar has a separate scorekeeper
	if CurGameName() == 'guitar' then
		ScoreKeeper = "ScoreKeeperGuitar"
	end

	-- two players and shared sides need the Shared ScoreKeeper.
	local styleType = GAMESTATE:GetCurrentStyle():GetStyleType()
	if styleType == 'StyleType_TwoPlayersSharedSides' then
		ScoreKeeper = "ScoreKeeperShared"
	end

	return ScoreKeeper
end

function StageSelection()
	if GAMESTATE:IsAnExtraStage() then
		local bExtra2 = GAMESTATE:GetCurrentStage() == 'Stage_Extra2'
		if bExtra2 then return true
		else return false
		end
	end
end

function OldStyleStringToDifficulty(diff)
	if diff == "beginner" then		return "Difficulty_Beginner"
	elseif diff == "easy" then		return "Difficulty_Easy"
	elseif diff == "basic" then		return "Difficulty_Easy"
	elseif diff == "light" then		return "Difficulty_Easy"
	elseif diff == "medium" then	return "Difficulty_Medium"
	elseif diff == "another" then	return "Difficulty_Medium"
	elseif diff == "trick" then		return "Difficulty_Medium"
	elseif diff == "standard" then	return "Difficulty_Medium"
	elseif diff == "difficult" then	return "Difficulty_Medium"
	elseif diff == "hard" then		return "Difficulty_Hard"
	elseif diff == "ssr" then		return "Difficulty_Hard"
	elseif diff == "maniac" then		return "Difficulty_Hard"
	elseif diff == "heavy" then		return "Difficulty_Hard"
	elseif diff == "smaniac" then	return "Difficulty_Challenge"
	elseif diff == "challenge" then	return "Difficulty_Challenge"
	elseif diff == "expert" then		return "Difficulty_Challenge"
	elseif diff == "oni" then		return "Difficulty_Challenge"
	elseif diff == "edit" then 		return "Difficulty_Edit"
	else 						return "Difficulty_Hard"
	end
end

--[ja] プレイ中のフォルダから他のフォルダのExtra曲を指定した場合ExtraX.crsの情報の取得に問題があるので対策
function Ex1crsCheckSelMusic(bsong)
	local exsetstate = ""
	local style = GAMESTATE:GetCurrentStyle()
	if style then
		local bExtra = GAMESTATE:IsExtraStage2()
		local extrasong, extrasteps = SONGMAN:GetExtraStageInfo(bExtra, style)
		local exsong = ""
		local exsonglist = ""
		local extrasong_l = string.lower(bsong:GetGroupName())
		if getenv("groupexsonglist") ~= "" then
			local check = 1
			exsonglist = split(":",getenv("groupexsonglist"))
			if #exsonglist >= 1 then
				for i=1,#exsonglist do
					local exsonglist_l = string.lower(exsonglist[i])
					local exgpc = split("/",exsonglist_l)
					if extrasong_l == exgpc[1] then
						exsetstate = exgpc[2].."/"..exgpc[3];
						check = 0
						break
					end
				end
			end
			if check == 1 then
				local songu = string.lower(extrasong:GetSongDir())
				local songDir;
				local exgpc = split("/",songu)
				songDir = exgpc[3].."/"..exgpc[4];
				
				exsetstate = songDir
			end
		else
			local songu = string.lower(extrasong:GetSongDir())
			local songDir;
			local exgpc = split("/",songu)
			songDir = exgpc[3].."/"..exgpc[4];
			
			exsetstate = songDir
		end
	end
	return exsetstate
end

function Ex1crsCheck(song,bsong,extra)
	local exsetstate = "none"
	local style = GAMESTATE:GetCurrentStyle()
	if style then
		local extrasong, extrasteps = SONGMAN:GetExtraStageInfo(extra, style)
		local exsong
		local exsonglist
		local extrasong_l = string.lower(bsong:GetGroupName())
		local songDir
		local exsDir
		if getenv("groupexsonglist") ~= "" then
			local check = 1
			exsonglist = split(":",getenv("groupexsonglist"))
			if #exsonglist > 1 then
				for i=1,#exsonglist do
					local exsonglist_l = string.lower(exsonglist[i])
					local exgpc = split("/",exsonglist_l)
					if extrasong_l == exgpc[1] then
						check = 0
						songDir = exgpc[2].."/"..exgpc[3]
						--Trace("songDir:"..songDir)
						break
					end
				end
			end
			if check == 0 then
				local songu = string.lower(song:GetSongDir())
				local extrasongDir;
				local exgpc = split("/",songu)
				extrasongDir = exgpc[3].."/"..exgpc[4];
				--Trace("extrasongDir:"..extrasongDir)
				if extrasongDir == songDir then
					exsetstate = "crs_ex"
				end
			else
				if extrasong == song then
					exsetstate = "n_ex"
				end
			end
		else
			if extrasong == song then
				exsetstate = "n_ex"
			end
		end
	end
	return exsetstate
end

function GoToEX2()
	if getenv("exflag") == "csc" then
		local omsflag = getenv("omsflag");
		if omsflag == 1 then
			return true
		else return false
		end
	else
		local ssStats = STATSMAN:GetPlayedStageStats(2)
		local bsong = ssStats:GetPlayedSongs()[1]
		local song = GAMESTATE:GetCurrentSong()
		local bExtra = GAMESTATE:IsExtraStage2()
		local flagset = 0
		if Ex1crsCheck(song,bsong,bExtra) == "crs_ex" or Ex1crsCheck(song,bsong,bExtra) == "n_ex" then
			flagset = 1
		end
		if flagset == 1 then
			if getenv("nomflagp1") == 1 or getenv("nomflagp2") == 1 then
				return true
			else return false
			end
		else return false
		end
	end
end

function LifeDiffSetStr()
	return GetLifeDifficulty()
end

function g_box_setcount()
	return 50
end

--[ja] ステージセット各種
function cstage_set(cStage)
	local s_count = 0;
	local stageindex = GAMESTATE:GetCurrentStageIndex();
	if stageindex > 0 then
		if cStage ~= 'Stage_1st' and 
		cStage ~= 'Stage_Extra1' and cStage ~= 'Stage_Extra2' then
			for s=1,stageindex do
				local ssStats = STATSMAN:GetPlayedStageStats( s );
				local sssong = ssStats:GetPlayedSongs()[1];
				s_count = s_count + sssong:GetStageCost();
			end;
		end;
	end;
	s_count = s_count + 1;
	return s_count;
end

function estage_set(w,stagetable,pStage,sssong,maxStages)
	local stageStr = "1st";
	local cStage = 'Stage_'..stageStr;
	if pStage ~= 'Stage_Final' and pStage ~= 'Stage_Extra1' and pStage ~= 'Stage_Extra2' then
		local StagesSetting = sssong:GetStageCost();
		local sset = 1;
		if w > 1 then
			stagetable[w] = stagetable[w-1] + StagesSetting;
		else stagetable[w] = StagesSetting;
		end;
		sset = stagetable[w] - (StagesSetting - 1);
		if stagetable[w] then
			stageStr = FormatNumberAndSuffix( sset );
			if stagetable[w] >= maxStages then
				cStage = 'Stage_Final';
			else cStage = 'Stage_'..stageStr;
			end;
		end;
	else cStage = pStage;
	end;
	return cStage;
end

function cstage_imagse_set(ist)
	cStage = 'Stage_1st';
	if GAMESTATE:IsCourseMode() then
		cStage = GAMESTATE:GetCurrentStage();
	else
		if GAMESTATE:IsEventMode() then
			cStage = 'Stage_Event';
		else
			local bExtra1 = GAMESTATE:IsExtraStage();
			local bExtra2 = GAMESTATE:IsExtraStage2();
			if bExtra1 then
				cStage = 'Stage_Extra1';
			elseif bExtra2 then
				cStage = 'Stage_Extra2';
			else
				cStage = "Stage_"..FormatNumberAndSuffix( ist );
				local maxStages = PREFSMAN:GetPreference("SongsPerPlay");
				local song = GAMESTATE:GetCurrentSong();
				local st_cost = 0;
				if song then
					st_cost = (song:GetStageCost() - 1);
				end;
				if ist + st_cost >= maxStages then
					cStage = 'Stage_Final';
				end;
			end;
		end;
	end;
	return cStage;
end

--[ja] 選択難易度・選曲画面ライバル表示セット
function sc_change_diff_set(pn,p)
	local pstr = ProfIDSet(p);
	if not GAMESTATE:IsCourseMode() then
		local pdiff = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
		SetAdhocPref("ProfCDifficulty",pdiff,pstr);
	end;
end

function sc_change_rt_set(p,sc)
	local pstr = ProfIDSet(p);
	local ropen = ProfIDPrefCheck("SRivalOpen",pstr,1);
	local adgraph = ProfIDPrefCheck("ScoreGraph",pstr,"Off");
	if ropen ~= getenv("s_rival_op"..p) then
		if sc == "sel" then
			SetAdhocPref("SRivalOpen",getenv("s_rival_op"..p),pstr);
		else setenv("s_rival_op"..p,ropen);
		end;
	end;
	if adgraph ~= getenv("scoregraphp"..p) then
		if sc == "sel" then
			SetAdhocPref("ScoreGraph",getenv("scoregraphp"..p),pstr);
		else setenv("scoregraphp"..p,adgraph);
		end;
	end;
	--20171229
	local pm = ToEnumShortString(GAMESTATE:GetPlayMode());
	if pm ~= 'Nonstop' and pm ~= 'Oni' and pm ~= 'Endless' then
		if #GAMESTATE:GetHumanPlayers() < 2 then
			local lsort = ProfIDPrefCheck("LastSortCh",pstr,"Group,ntype");
			local s_sort_c = split(",",lsort);
			if s_sort_c[2] ~= "ntype" and s_sort_c[2] ~= "default" then
				s_sort_c[2] = "ntype";
			end;
			if s_sort_c[1] ~= getenv("SortCh") then
				if sc == "sel" then
					SetAdhocPref("LastSortCh",getenv("SortCh")..","..s_sort_c[2],pstr);
				else setenv("SortCh",lsort);
				end;
			end;
		end;
	end;
end

--20170919
function sgbtsetting(self,song,pstage,mstages,maxstages)
	local brlist;
	local songtitle;
	local songartist;
	local songcolor;
	self:SetFromSong( song );
	local groupcolor = SONGMAN:GetSongColor(song);
	local sectioncolorlist = getenv("sectioncolorlist");
	local sdirs = split("/",song:GetSongDir());
	local bes = "BranchList";
	if GAMESTATE:IsExtraStage() and getenv("exflag") == "csc" then
		bes = "Extra1Songs";
	end;
	brlist = GetGroupParameter(song:GetGroupName(),bes);
	
	local ssStage = STATSMAN:GetCurStageStats():GetStage();
	local bExtra = GAMESTATE:IsExtraStage();
	local extracolor = THEME:GetMetric("MusicWheel","SongRealExtraColor");
	local screen = SCREENMAN:GetTopScreen();
	local ssStats;
	local sssong;
	local evaflag = 0;
	local cflag = 0;

	if screen then
		if THEME:GetMetric( screen:GetName(), "Class" ) == "ScreenEvaluation" then
			evaflag = 1;
			if THEME:GetMetric( screen:GetName(), "HeaderTitle" ) == "Summary" then
				ssStage = pstage;
				if ssStage == "Stage_Extra1" then
					if mstages == maxstages + 2 then
						ssStats = STATSMAN:GetPlayedStageStats(3);
					elseif mstages == maxstages + 1 then
						ssStats = STATSMAN:GetPlayedStageStats(2);
					end;
					sssong = ssStats:GetPlayedSongs()[1];
				end;
			else
				if ssStage == "Stage_Extra1" then
					ssStats = STATSMAN:GetPlayedStageStats(2);
					sssong = ssStats:GetPlayedSongs()[1];
				end;
			end;
			if ssStage == "Stage_Extra1" then
				if getenv("exflag") ~= "csc" and
				(Ex1crsCheck(song,sssong,bExtra) == "crs_ex" or Ex1crsCheck(song,sssong,bExtra) == "n_ex") then
					groupcolor = extracolor;
					cflag = 1;
				end;
			elseif ssStage == "Stage_Extra2" then
				groupcolor = extracolor;
				cflag = 1;
			end;
		else
			if GAMESTATE:IsExtraStage() then
				if getenv("exflag") ~= "csc" then
					local songu = string.lower(song:GetSongDir());
					local songDir;
					local exgpc = split("/",songu)
					songDir = exgpc[3].."/"..exgpc[4];
					if getenv("Ex1crsCheckSelMusic") == songDir then
						groupcolor = extracolor;
						cflag = 1;
					end;
				end;
			elseif GAMESTATE:IsExtraStage2() then
				groupcolor = extracolor;
				cflag = 1;
			end;
			if getenv("rnd_song") == 1 then
				songtitle = b_s_pr(brlist,song,"Title");
				songartist = b_s_pr(brlist,song,"Artist");
				songcolor = b_s_pr(brlist,song,"Color");
				if songtitle then
					if not songartist then
						songartist = "";
					end;
					self:SetFromString( songtitle, "", "", "", songartist, "" );
				end;
			end;
		end;
		if cflag == 0 then
			if songcolor then
				groupcolor = color(songcolor);
			else
				if sectioncolorlist ~= "" then
					if sectioncolorlist[song:GetGroupName().."/"..sdirs[4]] then
						if evaflag == 1 then
							groupcolor = color(sectioncolorlist[song:GetGroupName().."/"..sdirs[4]]);
						elseif getenv("rnd_song") ~= 1 then
							groupcolor = color(sectioncolorlist[song:GetGroupName().."/"..sdirs[4]]);
						elseif sectioncolorlist[song:GetGroupName()] then
							groupcolor = color(sectioncolorlist[song:GetGroupName()]);
						end;
					elseif sectioncolorlist[song:GetGroupName()] then
						groupcolor = color(sectioncolorlist[song:GetGroupName()]);
					end;
				end;
			end;
		end;
	end;
	self:diffuse(groupcolor);
	return self;
end