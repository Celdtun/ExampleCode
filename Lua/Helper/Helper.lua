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

_addon.name = 'Helper'
_addon.version = '00.00.01'
_addon.author = 'Celdtun'
_addon.language = 'English'
_addon.commands = { 'helper'}

-- Load command
--   Triggers on addon load.
function Load( )
	local player = windower.ffxi.get_player()
	if( player.name ~= nil) then
		Login( player.name)
	end
end
-- Login command
--   Triggers on login.
--   string name
function Login( name)
  windower.send_command( 'lua load InventoryConsolidate')
  windower.send_command( 'lua load RemoteCommand')
  windower.send_command( 'lua load Skillchains')
  windower.send_command( 'lua load TrustHelper')
  windower.send_command( 'lua load Debuffing')
end
-- Logout command
--   Triggers on logout.
--   string name
function Logout( name)
end
-- Unload command
--   Triggers on addon unload.
function Unload( )
end

-- Gain Buff command
--   Triggers on receiving a buff or debuff.
--   number buff_id
function GainBuff( buff_id)
end
-- Lose Buff command
--   Triggers on losing a buff or debuff.
--   number buff_id
function LoseBuff( buff_id)
end
-- Gain Experience command
--   Triggers on gaining any experience. limit is true, if the EXP gained were limit points.
--   number amount, number chain_number, bool limit
function GainXp( amount, chain_number, limit)
end
-- Lose Experience command
--   Triggers on losing any experience.
--   number amount
function LoseXp( amount)
end
-- Level Up command
--   Triggers on gaining a level.
--   number level
function LevelUp( level)
   windower.send_command( 'lua reload yush')
end
-- Level Down command
--   Triggers on losing a level.
--   number level
function LevelDown( level)
   windower.send_command( 'lua reload yush')
end
-- Job Change command
--   Triggers on job change. This will trigger on both main and sub job change.
--   number main_job_id, number main_job_level, number sub_job_id, number sub_job_level
function JobChange( main_job_id, main_job_level, sub_job_id, sub_job_level)
end
-- Target Change command
--   Triggers on target change.
--   number index
function TargetChange( index)
end
-- Weather Change command
--   Triggers on weather change.
--   number weather_id
function WeatherChange( weather_id)
end
-- Status Change command
--   Triggers on player status change. This only triggers for the following statuses: Idle, Engaged, Resting, Dead, Zoning
--   number new_status_id, number old_status_id
function StatusChange( new_status_id, old_status_id)
end
-- Party Invite command
--   Triggers on receiving a party or alliance invite.
--   string sender, number sender_id
function PartyInvite( sender, sender_id)
end
-- Time Change command
--   Triggers on time change. This only triggers when the displayed in-game time actually changes. Both arguments are the number of minutes since the beginning of the in-game day.
--   number new, number old
function TimeChange( new, old)
end
-- Day Change command
--   Triggers on day change.
--   number new_day, number old_day
function DayChange( new_day, old_day)
end
-- Zone Change command
--   Fires whenever the player is zoning. This includes logging in and logging out.
--   number new_id, number old_id
function ZoneChange( new_id, old_id)
end
-- Add Item command
--   Triggers whenever an item enters a bag (through trade, dropping from the treasure pool, NPC reward, moving it from another bag, etc.).
--   number bag, number index, number id, number count
function AddItem( bag, index, id, count)
end
-- Remove Item command
--   Triggers whenever an item leaves a bag (through trade, dropping it, usage, etc.).
--   number bag, number index, number id, number count
function RemoveItem( bag, index, id, count)
end
-- Incoming Text command
--   bool
--   string original, string modified, number original_mode, number modified_mode, bool blocked
function IncomingText( original, modified, original_mode, modified_mode, blocked)
end
-- Incoming Chunk command
--   bool
--   number id, string original, string modified, bool injected, bool blocked
function IncomingChunk( id, original, modified, injected, blocked)
end
-- Outgoing Text command
--   bool
--   string original, string modified, bool blocked
function OutgoingText( original, modified, blocked)
end
-- Outgoing Chunk command
--   bool
--   number id, string original, string modified, bool injected, bool blocked
function OutgoingChunk( id, original, modified, injected, blocked)
end
-- Addon Command command
--   Triggers on passing an addon command, which is any command of the form lua c <name>, where name is the addon name. (Everything after the command is passed to the function, not the command itself.)
--   string* ...
function AddonCommand( cmd)
end
-- Unhandled Command command
--   Triggers on Windower commands that weren't processed by any other plugin. (The entire line is passed to the function, including the command.)
--   string* ...
function UnhandledCommand( cmd)
end
-- Prerender command
--   Triggers before every rendering tick.
function Prerender( )
end
-- Postrender command
--   Triggers after every rendering tick.
function PostRender( )
end

-- Load command
windower.register_event( 'load', Load)
-- Login command
windower.register_event( 'login', Login)
-- Logout command
windower.register_event( 'logout', Logout)
-- Unload command
windower.register_event( 'unload', Unload)

-- Gain Buff command
windower.register_event( 'gain buff', GainBuff)
-- Lose Buff command
windower.register_event( 'lose buff', LoseBuff)
-- Gain Experience command
windower.register_event( 'gain experience', GainXp)
-- Lose Experience command
windower.register_event( 'lose experience', LoseXp)
-- Level Up command
windower.register_event( 'level up', LevelUp)
-- Level Down command
windower.register_event( 'level down', LevelDown)
-- Job Change command
windower.register_event( 'job change', JobChange)
-- Target Change command
windower.register_event( 'target change', TargetChange)
-- Weather Change command
windower.register_event( 'weather change', WeatherChange)
-- Status Change command
windower.register_event( 'status change', StatusChange)
-- Party Invite command
windower.register_event( 'party invite', PartyInvite)
-- Time Change command
windower.register_event( 'time change', TimeChange)
-- Day Change command
windower.register_event( 'day change', DayChange)
-- Zone Change command
windower.register_event( 'zone change', ZoneChange)
-- Add Item command
windower.register_event( 'add item', AddItem)
-- Remove Item command
windower.register_event( 'remove item', RemoveItem)
-- Incoming Text command
windower.register_event( 'incoming text', IncomingText)
-- Incoming Chunk command
windower.register_event( 'incoming chunk', IncomingChunk)
-- Outgoing Text command
windower.register_event( 'outgoing text', OutgoingText)
-- Outgoing Chunk command
windower.register_event( 'outgoing chunk', OutgoingChunk)
-- Addon Command command
windower.register_event( 'addon command', AddonCommand)
-- Unhandled Command command
windower.register_event( 'unhandled command', UnhandledCommand)
-- Prerender command
windower.register_event( 'prerender', Prerender)
-- Postrender command
windower.register_event( 'postrender', PostRender)

