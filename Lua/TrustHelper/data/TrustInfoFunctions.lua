-- Copyright © 2021, Celdtun
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
--     * Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
--     * Neither the name of <addon name> nor the
--      names of its contributors may be used to endorse or promote products
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL Celdtun BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-- TrustCastFunctions Details
-- Variables
--   info_functions.print_to_log
--   info_functions.command
--   info_functions.message_echo
--   info_functions.cast_wait_time
--   info_functions.num_supported_trusts
-- Functions
--   info_functions.loadTrusts( player_spells, include_echo)
--   info_functions.generateTrustCommand( trust_name, include_echo, dismiss_name)
--   info_functions.displaySupportedTrusts( )
--   info_functions.getMaxNumberTrusts( )
--   info_functions.getPartyInformation( )
--   info_functions.initialize( bind_funct, file_funct, position_funct, sets_funct)

resources = require( 'resources')
spells = resources.spells

info_functions = { }

-- Set to true to print logging messages to the lua.log file in the addon directory
info_functions.print_to_log = true

-- Primary table that contains information on all trusts that the player can summon
--   trust: Name of the trust
--   cast_command: Casting command for the trust
--   dismiss_command: Dismissing command for the trust
info_functions.command = { 
},{ id, trust, cast_command, dismiss_command}
-- Boolean to display echos with each command
--   true: Display echos
--   false: Do not display echos
info_functions.message_echo = true
-- Time between trust when casting all trusts
info_functions.cast_wait_time = 5.8
info_functions.num_supported_trusts = 0

