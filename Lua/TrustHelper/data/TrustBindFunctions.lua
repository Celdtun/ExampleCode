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

-- TrustBindFunctions Details
-- Variables
--   bind_functions.print_to_log
--   bind_functions.binds
-- Functions
--   bind_functions.setTrustBindData( bind_data)
--   bind_functions.updateBind( input_cmds)
--   bind_functions.changeBind( cmd, keys)
--   bind_functions.changePositionBind( num, cmd, keys)
--   bind_functions.displayBindInformation( )
--   bind_functions.getBindInformation( position)
--   bind_functions.isValidBindKey( keys)
--   bind_functions.getDikCode( keys)
--   bind_functions.initialize( info_funct, file_funct, position_funct, sets_funct)

require 'logger'
require 'tables'
config = require 'config'
files = require 'files'

bind_functions = { }

-- Set to true to print logging messages to the lua.log file in the addon directory
bind_functions.print_to_log = true

bind_functions.binds = { }

-- Used to load the bind_functions.binds table data
-- Inputs
--   bind_data: ( REQUIRED) binds table data
-- Returns
--   None
function bind_functions.setTrustBindData( bind_data)
  bind_functions.binds = bind_data
end
-- Used to parse the addon bind commands
-- Inputs
--   input_cmds: ( REQUIRED) input command
-- Returns
--   None
function bind_functions.updateBind( input_cmds)
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
  local cmd = input_cmds[ 1]  -- <modifier>
  local data = input_cmds[ 2] -- <keys>/<num>
  local keys = input_cmds[ 3] -- <keys>
  local msg_str

  if( cmd == nil and data == nil and keys == nil) then
    -- '': If modifier is blank, display the list of loaded binds
    bind_functions.displayBindInformation( )
  elseif( cmd == 'cast_all' and data ~= nil and keys == nil) then
    -- 'cast_all' <keys>: Modify the cast_all bind
    bind_functions.changeBind( cmd, data)
  elseif( cmd == 'cycle_set' and data ~= nil and keys == nil) then
    -- 'cycle_set' <keys>: Modify the cycle_set bind
    bind_functions.changeBind( cmd, data)
  elseif( cmd == 'dismiss_all' and data ~= nil and keys == nil) then
    -- 'dismiss_all' <keys>: Modify the dismiss_all bind
    bind_functions.changeBind( cmd, data)
  elseif( cmd == 'display' and data ~= nil and keys == nil) then
    -- 'display' <keys>: Modify the display trust bind
    bind_functions.changeBind( cmd, data)
  elseif( cmd == 'help' and data ~= nil and keys == nil) then
    -- 'help' <keys>: Modify the help bind
    bind_functions.changeBind( cmd, data)
  elseif(( cmd == 1 or cmd == 2 or cmd == 3 or cmd == 4 or cmd == 5) and
           data ~= nil and keys ~= nil) then
    -- <num> <bind> <keys>: Position specific binds
    bind_functions.changePositionBind( cmd, data, keys)
  else
    msg_str = 'TrustHelper Unknown bind command: ' .. cmd
    if( data ~= nil) then
      msg_str = msg_str .. ' ' .. data
      if( keys ~= nil) then
        msg_str = msg_str .. ' ' .. keys
      end
    end
    print( msg_str)
  end
