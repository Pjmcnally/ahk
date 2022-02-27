// This is not an AHK file I am just storing it here.

/*  This is my modified version of the function to re-role astrology modifier.
    It modifies the game so that re-rolls will will cost nothing and always roll 5%

    To use:
        Load the game in the browser and load this function in though the console.
        Then use the normal in game buttons to re-role astrology.
*/
function rerollSpecificAstrologyModifier(id, i, applySingleCost = false, confirmed = true, bypass = false) {
    let renderUIUpdate = false; if (!canRerollModifier(id, i)) { notifyPlayer(CONSTANTS.skill.Astrology, "Oi, it's locked. What are you doing?", "danger"); return; } else if (false && checkIfAnyMaxRolls(id, "", i) && !bypass) confirmed = false; if (!confirmed && SETTINGS.general.showAstrologyMaxRollConfirmation) { SwalLocale.fire({ title: getLangString("MENU_TEXT", "MAX_ROLL_DETECTED"), html: `<h5 class="font-w600 mb-1">${getLangString("MENU_TEXT", "REROLL_CONFIRM")}</h5>`, showCancelButton: true, icon: "warning", confirmButtonText: getLangString("MENU_TEXT", "REROLL"), }).then((result) => { if (result.value) { rerollSpecificAstrologyModifier(id, i, applySingleCost, true, true); } }); } else {
        if (applySingleCost) { if (i % 2 === 0) { if (getBankQty(CONSTANTS.item.Stardust) < getSingleStardustCost()) { notifyPlayer(CONSTANTS.skill.Astrology, templateString(getLangString("ASTROLOGY", "MISC_4"), { itemName: items[CONSTANTS.item.Stardust].name }), "danger"); return; } else { renderUIUpdate = true; } } else { if (getBankQty(CONSTANTS.item.Golden_Stardust) < getSingleGoldenStardustCost()) { notifyPlayer(CONSTANTS.skill.Astrology, templateString(getLangString("ASTROLOGY", "MISC_4"), { itemName: items[CONSTANTS.item.Golden_Stardust].name }), "danger"); return; } else { renderUIUpdate = true; } } }
        delete activeAstrologyModifiers[id][i]; activeAstrologyModifiers[id][i] = {}; const valueRoll = Math.random() * 100; let value = 5;
        if (value === 1) game.stats.Astrology.inc(AstrologyStats.MinRollsHit); else if (value === 5) game.stats.Astrology.inc(AstrologyStats.MaxRollsHit); let randomSkill = ASTROLOGY[id].skills[Math.floor(Math.random() * ASTROLOGY[id].skills.length)]; let modifierList; let modValue; if (i % 2 !== 0) { modifierList = JSON.parse(JSON.stringify(ASTROLOGY[id].uniqueModifiers)); game.stats.Astrology.inc(AstrologyStats.UniqueRerolls); } else {
            modifierList = JSON.parse(JSON.stringify(AstrologyDefaults.standardAstrologyModifierList)); game.stats.Astrology.inc(AstrologyStats.StandardRerolls); if (!SKILLS[randomSkill].hasMastery) {
                let modsToRemove = []; for (let i = 0; i < modifierList.length; i++) { if (!modifierData[modifierList[i]].isCombatModifier && modifierList[i] !== "increasedSkillXP") modsToRemove.push(modifierList[i]); }
                if (randomSkill === Skills.Hitpoints || randomSkill === Skills.Slayer || randomSkill === Skills.Prayer) { modsToRemove.push("increasedHiddenSkillLevel"); if (randomSkill === Skills.Slayer) modifierList.push("increasedSlayerCoins"); }
                for (let i = 0; i < modsToRemove.length; i++) { if (modifierList.indexOf(modsToRemove[i]) >= 0) modifierList.splice(modifierList.indexOf(modsToRemove[i]), 1); }
            } else {
                let modsToRemove = []; for (let i = 0; i < modifierList.length; i++) { if (modifierData[modifierList[i]].isCombatModifier) modsToRemove.push(modifierList[i]); }
                if (id === 7 && randomSkill === CONSTANTS.skill.Agility) { modsToRemove.push("increasedChanceToDoubleItemsSkill"); modifierList.push("decreasedAgilityObstacleCost"); }
                for (let i = 0; i < modsToRemove.length; i++) { if (modifierList.indexOf(modsToRemove[i]) >= 0) modifierList.splice(modifierList.indexOf(modsToRemove[i]), 1); }
            }
        }
        const random = Math.floor(Math.random() * modifierList.length); modValue = value; if (modifierData[modifierList[random]].isSkill) {
            if (!SKILLS[randomSkill].hasMastery && !modifierData[modifierList[random]].isCombatModifier && modifierList[random] !== "increasedSkillXP") { const skillID = ASTROLOGY[id].skills.indexOf(randomSkill); if (skillID === 0) randomSkill = ASTROLOGY[id].skills[1]; else randomSkill = ASTROLOGY[id].skills[0]; }
            modValue = [randomSkill, value]; activeAstrologyModifiers[id][i][modifierList[random]] = [modValue];
        } else { activeAstrologyModifiers[id][i][modifierList[random]] = modValue; }
        if (applySingleCost) updatePlayerStats(); if (renderUIUpdate) updateAllAstrologyModifiers(id);
    }
}
