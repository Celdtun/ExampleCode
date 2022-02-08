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

-- TrustFileFunctions Details
-- Variables
--   file_functions.print_to_log
--   file_functions.file_data
-- Functions
--   file_functions.checkSettingFileExists( )
--   file_functions.readSettingFile( )
--   file_functions.getTrustSetInfo( input_str)
--   file_functions.writeSetData( set_data)
--   file_functions.writeBindData( bind_data)
--   file_functions.writeSettingFile( )
--   file_functions.initialize( bind_funct, info_funct, position_funct, sets_funct)

require 'logger'
require 'tables'
config = require 'config'
files = require 'files'

file_functions = { }

-- Set to true to print logging messages to the lua.log file in the addon directory
file_functions.print_to_log = true

file_functions.file_data = { }

-- Used to check that the settings.xml file exists
-- Inputs
--   None
-- Returns
--   true if the file exists; false if the file does not exist
function file_functions.checkSettingFileExists( )

  local f = io.open( windower.addon_path..'data/settings.xml')
  if( f == nil) then
    return false
  end
  return true
end
-- Used to read settings.xml file and load the data for use
-- Inputs
--   None
-- Returns
--   None
function file_functions.readSettingFile( )
  local f = config.load()
  
	local num = 1
  local data_sets = f.trust_sets
  local bind_sets = f.binds
  local trust_1_data
  local trust_2_data
  local trust_3_data
  local trust_4_data
  local trust_5_data
  local name
	local empty_table = { }
  
  file_functions.file_data = { }
  file_functions.file_data.trust_sets = { }
  file_functions.file_data.binds_sets = { }
  
	file_functions.file_data.trust_sets.set_order = { }
  file_functions.file_data.trust_sets.num_sets = 0

  -- trust_sets =
  -- { 
		-- set_order =
		-- {
			-- name1,
			-- name2,
			-- etc...
		-- }
    -- name =
    -- {
      -- trust_1 =
      -- {
        -- position,
        -- size,
        -- trust =
        -- {
          -- trust_1
        -- },
      -- }, { position, size, trust}
      -- trust_2 =
      -- {
        -- position,
        -- size,
        -- trust =
        -- {
          -- trust_2
        -- },
      -- }, { position, size, trust}
      -- trust_3 =
      -- {
        -- position,
        -- size,
        -- trust =
        -- {
          -- trust_3
        -- },
      -- }, { position, size, trust}
      -- trust_4 =
      -- {
        -- position,
        -- size,
        -- trust =
        -- {
          -- trust_4
        -- },
      -- }, { position, size, trust}
      -- trust_5 =
      -- {
        -- position,
        -- size,
        -- trust = {
          -- trust_5
        -- },
      -- }, { position, size, trust}
    -- }. { trust_1, trust_2, trust_3, trust_4, trust_5}
  -- }
  
  for id, set_data in pairs( data_sets) do
    name = set_data.name:lower()
    file_functions.file_data.trust_sets[ name] = { }
		
		if( type( set_data.trust_1) == 'string') then
			trust_1_data = file_functions.getTrustSetInfo( set_data.trust_1)
		else
			trust_1_data = file_functions.getTrustSetInfo( nil)
		end
		if( type( set_data.trust_2) == 'string') then
			trust_2_data = file_functions.getTrustSetInfo( set_data.trust_2)
		else
			trust_2_data = file_functions.getTrustSetInfo( nil)
		end
		if( type( set_data.trust_3) == 'string') then
			trust_3_data = file_functions.getTrustSetInfo( set_data.trust_3)
		else
			trust_3_data = file_functions.getTrustSetInfo( nil)
		end
		if( type( set_data.trust_4) == 'string') then
			trust_4_data = file_functions.getTrustSetInfo( set_data.trust_4)
		else
			trust_4_data = file_functions.getTrustSetInfo( nil)
		end
		if( type( set_data.trust_5) == 'string') then
			trust_5_data = file_functions.getTrustSetInfo( set_data.trust_5)
		else
			trust_5_data = file_functions.getTrustSetInfo( nil)
		end
    file_functions.file_data.trust_sets[ name].trust_1 = trust_1_data
    file_functions.file_data.trust_sets[ name].trust_2 = trust_2_data
    file_functions.file_data.trust_sets[ name].trust_3 = trust_3_data
    file_functions.file_data.trust_sets[ name].trust_4 = trust_4_data
    file_functions.file_data.trust_sets[ name].trust_5 = trust_5_data
		file_functions.file_data.trust_sets.set_order[ set_data.order_position] = name
    file_functions.file_data.trust_sets.num_sets = file_functions.file_data.trust_sets.num_sets + 1
  end
 
  -- binds =
  -- { 
    -- cycle_set_bind,
    -- display_set_bind,
    -- cast_all_bind,
    -- dismiss_all_bind,
    -- echo,
    -- help_bind
    -- trust_1 =
    -- {
      -- cast_bind,
      -- dismiss_bind,
      -- cycle_bind,
      -- display_bind,
    -- }, { cast_bind, dismiss_bind, cycle_bind, display_bind}
    -- trust_2 =
    -- {
      -- cast_bind,
      -- dismiss_bind,
      -- cycle_bind,
      -- display_bind,
    -- }, { cast_bind, dismiss_bind, cycle_bind, display_bind}
    -- trust_3 =
      -- cast_bind,
      -- dismiss_bind,
      -- cycle_bind,
      -- display_bind,
    -- }, { cast_bind, dismiss_bind, cycle_bind, display_bind}
    -- trust_4 =
      -- cast_bind,
      -- dismiss_bind,
      -- cycle_bind,
      -- display_bind,
    -- }, { cast_bind, dismiss_bind, cycle_bind, display_bind}
    -- trust_5 =
      -- cast_bind,
      -- dismiss_bind,
      -- cycle_bind,
      -- display_bind,
    -- }, { cast_bind, dismiss_bind, cycle_bind, display_bind}
  -- }. { cycle_set_bind, display_set_bind, cast_all_bind, dismiss_all_bind, echo, help_bind, trust_1, trust_2, trust_3, trust_4, trust_5}
  
	file_functions.file_data.binds_sets.cycle_set_bind = bind_sets.cycle_set_bind
	file_functions.file_data.binds_sets.display_set_bind = bind_sets.display_set_bind
	file_functions.file_data.binds_sets.cast_all_bind = bind_sets.cast_all_bind
	file_functions.file_data.binds_sets.dismiss_all_bind = bind_sets.dismiss_all_bind
	file_functions.file_data.binds_sets.echo = bind_sets.echo
	file_functions.file_data.binds_sets.help_bind = bind_sets.help_bind

	file_functions.file_data.binds_sets.trust_1 = { }
	file_functions.file_data.binds_sets.trust_1.cast_bind = bind_sets.trust_1.cast_bind
	file_functions.file_data.binds_sets.trust_1.dismiss_bind = bind_sets.trust_1.dismiss_bind
	file_functions.file_data.binds_sets.trust_1.cycle_bind = bind_sets.trust_1.cycle_bind
	file_functions.file_data.binds_sets.trust_1.display_bind = bind_sets.trust_1.display_bind

	file_functions.file_data.binds_sets.trust_2 = { }
	file_functions.file_data.binds_sets.trust_2.cast_bind = bind_sets.trust_2.cast_bind
	file_functions.file_data.binds_sets.trust_2.dismiss_bind = bind_sets.trust_2.dismiss_bind
	file_functions.file_data.binds_sets.trust_2.cycle_bind = bind_sets.trust_2.cycle_bind
	file_functions.file_data.binds_sets.trust_2.display_bind = bind_sets.trust_2.display_bind

	file_functions.file_data.binds_sets.trust_3 = { }
	file_functions.file_data.binds_sets.trust_3.cast_bind = bind_sets.trust_3.cast_bind
	file_functions.file_data.binds_sets.trust_3.dismiss_bind = bind_sets.trust_3.dismiss_bind
	file_functions.file_data.binds_sets.trust_3.cycle_bind = bind_sets.trust_3.cycle_bind
	file_functions.file_data.binds_sets.trust_3.display_bind = bind_sets.trust_3.display_bind

	file_functions.file_data.binds_sets.trust_4 = { }
	file_functions.file_data.binds_sets.trust_4.cast_bind = bind_sets.trust_4.cast_bind
	file_functions.file_data.binds_sets.trust_4.dismiss_bind = bind_sets.trust_4.dismiss_bind
	file_functions.file_data.binds_sets.trust_4.cycle_bind = bind_sets.trust_4.cycle_bind
	file_functions.file_data.binds_sets.trust_4.display_bind = bind_sets.trust_4.display_bind

	file_functions.file_data.binds_sets.trust_5 = { }
	file_functions.file_data.binds_sets.trust_5.cast_bind = bind_sets.trust_5.cast_bind
	file_functions.file_data.binds_sets.trust_5.dismiss_bind = bind_sets.trust_5.dismiss_bind
	file_functions.file_data.binds_sets.trust_5.cycle_bind = bind_sets.trust_5.cycle_bind
	file_functions.file_data.binds_sets.trust_5.display_bind = bind_sets.trust_5.display_bind
  
  return file_functions.file_data
