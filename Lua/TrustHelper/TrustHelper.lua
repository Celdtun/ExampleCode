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

_addon.name = 'TrustHelper'
_addon.version = '00.00.01'
_addon.author = 'Celdtun'
_addon.language = 'English'
_addon.commands = { 'TrustHelper'}

-- TrustHelper Details
-- Variables
--   bind_functions
--   info_functions
--   file_functions
--   position_functions
--   sets_functions
--   print_to_log
-- Functions
--   loadTrustHelper( )
--   loginTrustHelper( )
--   unloadTrustHelper( )
--   commandTrustHelper( ...)
--   isValidCommand( input_cmds)
-- Events
--   'load', loadTrustHelper
--   'unload', unloadTrustHelper
--   'addon command', commandTrustHelper
--   'login', loginTrustHelper

-- Final Test:
--   Commands - 'set''<name>'
--   Commands - 'bind''cast_all'
--   Commands - 'bind''cycle_set'
--   Commands - 'bind''dismiss_all'
--   Commands - 'bind''help'
--   Commands - 'bind''num''cast'
--   Commands - 'bind''num''cycle'
--   Commands - 'bind''num''dismiss'
--   Commands - 'bind''num''display'
--   Boundary Testing - Settings - Missing
--   Boundary Testing - Settings - Corrupted
--   Boundary Testing - Settings - Missing Sets
--   Boundary Testing - Settings - Missing Binds
--   Boundary Testing - Settings - Binds set to nil
--   Boundary Testing - Trusts - Unable to load
--   Boundary Testing - Trusts - Check all names
--   Functionality - read settings
--   Functionality - write settings
--   Functionality - default settings

require 'logger'
require 'tables'
config = require 'config'
files = require 'files'

-- To-Do
--   To-Do
--     Fix the error when detecting the party size
-- Tested
--   Commands - ''
--   Commands - 'bind'''
--   Commands - 'cast_all'
--   Commands - 'dismiss_all'
--   Commands - 'display_binds'
--   Commands - 'display_trusts'
--   Commands - 'help'
--   Commands - 'h'
--   Commands - 'num'''
--   Commands - 'num''add'
--   Commands - 'num''a'
--   Commands - 'num''cycle'
--   Commands - 'num''c'
--   Commands - 'num''display'
--   Commands - 'num''disp'
--   Commands - 'num''remove'
--   Commands - 'num''rm'
--   Commands - 'set'''
--   Commands - 'set''add'
--   Commands - 'set''a'
--   Commands - 'set''cycle'
--   Commands - 'set''c'
--   Commands - 'set''display'
--   Commands - 'set''disp'
--   Commands - 'set''display_set'
--   Commands - 'set''disp_set'
--   Commands - 'set''list_order'
--   Commands - 'set''move'
--   Commands - 'set''mv'
--   Commands - 'set''remove'
--   Commands - 'set''rm'
--   Commands - 'restore_all'
--   Commands - 'unbind_all'
--   Shortcuts - Cycle Trust Set
--   Shortcuts - Display Trust Set
--   Shortcuts - Cast All
--   Shortcuts - Dismiss All
--   Shortcuts - Help
--   Shortcuts - Trust 1 Cast
--   Shortcuts - Trust 1 Cycle
--   Shortcuts - Trust 1 Dismiss
--   Shortcuts - Trust 2 Cast
--   Shortcuts - Trust 2 Cycle
--   Shortcuts - Trust 2 Dismiss
--   Shortcuts - Trust 3 Cast
--   Shortcuts - Trust 3 Cycle
--   Shortcuts - Trust 3 Dismiss
--   Shortcuts - Trust 4 Cast
--   Shortcuts - Trust 4 Cycle
--   Shortcuts - Trust 4 Dismiss
--   Shortcuts - Trust 5 Cast
--   Shortcuts - Trust 5 Cycle
--   Shortcuts - Trust 5 Dismiss

-- Functions specfic to TrustHelper
bind_functions = assert( loadfile( windower.addon_path .. "data/TrustBindFunctions.lua"))()
file_functions = assert( loadfile( windower.addon_path .. "data/TrustFileFunctions.lua"))()
info_functions = assert( loadfile( windower.addon_path .. "data/TrustInfoFunctions.lua"))()
position_functions = assert( loadfile( windower.addon_path .. "data/TrustPositionFunctions.lua"))()
sets_functions = assert( loadfile( windower.addon_path .. "data/TrustSetsFunctions.lua"))()