end
-- Used to react to non position specific addon bind commands
-- Inputs
--   cmd: ( REQUIRED) bind command to modify
--   keys: ( REQUIRED) bind keys; set to nil to unbind the shortcut
-- Returns
--   None
function bind_functions.changeBind( cmd, keys)

  if( cmd == 'cast_all') then
    windower.send_command( 'unbind ' .. bind_functions.binds.cast_all_bind)
    bind_functions.binds.cast_all_bind = keys
    if( keys ~= nil) then
      windower.send_command( 'bind ' .. keys .. ' TrustHelper cast_all')
    end
    if( print_to_log == true) then
      flog( nil, 'bind_functions.changeBind Setting cast_all bind: ' .. keys)
    end
  elseif( cmd == 'cycle_set') then
    windower.send_command( 'unbind ' .. bind_functions.binds.cycle_set_bind)
    bind_functions.binds.cycle_set_bind = keys
    if( keys ~= nil) then
      windower.send_command( 'bind ' .. keys .. ' TrustHelper cycle_set')
    end
    if( print_to_log == true) then
      flog( nil, 'bind_functions.changeBind Setting cycle_set bind: ' .. keys)
    end
  elseif( cmd == 'dismiss_all') then
    windower.send_command( 'unbind ' .. bind_functions.binds.dismiss_all_bind)
    bind_functions.binds.dismiss_all_bind = keys
    if( keys ~= nil) then
      windower.send_command( 'bind ' .. keys .. ' TrustHelper dismiss_all')
    end
    if( print_to_log == true) then
      flog( nil, 'bind_functions.changeBind Setting dismiss_all bind: ' .. keys)
    end
  elseif( cmd == 'help') then
    windower.send_command( 'unbind ' .. bind_functions.binds.help_bind)
    bind_functions.binds.help_bind = keys
    if( keys ~= nil) then
      windower.send_command( 'bind ' .. keys .. ' TrustHelper display_binds')
    end
    if( print_to_log == true) then
      flog( nil, 'bind_functions.changeBind Setting help_bind bind: ' .. keys)
    end
  else
    print( 'bind_functions.changeBind Unknown change bind command: ' .. cmd .. ' ' .. keys)
    if( print_to_log == true) then
      flog( nil, 'bind_functions.changeBind Unknown change bind command: ' .. cmd .. ' ' .. keys)
    end
  end

end
-- Used to react to position specific addon bind commands
-- Inputs
--   num: ( REQUIRED) bind position to modify
--   cmd: ( REQUIRED) bind command to modify
--   keys: ( REQUIRED) bind keys; set to nil to unbind the shortcut
-- Returns
--   None
function bind_functions.changePositionBind( num, cmd, keys)

  if( cmd == 'cast') then
    windower.send_command( 'unbind ' .. bind_functions.binds[ trust_number].cast_bind_keys)
    if( keys ~= nil) then
      position_functions.loadTrustNumber(
        num,
        bind_functions.binds[ num].name,
        keys,
        bind_functions.binds[ num].dismiss_bind_keys)
      position_functions.sendBindCommands( num)
    end
    if( print_to_log == true) then
      flog( nil, 'bind_functions.changeBind Setting position' .. num .. ' ' .. cmd .. ' bind: ' .. keys)
    end
  elseif( cmd == 'cycle') then
    windower.send_command( 'unbind ' .. keys)
    if( keys ~= nil) then
      windower.send_command( 'bind ' .. keys .. ' TrustHelper ' .. num .. ' c')
    end
    if( print_to_log == true) then
      flog( nil, 'bind_functions.changeBind Setting position' .. num .. ' ' .. cmd .. ' bind: ' .. keys)
    end
  elseif( cmd == 'dismiss') then
    windower.send_command( 'unbind ' .. bind_functions.binds[ trust_number].dismiss_bind_keys)
    if( keys ~= nil) then
      position_functions.loadTrustNumber(
        num,
        bind_functions.binds[ num].name,
        bind_functions.binds[ num].cast_bind_keys,
        keys)
      position_functions.sendBindCommands( num)
    end
    if( print_to_log == true) then
      flog( nil, 'bind_functions.changeBind Setting position' .. num .. ' ' .. cmd .. ' bind: ' .. keys)
    end
  elseif( cmd == 'display') then
    windower.send_command( 'unbind ' .. keys)
    if( keys ~= nil) then
      windower.send_command( 'bind ' .. keys .. ' TrustHelper ' .. num .. ' disp')
    end
    if( print_to_log == true) then
      flog( nil, 'bind_functions.changeBind Setting position' .. num .. ' ' .. cmd .. ' bind: ' .. keys)
    end
  else
    print( 'bind_functions.changePositionBind Unknown change bind command: ' .. num .. ' ' .. cmd .. ' ' .. keys)
    if( print_to_log == true) then
      flog( nil, 'bind_functions.changeBind Unknown change bind command: ' .. num .. ' ' .. cmd .. ' ' .. keys)
    end
    return
  end
