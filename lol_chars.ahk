; This is a script I was expirimenting with to help me limit my champion pool 
; in LoL.  I never finished it fully.

#IfWinActive ahk_class ApolloRuntimeContentWindow
; first letter is position 
; j = Jungle
; s = Support
; a = ADC
; t = Top
; m = Mid

; Second letter is which list
; l = learning
; g = good
; 1, 2, and 3 pull from tier list


;Mids are in this section
::ml::

::mg::

::m1::
   Clipboard = ^Ahri$|^Annie$|^Talon$
   send ^v
return

::m2::
   Clipboard = ^Malzahar$|^Morgana$|^Twisted Fate$|^Viktor$|^Diana$|^Cho'Gath$|^Lux$|^Anivia$|^Swain$|^Brand$|^Heimerdinger$|^Vel'Koz$|^Lissandra$|^Karthus$|^Wukong$|^Mordekaiser$|^Yasuo$|^Fizz$
   send ^v
return

::m3::
   Clipboard = ^Katarina$|^Lulu (AP)$|^Ziggs$|^Vladimir$|^Zed$|^Kayle$|^Galio$|^Kog'maw (AP)$|^Varus$|^Orianna$|^Xerath$|^Kennen$|^Karma$|^Pantheon$|^Zyra$|^Nidalee$|^Cassiopeia$|^Corki$
   send ^v
return

::ma::
   Clipboard = ^Ahri$|^Annie$|^Talon$|^Malzahar$|^Morgana$|^Twisted Fate$|^Viktor$|^Diana$|^Cho'Gath$|^Lux$|^Anivia$|^Swain$|^Brand$|^Heimerdinger$|^Vel'Koz$|^Lissandra$|^Karthus$|^Wukong$|^Mordekaiser$|^Yasuo$|^Fizz$|^Katarina$|^Lulu (AP)$|^Ziggs$|^Vladimir$|^Zed$|^Kayle$|^Galio$|^Kog'maw (AP)$|^Varus$|^Orianna$|^Xerath$|^Kennen$|^Karma$|^Pantheon$|^Zyra$|^Nidalee$|^Cassiopeia$|^Corki$
   send ^v
return


;Junglers go in this section
::jl::
   Clipboard = ^Elise$|^Vi$|^Diana$|^Nidalee$|^Shyvana$
   send ^v
return

::jg::
   Clipboard = ^Amumu$|^Xin Zhao$|^Kayle$|^Warwick$|^Elise$
   send ^v
return

::j1::
   Clipboard = ^Skarner$|^Kayle$|^Xin Zhao$|^Warwick$|^Elise$
   send ^v
return

::j2::
   Clipboard = ^Diana$|^Amumu$|^Shyvana$|^Udyr$|^Nocturne$|^Jax$|^Fizz$|^Aatrox$|^Vi$|^Ekko$|^Rammus$|^Pantheon$|^Sion,Wukong$|^Evelynn$|^Volibear$
   send ^v
return

::j3::
   Clipboard = ^Rek'Sai$|^Master Yi$|^Hecarim$|^Nidalee$|^Nunu$|^Nautilus$|^Shaco$|^Maokai$|^Jarvan IV$|^Sejuani$|^Rengar$|^Gragas$|^Fiddlesticks$|^Lee Sin$|^Trundle$|^Cho'Gath$|^Poppy$|^Irelia$|^Kha'Zix$|^Malphite$
   send ^v
return

::ja::
   Clipboard = ^Skarner$|^Kayle$|^Xin Zhao$|^Warwick$|^Elise$|^Diana$|^Amumu$|^Shyvana$|^Udyr$|^Nocturne$|^Jax$|^Fizz$|^Aatrox$|^Vi$|^Ekko$|^Rammus$|^Pantheon$|^Sion,Wukong$|^Evelynn$|^Volibear$|^Rek'Sai$|^Master Yi$|^Hecarim$|^Nidalee$|^Nunu$|^Nautilus$|^Shaco$|^Maokai$|^Jarvan IV$|^Sejuani$|^Rengar$|^Gragas$|^Fiddlesticks$|^Lee Sin$|^Trundle$|^Cho'Gath$|^Poppy$|^Irelia$|^Kha'Zix$|^Malphite$
   send ^v
return


;ADCs go in this section
::al::

::ag::

::a1::
   Clipboard = ^Sivir$|^Jinx$
   send ^v
return

