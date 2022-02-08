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

-- TrustSetsFunctions Details
-- Variables
--   sets_functions.print_to_log
--   sets_functions.trust_sets
-- Functions
--   sets_functions.updateSet( input_cmds)
--   sets_functions.addSet( name, num)
--   sets_functions.castAll( set_name)
--   sets_functions.changeSet( set_name)
--   sets_functions.cycleSet( )
--   sets_functions.dismissAll( )
--   sets_functions.displayTrustTable( trust_number)
--   sets_functions.displaySet( )
--   sets_functions.displayLoadedSet( )
--   sets_functions.getTrustFromSet( set_name, position, num)
--   sets_functions.listSetOrder( )
--   sets_functions.moveSet( name, num)
--   sets_functions.removeSet( name)
--   sets_functions.updatePosition( num, input_cmds)
--   sets_functions.addTrustPosition( num, add_name)
--   sets_functions.cycleTrustPosition( num)
--   sets_functions.removeTrustPosition( num, rm_name)
--   sets_functions.initialize( bind_funct, info_funct, file_funct, position_funct)
--   sets_functions.setTrustSetData( sets_data)
--   sets_functions.loadTrustSet( num)
--   sets_functions.isSetName( set_name)
--   sets_functions.isInTrustTable( num, name)

require 'logger'
require 'tables'
config = require 'config'
files = require 'files'

sets_functions = { }

-- Set to true to print logging messages to the lua.log file in the addon directory
sets_functions.print_to_log = true

sets_functions.trust_sets = { }
-- Used to parse the addon set commands
-- Inputs
--   input_cmds: ( REQUIRED) input command
-- Returns
--   None
function sets_functions.updateSet( input_cmds)
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

  local cmd = input_cmds[ 1]  -- <modifier>
  local name = input_cmds[ 2] -- <name>
  local num = input_cmds[ 3] -- <num>
  local msg_str

  if( cmd == nil and name == nil and num == nil) then
    -- '': If modifier is blank, display the name of the currently loaded set to chat
    name = sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set]
    windower.send_command( 'input /echo ~~~~~ Trust Set \'' .. name:upper() .. '\' ~~~~~;')
  elseif( cmd == 'add' or cmd == 'a') then
    -- 'add <name> <num>' or 'a <name> <num>': Add a set to the set list
    sets_functions.addSet( name, num)
  elseif( cmd == 'cycle' or cmd == 'c') then
    -- 'cycle' or 'c': Cycle to next set
    sets_functions.cycleSet()
  elseif( cmd == 'display' or cmd == 'disp') then
    -- 'display' or 'disp': Display the loaded trusts used in the current set
    sets_functions.displaySet()
  elseif( cmd == 'display_set' or cmd == 'disp_set') then
    -- 'display_set' or 'disp_set': Display the trusts used in the current set
    sets_functions.displayLoadedSet()
  elseif( cmd == 'list_order') then
    -- 'list_order': Display the set order list
    sets_functions.listSetOrder( )
  elseif( cmd == 'move' or cmd == 'mv') then
    -- 'move <name> <num>' or 'mv <name> <num>': Move a set to a specific position in the set list
    sets_functions.moveSet( name, num)
  elseif( cmd == 'remove' or cmd == 'rm') then
    -- 'remove <name>' or 'rm <name>': Remove a set from the set list
    sets_functions.removeSet( name)
  elseif( sets_functions.isSetName( name)) then
    -- <name>: Jump to the specified set
    sets_functions.changeSet( name)
  else
    msg_str = 'TrustHelper Unknown set command: ' .. cmd
    if( name ~= nil) then
      msg_str = msg_str .. ' ' .. name
      if( num ~= nil) then
        msg_str = msg_str .. ' ' .. num
      end
    end
    print( msg_str)
  end