-- Used to generate the command table containing all information for the known trusts
--     IDs are based on the Windower resourse spells and current as of Feb. 19, 2021
-- Inputs
--   player_spells: ( REQUIRED) List of spells the user knows; Generated from windower.ffxi.get_spells()
--   include_echo: ( REQUIRED) Include the echo command in the command; true or false
-- Returns
--   None
function info_functions.loadTrusts( player_spells, include_echo)

  info_functions.message_echo = include_echo
  
	-- Shantotto - Spell ID: 896
	if( player_spells[ 896] == true) then
		info_functions.generateTrustCommand( "Shantotto", include_echo) end
	-- Naji - Spell ID: 897
	if( player_spells[ 897] == true) then
		info_functions.generateTrustCommand( "Naji", include_echo) end
	-- Kupipi - Spell ID: 898
	if( player_spells[ 898] == true) then
		info_functions.generateTrustCommand( "Kupipi", include_echo) end
	-- Excenmille - Spell ID: 899
	if( player_spells[ 899] == true) then
		info_functions.generateTrustCommand( "Excenmille", include_echo) end
	-- Ayame - Spell ID: 900
	if( player_spells[ 900] == true) then
		info_functions.generateTrustCommand( "Ayame", include_echo) end
	-- Nanaa Mihgo - Spell ID: 901
	if( player_spells[ 901] == true) then
		info_functions.generateTrustCommand( "Nanaa Mihgo", include_echo) end
	-- Curilla - Spell ID: 902
	if( player_spells[ 902] == true) then
		info_functions.generateTrustCommand( "Curilla", include_echo) end
	-- Volker - Spell ID: 903
	if( player_spells[ 903] == true) then
		info_functions.generateTrustCommand( "Volker", include_echo) end
	-- Ajido-Marujido - Spell ID: 904
	if( player_spells[ 904] == true) then
		info_functions.generateTrustCommand( "Ajido-Marujido", include_echo) end
	-- Trion - Spell ID: 905
	if( player_spells[ 905] == true) then
		info_functions.generateTrustCommand( "Trion", include_echo) end
	-- Zeid - Spell ID: 906
	if( player_spells[ 906] == true) then
		info_functions.generateTrustCommand( "Zeid", include_echo) end
	-- Lion - Spell ID: 907
	if( player_spells[ 907] == true) then
		info_functions.generateTrustCommand( "Lion", include_echo) end
	-- Tenzen - Spell ID: 908
	if( player_spells[ 908] == true) then
		info_functions.generateTrustCommand( "Tenzen", include_echo) end
	-- Mihli Aliapoh - Spell ID: 909
	if( player_spells[ 909] == true) then
		info_functions.generateTrustCommand( "Mihli Aliapoh", include_echo) end
	-- Valaineral - Spell ID: 910
	if( player_spells[ 910] == true) then
		info_functions.generateTrustCommand( "Valaineral", include_echo) end
	-- Joachim - Spell ID: 911
	if( player_spells[ 911] == true) then
		info_functions.generateTrustCommand( "Joachim", include_echo) end
	-- Naja Salaheem - Spell ID: 912
	if( player_spells[ 912] == true) then
		info_functions.generateTrustCommand( "Naja Salaheem", include_echo) end
	-- Prishe - Spell ID: 913
	if( player_spells[ 913] == true) then
		info_functions.generateTrustCommand( "Prishe", include_echo) end
	-- Ulmia - Spell ID: 914
	if( player_spells[ 914] == true) then
		info_functions.generateTrustCommand( "Ulmia", include_echo) end
	-- Shikaree Z - Spell ID: 915
	if( player_spells[ 915] == true) then
		info_functions.generateTrustCommand( "Shikaree Z", include_echo) end
	-- Cherukiki - Spell ID: 916
	if( player_spells[ 916] == true) then
		info_functions.generateTrustCommand( "Cherukiki", include_echo) end
	-- Iron Eater - Spell ID: 917
	if( player_spells[ 917] == true) then
		info_functions.generateTrustCommand( "Iron Eater", include_echo) end
	-- Gessho - Spell ID: 918
	if( player_spells[ 918] == true) then
		info_functions.generateTrustCommand( "Gessho", include_echo) end
	-- Gadalar - Spell ID: 919
	if( player_spells[ 919] == true) then
		info_functions.generateTrustCommand( "Gadalar", include_echo) end
	-- Rainemard - Spell ID: 920
	if( player_spells[ 920] == true) then
		info_functions.generateTrustCommand( "Rainemard", include_echo) end
	-- Ingrid - Spell ID: 921
	if( player_spells[ 921] == true) then
		info_functions.generateTrustCommand( "Ingrid", include_echo) end
	-- Lehko Habhoka - Spell ID: 922
	if( player_spells[ 922] == true) then
		info_functions.generateTrustCommand( "Lehko Habhoka", include_echo) end
	-- Nashmeira - Spell ID: 923
	if( player_spells[ 923] == true) then
		info_functions.generateTrustCommand( "Nashmeira", include_echo) end
	-- Zazarg - Spell ID: 924
	if( player_spells[ 924] == true) then
		info_functions.generateTrustCommand( "Zazarg", include_echo) end
	-- Ovjang - Spell ID: 925
	if( player_spells[ 925] == true) then
		info_functions.generateTrustCommand( "Ovjang", include_echo) end
	-- Mnejing - Spell ID: 926
	if( player_spells[ 926] == true) then
		info_functions.generateTrustCommand( "Mnejing", include_echo) end
	-- Sakura - Spell ID: 927
	if( player_spells[ 927] == true) then
		info_functions.generateTrustCommand( "Sakura", include_echo) end
	-- Luzaf - Spell ID: 928
	if( player_spells[ 928] == true) then
		info_functions.generateTrustCommand( "Luzaf", include_echo) end
	-- Najelith - Spell ID: 929
	if( player_spells[ 929] == true) then
		info_functions.generateTrustCommand( "Najelith", include_echo) end
	-- Aldo - Spell ID: 930
	if( player_spells[ 930] == true) then
		info_functions.generateTrustCommand( "Aldo", include_echo) end
	-- Moogle - Spell ID: 931
	if( player_spells[ 931] == true) then
		info_functions.generateTrustCommand( "Moogle", include_echo) end
	-- Fablinix - Spell ID: 932
	if( player_spells[ 932] == true) then
		info_functions.generateTrustCommand( "Fablinix", include_echo) end
	-- Maat - Spell ID: 933
	if( player_spells[ 933] == true) then
		info_functions.generateTrustCommand( "Maat", include_echo) end
	-- D. Shantotto - Spell ID: 934
	if( player_spells[ 934] == true) then
		info_functions.generateTrustCommand( "D. Shantotto", include_echo) end
	-- Star Sibyl - Spell ID: 935
	if( player_spells[ 935] == true) then
		info_functions.generateTrustCommand( "Star Sibyl", include_echo) end
	-- Karaha-Baruha - Spell ID: 936
	if( player_spells[ 936] == true) then
		info_functions.generateTrustCommand( "Karaha-Baruha", include_echo) end
	-- Cid - Spell ID: 937
	if( player_spells[ 937] == true) then
		info_functions.generateTrustCommand( "Cid", include_echo) end
	-- Gilgamesh - Spell ID: 938
	if( player_spells[ 938] == true) then
		info_functions.generateTrustCommand( "Gilgamesh", include_echo) end
	-- Areuhat - Spell ID: 939
	if( player_spells[ 939] == true) then
		info_functions.generateTrustCommand( "Areuhat", include_echo) end
	-- Semih Lafihna - Spell ID: 940
	if( player_spells[ 940] == true) then
		info_functions.generateTrustCommand( "Semih Lafihna", include_echo) end
	-- Elivira - Spell ID: 941
	if( player_spells[ 941] == true) then
		info_functions.generateTrustCommand( "Elivira", include_echo) end
	-- Noillurie - Spell ID: 942
	if( player_spells[ 942] == true) then
		info_functions.generateTrustCommand( "Noillurie", include_echo) end
	-- Lhu Mhakaracc - Spell ID: 943
	if( player_spells[ 943] == true) then
		info_functions.generateTrustCommand( "Lhu Mhakaracc", include_echo) end
	-- Ferreous Coffin - Spell ID: 944
	if( player_spells[ 944] == true) then
		info_functions.generateTrustCommand( "Ferreous Coffin", include_echo) end
	-- Lilisette - Spell ID: 945
	if( player_spells[ 945] == true) then
		info_functions.generateTrustCommand( "Lilisette", include_echo) end
	-- Mumor - Spell ID: 946
	if( player_spells[ 946] == true) then
		info_functions.generateTrustCommand( "Mumor", include_echo) end
	-- Uka Totlihn - Spell ID: 947
	if( player_spells[ 947] == true) then
		info_functions.generateTrustCommand( "Uka Totlihn", include_echo) end
	-- Klara - Spell ID: 948
	if( player_spells[ 948] == true) then
		info_functions.generateTrustCommand( "Klara", include_echo) end
	-- Romaa Mihgo - Spell ID: 949
	if( player_spells[ 949] == true) then
		info_functions.generateTrustCommand( "Romaa Mihgo", include_echo) end
	-- Kuyin Hathdenna - Spell ID: 950
	if( player_spells[ 950] == true) then
		info_functions.generateTrustCommand( "Kuyin Hathdenna", include_echo) end
	-- Rahal - Spell ID: 951
	if( player_spells[ 951] == true) then
		info_functions.generateTrustCommand( "Rahal", include_echo) end
	-- Koru-Moru - Spell ID: 952
	if( player_spells[ 952] == true) then
		info_functions.generateTrustCommand( "Koru-Moru", include_echo) end
	-- Pieuje (UC) - Spell ID: 953
	if( player_spells[ 953] == true) then
		info_functions.generateTrustCommand( "Pieuje (UC)", include_echo, "Pieuje") end
	-- I. Shield (UC) - Spell ID: 954
	if( player_spells[ 954] == true) then
		info_functions.generateTrustCommand( "I. Shield (UC)", include_echo) end
	-- Apururu (UC) - Spell ID: 955
	if( player_spells[ 955] == true) then
		info_functions.generateTrustCommand( "Apururu (UC)", include_echo, "Apururu") end
	-- Jakoh (UC) - Spell ID: 956
	if( player_spells[ 956] == true) then
		info_functions.generateTrustCommand( "Jakoh (UC)", include_echo, "Jakoh") end
	-- Flaviria (UC) - Spell ID: 957
	if( player_spells[ 957] == true) then
		info_functions.generateTrustCommand( "Flaviria (UC)", include_echo, "Flaviria") end
	-- Babban - Spell ID: 958
	if( player_spells[ 958] == true) then
		info_functions.generateTrustCommand( "Babban", include_echo) end
	-- Abenzio - Spell ID: 959
	if( player_spells[ 959] == true) then
		info_functions.generateTrustCommand( "Abenzio", include_echo) end
	-- Rughadjeen - Spell ID: 960
	if( player_spells[ 960] == true) then
		info_functions.generateTrustCommand( "Rughadjeen", include_echo) end
	-- Kukki-Chebukki - Spell ID: 961
	if( player_spells[ 961] == true) then
		info_functions.generateTrustCommand( "Kukki-Chebukki", include_echo) end
	-- Margret - Spell ID: 962
	if( player_spells[ 962] == true) then
		info_functions.generateTrustCommand( "Margret", include_echo) end
	-- Chacharoon - Spell ID: 963
	if( player_spells[ 963] == true) then
		info_functions.generateTrustCommand( "Chacharoon", include_echo) end
	-- Lhe Lhangavo - Spell ID: 964
	if( player_spells[ 964] == true) then
		info_functions.generateTrustCommand( "Lhe Lhangavo", include_echo) end
	-- Arciela - Spell ID: 965
	if( player_spells[ 965] == true) then
		info_functions.generateTrustCommand( "Arciela", include_echo) end
	-- Mayakov - Spell ID: 966
	if( player_spells[ 966] == true) then
		info_functions.generateTrustCommand( "Mayakov", include_echo) end
	-- Qultada - Spell ID: 967
	if( player_spells[ 967] == true) then
		info_functions.generateTrustCommand( "Qultada", include_echo) end
	-- Adelheid - Spell ID: 968
	if( player_spells[ 968] == true) then
		info_functions.generateTrustCommand( "Adelheid", include_echo) end
	-- Amchuchu - Spell ID: 969
	if( player_spells[ 969] == true) then
		info_functions.generateTrustCommand( "Amchuchu", include_echo) end
	-- Brygid - Spell ID: 970
	if( player_spells[ 970] == true) then
		info_functions.generateTrustCommand( "Brygid", include_echo) end
	-- Mildaurion - Spell ID: 971
	if( player_spells[ 971] == true) then
		info_functions.generateTrustCommand( "Mildaurion", include_echo) end
	-- Halver - Spell ID: 972
	if( player_spells[ 972] == true) then
		info_functions.generateTrustCommand( "Halver", include_echo) end
	-- Rongelouts - Spell ID: 973
	if( player_spells[ 973] == true) then
		info_functions.generateTrustCommand( "Rongelouts", include_echo) end
	-- Leonoyne - Spell ID: 974
	if( player_spells[ 974] == true) then
		info_functions.generateTrustCommand( "Leonoyne", include_echo) end
	-- Maximilian - Spell ID: 975
	if( player_spells[ 975] == true) then
		info_functions.generateTrustCommand( "Maximilian", include_echo) end
	-- Kayeel-Payeel - Spell ID: 976
	if( player_spells[ 976] == true) then
		info_functions.generateTrustCommand( "Kayeel-Payeel", include_echo) end
	-- Robel-Akbel - Spell ID: 977
	if( player_spells[ 977] == true) then
		info_functions.generateTrustCommand( "Robel-Akbel", include_echo) end
	-- Kupofried - Spell ID: 978
	if( player_spells[ 978] == true) then
		info_functions.generateTrustCommand( "Kupofried", include_echo) end
	-- Selh'teus - Spell ID: 979
	if( player_spells[ 979] == true) then
		info_functions.generateTrustCommand( "Selh'teus", include_echo) end
	-- Yoran-Oran (UC) - Spell ID: 980
	if( player_spells[ 980] == true) then
		info_functions.generateTrustCommand( "Yoran-Oran (UC)", include_echo) end
	-- Sylvie (UC) - Spell ID: 981
	if( player_spells[ 981] == true) then
		info_functions.generateTrustCommand( "Sylvie (UC)", include_echo) end
	-- Abquhbah - Spell ID: 982
	if( player_spells[ 982] == true) then
		info_functions.generateTrustCommand( "Abquhbah", include_echo) end
	-- Balamor - Spell ID: 983
	if( player_spells[ 983] == true) then
		info_functions.generateTrustCommand( "Balamor", include_echo) end
	-- August - Spell ID: 984
	if( player_spells[ 984] == true) then
		info_functions.generateTrustCommand( "August", include_echo) end
	-- Rosulatia - Spell ID: 985
	if( player_spells[ 985] == true) then
		info_functions.generateTrustCommand( "Rosulatia", include_echo) end
	-- Teodor - Spell ID: 986
	if( player_spells[ 986] == true) then
		info_functions.generateTrustCommand( "Teodor", include_echo) end
	-- Ullegore - Spell ID: 987
	if( player_spells[ 987] == true) then
		info_functions.generateTrustCommand( "Ullegore", include_echo) end
	-- Makki-Chebukki - Spell ID: 988
	if( player_spells[ 988] == true) then
		info_functions.generateTrustCommand( "Makki-Chebukki", include_echo) end
	-- King of Hearts - Spell ID: 989
	if( player_spells[ 989] == true) then
		info_functions.generateTrustCommand( "King of Hearts", include_echo) end
	-- Morimar - Spell ID: 990
	if( player_spells[ 990] == true) then
		info_functions.generateTrustCommand( "Morimar", include_echo) end
	-- Darrcuiln - Spell ID: 991
	if( player_spells[ 991] == true) then
		info_functions.generateTrustCommand( "Darrcuiln", include_echo) end
	-- AAHM - Spell ID: 992
	if( player_spells[ 992] == true) then
		info_functions.generateTrustCommand( "AAHM", include_echo) end
	-- AAEV - Spell ID: 993
	if( player_spells[ 993] == true) then
		info_functions.generateTrustCommand( "AAEV", include_echo) end
	-- AAMR - Spell ID: 994
	if( player_spells[ 994] == true) then
		info_functions.generateTrustCommand( "AAMR", include_echo) end
	-- AATT - Spell ID: 995
	if( player_spells[ 995] == true) then
		info_functions.generateTrustCommand( "AATT", include_echo) end
	-- AAGK - Spell ID: 996
	if( player_spells[ 996] == true) then
		info_functions.generateTrustCommand( "AAGK", include_echo) end
	-- Iroha - Spell ID: 997
	if( player_spells[ 997] == true) then
		info_functions.generateTrustCommand( "Iroha", include_echo) end
	-- Ygnas - Spell ID: 998
	if( player_spells[ 998] == true) then
		info_functions.generateTrustCommand( "Ygnas", include_echo) end
	-- Monberaux - Spell ID: 999
	if( player_spells[ 999] == true) then
		info_functions.generateTrustCommand( "Monberaux", include_echo) end
	-- Matsui-P - Spell ID: 1003
	if( player_spells[ 1003] == true) then
		info_functions.generateTrustCommand( "Matsui-P", include_echo) end
	-- Excenmille [S] - Spell ID: 1004
	if( player_spells[ 1004] == true) then
		info_functions.generateTrustCommand( "Excenmille [S]", include_echo) end
	-- Ayame (UC) - Spell ID: 1005
	if( player_spells[ 1005] == true) then
		info_functions.generateTrustCommand( "Ayame (UC)", include_echo) end
	-- Maat (UC) - Spell ID: 1006
	if( player_spells[ 1006] == true) then
		info_functions.generateTrustCommand( "Maat (UC)", include_echo) end
	-- Aldo (UC) - Spell ID: 1007
	if( player_spells[ 1007] == true) then
		info_functions.generateTrustCommand( "Aldo (UC)", include_echo) end
	-- Naja (UC) - Spell ID: 1008
	if( player_spells[ 1008] == true) then
		info_functions.generateTrustCommand( "Naja (UC)", include_echo) end
	-- Lion II - Spell ID: 1009
	if( player_spells[ 1009] == true) then
		info_functions.generateTrustCommand( "Lion II", include_echo, "Lion") end
	-- Zeid II - Spell ID: 1010
	if( player_spells[ 1010] == true) then
		info_functions.generateTrustCommand( "Zeid II", include_echo, "Zeid") end
	-- Prishe II - Spell ID: 1011
	if( player_spells[ 1011] == true) then
		info_functions.generateTrustCommand( "Prishe II", include_echo, "Prishe") end
	-- Nashmeira II - Spell ID: 1012
	if( player_spells[ 1012] == true) then
		info_functions.generateTrustCommand( "Nashmeira II", include_echo, "Nashmeira") end
	-- Lilisette II - Spell ID: 1013
	if( player_spells[ 1013] == true) then
		info_functions.generateTrustCommand( "Lilisette II", include_echo, "Lilisette") end
	-- Tenzen II - Spell ID: 1014
	if( player_spells[ 1014] == true) then
		info_functions.generateTrustCommand( "Tenzen II", include_echo, "Tenzen") end
	-- Mumor II - Spell ID: 1015
	if( player_spells[ 1015] == true) then
		info_functions.generateTrustCommand( "Mumor II", include_echo, "Mumor") end
	-- Ingrid II - Spell ID: 1016
	if( player_spells[ 1016] == true) then
		info_functions.generateTrustCommand( "Ingrid II", include_echo, "Ingrid") end
	-- Arciela II - Spell ID: 1017
	if( player_spells[ 1017] == true) then
		info_functions.generateTrustCommand( "Arciela II", include_echo, "Arciela") end
	-- Iroha II - Spell ID: 1018
	if( player_spells[ 1018] == true) then
		info_functions.generateTrustCommand( "Iroha II", include_echo, "Iroha") end
	-- Shantotto II - Spell ID: 1019
	if( player_spells[ 1019] == true) then
		info_functions.generateTrustCommand( "Shantotto II", include_echo, "Shantotto") end