-- Set to true to print logging messages to the lua.log file in the addon directory
print_to_log = true

-- Confirm that the support files exist and call the login function if the player is already logged in
-- Runs when the addon is loaded
-- Inputs
--   None
-- Returns
--   None
function loadTrustHelper( )
  if( print_to_log == true) then
    -- Base message to the dubugger
    flog( nil, 'loadTrustHelper Load')
  end
  
  -- Confirm that the system can locate the support files
	if( info_functions == nil) then
    if( print_to_log == true) then
      -- Base message to the dubugger
      flog( nil, 'loginTrustHelper Missing TrustCastFunctions.lua')
    end
    error( 'loginTrustHelper Missing TrustCastFunctions.lua')
  end
  
  -- Check if the player is logged in, if so, run the login function
  if( windower.ffxi.get_info().logged_in == true) then
    loginTrustHelper()
  end
end

-- Setup TrustHelper to be used, loads the user data, the trust data and the binds
-- Runs when the user logs in
-- Inputs
--   None
-- Returns
--   None
function loginTrustHelper( )
  -- Base message to debugger
  if( print_to_log == true) then
    -- Base message to the dubugger
    flog( nil, 'loginTrustHelper Login')
  end
	
	local max_trusts
	local name
	local cast_bind
	local dismiss_bind
	local cycle_bind
  local file_data
  local pausecount = 0
	local have_data = false
	local player_spells
  
  while( have_data == false) do
	
		player_spells = windower.ffxi.get_spells()
		
		-- Naji - Spell ID: 897
		-- Ayame - Spell ID: 900
		-- Volker - Spell ID: 903
		-- Iron Eater - Spell ID: 917
		-- Excenmille - Spell ID: 899
		-- Curilla - Spell ID: 902
		-- Trion - Spell ID: 905
		-- Kupipi - Spell ID: 898
		-- Nanaa Mihgo - Spell ID: 901
		-- Ajido-Marujido - Spell ID: 904
		if( player_spells ~= nil and
        ( player_spells[ 897] == true or
				  player_spells[ 900] == true or
  				player_spells[ 903] == true or
	  			player_spells[ 917] == true or
				  player_spells[ 899] == true or
				  player_spells[ 902] == true or
				  player_spells[ 905] == true or
				  player_spells[ 898] == true or
  				player_spells[ 901] == true or
				  player_spells[ 904] == true)) then
			-- The player has at least one of the starting city trusts
			have_data = true
		else
			coroutine.sleep(2)
			pausecount = pausecount + 1
		end
  end

	if( pausecount >= 10) then
		print( 'Error Loading TrustHelper; Player Does Not Know Any Trusts')
		return
	end

	if( file_functions.checkSettingFileExists() == false) then
		file_functions.writeDefaultSettingFile()
	end

	-- Read the configuration settings.xml file
	file_data = file_functions.readSettingFile()
  sets_functions.setTrustSetData( file_data.trust_sets)
  bind_functions.setTrustBindData( file_data.binds_sets)

  -- Load the availible trust list based on the user's known spells
 	info_functions.loadTrusts(
    windower.ffxi.get_spells(),
    file_data.binds_sets.echo)

  job_specific_set = sets_functions.hasJobTrustSet( windower.ffxi.get_player().main_job)
  if( job_specific_set ~= nil) then
    sets_functions.loadTrustSet( job_specific_set)
  else
    -- Load the default set
    sets_functions.loadTrustSet( 1)
  end

  -- Load the help bind if not set to nil
  windower.send_command( 'unbind ' .. bind_functions.binds.help_bind)
  if( bind_functions.binds.help_bind ~= nil) then
    -- Set the display bind command
    windower.send_command( 'bind ' .. bind_functions.binds.help_bind .. ' TrustHelper display_binds')
  end
  if( print_to_log == true) then
    -- Debug message for Help Bind
    flog( nil, 'loginTrustHelper Setting help bind: ' .. bind_functions.binds.help_bind)
  end
  -- Load the cast all bind if not set to nil
  windower.send_command( 'unbind ' .. bind_functions.binds.cast_all_bind)
  if( bind_functions.binds.cast_all_bind ~= nil) then
    -- Set the cast all command bind
    windower.send_command( 'bind ' .. bind_functions.binds.cast_all_bind .. ' TrustHelper cast_all')
  end
  if( print_to_log == true) then
    -- Debug message for Cast All Bind
    flog( nil, 'loginTrustHelper Setting cast all bind: ' .. bind_functions.binds.cast_all_bind)
  end
  -- Load the dismiss all bind if not set to nil
  windower.send_command( 'unbind ' .. bind_functions.binds.dismiss_all_bind)
  if( bind_functions.binds.dismiss_all_bind ~= nil) then
    -- Set the dismiss all command bind
    windower.send_command( 'bind ' .. bind_functions.binds.dismiss_all_bind .. ' TrustHelper dismiss_all')
  end
  if( print_to_log == true) then
    -- Debug message for Dimiss All Bind
    flog( nil, 'loginTrustHelper Setting dimiss all bind: ' .. bind_functions.binds.dismiss_all_bind)
  end
  -- Load the cycle set bind if not set to nil
  windower.send_command( 'unbind ' .. bind_functions.binds.cycle_set_bind)
  if( bind_functions.binds.cycle_set_bind ~= nil) then
    -- Set the cycle set bind
    windower.send_command( 'bind ' .. bind_functions.binds.cycle_set_bind .. ' TrustHelper set c')
  end
  if( print_to_log == true) then
    -- Debug message for Cycle Set Bind
    flog( nil, 'loginTrustHelper Setting cycle set bind: ' .. bind_functions.binds.cycle_set_bind)
  end
  -- Load the cycle set bind if not set to nil
  windower.send_command( 'unbind ' .. bind_functions.binds.display_set_bind)
  if( bind_functions.binds.display_set_bind ~= nil) then
    -- Set the display set bind
    windower.send_command( 'bind ' .. bind_functions.binds.display_set_bind .. ' TrustHelper set disp')
  end
  if( print_to_log == true) then
    -- Debug message for Display Set Bind
    flog( nil, 'loginTrustHelper Setting display set bind: ' .. bind_functions.binds.display_set_bind)
  end