end
-- Used to add a set name to the set list at a specified location
-- Inputs
--   name: ( REQUIRED) new set name
--   num: ( REQUIRED) position to load the new set; nil will place the set at the end of the set list
-- Returns
--   None
function sets_functions.addSet( name, num)

  local set_name = name:lower()
  local current_pos = 0
  
  for pos, data in pairs( sets_functions.trust_sets.set_order) do
    if( data == set_name) then
      current_pos = pos
    end
  end
	
	if( current_pos ~= 0) then
		print( 'Trust Set ' .. name .. ' Already Exists')
		return
	end
	
  sets_functions.trust_sets.num_sets = sets_functions.trust_sets.num_sets + 1

  if( num == nil) then
    sets_functions.trust_sets.set_order[ sets_functions.trust_sets.num_sets] = set_name
  else
    for pos = trust_sets.num_sets, num, -1 do
      sets_functions.trust_sets.set_order[ pos] = sets_functions.trust_sets.set_order[ pos - 1]
    end
    sets_functions.trust_sets.set_order[ num] = set_name
  end

  sets_functions.trust_sets[ set_name] = { }
  sets_functions.trust_sets[ set_name].trust_1 = { }
    sets_functions.trust_sets[ set_name].trust_1.position = 0
    sets_functions.trust_sets[ set_name].trust_1.size = 0
    sets_functions.trust_sets[ set_name].trust_1.trust = { }
  sets_functions.trust_sets[ set_name].trust_2 = { }
    sets_functions.trust_sets[ set_name].trust_2.position = 0
    sets_functions.trust_sets[ set_name].trust_2.size = 0
    sets_functions.trust_sets[ set_name].trust_2.trust = { }
  sets_functions.trust_sets[ set_name].trust_3 = { }
    sets_functions.trust_sets[ set_name].trust_3.position = 0
    sets_functions.trust_sets[ set_name].trust_3.size = 0
    sets_functions.trust_sets[ set_name].trust_3.trust = { }
  sets_functions.trust_sets[ set_name].trust_4 = { }
    sets_functions.trust_sets[ set_name].trust_4.position = 0
    sets_functions.trust_sets[ set_name].trust_4.size = 0
    sets_functions.trust_sets[ set_name].trust_4.trust = { }
  sets_functions.trust_sets[ set_name].trust_5 = { }
    sets_functions.trust_sets[ set_name].trust_5.position = 0
    sets_functions.trust_sets[ set_name].trust_5.size = 0
    sets_functions.trust_sets[ set_name].trust_5.trust = { }
    
 	print( 'Added Trust Set: ' .. name)

  file_functions.writeSetData( sets_functions.trust_sets)
end
-- Cast all allowed trusts
-- Inputs
--   None
-- Returns
--   None
function sets_functions.castAll( set_name)
  local cast_msg
  local party_size, is_party_leader = info_functions.getPartyInformation()
  local num_trusts = info_functions.getMaxNumberTrusts()
  
  if( is_party_leader ~= true) then
    windower.send_command( 'input /echo ~~~~~ Unable to Cast Trusts, Not Party Leader ~~~~~;')
    return
  elseif( party_size == 6) then
    windower.send_command( 'input /echo ~~~~~ Unable to Cast Trusts, Party Already Full ~~~~~;')
    return
  end

  -- Display echo if enabled
  if( info_functions.message_echo ~= false) then
    cast_msg = 'input /echo ~~~~~ Casting Set \'' .. string.upper( set_name) .. '\' All Trusts ~~~~~; '
  end

  -- Calculate the number of trusts the play can summon based on the party size
  if(( 6 - party_size) < num_trusts) then
    num_trusts = 6 - party_size
  end

	-- Build the cast all string
  for i = 1, num_trusts, 1 do
    if( i == 1) then
      cast_msg = cast_msg .. position_functions.binds[ i].cast_command
    else
      cast_msg = cast_msg .. ' wait ' .. info_functions.cast_wait_time .. '; ' .. position_functions.binds[ i].cast_command
    end
  end

  -- Send cast all string to the windower
  windower.send_command( cast_msg)
end
-- Used to jump to a specified set
-- Inputs
--   name: ( REQUIRED) set name
-- Returns
--   None
function sets_functions.changeSet( set_name)
  for num, name in paris( sets_functions.trust_sets.set_order) do
    if( name == set_name) then
      windower.send_command( 'input /echo ~~~~~ TrustHelper Loaded Set: ' .. sets_functions.trust_sets.set_order[ num]:upper() .. ' ~~~~~;')
      sets_functions.loadTrustSet( num)
      return
    end
  end