end
-- Used to generate casting and dismissing commands for a specified trust_name
-- Inputs
--   trust_name: ( REQUIRED) Name of the trust; Example 'King of Hearts' or 'Lion II'
--   include_echo: ( REQUIRED) Include the echo command in the command; true or false
--   dismiss_name: Name used to dismiss the trust if different from the trust name;
--       Example: 'Lion'
-- Returns
--   None
function info_functions.generateTrustCommand( trust_name, include_echo, dismiss_name)
  local cast_str = ''
  local dismiss_str = ''
	local name = trust_name:gsub( ' ', '')
	
  -- If include echo input is not false, Aad the echos to the command strings
  if( include_echo ~= false) then
    -- Example: 'input /echo ~~~~~ Casting King of Hearts ~~~~~; '
    cast_str = cast_str .. 'input /echo ~~~~~ Casting ' .. trust_name .. ' ~~~~~; '
    -- Example: 'input /echo ~~~~~ Dismissing King of Hearts ~~~~~; '
    dismiss_str = dismiss_str .. 'input /echo ~~~~~ Dismissing ' .. trust_name .. ' ~~~~~; '
  end

  -- Generate the remainder of the casting commands
  --   Example: 'input /echo ~~~~~ Casting King of Hearts ~~~~~; input /ma "King of Hearts" <me>;'
  --   Example: 'input /echo ~~~~~ Casting Lion II ~~~~~; input /ma "Lion II" <me>;'
	cast_str = cast_str .. 'input /ma "' .. trust_name .. '" <me>;'
  
  -- Determine if the dismiss command is the same as the casting command
	if( dismiss_name == nil) then
    -- Generate the remainder of the dismissing command; same name as casting
    --   Example: 'input /echo ~~~~~ Dismissing King of Hearts ~~~~~; input /retr "King of Hearts";'
    dismiss_str = dismiss_str .. 'input /retr "' .. trust_name .. '";'
	else
    -- Generate the remainder of the dismissing command; different name as casting
    --   Example: 'input /echo ~~~~~ Dismissing Lion II ~~~~~; input /retr "Lion";'
    dismiss_str = dismiss_str .. 'input /retr "' .. dismiss_name .. '";'
	end

	info_functions.num_supported_trusts = info_functions.num_supported_trusts + 1

  -- Add the trust to the command table
	info_functions.command[ name:lower()] = { 
    id = info_functions.num_supported_trusts,
    trust = trust_name,
    cast_command = cast_str,
    dismiss_command = dismiss_str
  }