end

-- Unload TrustHelper and unbind all commands
-- Runs when the addon is unloaded
-- Inputs
--   None
-- Returns
--   None
function unloadTrustHelper( )
  if( print_to_log == true) then
    -- Base message to the dubugger
    flog( nil, 'unloadTrustHelper Unload')
  end
  
  -- Remove all bind information
  position_functions.clearBinds()

  -- Unbind the set cycle bind command if not set to nil
  if( bind_functions.binds.cycle_set_bind ~= nil) then
    windower.send_command( 'unbind ' .. bind_functions.binds.cycle_set_bind)
    if( print_to_log == true) then
      flog( nil, 'unloadTrustHelper Clear cycle set bind')
    end
  end
  -- Unbind the set display set bind command if not set to nil
  if( bind_functions.binds.display_set_bind ~= nil) then
    windower.send_command( 'unbind ' .. bind_functions.binds.display_set_bind)
    if( print_to_log == true) then
      flog( nil, 'unloadTrustHelper Clear display set bind')
    end
  end
  -- Unbind the display bind command if not set to nil
  if( bind_functions.binds.help_bind ~= nil) then
    windower.send_command( 'unbind ' .. bind_functions.binds.help_bind)
    if( print_to_log == true) then
      flog( nil, 'unloadTrustHelper Clear help bind')
    end
  end
  -- Unbind the cast all bind command if not set to nil
  if( bind_functions.binds.cast_all_bind ~= nil) then
    windower.send_command( 'unbind ' .. bind_functions.binds.cast_all_bind)
    if( print_to_log == true) then
      flog( nil, 'unloadTrustHelper Clear cast all bind')
    end
  end
  -- Unbind the dismiss all bind command if not set to nil
  if( bind_functions.binds.dismiss_all_bind ~= nil) then
    windower.send_command( 'unbind ' .. bind_functions.binds.dismiss_all_bind)
    if( print_to_log == true) then
      flog( nil, 'unloadTrustHelper Clear dismiss all bind')
    end
  end