end
-- Used to transiton to the next set in the set list
-- Inputs
--   None
-- Returns
--   None
function sets_functions.cycleSet( )
	local set = sets_functions.trust_sets.current_set
	local next_set = set + 1
	
	if( sets_functions.trust_sets.set_order[ next_set] == nil) then
		next_set = 1
	end

	windower.send_command( 'input /echo ~~~~~ TrustHelper Loaded Set: ' .. sets_functions.trust_sets.set_order[ next_set]:upper() .. ' ~~~~~;')
	
	sets_functions.loadTrustSet( next_set)
end
-- Dismiss all trusts
-- Inputs
--   None
-- Returns
--   None
function sets_functions.dismissAll( )
  if( info_functions.message_echo ~= false) then
    windower.send_command( 'input /echo ~~~~~ Dismissing All Trusts ~~~~~; input /retr all;')
  else
    windower.send_command( 'input /retr all;')
  end
end
-- Display all trusts loaded in a specified trust table
-- Inputs
--   trust_number: Trust table to display
-- Returns
--   None
function sets_functions.displayTrustTable( trust_number)
	local set_name = sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set]
	local set_info = sets_functions.trust_sets[ set_name]
	local size
	local position
	local trust
  local message

  if( trust_number == 1) then
    -- Display trust table 1
		size = set_info.trust_1.size
		position = set_info.trust_1.position
		trust = set_info.trust_1.trust
  elseif( trust_number == 2) then
    -- Display trust table 2
		size = set_info.trust_2.size
		position = set_info.trust_2.position
		trust = set_info.trust_2.trust
  elseif( trust_number == 3) then
    -- Display trust table 3
		size = set_info.trust_3.size
		position = set_info.trust_3.position
		trust = set_info.trust_3.trust
  elseif( trust_number == 4) then
    -- Display trust table 4
		size = set_info.trust_4.size
		position = set_info.trust_4.position
		trust = set_info.trust_4.trust
  elseif( trust_number == 5) then
    -- Display trust table 5
		size = set_info.trust_5.size
		position = set_info.trust_5.position
		trust = set_info.trust_5.trust
  end

  -- Add echo message to the beginning of the message
  message = 'input /echo ~~~~~ Trust Table ' .. trust_number .. ' (' .. size  .. ' Trusts) ~~~~~;'
  -- Add echo message to the beginning of the message
	if( size > 0) then
		message = message .. 'input /echo ~~~~~ Current Trust Loaded: ' .. info_functions.command[ trust[ position]].trust .. ' ~~~~~;'
	else
		message = message .. 'input /echo ~~~~~ Current Trust Loaded: None ~~~~~;'
	end

	for pos = 1, size, 1 do
		message = message .. 'input /echo ~~~~~ Position ' .. pos .. ': ' .. info_functions.command[ trust[ pos]].trust .. ' ~~~~~;'
	end

  -- Send the message to windower
  windower.send_command( message)
end
-- Display all trusts used in the set
-- Inputs
--   None
-- Returns
--   None
function sets_functions.displaySet( )
	local set_name = sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set]
	local set_info = sets_functions.trust_sets[ set_name]
	local size
	local position
	local trust
  local message
	
  -- Add echo message to the beginning of the message
  message = 'input /echo ~~~~~ Trust Set \'' .. string.upper( set_name) .. '\' ~~~~~;'

	for trust_number = 1, 5, 1 do
		if( trust_number == 1) then
			-- Display trust table 1
			size = set_info.trust_1.size
			position = set_info.trust_1.position
			trust = set_info.trust_1.trust
		elseif( trust_number == 2) then
			-- Display trust table 2
			size = set_info.trust_2.size
			position = set_info.trust_2.position
			trust = set_info.trust_2.trust
		elseif( trust_number == 3) then
			-- Display trust table 3
			size = set_info.trust_3.size
			position = set_info.trust_3.position
			trust = set_info.trust_3.trust
		elseif( trust_number == 4) then
			-- Display trust table 4
			size = set_info.trust_4.size
			position = set_info.trust_4.position
			trust = set_info.trust_4.trust
		elseif( trust_number == 5) then
			-- Display trust table 5
			size = set_info.trust_5.size
			position = set_info.trust_5.position
			trust = set_info.trust_5.trust
		end
		
		-- Add echo message to the beginning of the message
		message = message .. 'input /echo ~~~~~ Trust Table ' .. trust_number .. ' (' .. size  .. ' Trusts) ~~~~~;'
		-- Add echo message to the beginning of the message
		message = message .. 'input /echo   ~~~~~   Current Trust Loaded: ' .. info_functions.command[ trust[ position]].trust .. ' ~~~~~;'

		for pos = 1, size, 1 do
			message = message .. 'input /echo   ~~~~~   Position ' .. pos .. ': ' .. info_functions.command[ trust[ pos]].trust .. ' ~~~~~;'
		end
	end
	
  -- Send the message to windower
  windower.send_command( message)
