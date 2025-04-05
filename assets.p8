pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

function player_gfx_controller(p)

 -- f,x,y,h,v
	local pickaxe_frames = {
	 [0] = { {6,8,0,false,false},{5,6,6,false,true},{4,0,8,false,true} },
	 [1] = { {4,0,-8,false,false},{5,6,-6,false,false},{6,8,0,false,false} },
	 [2] = { {6,-8,0,true,false},{5,-6,-6,true,false},{4,0,-8,true,false} },
	 [3] = { {4,0,-8,true,false},{5,-6,-6,true,false},{6,-8,0,true,false} },
	}

	local player_dir = 0
	local step_state = 0
	local step_timer = 0
	local pickaxe_frame_timer = 0
	local f = function()
	
		step_timer -= 1
		pickaxe_frame_timer -= pickaxe_frame_timer > 1 and 0.7 or 0.2
		if step_timer <= 0 then step_state = 0 else step_state = 16 end 
	
		if (btnp(⬇️)) player_dir = 0 step_timer = 6
		if (btnp(➡️)) player_dir = 1 step_timer = 6
		if (btnp(⬆️)) player_dir = 2 step_timer = 6
		if (btnp(⬅️)) player_dir = 3 step_timer = 6
	
		spr(player_dir+step_state,player.x, player.y)

		if pickaxe_frame_timer >= 0 then
			local animation_set = pickaxe_frames[player_dir]
			local pickaxe_animation_duration = 3
			local current_pickaxe_frame = ceil(pickaxe_animation_duration - pickaxe_frame_timer)
			local cpfd = animation_set[current_pickaxe_frame]

			if cpfd then
				spr(cpfd[1], player.x + cpfd[2], player.y + cpfd[3], 1,1, cpfd[4], cpfd[5])
			else
				print(cpfd)
				print(animation_set)
				print(current_pickaxe_frame)
			end
		end
	end
	
	local s = function() pickaxe_frame_timer = 3	end
	
	return f,s
	
end
__gfx__
000000000000000000000000000000000000000000000000000070000000000000200000000000000000000000000000000a7000000c7000000b700000087000
00a88a00000aa80000aaaa00008aa000007766000777600000000700000000000212000000000000000000000000000000aa770000cc770000bb770000887700
098778a0009a877009aaaaa00778aa0007666660000667000000067000200000211120220000000000000000000000000aaa77700ccc77700bbb777008887770
098668900099866009999990066899007002100600016660222226700212202211111211000000000000000000000000aaaa7777cccc7777bbbb777788887777
061771700067717006777770071777000002100000121660111116600111121111000181000000000000000000000000888899991111dddd5555333311112222
067777700067777006777770077777000002100001210060000006600111018110000181000000000000000000000000088899900111ddd00555333001112220
011111100011111001111110011111000002100012100060000006000110018100000011000000000000000000000000008899000011dd000055330000112200
09a009a0009a09a009a009a009a09a000002100021000000000060000100001100000000000000000000000000000000000890000001d0000005300000012000
000000000000000000aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000aa8009aaaaa008aa0000000000000000000000000000000158500000000000000000000000000000000000000000000000000000000000000000
00a88a000009a87709999990778aa000000000000000000000000000001555550001585000000000000000000000000000000000000000000000000000000000
098778a0000998660677777066899000000000000000000000000000001550d00015555500000000000000000000000000000000000000000000000000000000
0986689000067717067779a07177700000000000000000000000000000155400001550d000000000000000000000000000000000000000000000000000000000
0617717000a67777011119a077777a00000000000000000000000000000015400015450000000000000000000000000000000000000000000000000000000000
067777700099111109a0000011119900000000000000000000000000000154500155540000000000000000000000000000000000000000000000000000000000
09a111100000009a000000009a000000000000000000000000000000015555401555400000000000000000000000000000000000000000000000000000000000
00000000000000000007000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000007070007700077070000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000aaaa0000aaaa000070070000000000000000000000000000000000007777000077770000700700000000000000000000000000
0000000000000000000aa0000a9999a00a0000a00000000000000000000000000000000000077000077777700700007000000000000000000000000000000000
00000000000aa00000a99a00a990099aa000000a7000000700000000000000000007700000777700777007777000000770000007000000000000000000000000
0008800000a99a000a9009a0a900009aa000000a0000000000000000000770000077770007700770770000777000000700000000000000000000000000000000
0008800000a99a000a9009a0a900009aa000000a0000000000000000000770000077770007700770770000777000000700000000000000000000000000000000
00000000000aa00000a99a00a990099aa000000a7000000700000000000000000007700000777700777007777000000770000007000000000000000000000000
0000000000000000000aa0000a9999a00a0000a00000000000000000000000000000000000077000077777700700007000000000000000000000000000000000
00000000000000000000000000aaaa0000aaaa000070070000000000000000000000000000000000007777000077770000700700000000000000000000000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
100000011000000110000001101010100000000000000000000000000000000000000000000000000000000000000000000a7000000c7000000b700000087000
1d16d600121828000666666001010101000000000000000000000000000000000000000000000000000000000000000000aa770000cc770000bb770000887700
d1dd6d6121228281dd6666660000000000000000000000000000000000000000000000000000000000000000000000000aaa77700ccc77700bbb777008887770
1d1dd6d112122821ddd66666101010100000000000000000000000000000000000000000000000000000000000000000aaaa7777cccc7777bbbb777788887777
0000100000001000dddd6666000000000000000000000000000000000000000000000000000000000000000000000000888899991111dddd5555333311112222
1d6001dd12800122ddddd666000000000000000000000000000000000000000000000000000000000000000000000000088899900111ddd00555333001112220
d6d61d1d28281212dddddd66010001000000000000000000000000000000000000000000000000000000000000000000008899000011dd000055330000112200
6d6d11d1228211211dddddd1000000000000000000000000000000000000000000000000000000000000000000000000000890000001d0000005300000012000
10000001101111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08282820110111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20828282111111010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02082828111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20208282101111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02020828110111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20202080111111010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12020201111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10000001100000011000000110000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d6666600d6666600d6666600d666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
da766666dc766666db766666d8766666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d8966666d1d66666d5366666d1266666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddd6666dddd6666dddd6666dddd6666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddda76dddddc76dddddb76ddddd876000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddd896ddddd1d6ddddd536ddddd126000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1dddddd11dddddd11dddddd11dddddd1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
40400f400f0f4040400040000000404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040000040404040404000404000404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040000000404040400000000000404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040004040004040004040000000404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040000000000000000000400000404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040009191919191919191000000404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040919191919191919191919100404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040a0a0a0a0a0a0a0a0a0a0a0a0404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040a0a080a0909090a08282a0a0404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040808080a090a0a0828282a0a0404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040a0a0a0a0a0a0a0a0818181a0404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040a0a083838383a0a0a08181a0404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040a0a000000000a0a0a0a0a0a0404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040a0a0a0a0a0a0a0a0a0a0a0a0404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