::a2::
   Clipboard = ^Ashe$|^Vayne$|^Draven$
   send ^v
return

::a3::
   Clipboard = ^Miss Fortune$|^Corki$|^Varus$|^Kalista$|^Kog'Maw$|^Caitlyn$|^Mordekaiser$|^Tristana$|^Graves$|^Ezreal$|^Twitch$|^Quinn$|^Lucian$
   send ^v
return

::aa::
   Clipboard = ^Sivir$|^Jinx$|^Ashe$|^Vayne$|^Draven$|^Miss Fortune$|^Corki$|^Varus$|^Kalista$|^Kog'Maw$|^Caitlyn$|^Mordekaiser$|^Tristana$|^Graves$|^Ezreal$|^Twitch$|^Quinn$|^Lucian$
   send ^v
return


;TOPs go in this section
::tl::

::tg::

::t1::
   Clipboard = ^Fiora$|^Wukong$|^Malphite$|^Irelia$
   send ^v
return

::t2::
   Clipboard = ^Riven$|^Gangplank$|^Tryndamere$|^Lissandra$|^Renekton$|^Shen$|^Vladimir$|^Rengar$|^Heimerdinger$|^Kennen$|^Cho'gath$|^Gnar$|^Hecarim$|^Jarvan IV$|^Nasus$|^Garen$|^Singed$|^Kayle$|^Diana$|^Swain$|^Aatrox$|^Yasuo$|^Fizz$
   send ^v
return

::t3::
   Clipboard = ^Rumble$|^Lulu$|^Rek'Sai$|^Pantheon$|^Sion$|^Nautilus$|^Cassiopeia$|^Akali$|^Poppy$|^Xin Zhao$|^Urgot$|^Morgana$|^Maokai$|^Darius$|^Yorick$|^Teemo$|^Karma$|^Malzahar$|^Nidalee$|^Jax$|^Quinn$|^Galio$|^Volibear$|^Warwick$|^Zed$|^Trundle$|^Udyr$|^Lee Sin$|^Gragas$|^Jayce$|^Olaf$|^Viktor$|^Kha'Zix$|^Vi$
   send ^v
return

::ta::
   Clipboard = ^Fiora$|^Wukong$|^Malphite$|^Irelia$|^Riven$|^Gangplank$|^Tryndamere$|^Lissandra$|^Renekton$|^Shen$|^Vladimir$|^Rengar$|^Heimerdinger$|^Kennen$|^Cho'gath$|^Gnar$|^Hecarim$|^Jarvan IV$|^Nasus$|^Garen$|^Singed$|^Kayle$|^Diana$|^Swain$|^Aatrox$|^Yasuo$|^Fizz$|^Rumble$|^Lulu$|^Rek'Sai$|^Pantheon$|^Sion$|^Nautilus$|^Cassiopeia$|^Akali$|^Poppy$|^Xin Zhao$|^Urgot$|^Morgana$|^Maokai$|^Darius$|^Yorick$|^Teemo$|^Karma$|^Malzahar$|^Nidalee$|^Jax$|^Quinn$|^Galio$|^Volibear$|^Warwick$|^Zed$|^Trundle$|^Udyr$|^Lee Sin$|^Gragas$|^Jayce$|^Olaf$|^Viktor$|^Kha'Zix$|^Vi$
   send ^v
return


;Supports go in this section
::sl::
   Clipboard = ^Blitzcrank$|^Thresh$|^Braum$
   send ^v
return

::sg::
   Clipboard = ^Leona$
   send ^v
return

::s1::
   Clipboard = ^Janna$|^Blitzcrank$|^Nautilus$
   send ^v
return

::s2::
   Clipboard = ^Soraka$|^Sona$|^Braum$|^Leona$|^Brand$|^Thresh$
   send ^v
return

::s3::
   Clipboard = ^Nami$|^Taric$|^Alistar$|^Lulu$|^Morgana$|^Zyra$|^Vel'Koz$|^Shen$|^Bard$|^Annie$|^Lux$|^Karma$|^Xerath$
   send ^v
return

::sa::
   Clipboard = ^Janna$|^Blitzcrank$|^Nautilus$|^Soraka$|^Sona$|^Leona$|^Brand$|^Braum$|^Thresh$|^Nami$|^Taric$|^Alistar$|^Lulu$|^Morgana$|^Zyra$|^Vel'Koz$|^Shen$|^Bard$|^Annie$|^Lux$|^Karma$|^Xerath$
   send ^v
return