end
-- Display all trusts in the set that are currently loaded for the binds
-- Inputs
--   None
-- Returns
--   None
function sets_functions.displayLoadedSet( )
	local set_name = sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set]
	local set_info = sets_functions.trust_sets[ set_name]
	local size
	local position
	local trust
  local message

  -- Add echo message to the beginning of the message
  message = 'input /echo ~~~~~ Trust Set \'' .. string.upper( set_name) .. '\' ~~~~~;'

	for trust_number = 1, 5, 1 do
		if( trust_number == 1) then
			-- Display trust table 1
			size = set_info.trust_1.size
			position = set_info.trust_1.position
			trust = set_info.trust_1.trust
		elseif( trust_number == 2) then
			-- Display trust table 2
			size = set_info.trust_2.size
			position = set_info.trust_2.position
			trust = set_info.trust_2.trust
		elseif( trust_number == 3) then
			-- Display trust table 3
			size = set_info.trust_3.size
			position = set_info.trust_3.position
			trust = set_info.trust_3.trust
		elseif( trust_number == 4) then
			-- Display trust table 4
			size = set_info.trust_4.size
			position = set_info.trust_4.position
			trust = set_info.trust_4.trust
		elseif( trust_number == 5) then
			-- Display trust table 5
			size = set_info.trust_5.size
			position = set_info.trust_5.position
			trust = set_info.trust_5.trust
		end
		
		-- Add echo message to the beginning of the message
		message = message .. 'input /echo ~~~~~ Trust Table ' .. trust_number .. ' (' .. size  .. ' Trusts) ~~~~~;'
		-- Add echo message to the beginning of the message
		message = message .. 'input /echo   ~~~~~   Current Trust Loaded: ' .. info_functions.command[ trust[ position]].trust .. ' ~~~~~;'
	end
	
  -- Send the message to windower
  windower.send_command( message)
end
-- Return the name of a trust located in a specified set, in the specified position at the specified location
-- Inputs
--   set_name: ( REQUIRED) set name
--   position: ( REQUIRED) position to lookup
--   num: ( REQUIRED) number location in the position
-- Returns
--   name of the trust
function sets_functions.getTrustFromSet( set_name, position, num)

	local set_info = sets_functions.trust_sets[ set_name]
	local set_data
	local trust_list
	
	if( position == 1) then
    set_data = set_info.trust_1
	elseif( position == 2) then
    set_data = set_info.trust_2
	elseif( position == 3) then
    set_data = set_info.trust_3
	elseif( position == 4) then
    set_data = set_info.trust_4
	elseif( position == 5) then
    set_data = set_info.trust_5
	end

  if( set_data.size > 0) then
    trust_list = set_data.trust
    
    for id, name in pairs( trust_list) do
      if( id == num) then
        return( name)
      end
    end
  end
	
  return nil
end
-- Display all sets in the order of the set list
-- Inputs
--   None
-- Returns
--   None
function sets_functions.listSetOrder( )

  local msg_str
	
  -- Add echo message to the beginning of the message
  msg_str = 'input /echo ~~~~~ Trust Set List ~~~~~;'

  for num = 1, sets_functions.trust_sets.num_sets, 1 do
    msg_str = msg_str .. 'input /echo ~~~~~ ' .. num .. ': ' .. sets_functions.trust_sets.set_order[ num]:upper() .. ' ~~~~~;'
  end
  
  windower.send_command( msg_str)
