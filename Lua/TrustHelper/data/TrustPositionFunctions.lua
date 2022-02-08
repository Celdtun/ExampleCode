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

-- TrustPositionFunctions Details
-- Variables
--   position_functions.binds
-- Functions
--   position_functions.getTrustNumberName( trust_number)
--   position_functions.clearTrustNumber( trust_number)
--   position_functions.loadTrustNumber( trust_number, name, cast_keys, dimiss_keys)
--   position_functions.clearBinds( )
--   position_functions.loadBinds( )
--   position_functions.clearBindCommands( trust_number)
--   position_functions.sendBindCommands( trust_number)
--   position_functions.getHelpInformation( num, name, cast_keys, dimiss_keys)
--   position_functions.initialize( bind_funct, info_funct, file_funct, sets_funct)

require 'logger'
require 'tables'
config = require 'config'
files = require 'files'

position_functions = { }

-- Bind table contining information specific to a bound position; 1 correlates to the first trust, 2 the second trust, etc...
--   name: Trust name in lowercase
--   trust: Name of the trust
--   cast_command: Casting command for the trust
--   cast_bind_keys: Bind key for casting the trust command
--   cast_bind_command: Actual bind command for casting the trust
--   cast_bind_keys: Bind key for dismissing the trust command
--   cast_bind_command: Actual bind command for dismissing the trust
--   help_str: String containing information that can be displayed to the chat to define the trust and it's binds
position_functions.binds = {
  [ 1] = { name = 'none', trust = 'None', cast_command = nil, cast_bind_keys = nil, cast_bind_command = nil, dismiss_bind_keys = nil, dismiss_bind_command = nil, help_str = nil},
  [ 2] = { name = 'none', trust = 'None', cast_command = nil, cast_bind_keys = nil, cast_bind_command = nil, dismiss_bind_keys = nil, dismiss_bind_command = nil, help_str = nil},
  [ 3] = { name = 'none', trust = 'None', cast_command = nil, cast_bind_keys = nil, cast_bind_command = nil, dismiss_bind_keys = nil, dismiss_bind_command = nil, help_str = nil},
  [ 4] = { name = 'none', trust = 'None', cast_command = nil, cast_bind_keys = nil, cast_bind_command = nil, dismiss_bind_keys = nil, dismiss_bind_command = nil, help_str = nil},
  [ 5] = { name = 'none', trust = 'None', cast_command = nil, cast_bind_keys = nil, cast_bind_command = nil, dismiss_bind_keys = nil, dismiss_bind_command = nil, help_str = nil},
},{ name, trust, cast_command, cast_bind_keys, cast_bind_command, dismiss_bind_keys, dismiss_bind_command, help_str}

-- Used to get the name of the trust at a bind postion
-- Inputs
--   trust_number: ( REQUIRED) Which bind position to get; Range 1-5
-- Returns
--   Name of the trust
function position_functions.getTrustNumberName( trust_number)
  return position_functions.binds[ trust_number].trust
end

-- Used to clear trust data at a trust postion
-- Inputs
--   trust_number: ( REQUIRED) Which bind position to get; Range 1-5
-- Returns
--   None
function position_functions.clearTrustNumber( trust_number)
  -- Confirm that the specified trust number is valid
  if( trust_number ~= 1 and trust_number ~= 2 and trust_number ~= 3 and 
      trust_number ~= 4 and trust_number ~= 5) then
		print( "Clear Trust Number Failed: Unknown Trust Number")
		return
  else
    position_functions.binds[ trust_number].name = 'None'
    position_functions.binds[ trust_number].trust = 'None'
    position_functions.binds[ trust_number].cast_command = nil
    position_functions.binds[ trust_number].cast_bind_keys = nil
    position_functions.binds[ trust_number].cast_bind_command = nil
    position_functions.binds[ trust_number].dismiss_bind_keys = nil
    position_functions.binds[ trust_number].dismiss_bind_command = nil
    position_functions.binds[ trust_number].help_str = nil
  end
end