end

-- Used to parse through all addon commands, will pass on the command if the command is specific to a position table
-- Run when an addon command is passed to TrustHelper
-- Inputs
--   None
-- Returns
--   None
function commandTrustHelper( ...)

  -- Possible Commands
  --   <#> <modifier>: Specfic trust position to modify
  --     <#>: Trust position to modify; specify 1-5
  --       ** Note: Will only support the command if the player can cast that trust position **
  --     <modifier>: ( OPTIONAL) Specific method to modify the trust position
  --      '': If modifier is blank, display the name of the currently loaded set to chat
  --      'add <name> <num>' or 'a <name> <num>': Add a set to the set list
  --        '': If num is blank, add the set to the end of the set list
  --        <num> ( OPTIONAL): Number position where to add the new set
  --      'cycle' or 'c': Cycle to next set
  --        ** Note: Will wrap around to one at the bottom of the table
  --      'display' or 'disp': Display the loaded trusts used in the current set
  --      'display_set' or 'disp_set': Display the trusts used in the current set
  --      'list_order': Display the set order list
  --      'move <name> <num>' or 'mv <name> <num>': Move a set to a specific position in the set list
  --      <name>: Jump to the specified set
  --      'remove <name>' or 'rm <name>': Remove a set from the set list
  --  'set' <modifier>: Set modification
  --    <modifier>: ( OPTIONAL) Specific method to modify the set
  --      '': If modifier is blank, display the name of the currently loaded set to chat
  --      'add <name> <num>' or 'a <name> <num>': Add a set to the set list
  --        '': If num is blank, add the set to the end of the set list
  --        <num> ( OPTIONAL): Number position where to add the new set
  --      'cycle' or 'c': Cycle to next set
  --        ** Note: Will wrap around to one at the bottom of the table
  --      'display' or 'disp': Display the loaded trusts used in the current set
  --      'display_set' or 'disp_set': Display the trusts used in the current set
  --      'list_order': Display the set order list
  --      'move <name> <num>' or 'mv <name> <num>': Move a set to a specific position in the set list
  --      <name>: Jump to the specified set
  --      'remove <name>' or 'rm <name>': Remove a set from the set list
  --  'bind' <modifier>: Bind key modifications; Set <keys> to 'nil' to remove the bind
  --    <modifier>: ( OPTIONAL) Specific method to modify the set
  --      '': If modifier is blank, display the list of loaded binds
  --      'cast_all' <keys>: Modify the cast_all bind
  --      'cycle_set' <keys>: Modify the cycle_set bind
  --      'dismiss_all' <keys>: Modify the dismiss_all bind
  --      'help' <keys>: Modify the help bind
  --      <num> <bind> <keys>: Position specific binds
  --        <num>: Number of the position to modify
  --        <bind>: Which bind to adjust
  --          'cast' <keys>: Bind for casting the trust loaded in the position
  --          'cycle' <keys>: Bind for cycling the trust loaded in the position
  --          'dismiss' <keys>: Bind for dismissing the trust loaded in the position
  --          'display' <keys>: Display the loaded trust in the position
  --  <command>: General commands to TrustHelper
  --    'cast_all': Cast all trusts
  --    'dismiss_all': Dismiss all trusts
  --    'display_binds': Display binds for the trusts loaded in each position
  --    'display_trusts': Display the names of supported trusts
  --    'help' or 'h': Display supported TrustHelper addon commands
  --    'restore_all': Rebind all commands; Used in conjunction with unbind_all
  --    'unbind_all': Unbind all commands; Used in conjunction with restore_all

  --windower.debug('commandTrustHelper Addon Command' .. input)
	local input_cmds = { }
  local cmd
  local modifier
  local debug_msg = ''

  -- Confirm that the command is not simply 'th' to 'TrustHelper'
  if( not arg) then
    if( print_to_log == true) then
      -- Base message to the dubugger
      flog( nil, 'commandTrustHelper Missing Command input')
    end
    error( 'commandTrustHelper Missing Command input')
    return
  end

  -- Break the command into individual values
  for index, value in ipairs( arg) do
    input_cmds[ index] = windower.from_shift_jis( windower.convert_auto_trans( value))
		if( type( tonumber( input_cmds[ index])) == 'number') then
			input_cmds[ index] = tonumber( input_cmds[ index])
		else
			input_cmds[ index] = input_cmds[ index]:lower()
		end
    debug_msg = debug_msg .. input_cmds[ index] .. ' '
	end
	
  if( print_to_log == true) then
    -- Base message to the dubugger
    flog( nil, 'commandTrustHelper Received command: ' .. debug_msg)
  end

  if( not isValidCommand( input_cmds)) then
		if( input_cmds[ 1] ~= nil) then
			error( 'commandTrustHelper Unknown command: ' .. input_cmds[ 1])
			if( print_to_log == true) then
				-- Base message to the dubugger
				flog( nil, 'commandTrustHelper Unknown command: ' .. input_cmds[ 1])
			end
		else
			error( 'commandTrustHelper Unknown command')
			if( print_to_log == true) then
				-- Base message to the dubugger
				flog( nil, 'commandTrustHelper Unknown command')
			end
		end
		return
  end

  -- Remove the first command from input_cmds and save to cmd
  cmd = table.remove( input_cmds, 1)

  -- Parse the provided command
  if( cmd == 1 or cmd == 2 or cmd == 3 or cmd == 4 or cmd == 5) then
    -- Command is to modify one of the position tables
    sets_functions.updatePosition( cmd, input_cmds)
  elseif( cmd == 'set') then
    -- Command is to modify one of the sets
    sets_functions.updateSet( input_cmds)
  elseif( cmd == 'bind') then
    -- Command is to modify one of the binds
    bind_functions.updateBind( input_cmds)
  elseif( cmd == 'cast_all' and ( not input_cmds[ 1])) then
    -- Command is to cast all trusts
    sets_functions.castAll( sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set])
  elseif( cmd == 'dismiss_all' and ( not input_cmds[ 1])) then
    -- Command is to dismiss all trusts
    sets_functions.dismissAll()
  elseif( cmd == 'display_binds' and ( not input_cmds[ 1])) then
    -- Command is to display the binds
		bind_functions.displayBindInformation()
  elseif( cmd == 'display_trusts' and ( not input_cmds[ 1])) then
    -- Command is to display the supported trusts
		info_functions.displaySupportedTrusts()
  elseif( cmd == 'restore_all' and ( not input_cmds[ 1])) then
    -- Resend all bind commands
    loadTrustHelper()
  elseif( cmd == 'unbind_all' and ( not input_cmds[ 1])) then
    -- Unbind all boind commands
    unloadTrustHelper()
  else
    -- Command is to display TrustHelper Help
    print( 'TrustHelper Supported Commands are:')
    print( '  <#> <modifier>: Specfic trust position to modify')
    print( '    <#>: Trust position to modify; specify 1-5')
    print( '    <modifier>: ( OPTIONAL) Specific method to modify the trust position')
    print( '      \'\': If modifier is blank, display the name of the currently loaded trust to chat')
    print( '      \'add <name>\' or \'a <name>\': Add a trust name to the specified trust position')
    print( '      \'cycle\' or \'c\': Cycle forward one number in the specificed trust number table')
    print( '      \'display\' or \'disp\': Display the trust current loaded in the specified trust position table')
    print( '      \'remove <name>\' or \'rm <name>\': Remove a trust name from the specified trust position')
    print( '  \'set\' <modifier>: Set modification')
    print( '    <modifier>: ( OPTIONAL) Specific method to modify the set')
    print( '      \'\': If modifier is blank, display the name of the currently loaded set to chat')
    print( '      \'add <name> <num>\' or \'a <name> <num>\': Add a set to the set list')
    print( '        \'\': If num is blank, add the set to the end of the set list')
    print( '        <num> ( OPTIONAL): Number position where to add the new set')
    print( '      \'cycle\' or \'c\': Cycle to next set')
    print( '      \'display\' or \'disp\': Display the loaded trusts used in the current set')
    print( '      \'display_set\' or \'disp_set\': Display the trusts used in the current set')
    print( '      \'list_order\': Display the set order list')
    print( '      <name>: Jump to the specified set')
    print( '      \'move <name> <num>\' or \'mv <name> <num>\': Move a set to a specific position in the set list')
    print( '      \'remove <name>\' or \'rm <name\': Remove a set from the set list')
    print( '  \'bind\' <modifier>: Bind key modifications; Set <keys> to \'nil\' to remove the bind')
    print( '    <modifier>: ( OPTIONAL) Specific method to modify the bind')
    print( '      \'\': If modifier is blank, display the list of loaded binds')
    print( '      \'cast_all\' <keys>: Modify the cast_all bind')
    print( '      \'cycle_set\' <keys>: Modify the cycle_set bind')
    print( '      \'dismiss_all\' <keys>: Modify the dismiss_all bind')
    print( '      \'help\' <keys>: Modify the help bind')
    print( '      <num> <bind> <keys>: Position specific binds')
    print( '        <num>: Number of the position to modify')
    print( '        <bind>: Which bind to adjust')
    print( '          \'cast\' <keys>: Bind for casting the trust loaded in the position')
    print( '          \'cycle\' <keys>: Bind for cycling the trust loaded in the position')
    print( '          \'dismiss\' <keys>: Bind for dismissing the trust loaded in the position')
    print( '  <command>: General commands to TrustHelper')
    print( '    \'cast_all\': Cast all trusts')
    print( '    \'dismiss_all\': Dismiss all trusts')
    print( '    \'display_binds\': Display binds for the trusts loaded in each position')
    print( '    \'display_trusts\': Display the names of supported trusts')
    print( '    \'help\' or \'h\': Display supported TrustHelper addon commands')
    print( '    \'restore_all\': Rebind all commands; Used in conjunction with unbind_all')
    print( '    \'unbind_all\': Unbind all commands; Used in conjunction with restore_all')
  end