end
-- Used to display a list containing all known trusts by the player
-- Inputs
--   None
-- Returns
--   None
function info_functions.displaySupportedTrusts( )
	local msg_str
  local name_list = { }
	
	-- Display Header
	msg_str = 'input /echo ~~~~~ Player Supported Trusts ~~~~~;'

	for name in pairs( info_functions.command) do
		table.insert( name_list, name)
	end
	
	table.sort( name_list)
	
	for num, name in pairs( name_list) do
		msg_str = msg_str .. 'input /echo ~~~~~ ' .. info_functions.command[ name].trust .. ' ~~~~~;'
	end

  windower.send_command( msg_str)
end

-- Used to return the max number of trusts the player is alllowed to summon based on the
--     keyitems "Rhapsody in Crimson" and "Rhapsody in White"
-- Inputs
--   None
-- Returns
--   max_trusts: Maximum number of trust the player can summon; 3, 4, or 5
function info_functions.getMaxNumberTrusts( )

  local keyitem_list = windower.ffxi.get_key_items()
  local max_trusts = 3

  for id, keyitem in pairs( keyitem_list) do
    -- Locate Rhapsody in Crimson ( ID: 2887)
    --   Summon up to 5 Trusts
		if( keyitem == 2887) then
			max_trusts = 5
    -- Locate Rhapsody in White ( ID: 2884)
    --   Summon up to 4 Trusts
		elseif( keyitem == 3031 and max_trusts == 3) then
			max_trusts = 4
		end    
  end
	return max_trusts