end
-- Used to parse a single set position string into a list of trusts to use
-- Inputs
--   input_str: ( REQUIRED) input string to parse
-- Returns
--   set_info: table containing the trust names
function file_functions.getTrustSetInfo( input_str)

	local set_info = { }
  local trusts = { }
  local data = input_str
  local start_pos
  local stop_pos
  local num = 1
  local name
  
  if( input_str == nil) then
    set_info.position = 0
    set_info.size = 0
    set_info.trust = trust
  else
    -- {
      -- position,
      -- size,
      -- trust =
      -- {
        -- trust_names
      -- },
    -- }, { position, size, trust}
    
    -- Remove all spaces from the input
    data = data:gsub(' ', '')
    -- Convert the enntire string to lowercase
    data = data:lower()

    start_pos, stop_pos = string.find( data, ',')
    while( start_pos ~= nil) do
      trusts[ num] = string.sub( data, 1, ( start_pos - 1))
      num = num + 1
      data = string.sub( data, ( stop_pos + 1), -1)
      start_pos, stop_pos = string.find( data, ',')
    end
    trusts[ num] = data
    
    set_info.position = 1
    set_info.size = num
    set_info.trust = trusts
  end
  
	return set_info
end
-- Used to update the settings.xml file with new set data information
-- Inputs
--   set_data: ( REQUIRED) new set data
-- Returns
--   None
function file_functions.writeSetData( set_data)
  file_functions.file_data.trust_sets = set_data
  file_functions.writeSettingFile()