end
-- Used to change the position of a set in the set list
-- Inputs
--   name: ( REQUIRED) set name
--   num: ( REQUIRED) new position in the set list
-- Returns
--   None
function sets_functions.moveSet( name, num)

  local set_name = name:lower()
  local current_pos = 0
  
  for pos, data in pairs( sets_functions.trust_sets.set_order) do
    if( data == set_name) then
      current_pos = pos
    end
  end
	
	if( current_pos == 0) then
		print( 'Not a Valid Trust Set: ' .. name)
		return
	end
  
  for pos = current_pos, sets_functions.trust_sets.num_sets, 1 do
    sets_functions.trust_sets.set_order[ pos] = sets_functions.trust_sets.set_order[ pos + 1]
  end
  
  for pos = sets_functions.trust_sets.num_sets, num, -1 do
    sets_functions.trust_sets.set_order[ pos] = sets_functions.trust_sets.set_order[ pos - 1]
  end
	
	sets_functions.trust_sets.set_order[ num] = name
end
-- Used to remove a set from the set list
-- Inputs
--   name: ( REQUIRED) set name
-- Returns
--   None
function sets_functions.removeSet( name)

  local set_name = name:lower()
  local pos = 0
  
  for num, data in pairs( sets_functions.trust_sets.set_order) do
    if( data == set_name) then
      pos = num
    end
  end
  
	if( pos == 0) then
		print( 'Not a Valid Trust Set: ' .. name)
		return
	end
  
  for num = pos, sets_functions.trust_sets.num_sets, 1 do
    sets_functions.trust_sets.set_order[ pos] = sets_functions.trust_sets.set_order[ pos + 1]
  end

  sets_functions.trust_sets.set_order[ sets_functions.trust_sets.num_sets] = nil
  sets_functions.trust_sets.num_sets = sets_functions.trust_sets.num_sets -1

  sets_functions.trust_sets[ set_name] = nil
	
	print( 'Removed Trust Set: ' .. name)

  file_functions.writeSetData( sets_functions.trust_sets)
end
-- Update a specific trust table based on the provided input command
-- Inputs
--   num: Trust table to modify
--   input_cmds: Command used to modify the table
-- Returns
--   None
function sets_functions.updatePosition( num, input_cmds)

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

  local cmd = input_cmds[ 1]  -- <modifier>
  local name = input_cmds[ 2] -- <name>

  if( cmd == nil and name == nil) then
    -- Display the name of the currently loaded trust to chat
    windower.send_command( 'input /echo ~~~~~ Trust ' .. num .. ': ' .. position_functions.getTrustNumberName( num) .. ' ~~~~~;')
  elseif( cmd == 'add' or cmd == 'a') then
    -- Add a trust name to the specified trust position
    sets_functions.addTrustPosition( num, name)
  elseif( cmd == 'cycle' or cmd == 'c') then
    -- Cycle forward one number in the specificed trust number table
    sets_functions.cycleTrustPosition( num) 
  elseif( cmd == 'display' or cmd == 'disp') then
    -- Display the trust current loaded in the specified trust position table
    sets_functions.displayTrustTable( num) 
  elseif( cmd == 'remove' or cmd == 'rm') then
    -- Remove a trust name from the specified trust position
    sets_functions.removeTrustPosition( num, name)
  else
    print( 'TrustHelper Unknown command: ' .. num .. ' ' .. cmd)
  end
