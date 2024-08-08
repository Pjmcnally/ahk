#IfWinActive, Melvor Idle
^1::melvor.KeepAwake()
^2::melvor.RandomClick()
^Space::melvor.ToggleFastClick(true, 250)
^!Space::melvor.ToggleFastClick(false, 250)

^g::Send, % "game.gp.add()"
^i::Send, % "game.bank.addItemByID('" . Trim(CLIPBOARD) . "', , true, true, false){Left 20}"
^p::Send, % "game.petManager.unlockPetByID('" . Trim(CLIPBOARD) . "');"
^t::Send, % "game.testForOffline(){Left 1}"
#IfWinActive ; End #IfWinActive

/*
For discovering marks
for (let i = 0; i < 61; i += 1) {game.summoning.discoverMark(game.summoning.actions.getObjectByID('melvorTotH:LightningSpirit'));}
*/