end
-- Used to update the settings.xml file with new bind information
-- Inputs
--   bind_data: ( REQUIRED) new bind data
-- Returns
--   None
function file_functions.writeBindData( bind_data)
  file_functions.file_data.binds_sets = bind_data
  file_functions.writeSettingFile()
end
-- Used to write/update the settings.xml file
-- Inputs
--   None
-- Returns
--   None
function file_functions.writeSettingFile( )
  local f
	local num_sets = 0
	local set_name
	local set_data
	local msg_str
  local trust_sets = file_functions.file_data.trust_sets
  local binds = file_functions.file_data.binds_sets

	-- if( f ~= nil) then
		-- print( 'file_functions.writeDefaultSettingFile: File Already Exists')
		-- return
	-- end
	
	f = io.open( windower.addon_path..'data/settings.xml', 'w')

  f:write('<?xml version="1.1" ?>\n')
  f:write('<settings>\n')
  f:write('  <global>\n')
  f:write('    <!-- ~~~~~~ Trust Set List ~~~~~ -->\n')
  f:write('    <!-- Titles for sets of trusts that can be used under different situations -->\n')
  f:write('    <!-- Any string may be used as a title of a trust set; separate each title with a comma (,) -->\n')
  f:write('    <!--   Example: RDM, SAM, THF -->\n')
  f:write('    <!-- ** base-set is assumed to exist so it does not need to be included in the trust_set list ** -->\n')
  f:write('    <trust_sets>\n')
  f:write('      <!-- ~~~~~~ Trust Sets ~~~~~ -->\n')

  for id in pairs( trust_sets.set_order) do
		num_sets = num_sets + 1
	end
	
	for num = 1, num_sets, 1 do
		set_name = trust_sets.set_order[ num]
		set_data = trust_sets[ set_name]
		
		if( set_data ~= nil) then
			if( set_name == 'base_set') then
				f:write('      <!-- ~~~~~~ Base Set Trust Set ~~~~~ -->\n')
				f:write('      <!-- ** Must include the "base-set", all other sets are optional ** -->\n')
				f:write('      <base_set>\n')
			else
				f:write('      <!-- ~~~~~~ ' .. set_name:upper() .. ' Trust Set ~~~~~ -->\n')
				f:write('      <' .. set_name:lower() .. '>\n')
			end
			f:write('        <!-- Order Position -->\n')
			f:write('        <order_position>' .. num .. '</order_position>\n')
			f:write('        <!-- Set name -->\n')
			f:write('        <name>' .. set_name:lower() .. '</name>\n')
			f:write('        <!-- Trust position #1 -->\n')
			f:write('        <trust_1>\n')
			if( set_data.trust_1.size > 0) then
				msg = ''
				for trust_num = 1, set_data.trust_1.size, 1 do
					if( trust_num == 1) then
						msg_str = set_data.trust_1.trust[ trust_num]
					else
						msg_str = msg_str .. ', ' .. set_data.trust_1.trust[ trust_num]
					end
				end
				f:write('          ' .. msg_str:lower() .. '\n')
			end
			f:write('        </trust_1>\n')
			f:write('        <!-- Trust position #2 -->\n')
			f:write('        <trust_2>\n')
			if( set_data.trust_2.size > 0) then
				msg = ''
				for trust_num = 1, set_data.trust_2.size, 1 do
					if( trust_num == 1) then
						msg_str = set_data.trust_2.trust[ trust_num]
					else
						msg_str = msg_str .. ', ' .. set_data.trust_2.trust[ trust_num]
					end
				end
				f:write('          ' .. msg_str:lower() .. '\n')
			end
			f:write('        </trust_2>\n')
			f:write('        <!-- Trust position #3 -->\n')
			f:write('        <trust_3>\n')
			if( set_data.trust_3.size > 0) then
				msg = ''
				for trust_num = 1, set_data.trust_3.size, 1 do
					if( trust_num == 1) then
						msg_str = set_data.trust_3.trust[ trust_num]
					else
						msg_str = msg_str .. ', ' .. set_data.trust_3.trust[ trust_num]
					end
				end
				f:write('          ' .. msg_str:lower() .. '\n')
			end
			f:write('        </trust_3>\n')
			f:write('        <!-- Trust position #4 -->\n')
			f:write('        <trust_4>\n')
			if( set_data.trust_4.size > 0) then
				msg = ''
				for trust_num = 1, set_data.trust_4.size, 1 do
					if( trust_num == 1) then
						msg_str = set_data.trust_4.trust[ trust_num]
					else
						msg_str = msg_str .. ', ' .. set_data.trust_4.trust[ trust_num]
					end
				end
				f:write('          ' .. msg_str:lower() .. '\n')
			end
			f:write('        </trust_4>\n')
			f:write('        <!-- Trust position #5 -->\n')
			f:write('        <trust_5>\n')
			if( set_data.trust_5.size > 0) then
				msg = ''
				for trust_num = 1, set_data.trust_5.size, 1 do
					if( trust_num == 1) then
						msg_str = set_data.trust_5.trust[ trust_num]
					else
						msg_str = msg_str .. ', ' .. set_data.trust_5.trust[ trust_num]
					end
				end
				f:write('          ' .. msg_str:lower() .. '\n')
			end
			f:write('        </trust_5>\n')
			f:write('      </' .. set_name:lower() .. '>\n')
		end
  end
  f:write('    </trust_sets>\n')
  f:write('    <!-- ~~~~~~ Trust Binds ~~~~~ -->\n')
  f:write('    <!-- Bind Information -->\n')
  f:write('    <!-- Binds used to control the TrustHelper Addon -->\n')
  f:write('    <!-- ** All binds are in the windower format ** -->\n')
  f:write('    <binds>\n')
  f:write('      <!-- Trust position #1 binds -->\n')
  f:write('      <trust_1>\n')
  f:write('        <cast_bind>' .. binds.trust_1.cast_bind .. '</cast_bind>\n')
  f:write('        <dismiss_bind>' .. binds.trust_1.dismiss_bind .. '</dismiss_bind>\n')
  f:write('        <cycle_bind>' .. binds.trust_1.cycle_bind .. '</cycle_bind>\n')
  f:write('        <display_bind>' .. binds.trust_1.display_bind .. '</display_bind>\n')
  f:write('      </trust_1>\n')
  f:write('      <!-- Trust position #2 binds -->\n')
  f:write('      <trust_2>\n')
  f:write('        <cast_bind>' .. binds.trust_2.cast_bind .. '</cast_bind>\n')
  f:write('        <dismiss_bind>' .. binds.trust_2.dismiss_bind .. '</dismiss_bind>\n')
  f:write('        <cycle_bind>' .. binds.trust_2.cycle_bind .. '</cycle_bind>\n')
  f:write('        <display_bind>' .. binds.trust_2.display_bind .. '</display_bind>\n')
  f:write('      </trust_2>\n')
  f:write('      <!-- Trust position #3 binds -->\n')
  f:write('      <trust_3>\n')
  f:write('        <cast_bind>' .. binds.trust_3.cast_bind .. '</cast_bind>\n')
  f:write('        <dismiss_bind>' .. binds.trust_3.dismiss_bind .. '</dismiss_bind>\n')
  f:write('        <cycle_bind>' .. binds.trust_3.cycle_bind .. '</cycle_bind>\n')
  f:write('        <display_bind>' .. binds.trust_3.display_bind .. '</display_bind>\n')
  f:write('      </trust_3>\n')
  f:write('      <!-- Trust position #4 binds -->\n')
  f:write('      <trust_4>\n')
  f:write('        <cast_bind>' .. binds.trust_4.cast_bind .. '</cast_bind>\n')
  f:write('        <dismiss_bind>' .. binds.trust_4.dismiss_bind .. '</dismiss_bind>\n')
  f:write('        <cycle_bind>' .. binds.trust_4.cycle_bind .. '</cycle_bind>\n')
  f:write('        <display_bind>' .. binds.trust_4.display_bind .. '</display_bind>\n')
  f:write('      </trust_4>\n')
  f:write('      <!-- Trust position #5 binds -->\n')
  f:write('      <trust_5>\n')
  f:write('        <cast_bind>' .. binds.trust_5.cast_bind .. '</cast_bind>\n')
  f:write('        <dismiss_bind>' .. binds.trust_5.dismiss_bind .. '</dismiss_bind>\n')
  f:write('        <cycle_bind>' .. binds.trust_5.cycle_bind .. '</cycle_bind>\n')
  f:write('        <display_bind>' .. binds.trust_5.display_bind .. '</display_bind>\n')
  f:write('      </trust_5>\n')
  f:write('      <!-- Cycle Set Bind -->\n')
  f:write('      <!-- ** May be set to nil if no bind is to be loaded ** -->\n')
  f:write('      <cycle_set_bind>' .. binds.cycle_set_bind .. '</cycle_set_bind>\n')
  f:write('      <!-- Display Set Bind -->\n')
  f:write('      <!-- Used to trigger TrustHelper to display the currently loaded trust set -->\n')
  f:write('      <!-- ** May be set to nil if no bind is to be loaded ** -->\n')
  f:write('      <display_set_bind>' .. binds.display_set_bind .. '</display_set_bind>\n')
  f:write('      <!-- Cast All Bind -->\n')
  f:write('      <!-- Used to trigger TrustHelper to cast all possible trusts in the proper trust order -->\n')
  f:write('      <!-- ** May be set to nil if no bind is to be loaded ** -->\n')
  f:write('      <cast_all_bind>' .. binds.cast_all_bind .. '</cast_all_bind>\n')
  f:write('      <!-- Dismiss All Bind -->\n')
  f:write('      <!-- Used to trigger TrustHelper to dismiss all summoned trusts -->\n')
  f:write('      <!-- ** May be set to nil if no bind is to be loaded ** -->\n')
  f:write('      <dismiss_all_bind>' .. binds.dismiss_all_bind .. '</dismiss_all_bind>\n')
  f:write('      <!-- Echo Bind -->\n')
  f:write('      <!-- Causes TrustHelper to send an echo to the players chat window whenever a TrustHelper command is triggered -->\n')
  f:write('      <!-- ** May be set to nil if no bind is to be loaded ** -->\n')
	if( binds.echo == true) then
		f:write('      <echo>true</echo>\n')
	else
		f:write('      <echo>false</echo>\n')
	end
  f:write('      <!-- Help Bind -->\n')
  f:write('      <!-- Causes TrustHelper to send an echo to the players chat window containing all possible TrustHelper commands -->\n')
  f:write('      <!-- ** May be set to nil if no bind is to be loaded ** -->\n')
  f:write('      <help_bind>' .. binds.help_bind .. '</help_bind>\n')
  f:write('    </binds>\n')
  f:write('  </global>\n')
  f:write('</settings>\n')

	f:close()