end
-- Used to display all set binds to the chat window
-- Inputs
--   None
-- Returns
--   None
function bind_functions.displayBindInformation( )
	local msg_str
	local key_str

	-- Display Header
	msg_str = 'input /echo ~~~~~ Display Bind Information ~~~~~;'
  -- Display the cycle set bind if not set to nil
  if( bind_functions.binds.cycle_set_bind ~= nil) then
		key_str = bind_functions.getBindKeyInformation( bind_functions.binds.cycle_set_bind)
		msg_str = msg_str .. 'input /echo ~~~~~ Cycle Trust Set: ' .. key_str .. ' ~~~~~;'
  end
  if( bind_functions.binds.display_set_bind ~= nil) then
		key_str = bind_functions.getBindKeyInformation( bind_functions.binds.display_set_bind)
		msg_str = msg_str .. 'input /echo ~~~~~ Display Trust Set: ' .. key_str .. ' ~~~~~;'
  end
  -- Display the cast all bind if not set to nil
  if( bind_functions.binds.cast_all_bind ~= nil) then
		key_str = bind_functions.getBindKeyInformation( bind_functions.binds.cast_all_bind)
		msg_str = msg_str .. 'input /echo ~~~~~ Cast All Trusts: ' .. key_str .. ' ~~~~~;'
  end
  -- Display the dismiss all bind if not set to nil
  if( bind_functions.binds.dismiss_all_bind ~= nil) then
		key_str = bind_functions.getBindKeyInformation( bind_functions.binds.dismiss_all_bind)
		msg_str = msg_str .. 'input /echo ~~~~~ Dismiss All Trusts: ' .. key_str .. ' ~~~~~;'
  end
  -- Display the help bind if not set to nil
  if( bind_functions.binds.help_bind ~= nil) then
		key_str = bind_functions.getBindKeyInformation( bind_functions.binds.help_bind)
		msg_str = msg_str .. 'input /echo ~~~~~ Help Information: ' .. key_str .. ' ~~~~~;'
  end
	-- Display trust position information
  for i = 1, info_functions.getMaxNumberTrusts(), 1 do
    msg_str = msg_str .. 'input /echo ' .. position_functions.binds[ i].help_str
  end
	windower.send_command( msg_str)
end
-- Used to return the binds setting of the specified bind position
-- Inputs
--   position: ( REQUIRED) bind position to modify
-- Returns
--   None
function bind_functions.getBindInformation( position)

	local cast_bind = nil
	local dismiss_bind = nil
	local cycle_bind = nil
	local display_bind = nil
	
	if( position == 1) then
		cast_bind = bind_functions.binds.trust_1.cast_bind
		dismiss_bind = bind_functions.binds.trust_1.dismiss_bind
		cycle_bind = bind_functions.binds.trust_1.cycle_bind
		display_bind = bind_functions.binds.trust_1.display_bind
	elseif( position == 2) then
		cast_bind = bind_functions.binds.trust_2.cast_bind
		dismiss_bind = bind_functions.binds.trust_2.dismiss_bind
		cycle_bind = bind_functions.binds.trust_2.cycle_bind
		display_bind = bind_functions.binds.trust_2.display_bind
	elseif( position == 3) then
		cast_bind = bind_functions.binds.trust_3.cast_bind
		dismiss_bind = bind_functions.binds.trust_3.dismiss_bind
		cycle_bind = bind_functions.binds.trust_3.cycle_bind
		display_bind = bind_functions.binds.trust_3.display_bind
	elseif( position == 4) then
		cast_bind = bind_functions.binds.trust_4.cast_bind
		dismiss_bind = bind_functions.binds.trust_4.dismiss_bind
		cycle_bind = bind_functions.binds.trust_4.cycle_bind
		display_bind = bind_functions.binds.trust_4.display_bind
	elseif( position == 5) then
		cast_bind = bind_functions.binds.trust_5.cast_bind
		dismiss_bind = bind_functions.binds.trust_5.dismiss_bind
		cycle_bind = bind_functions.binds.trust_5.cycle_bind
		display_bind = bind_functions.binds.trust_5.display_bind
	end
	
	return cast_bind, dismiss_bind, cycle_bind, display_bind