end

-- Confirms that an addon command is a valid command
-- Inputs
--   input_cmds: Addon command sent to TrustHelper
-- Returns
--   true: Command is valid
--   false Command is not valid
function isValidCommand( input_cmds)
  --   <#> <modifier>: Specfic trust position to modify
  --     <#>: Trust position to modify; specify 1-5
  --       ** Note: Will only support the command if the player can cast that trust position **
  --     <modifier>: ( OPTIONAL) Specific method to modify the trust position
  --       '': If modifier is blank, display the name of the currently loaded trust to chat
  --       'add <name>' or 'a <name>': Add a trust name to the specified trust position
  --       'cycle' or 'c': Cycle forward one number in the specificed trust number table
  --         ** Note: Will wrap around to one at the bottom of the table
  --       'display' or 'disp': Display the trust current loaded in the specified trust position table
  --       'remove <name>' or 'rm <name>': Remove a trust name from the specified trust position
  --  'set' <modifier>: Set modification
  --    <modifier>: ( OPTIONAL) Specific method to modify the set
  --      '': If modifier is blank, display the name of the currently loaded set to chat
  --      'add <name> <num>' or 'a <name> <num>': Add a set to the set list
  --        '': If num is blank, add the set to the end of the set list
  --        <num> ( OPTIONAL): Number position where to add the new set
  --      'cycle' or 'c': Cycle to next set
  --        ** Note: Will wrap around to one at the bottom of the table
  --      'display' or 'disp': Display the loaded trusts used in the current set
  --      'display_set' or 'disp_set': Display the trusts used in the current set
  --      'list_order': Display the set order list
  --      'move <name> <num>' or 'mv <name> <num>': Move a set to a specific position in the set list
  --      <name>: Jump to the specified set
  --      'remove <name>' or 'rm <name>': Remove a set from the set list
  --  'bind' <modifier>: Bind key modifications; Set <keys> to 'nil' to remove the bind
  --    <modifier>: ( OPTIONAL) Specific method to modify the set
  --      '': If modifier is blank, display the list of loaded binds
  --      'cast_all' <keys>: Modify the cast_all bind
  --      'cycle_set' <keys>: Modify the cycle_set bind
  --      'dismiss_all' <keys>: Modify the dismiss_all bind
  --      'help' <keys>: Modify the help bind
  --      <num> <bind> <keys>: Position specific binds
  --        <num>: Number of the position to modify
  --        <bind>: Which bind to adjust
  --          'cast' <keys>: Bind for casting the trust loaded in the position
  --          'cycle' <keys>: Bind for cycling the trust loaded in the position
  --          'dismiss' <keys>: Bind for dismissing the trust loaded in the position
  --          'display' <keys>: Display the loaded trust in the position
  --  <command>: General commands to TrustHelper
  --    'cast_all': Cast all trusts
  --    'dismiss_all': Dismiss all trusts
  --    'display_binds': Display binds for the trusts loaded in each position
  --    'display_trusts': Display the names of supported trusts
  --    'help' or 'h': Display supported TrustHelper addon commands
  --    'restore_all': Rebind all commands; Used in conjunction with unbind_all
  --    'unbind_all': Unbind all commands; Used in conjunction with restore_all

  if( print_to_log == true) then
    -- Base message to the dubugger
    flog( nil, 'isValidCommand')
  end

  local max_trusts = info_functions.getMaxNumberTrusts()
	
  if( input_cmds[ 5] == nil) then
    if( input_cmds[ 1] == 1 or input_cmds[ 1] == 2 or input_cmds[ 1] == 3 or
        input_cmds[ 1] == 4 or input_cmds[ 1] == 5) then
      -- First input is a possible supported number
      if( input_cmds[ 2] == nil and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
        --'': If modifier is blank, display the name of the currently loaded trust to chat
        return true
      end
      if( input_cmds[ 1] <= max_trusts and input_cmds[ 4] == nil) then
        if(( input_cmds[ 2] == 'add' or input_cmds[ 2] == 'a') and input_cmds[ 3] ~= nil) then
          -- 'add <name>' or 'a <name>': Add a trust name to the specified trust position
          return true
        end
        if(( input_cmds[ 2] == 'cycle' or input_cmds[ 2] == 'c') and input_cmds[ 3] == nil) then
          -- 'cycle' or 'c': Cycle forward one number in the specificed trust number table
          return true
        end
        if(( input_cmds[ 2] == 'display' or input_cmds[ 2] == 'disp') and input_cmds[ 3] == nil) then
          -- 'display' or 'disp': Display the trust current loaded in the specified trust position table
          return true
        end
        if(( input_cmds[ 2] == 'remove' or input_cmds[ 2] == 'rm') and input_cmds[ 3]~= nil) then
          -- 'remove <name>' or 'rm <name>': Remove a trust name from the specified trust position
          return true
        end
      end
    elseif( input_cmds[ 1] == 'set') then
      if( input_cmds[ 2] == nil and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
        -- '': If modifier is blank, display the name of the currently loaded set to chat
        return true
      end
      if(( input_cmds[ 2] == 'add' or input_cmds[ 2] == 'a') and input_cmds[ 3] ~= nil) then
        -- 'add <name> <num>' or 'a <name> <num>': Add a set to the set list
        if( input_cmds[ 4] == nil) then
          -- '': If num is blank, add the set to the end of the set list
          return true
        end
        if( input_cmds[ 4] == 1 or input_cmds[ 4] == 2 or input_cmds[ 4] == 3 or input_cmds[ 4] == 4 or input_cmds[ 4] == 5) then
          -- <num> ( OPTIONAL): Number position where to add the new set
          return true
        end
      end
      if(( input_cmds[ 2] == 'cycle' or input_cmds[ 2] == 'c') and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
        -- 'cycle' or 'c': Cycle to next set
        return true
      end
      if(( input_cmds[ 2] == 'display' or input_cmds[ 2] == 'disp') and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
        -- 'display' or 'disp': Display the trusts used in the current set
        return true
      end
      if(( input_cmds[ 2] == 'display_set' or input_cmds[ 2] == 'disp_set') and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
        -- 'display' or 'disp': Display the trusts used in the current set
        return true
      end
      if( input_cmds[ 2] == 'list_order' and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
        -- 'list_order': Display the set order list
        return true
      end
      if(( input_cmds[ 2] == 'move' or input_cmds[ 2] == 'mv') and input_cmds[ 3] ~= nil and
         ( input_cmds[ 4] == 1 or input_cmds[ 4] == 2 or input_cmds[ 4] == 3 or input_cmds[ 4] == 4 or input_cmds[ 4] == 5)) then
        -- 'move <name> <num>' or 'mv <name> <num>': Move a set to a specific position in the set list
        return true
      end
      if(( input_cmds[ 2] == 'remove' or input_cmds[ 2] == 'rm') and input_cmds[ 3] ~= nil and input_cmds[ 4] == nil) then
        -- 'remove <name>' or 'rm <name>': Remove a set from the set list
        return true
      end
      if( input_cmds[ 2] ~= nil and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
        --  <name>: Jump to the specified set
        return true
      end
    elseif( input_cmds[ 1] == 'bind') then
      if( input_cmds[ 2] == nil and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
        -- '': If modifier is blank, display the list of loaded binds
        return true
      end
      if( input_cmds[ 2] == 'cast_all' and input_cmds[ 3] ~= nil and input_cmds[ 4] == nil) then
        -- 'cast_all' <keys>: Modify the cast_all bind
        return true
      end
      if( input_cmds[ 2] == 'cycle_set' and input_cmds[ 3] ~= nil and input_cmds[ 4] == nil) then
        -- 'cycle_set' <keys>: Modify the cycle_set bind
        return true
      end
      if( input_cmds[ 2] == 'dismiss_all' and input_cmds[ 3] ~= nil and input_cmds[ 4] == nil) then
        -- 'dismiss_all' <keys>: Modify the dismiss_all bind
        return true
      end
      if( input_cmds[ 2] == 'help' and input_cmds[ 3] ~= nil and input_cmds[ 4] == nil) then
        -- 'help' <keys>: Modify the help bind
        return true
      end
      if( input_cmds[ 2] == 1 or input_cmds[ 2] == 2 or input_cmds[ 2] == 3 or input_cmds[ 2] == 4 or input_cmds[ 2] == 5) then
        if( input_cmds[ 3] == 'cast' and input_cmds[ 4] ~= nil) then
          -- 'cast' <keys>: Bind for casting the trust loaded in the position
          return true
        end
        if( input_cmds[ 3] == 'cycle' and input_cmds[ 4] ~= nil) then
          -- 'cycle' <keys>: Bind for cycling the trust loaded in the position
          return true
        end
        if( input_cmds[ 3] == 'dismiss' and input_cmds[ 4] ~= nil) then
          -- 'dismiss' <keys>: Bind for dismissing the trust loaded in the position
          return true
        end
        if( input_cmds[ 3] == 'display' and input_cmds[ 4] ~= nil) then
          -- 'display' <keys>: Display the loaded trust in the position
          return true
        end
      end
    elseif( input_cmds[ 1] == 'cast_all' and input_cmds[ 2] == nil and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
      -- 'cast_all': Cast all trusts
      return true
    elseif( input_cmds[ 1] == 'dismiss_all' and input_cmds[ 2] == nil and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
      -- 'dismiss_all': Dismiss all trusts
      return true
    elseif( input_cmds[ 1] == 'display_binds' and input_cmds[ 2] == nil and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
      -- 'display_binds': Display binds for the trusts loaded in each position
      return true
    elseif( input_cmds[ 1] == 'display_trusts' and input_cmds[ 2] == nil and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
      -- 'display_trusts': Display the names of supported trusts
      return true
    elseif(( input_cmds[ 1] == 'help' or input_cmds[ 1] == 'h') and input_cmds[ 2] == nil and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
      -- 'help' or 'h': Display supported TrustHelper addon commands
      return true
    elseif( input_cmds[ 1] == 'restore_all' and input_cmds[ 2] == nil and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
      -- 'restore_all': Rebind all commands; Used in conjunction with unbind_all
      return true
    elseif( input_cmds[ 1] == 'unbind_all' and input_cmds[ 2] == nil and input_cmds[ 3] == nil and input_cmds[ 4] == nil) then
      -- 'unbind_all': Unbind all commands; Used in conjunction with restore_all
      return true
    end
  end
  return false
end

-- Event commands for the addon
-- Load command
windower.register_event( 'load', loadTrustHelper)
-- Unload command
windower.register_event( 'unload', unloadTrustHelper)
-- Addon input command
windower.register_event( 'addon command', commandTrustHelper)
-- Login command
windower.register_event( 'login', loginTrustHelper)