end
-- Add a trust to a trust table.  Will confirm that the trust is not already loaded first
-- Inputs
--   num: Trust table to modify
--   name: Name of the trust to add
-- Returns
--   None
function sets_functions.addTrustPosition( num, add_name)

	local set_info = sets_functions.trust_sets[ sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set]]
	local name = add_name:lower()
  local in_table
  local position

  -- Confirm that the trust name is provided
  if( name == nil) then
    -- Missing name data
    print( 'TrustHelper Missing Trust Name')
    return
  end

  -- Check to see if the name is already in the list
  in_table = sets_functions.isInTrustTable( num, name)
  if( in_table ~= nil) then
    -- The name is already in the list
    print( 'TrustHelper Trust Already in the Table')
    return
  elseif( info_functions.command[ name] == nil) then
    -- The name is not a known trust
    print( 'TrustHelper Unknown Trust Name: ' .. name)
    return
  end

  if( num == 1) then
    -- Modify trust position 1
		set_info.trust_1.size = set_info.trust_1.size + 1
		set_info.trust_1.trust[ set_info.trust_1.size] = name
  elseif( num == 2) then
    -- Modify trust position 2
		set_info.trust_2.size = set_info.trust_2.size + 1
		set_info.trust_2.trust[ set_info.trust_2.size] = name
  elseif( num == 3) then
    -- Modify trust position 3
		set_info.trust_3.size = set_info.trust_3.size + 1
		set_info.trust_3.trust[ set_info.trust_3.size] = name
  elseif( num == 4) then
    -- Modify trust position 4
		set_info.trust_4.size = set_info.trust_4.size + 1
		set_info.trust_4.trust[ set_info.trust_4.size] = name
  elseif( num == 5) then
    -- Modify trust position 5
		set_info.trust_5.size = set_info.trust_5.size + 1
		set_info.trust_5.trust[ set_info.trust_5.size] = name
  end

  print( 'TrustHelper Added ' .. info_functions.command[ name].trust .. ' to Trust Table ' .. num)
  file_functions.writeSetData( sets_functions.trust_sets)
end
-- Move and load the next trust position in the specified trust table
-- Inputs
--   num: Trust table to modify
-- Returns
--   None
function sets_functions.cycleTrustPosition( num)

	local set_name = sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set]
	local set_info = sets_functions.trust_sets[ set_name]
	local position
	local next_position
	local size
	local name
	local next_name
	local cast_bind
	local dismiss_bind
	local cycle_bind

	if( num == 1) then
		position = set_info.trust_1.position
		size = set_info.trust_1.size
	elseif( num == 2) then
		position = set_info.trust_2.position
		size = set_info.trust_2.size
	elseif( num == 3) then
		position = set_info.trust_3.position
		size = set_info.trust_3.size
	elseif( num == 4) then
		position = set_info.trust_4.position
		size = set_info.trust_4.size
	elseif( num == 5) then
		position = set_info.trust_5.position
		size = set_info.trust_5.size
	end

	if( position == size) then
		next_position = 1
	else
		next_position = position + 1
	end

	name = sets_functions.getTrustFromSet( set_name, num, position)
	next_name = sets_functions.getTrustFromSet( set_name, num, next_position)
	cast_bind, dimiss_bind, cycle_bind = bind_functions.getBindInformation( num)

	windower.send_command( 'input /echo ~~~~~ Trust ' .. num .. ' Change: ' .. info_functions.command[ name].trust .. ' -> ' .. info_functions.command[ next_name].trust .. ' ~~~~~;')

	-- Clear any data from the bind table
	position_functions.clearTrustNumber( num)
	-- Load the trust in to the bind table
	position_functions.loadTrustNumber( num, next_name, cast_bind, dimiss_bind)
  position_functions.sendBindCommands( num)

	if( num == 1) then
		set_info.trust_1.position = next_position
	elseif( num == 2) then
		set_info.trust_2.position = next_position
	elseif( num == 3) then
		set_info.trust_3.position = next_position
	elseif( num == 4) then
		set_info.trust_4.position = next_position
	elseif( num == 5) then
		set_info.trust_5.position = next_position
	end