end
-- Used to write a default version of settings.xml file
-- Inputs
--   None
-- Returns
--   None
function file_functions.writeDefaultSettingFile( )
  local f = io.open( windower.addon_path..'data/settings.xml')

	if( f ~= nil) then
		print( 'file_functions.writeDefaultSettingFile: File Already Exists')
		return
	end
	
	f = io.open( windower.addon_path..'data/settings.xml', 'w')

  f:write('<?xml version="1.1" ?>\n')
  f:write('<settings>\n')
  f:write('  <global>\n')
  f:write('    <!-- ~~~~~~ Trust Set List ~~~~~ -->\n')
  f:write('    <!-- Titles for sets of trusts that can be used under different situations -->\n')
  f:write('    <!-- Any string may be used as a title of a trust set; separate each title with a comma (,) -->\n')
  f:write('    <!--   Example: rdm, sam, thf -->\n')
  f:write('    <!-- ** base-set is assumed to exist so it does not need to be included in the trust_set list ** -->\n')
  f:write('    <trust_sets>\n')
  f:write('      <!-- ~~~~~~ Trust Sets ~~~~~ -->\n')
  f:write('      <!-- ~~~~~~ Base Set Trust Set ~~~~~ -->\n')
  f:write('      <!-- ** Must include the "base-set", all other sets are optional ** -->\n')
  f:write('      <base_set>\n')
  f:write('        <!-- Order Position -->\n')
  f:write('        <order_position>1</order_position>\n')
  f:write('        <!-- Set name -->\n')
  f:write('        <name>base_set</name>\n')
  f:write('        <!-- Trust position #1 -->\n')
  f:write('        <trust_1>\n')
  f:write('        </trust_1>\n')
  f:write('        <!-- Trust position #2 -->\n')
  f:write('        <trust_2>\n')
  f:write('        </trust_2>\n')
  f:write('        <!-- Trust position #3 -->\n')
  f:write('        <trust_3>\n')
  f:write('        </trust_3>\n')
  f:write('        <!-- Trust position #4 -->\n')
  f:write('        <trust_4>\n')
  f:write('        </trust_4>\n')
  f:write('        <!-- Trust position #5 -->\n')
  f:write('        <trust_5>\n')
  f:write('        </trust_5>\n')
  f:write('      </base_set>\n')
  f:write('    </trust_sets>\n')
  f:write('    <!-- ~~~~~~ Trust Binds ~~~~~ -->\n')
  f:write('    <!-- Bind Information -->\n')
  f:write('    <!-- Binds used to control the TrustHelper Addon -->\n')
  f:write('    <!-- ** All binds are in the windower format ** -->\n')
  f:write('    <binds>\n')
  f:write('      <!-- Trust position #1 binds -->\n')
  f:write('      <trust_1>\n')
  f:write('        <cast_bind>nil</cast_bind>\n')
  f:write('        <dismiss_bind>nil</dismiss_bind>\n')
  f:write('        <cycle_bind>nil</cycle_bind>\n')
  f:write('        <display_bind>nil</display_bind>')
  f:write('      </trust_1>\n')
  f:write('      <!-- Trust position #2 binds -->\n')
  f:write('      <trust_2>\n')
  f:write('        <cast_bind>nil</cast_bind>\n')
  f:write('        <dismiss_bind>nil</dismiss_bind>\n')
  f:write('        <cycle_bind>nil</cycle_bind>\n')
  f:write('        <display_bind>nil</display_bind>')
  f:write('      </trust_2>\n')
  f:write('      <!-- Trust position #3 binds -->\n')
  f:write('      <trust_3>\n')
  f:write('        <cast_bind>nil</cast_bind>\n')
  f:write('        <dismiss_bind>nil</dismiss_bind>\n')
  f:write('        <cycle_bind>nil</cycle_bind>\n')
  f:write('        <display_bind>nil</display_bind>')
  f:write('      </trust_3>\n')
  f:write('      <!-- Trust position #4 binds -->\n')
  f:write('      <trust_4>\n')
  f:write('        <cast_bind>nil</cast_bind>\n')
  f:write('        <dismiss_bind>nil</dismiss_bind>\n')
  f:write('        <cycle_bind>nil</cycle_bind>\n')
  f:write('        <display_bind>nil</display_bind>')
  f:write('      </trust_4>\n')
  f:write('      <!-- Trust position #5 binds -->\n')
  f:write('      <trust_5>\n')
  f:write('        <cast_bind>nil</cast_bind>\n')
  f:write('        <dismiss_bind>nil</dismiss_bind>\n')
  f:write('        <cycle_bind>nil</cycle_bind>\n')
  f:write('        <display_bind>nil</display_bind>')
  f:write('      </trust_5>\n')
  f:write('      <!-- Cycle Set Bind -->\n')
  f:write('      <!-- ** May be set to nil if no bind is to be loaded ** -->\n')
  f:write('      <cycle_set_bind>nil</cycle_set_bind>\n')
  f:write('      <!-- Display Set Bind -->')
  f:write('      <!-- Used to trigger TrustHelper to display the currently loaded trust set -->')
  f:write('      <!-- ** May be set to nil if no bind is to be loaded ** -->')
  f:write('      <display_set_bind>nil</display_set_bind>')
  f:write('      <!-- Cast All Bind -->\n')
  f:write('      <!-- Used to trigger TrustHelper to cast all possible trusts in the proper trust order -->\n')
  f:write('      <!-- ** May be set to nil if no bind is to be loaded ** -->\n')
  f:write('      <cast_all_bind>nil</cast_all_bind>\n')
  f:write('      <!-- Dismiss All Bind -->\n')
  f:write('      <!-- Used to trigger TrustHelper to dismiss all summoned trusts -->\n')
  f:write('      <!-- ** May be set to nil if no bind is to be loaded ** -->\n')
  f:write('      <dismiss_all_bind>nil</dismiss_all_bind>\n')
  f:write('      <!-- Echo Bind -->\n')
  f:write('      <!-- Causes TrustHelper to send an echo to the players chat window whenever a TrustHelper command is triggered -->\n')
  f:write('      <!-- ** May be set to nil if no bind is to be loaded ** -->\n')
  f:write('      <echo>true</echo>\n')
  f:write('      <!-- Help Bind -->\n')
  f:write('      <!-- Causes TrustHelper to send an echo to the players chat window containing all possible TrustHelper commands -->\n')
  f:write('      <!-- ** May be set to nil if no bind is to be loaded ** -->\n')
  f:write('      <help_bind>!q</help_bind>\n')
  f:write('    </binds>\n')
  f:write('  </global>\n')
  f:write('</settings>\n')

	f:close()
end

return file_functions