-- Used to assign trust data to a bind postion
-- Inputs
--   trust_number: ( REQUIRED) Which bind position to get; Range 1-5
--   name: ( REQUIRED) Name of the trust; Example 'King of Hearts' or 'Lion II'
--   cast_keys: ( REQUIRED) Keys to use for the bind
--   dimiss_keys: ( REQUIRED) Keys to use for the bind
-- Returns
--   None
function position_functions.loadTrustNumber( trust_number, name, cast_keys, dimiss_keys)

  -- Confirm that the specified trust number is valid
  if( trust_number ~= 1 and trust_number ~= 2 and trust_number ~= 3 and 
      trust_number ~= 4 and trust_number ~= 5 or trust_number > info_functions.getMaxNumberTrusts()) then
		print( "Load Trust Failed: Unknown Trust Number")
		return
  -- Confirm that the specified trust is known by the player
	elseif( info_functions.command[ name] == nil) then
		print( "Load Trust Failed: Unknown Trust " .. name)
		return
  else
    -- Copy the specified trust information to the bind table
    position_functions.binds[ trust_number].name = name
    position_functions.binds[ trust_number].trust = info_functions.command[ name].trust
    position_functions.binds[ trust_number].cast_command = info_functions.command[ name].cast_command
    position_functions.binds[ trust_number].cast_bind_keys = cast_keys
    position_functions.binds[ trust_number].cast_bind_command = 'bind ' .. cast_keys .. ' ' .. info_functions.command[ name].cast_command
    position_functions.binds[ trust_number].dismiss_bind_keys = dimiss_keys
    position_functions.binds[ trust_number].dismiss_bind_command = 'bind ' .. dimiss_keys .. ' ' .. info_functions.command[ name].dismiss_command
    position_functions.binds[ trust_number].help_str = position_functions.getHelpInformation( trust_number, name, cast_keys, dimiss_keys)
	end
end

-- Clear all binds related to trusts
-- Inputs
--   None
-- Returns
--   None
function position_functions.clearBinds( )
  for i = 1, info_functions.getMaxNumberTrusts(), 1 do
    position_functions.clearBindCommands( i)
  end
end

-- Send bind information for all trust positions
-- Inputs
--   None
-- Returns
--   None
function position_functions.loadBinds( )
  for i = 1, info_functions.getMaxNumberTrusts(), 1 do
    if( position_functions.binds[ i].name ~= 'none') then
      position_functions.sendBindCommands( i)
    end
  end
end

-- Used to clear the bind from windower
-- Inputs
--   trust_number: ( REQUIRED) Which info_functions.command bind to clear ; Range 1-5
-- Returns
--   None
function position_functions.clearBindCommands( trust_number)
  if( trust_number ~= 1 and trust_number ~= 2 and trust_number ~= 3 and
      trust_number ~= 4 and trust_number ~= 5 or trust_number > info_functions.getMaxNumberTrusts()) then
		print( "Load Trust Failed: Unknown Trust Number")
		return
  end
  -- Unbind the keys
	if( position_functions.binds[ trust_number].cast_bind_keys ~= nil) then
		windower.send_command( 'unbind ' .. position_functions.binds[ trust_number].cast_bind_keys)
	end
	if( position_functions.binds[ trust_number].dismiss_bind_keys ~= nil) then
		windower.send_command( 'unbind ' .. position_functions.binds[ trust_number].dismiss_bind_keys)
	end
end

-- Used to send the bind info_functions.commands to windower
-- Inputs
--   trust_number: ( REQUIRED) Which bind info_functions.command to send; Range 1-5
-- Returns
--   None
function position_functions.sendBindCommands( trust_number)

  if( trust_number ~= 1 and trust_number ~= 2 and trust_number ~= 3 and
      trust_number ~= 4 and trust_number ~= 5 or trust_number > info_functions.getMaxNumberTrusts()) then
		print( "Load Trust Failed: Unknown Trust Number")
		return
  -- Confirm that the specified trust is programmed
	elseif( position_functions.binds[ trust_number].cast_bind_keys == nil or position_functions.binds[ trust_number].dismiss_bind_keys == nil) then
		print( "Load Trust Failed: Unknown Trust position_functions.binds")
		return
  end
  -- Unbind the keys to ensure it is set properly
  position_functions.clearBindCommands( trust_number)
  -- Send the casting bind to windower
	windower.send_command( position_functions.binds[ trust_number].cast_bind_command)
  -- Send the dimissing bind to windower
	windower.send_command( position_functions.binds[ trust_number].dismiss_bind_command)
end

-- Used to generate the string detailing the trust bind info_functions.commands
-- Inputs
--   name: ( REQUIRED) Name of the trust; Example 'King of Hearts' or 'Lion II'
--   cast_keys: ( REQUIRED) Keys to use for the bind
--   dimiss_keys: ( REQUIRED) Keys to use for the bind
-- Returns
--   help_str: String containing the help message
function position_functions.getHelpInformation( num, name, cast_keys, dimiss_keys)
  -- Parse the Cast info_functions.command
  local help_str = '~~~~~ Trust ' .. num .. ': ' .. info_functions.command[ name].trust .. ' - Cast: '
  help_str = help_str ..  bind_functions.getBindKeyInformation( cast_keys)
  -- Parse the Dismiss info_functions.command
  help_str = help_str .. ', Dismiss: '
  help_str = help_str ..  bind_functions.getBindKeyInformation( dimiss_keys)
  help_str = help_str .. ' ~~~~~;'
  
  -- Return the help string
  return help_str
end

return position_functions