end
-- Used to identify specific bind modifiers
-- Inputs
--   keys: ( REQUIRED) Key set to parse
-- Returns
--   msg_str: String containing the modifiers for the specified string
function bind_functions.getBindKeyInformation( keys)

  -- Message String
  local bind_key = keys
  local msg_str = nil
  local input
  local start
  local stop

  -- '|' OR info_functions.command
  --   Recursively call for each OR
  if( string.match( bind_key, '|')) then
    input = bind_key
    start, stop = string.find( input, '|')
    msg_str = '(' ..  bind_functions.getBindKeyInformation( string.sub( bind_key, 1, start)) .. ')'
    input = string.sub( input, ( start + 1))
    while( input ~= nil and start ~= nil) do
      start, stop = string.find( input, '|')
      if( start ~= nil) then
        msg_str = '|(' ..  bind_functions.getBindKeyInformation( string.sub( bind_key, 1, start)) .. ')'
        input = string.sub( input, ( start + 1))
      end
    end
  else

    -- '^' Ctrl
    if( string.match( bind_key, '%^')) then
      -- Translate the wildcard to key assignment
      msg_str = '(Ctrl'
      -- Remove wildcard from string
      bind_key = string.gsub( bind_key, '%^', '')
    end
    -- '!' Alt
    if( string.match( bind_key, '!')) then
      -- Translate the wildcard to key assignment
      if( msg_str == nil) then
        msg_str = '(Alt'
      else
        -- Previous wildcard already started string
        msg_str = msg_str .. '+Alt'
      end
      -- Remove wildcard from string
      bind_key = string.gsub( bind_key, '!', '')
    end
    -- '@' Win
    if( string.match( bind_key, '@')) then
      -- Translate the wildcard to key assignment
      if( msg_str == nil) then
        msg_str = '(Win'
      else
        -- Previous wildcard already started string
        msg_str = msg_str .. '+Win'
      end
      -- Remove wildcard from string
      bind_key = string.gsub( bind_key, '@', '')
    end
    -- '#' Apps
    if( string.match( bind_key, '#')) then
      -- Translate the wildcard to key assignment
      if( msg_str == nil) then
        msg_str = '(Apps'
      else
        -- Previous wildcard already started string
        msg_str = msg_str .. '+Apps'
      end
      -- Remove wildcard from string
      bind_key = string.gsub( bind_key, '#', '')
    end
    -- '~' Shift
    if( string.match( bind_key, '~')) then
      -- Translate the wildcard to key assignment
      if( msg_str == nil) then
        msg_str = '(Shift'
      else
        -- Previous wildcard already started string
        msg_str = msg_str .. '+Shift'
      end
    end
      -- Remove wildcard from string
      bind_key = string.gsub( bind_key, '~', '')
  end
  
  -- Add the bind key to the message string
  msg_str = msg_str .. '+' .. bind_key .. ')'
  
  -- Return the modifier string
  return msg_str
end
-- Used to confirm that the provided keys are a valid bind string for windower
-- Inputs
--   keys: ( REQUIRED) Key set to parse
-- Returns
--   true if the bind keys are valid; false if the bind keys are not valid
function bind_functions.isValidBindKey( keys)

  -- Message String
  local bind_key = keys
  local is_valid = true
  local in_modifier = true
  
  local msg_str = nil
  local input
  local start
  local stop

  -- '|' OR info_functions.command
  --   Recursively call for each OR
  if( string.match( bind_key, '|')) then
    start, stop = string.find( bind_key, '|')
    is_valid = bind_functions.isValidBindKey( string.sub( bind_key, 1, start))
    bind_key = string.sub( bind_key, ( start + 1))
    start, stop = string.find( bind_key, '|')
    while( is_valid == true and bind_key ~= nil and start ~= nil) do
      if( start ~= nil) then
        is_valid = bind_functions.getBindKeyInformation( string.sub( bind_key, 1, start))
        bind_key = string.sub( bind_key, ( start + 1))
        start, stop = string.find( bind_key, '|')
      end
    end
  else
    while( in_modifier == true) do
      input = string.sub( bind_key, 1, 2)
      if( input == '%^' or input == '!' or input == '@' or input == '#' or input == '~') then
        bind_key = string.sub( bind_key, 2, -1)
        input = string.sub( bind_key, 1, 2)
      else
        in_modifier = false
      end
    end
    while( bind_key ~= nil and is_valid == true) do
      input = bind_functions.getDikCode( keys)
      if( input ~= nil) then
        bind_keys = string.gsub( bind_key, input, '')
      else
        input = string.sub( bind_key, 1, 2)
        if( input == '%^' or input == '!' or input == '@' or input == '#' or input == '~') then
          is_valid = false
        end
      end
    end
  end
  return is_valid