end

-- Used to return information about the player's party
-- Inputs
--   None
-- Returns
--   is_party_leader: Returns true if the player is a partyy leader; true or false
--   party_size: Size of the party; Will return 1 if the player is not in a party; 1, 2, 3, 4, 5, or 6
function info_functions.getPartyInformation( )

  local self_info = windower.ffxi.get_player()
  local party_info = windower.ffxi.get_party()
  local other_info
  local is_party_leader = false
  local party_size = 1
	
-- print( windower.ffxi.get_mob_by_name( party_info.p1.name))
  -- Check for player 1 infomation
  if( party_info.p1 ~= nil) then
    -- Get the player information
    other_info = windower.ffxi.get_mob_by_name( party_info.p1.name)
    -- Confirm that the player is not a npc (summoned trust)
    if( other_info.is_npc ~= true) then
      -- Increment the party size by 1
      party_size = party_size + 1
    end
  end
  -- Check for player 2 infomation
  if( party_info.p2 ~= nil) then
    -- Get the player information
    other_info = windower.ffxi.get_mob_by_name( party_info.p2.name)
    if( other_info.is_npc ~= true) then
      -- Increment the party size by 1
      party_size = party_size + 1
    end
  end
  -- Check for player 3 infomation
  if( party_info.p3 ~= nil) then
    -- Get the player information
    other_info = windower.ffxi.get_mob_by_name( party_info.p3.name)
    if( other_info.is_npc ~= true) then
      -- Increment the party size by 1
      party_size = party_size + 1
    end
  end
  -- Check for player 4 infomation
  if( party_info.p4 ~= nil) then
    -- Get the player information
    other_info = windower.ffxi.get_mob_by_name( party_info.p4.name)
    if( other_info.is_npc ~= true) then
      -- Increment the party size by 1
      party_size = party_size + 1
    end
  end
  -- Check for player 5 infomation
  if( party_info.p5 ~= nil) then
    -- Get the player information
    other_info = windower.ffxi.get_mob_by_name( party_info.p5.name)
    if( other_info.is_npc ~= true) then
      -- Increment the party size by 1
      party_size = party_size + 1
    end
  end

  -- Check if the player is the leader of the party
  if( party_size == 1) then
    is_party_leader = true
	elseif( party_size > 1 and
      party_info.party1_leader == self_info.id or
      party_info.party2_leader == self_info.id or
      party_info.party3_leader == self_info.id) then
    is_party_leader = true
  end

  -- Return party_size and is_party_leader
  return party_size, is_party_leader
end

return info_functions