end
-- Remove a trust from a trust table.  Will confirm that the trust is loaded first
-- Inputs
--   num: Trust table to modify
--   name: Name of the trust to remove
-- Returns
--   None
function sets_functions.removeTrustPosition( num, rm_name)

	local set_info = sets_functions.trust_sets[ sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set]]
	local name = rm_name
	local size
	local position
	local trust

  -- Confirm that the trust name is provided
  if( name == nil) then
    -- Missing name data
    print( 'TrustHelper Missing Trust Name')
    return
  end

  -- Check to see if the name is already in the list
  target_position = sets_functions.isInTrustTable( num, name)
  if( target_position == nil) then
    -- The name is not in the list
    print( 'TrustHelper Trust Not in Trust Table')
    return
  end

  print( 'TrustHelper Removed ' .. info_functions.command[ name].trust .. ' from Trust Table ' .. num)

  if( num == 1) then
    -- Modify trust position 1
		size = set_info.trust_1.size
		position = set_info.trust_1.position
		trust = set_info.trust_1.trust
  elseif( num == 2) then
    -- Modify trust position 2
		size = set_info.trust_2.size
		position = set_info.trust_2.position
		trust = set_info.trust_2.trust
  elseif( num == 3) then
    -- Modify trust position 3
		size = set_info.trust_3.size
		position = set_info.trust_3.position
		trust = set_info.trust_3.trust
  elseif( num == 4) then
    -- Modify trust position 4
		size = set_info.trust_4.size
		position = set_info.trust_4.position
		trust = set_info.trust_4.trust
  elseif( num == 5) then
    -- Modify trust position 5
		size = set_info.trust_5.size
		position = set_info.trust_5.position
		trust = set_info.trust_5.trust
  end

	for pos = target_position, size, 1 do
		trust[ pos] = trust[ pos + 1]
	end
	
	size = size - 1

	if( target_position <= position) then
		if( position == size) then
			position = 1
		else
			position = position + 1
		end
		-- Update binds
		name = trust[ position]
		windower.send_command( 'input /echo ~~~~~ Trust ' .. num .. ' Change: ' .. info_functions.command[ rm_name].trust .. ' -> ' .. info_functions.command[ name].trust .. ' ~~~~~;')
		cast_bind, dimiss_bind, cycle_bind = bind_functions.getBindInformation( num)
		-- Clear any data from the bind table
		position_functions.clearTrustNumber( num)
		-- Load the trust in to the bind table
		position_functions.loadTrustNumber( num, name, cast_bind, dimiss_bind)
		position_functions.sendBindCommands( num)
	end

  if( num == 1) then
    -- Modify trust position 1
		set_info.trust_1.size = size
		set_info.trust_1.position = position
		set_info.trust_1.trust = trust
  elseif( num == 2) then
    -- Modify trust position 2
		set_info.trust_2.size = size
		set_info.trust_2.position = position
		set_info.trust_2.trust = trust
  elseif( num == 3) then
    -- Modify trust position 3
		set_info.trust_3.size = size
		set_info.trust_3.position = position
		set_info.trust_3.trust = trust
  elseif( num == 4) then
    -- Modify trust position 4
		set_info.trust_4.size = size
		set_info.trust_4.position = position
		set_info.trust_4.trust = trust
  elseif( num == 5) then
    -- Modify trust position 5
		set_info.trust_5.size = size
		set_info.trust_5.position = position
		set_info.trust_5.trust = trust
  end
  file_functions.writeSetData( sets_functions.trust_sets)
end
-- Used to load the sets_functions.trust_sets table data
-- Inputs
--   sets_data: ( REQUIRED) set table data
-- Returns
--   None
function sets_functions.setTrustSetData( sets_data)
  sets_functions.trust_sets = sets_data
end
-- Used to check is a job specific trust set exists and returns the number if it does
-- Inputs
--   main_job: ( REQUIRED) player main job
-- Returns
--   set_number: Position number of the job specific trust set, returns nil if the job specific set does not exist
function sets_functions.hasJobTrustSet( main_job)
	job = main_job:lower( )
	
	for num, name in pairs( sets_functions.trust_sets.set_order) do
    if( name == job) then
      return num
    end
  end

  return nil