end
-- Used to lookup dik codes
-- Inputs
--   keys: ( REQUIRED) Key set to parse
-- Returns
--   name of the dik code or nil if none found
function bind_functions.getDikCode( keys)
  if( string.match( keys, 'DIK_GRAVE')) then
    return 'DIK_GRAVE'
  elseif( string.match( keys, 'DIK_ESCAPE')) then
    return 'DIK_ESCAPE'
  elseif( string.match( keys, 'DIK_1')) then
    return 'DIK_1'
  elseif( string.match( keys, 'DIK_2')) then
    return 'DIK_2'
  elseif( string.match( keys, 'DIK_3')) then
    return 'DIK_3'
  elseif( string.match( keys, 'DIK_4')) then
    return 'DIK_4'
  elseif( string.match( keys, 'DIK_5')) then
    return 'DIK_5'
  elseif( string.match( keys, 'DIK_6')) then
    return 'DIK_7'
  elseif( string.match( keys, 'DIK_8')) then
    return 'DIK_8'
  elseif( string.match( keys, 'DIK_9')) then
    return 'DIK_9'
  elseif( string.match( keys, 'DIK_0')) then
    return 'DIK_0'
  elseif( string.match( keys, 'DIK_MINUS')) then
    return 'DIK_MINUS'
  elseif( string.match( keys, 'DIK_EQUALS')) then
    return 'DIK_EQUALS'
  elseif( string.match( keys, 'DIK_BACK')) then
    return 'DIK_BACK'
  elseif( string.match( keys, 'DIK_TAB')) then
    return 'DIK_TAB'
  elseif( string.match( keys, 'DIK_Q')) then
    return 'DIK_Q'
  elseif( string.match( keys, 'DIK_W')) then
    return 'DIK_W'
  elseif( string.match( keys, 'DIK_E')) then
    return 'DIK_E'
  elseif( string.match( keys, 'DIK_R')) then
    return 'DIK_R'
  elseif( string.match( keys, 'DIK_T')) then
    return 'DIK_T'
  elseif( string.match( keys, 'DIK_Y')) then
    return 'DIK_Y'
  elseif( string.match( keys, 'DIK_U')) then
    return 'DIK_U'
  elseif( string.match( keys, 'DIK_I')) then
    return 'DIK_I'
  elseif( string.match( keys, 'DIK_O')) then
    return 'DIK_O'
  elseif( string.match( keys, 'DIK_P')) then
    return 'DIK_P'
  elseif( string.match( keys, 'DIK_LBRACKET')) then
    return 'DIK_LBRACKET'
  elseif( string.match( keys, 'DIK_RBRACKET')) then
    return 'DIK_RBRACKET'
  elseif( string.match( keys, 'DIK_RETURN')) then
    return 'DIK_RETURN'
  elseif( string.match( keys, 'DIK_LCONTROL')) then
    return 'DIK_LCONTROL'
  elseif( string.match( keys, 'DIK_A')) then
    return 'DIK_A'
  elseif( string.match( keys, 'DIK_S')) then
    return 'DIK_S'
  elseif( string.match( keys, 'DIK_D')) then
    return 'DIK_D'
  elseif( string.match( keys, 'DIK_F')) then
    return 'DIK_F'
  elseif( string.match( keys, 'DIK_G')) then
    return 'DIK_G'
  elseif( string.match( keys, 'DIK_H')) then
    return 'DIK_H'
  elseif( string.match( keys, 'DIK_J')) then
    return 'DIK_J'
  elseif( string.match( keys, 'DIK_K')) then
    return 'DIK_K'
  elseif( string.match( keys, 'DIK_L')) then
    return 'DIK_L'
  elseif( string.match( keys, 'DIK_SEMICOLON')) then
    return 'DIK_SEMICOLON'
  elseif( string.match( keys, 'DIK_APOSTROPHE')) then
    return 'DIK_APOSTROPHE'
  elseif( string.match( keys, 'DIK_LSHIFT')) then
    return 'DIK_LSHIFT'
  elseif( string.match( keys, 'DIK_BACKSLASH')) then
    return 'DIK_BACKSLASH'
  elseif( string.match( keys, 'DIK_Z')) then
    return 'DIK_Z'
  elseif( string.match( keys, 'DIK_X')) then
    return 'DIK_X'
  elseif( string.match( keys, 'DIK_C')) then
    return 'DIK_C'
  elseif( string.match( keys, 'DIK_V')) then
    return 'DIK_V'
  elseif( string.match( keys, 'DIK_B')) then
    return 'DIK_B'
  elseif( string.match( keys, 'DIK_N')) then
    return 'DIK_N'
  elseif( string.match( keys, 'DIK_M')) then
    return 'DIK_M'
  elseif( string.match( keys, 'DIK_COMMA')) then
    return 'DIK_COMMA'
  elseif( string.match( keys, 'DIK_PERIOD')) then
    return 'DIK_PERIOD'
  elseif( string.match( keys, 'DIK_SLASH')) then
    return 'DIK_SLASH'
  elseif( string.match( keys, 'DIK_RSHIFT')) then
    return 'DIK_RSHIFT'
  elseif( string.match( keys, 'DIK_MULTIPLY')) then
    return 'DIK_MULTIPLY'
  elseif( string.match( keys, 'DIK_LMENU')) then
    return 'DIK_LMENU'
  elseif( string.match( keys, 'DIK_LMENU')) then
    return 'DIK_LMENU'
  elseif( string.match( keys, 'DIK_SPACE')) then
    return 'DIK_SPACE'
  elseif( string.match( keys, 'DIK_CAPITAL')) then
    return 'DIK_CAPITAL'
  elseif( string.match( keys, 'DIK_F1')) then
    return 'DIK_F1'
  elseif( string.match( keys, 'DIK_F2')) then
    return 'DIK_F2'
  elseif( string.match( keys, 'DIK_F3')) then
    return 'DIK_F3'
  elseif( string.match( keys, 'DIK_F4')) then
    return 'DIK_F4'
  elseif( string.match( keys, 'DIK_F5')) then
    return 'DIK_F5'
  elseif( string.match( keys, 'DIK_F6')) then
    return 'DIK_F6'
  elseif( string.match( keys, 'DIK_F7')) then
    return 'DIK_F7'
  elseif( string.match( keys, 'DIK_F8')) then
    return 'DIK_F8'
  elseif( string.match( keys, 'DIK_F9')) then
    return 'DIK_F9'
  elseif( string.match( keys, 'DIK_F10')) then
    return 'DIK_F10'
  elseif( string.match( keys, 'DIK_NUMLOCK')) then
    return 'DIK_NUMLOCK'
  elseif( string.match( keys, 'DIK_DIVIDE')) then
    return 'DIK_DIVIDE'
  elseif( string.match( keys, 'DIK_SCROLL')) then
    return 'DIK_SCROLL'
  elseif( string.match( keys, 'DIK_NUMPAD7')) then
    return 'DIK_NUMPAD7'
  elseif( string.match( keys, 'DIK_NUMPAD8')) then
    return 'DIK_NUMPAD8'
  elseif( string.match( keys, 'DIK_NUMPAD9')) then
    return 'DIK_NUMPAD9'
  elseif( string.match( keys, 'DIK_SUBTRACT')) then
    return 'DIK_SUBTRACT'
  elseif( string.match( keys, 'DIK_NUMPAD4')) then
    return 'DIK_NUMPAD4'
  elseif( string.match( keys, 'DIK_NUMPAD5')) then
    return 'DIK_NUMPAD5'
  elseif( string.match( keys, 'DIK_NUMPAD6')) then
    return 'DIK_NUMPAD6'
  elseif( string.match( keys, 'DIK_ADD')) then
    return 'DIK_ADD'
  elseif( string.match( keys, 'DIK_NUMPAD1')) then
    return 'DIK_NUMPAD1'
  elseif( string.match( keys, 'DIK_NUMPAD2')) then
    return 'DIK_NUMPAD2'
  elseif( string.match( keys, 'DIK_NUMPAD3')) then
    return 'DIK_NUMPAD3'
  elseif( string.match( keys, 'DIK_NUMPAD0')) then
    return 'DIK_NUMPAD0'
  elseif( string.match( keys, 'DIK_DECIMAL')) then
    return 'DIK_DECIMAL'
  elseif( string.match( keys, 'DIK_F11')) then
    return 'DIK_F11'
  elseif( string.match( keys, 'DIK_F12')) then
    return 'DIK_F12'
  elseif( string.match( keys, 'DIK_KANA')) then
    return 'DIK_KANA'
  elseif( string.match( keys, 'DIK_CONVERT')) then
    return 'DIK_CONVERT'
  elseif( string.match( keys, 'DIK_NOCONVERT')) then
    return 'DIK_NOCONVERT'
  elseif( string.match( keys, 'DIK_YEN')) then
    return 'DIK_YEN'
  elseif( string.match( keys, 'DIK_KANJI')) then
    return 'DIK_KANJI'
  elseif( string.match( keys, 'DIK_NUMPADENTER')) then
    return 'DIK_NUMPADENTER'
  elseif( string.match( keys, 'DIK_RCONTROL')) then
    return 'DIK_RCONTROL'
  elseif( string.match( keys, 'DIK_SYSRQ')) then
    return 'DIK_SYSRQ'
  elseif( string.match( keys, 'DIK_RMENU')) then
    return 'DIK_RMENU'
  elseif( string.match( keys, 'DIK_PAUSE')) then
    return 'DIK_PAUSE'
  elseif( string.match( keys, 'DIK_HOME')) then
    return 'DIK_HOME'
  elseif( string.match( keys, 'DIK_UP')) then
    return 'DIK_UP'
  elseif( string.match( keys, 'DIK_PRIOR')) then
    return 'DIK_PRIOR'
  elseif( string.match( keys, 'DIK_LEFT')) then
    return 'DIK_LEFT'
  elseif( string.match( keys, 'DIK_RIGHT')) then
    return 'DIK_RIGHT'
  elseif( string.match( keys, 'DIK_END')) then
    return 'DIK_END'
  elseif( string.match( keys, 'DIK_DOWN')) then
    return 'DIK_DOWN'
  elseif( string.match( keys, 'DIK_NEXT')) then
    return 'DIK_NEXT'
  elseif( string.match( keys, 'DIK_INSERT')) then
    return 'DIK_INSERT'
  elseif( string.match( keys, 'DIK_DELETE')) then
    return 'DIK_DELETE'
  elseif( string.match( keys, 'DIK_LWIN')) then
    return 'DIK_LWIN'
  elseif( string.match( keys, 'DIK_LWIN')) then
    return 'DIK_LWIN'
  elseif( string.match( keys, 'DIK_RWIN')) then
    return 'DIK_RWIN'
  elseif( string.match( keys, 'DIK_APPS')) then
    return 'DIK_APPS'
  elseif( string.match( keys, 'DIK_MAIL')) then
    return 'DIK_MAIL'
  elseif( string.match( keys, 'DIK_MEDIASELECT')) then
    return 'DIK_MEDIASELECT'
  elseif( string.match( keys, 'DIK_MEDIASTOP')) then
    return 'DIK_MEDIASTOP'
  elseif( string.match( keys, 'DIK_MUTE')) then
    return 'DIK_MUTE'
  elseif( string.match( keys, 'DIK_MYCOMPUTER')) then
    return 'DIK_MYCOMPUTER'
  elseif( string.match( keys, 'DIK_NEXT')) then
    return 'DIK_NEXT'
  elseif( string.match( keys, 'DIK_NEXTTRACK')) then
    return 'DIK_NEXTTRACK'
  elseif( string.match( keys, 'DIK_PLAYPAUSE')) then
    return 'DIK_PLAYPAUSE'
  elseif( string.match( keys, 'DIK_POWER')) then
    return 'DIK_POWER'
  elseif( string.match( keys, 'DIK_PREVTRACK')) then
    return 'DIK_PREVTRACK'
  elseif( string.match( keys, 'DIK_STOP')) then
    return 'DIK_STOP'
  elseif( string.match( keys, 'DIK_VOLUMEDOWN')) then
    return 'DIK_VOLUMEDOWN'
  elseif( string.match( keys, 'DIK_VOLUMEUP')) then
    return 'DIK_VOLUMEUP'
  elseif( string.match( keys, 'DIK_WEBBACK')) then
    return 'DIK_WEBBACK'
  elseif( string.match( keys, 'DIK_WEBFAVORITES')) then
    return 'DIK_WEBFAVORITES'
  elseif( string.match( keys, 'DIK_WEBFORWARD')) then
    return 'DIK_WEBFORWARD'
  elseif( string.match( keys, 'DIK_WEBHOME')) then
    return 'DIK_WEBHOME'
  elseif( string.match( keys, 'DIK_WEBREFRESH')) then
    return 'DIK_WEBREFRESH'
  elseif( string.match( keys, 'DIK_WEBSEARCH')) then
    return 'DIK_WEBSEARCH'
  elseif( string.match( keys, 'DIK_WEBSTOP')) then
    return 'DIK_WEBSTOP'
  end
  return nil
end

return bind_functions