end
-- Used to load a set from the specified position in the trust list
-- Inputs
--   num: ( REQUIRED) position of the set in the set list
-- Returns
--   None
function sets_functions.loadTrustSet( num)

	sets_functions.trust_sets.current_set = num
	
  -- Get the max number of trusts that the user can summon
  max_trusts = info_functions.getMaxNumberTrusts()
  
  -- Load the trust 1 bind commands
	-- Get position information
	name = sets_functions.getTrustFromSet( sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set], 1, 1)
  if( name ~= nil) then
    cast_bind, dimiss_bind, cycle_bind, display_bind = bind_functions.getBindInformation( 1)
    -- Cast and Dismiss information
    position_functions.loadTrustNumber( 1, name, cast_bind, dimiss_bind)
    -- Bind the cycle command
    bind_functions.changePositionBind( 1, 'cycle', cycle_bind)
    bind_functions.changePositionBind( 1, 'display', display_bind)
  end

  -- Load the trust 1 bind commands
	-- Get position information
	name = sets_functions.getTrustFromSet( sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set], 2, 1)
  if( name ~= nil) then
    cast_bind, dimiss_bind, cycle_bind, display_bind = bind_functions.getBindInformation( 2)
    -- Cast and Dismiss information
    position_functions.loadTrustNumber( 2, name, cast_bind, dimiss_bind)
    -- Bind the cycle command
    bind_functions.changePositionBind( 2, 'cycle', cycle_bind)
    bind_functions.changePositionBind( 2, 'display', display_bind)
  end

  -- Load the trust 1 bind commands
	-- Get position information
	name = sets_functions.getTrustFromSet( sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set], 3, 1)
  if( name ~= nil) then
    cast_bind, dimiss_bind, cycle_bind, display_bind = bind_functions.getBindInformation( 3)
    -- Cast and Dismiss information
    position_functions.loadTrustNumber( 3, name, cast_bind, dimiss_bind)
    -- Bind the cycle command
    bind_functions.changePositionBind( 3, 'cycle', cycle_bind)
    bind_functions.changePositionBind( 3, 'display', display_bind)
  end

  -- Confirm that the player can call 4 trusts and load the trust 4 bind commands
  if( max_trusts >= 4) then
		-- Get position information
		name = sets_functions.getTrustFromSet( sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set], 4, 1)
    if( name ~= nil) then
      cast_bind, dimiss_bind, cycle_bind, display_bind = bind_functions.getBindInformation( 4)
      -- Cast and Dismiss information
      position_functions.loadTrustNumber( 4, name, cast_bind, dimiss_bind)
      -- Bind the cycle command
      bind_functions.changePositionBind( 4, 'cycle', cycle_bind)
      bind_functions.changePositionBind( 4, 'display', display_bind)
    end
  end

  -- Confirm that the player can call 5 trusts and load the trust 5 bind commands
  if( max_trusts == 5) then
		-- Get position information
		name = sets_functions.getTrustFromSet( sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set], 5, 1)
    if( name ~= nil) then
      cast_bind, dimiss_bind, cycle_bind, display_bind = bind_functions.getBindInformation( 5)
      -- Cast and Dismiss information
      position_functions.loadTrustNumber( 5, name, cast_bind, dimiss_bind)
      -- Bind the cycle command
      bind_functions.changePositionBind( 5, 'cycle', cycle_bind)
      bind_functions.changePositionBind( 5, 'display', display_bind)
    end
  end

  -- Set all of the supported cast and dimisss binds
  position_functions.loadBinds( )
end
-- Used to load a set of a specified name from the trust list
-- Inputs
--   set_name: ( REQUIRED) name of the set in the set list
-- Returns
--   None
function sets_functions.isSetName( set_name)
  for num, name in pairs( sets_functions.trust_sets.set_order) do
    if( name == set_name) then
      return true
    end
  end
  return false
end
-- Checks to see if a trust is already loaded in a trust position table
-- Inputs
--   num: Which trust table to check; Range 1-5
--   name: Name of the trust
-- Returns
--   num: Position in the trust table where the trust is loaded, returns nil if the trust is not loaded
function sets_functions.isInTrustTable( num, name)

	local set_info = sets_functions.trust_sets[ sets_functions.trust_sets.set_order[ sets_functions.trust_sets.current_set]]
	local trust
	local size

	if( num == 1) then
		trust = set_info.trust_1.trust
		size = set_info.trust_1.size
	elseif( num == 2) then
		trust = set_info.trust_2.trust
		size = set_info.trust_2.size
	elseif( num == 3) then
		trust = set_info.trust_3.trust
		size = set_info.trust_3.size
	elseif( num == 4) then
		trust = set_info.trust_4.trust
		size = set_info.trust_4.size
	elseif( num == 5) then
		trust = set_info.trust_5.trust
		size = set_info.trust_5.size
	end
	
	for pos = 1, size, 1 do
		if( trust[ pos] == name) then
			return pos
		end
	end
	
	return nil
end

return sets_functions
