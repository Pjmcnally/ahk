merge_lootfilter() {
    script := "
    (
        $filterPath = 'C:\Users\Patrick\AppData\LocalLow\Eleventh Hour Games\Last Epoch\Filters'
        $baseFilterHighPath = 'C:\Users\Patrick\AppData\LocalLow\Eleventh Hour Games\Last Epoch\Filters\Base - Multi - High.xml'
        $baseFilterLowPath = 'C:\Users\Patrick\AppData\LocalLow\Eleventh Hour Games\Last Epoch\Filters\Base - Multi - Low.xml'
        $OutPath = 'C:\Users\Patrick\AppData\LocalLow\Eleventh Hour Games\Last Epoch\Filters\# Merged Loot Filter.xml'

        $ruleList = [System.Collections.ArrayList]::new()
        $xml = [xml](Get-Content $baseFilterLowPath)
        $xml.SelectSingleNode('//name').InnerText = '# Merged Loot Filter'
        $xml.SelectSingleNode('//description').InnerText = '# Merged Loot filter'

        $charFiles = Get-ChildItem -Path $FilterPath -Filter 'Base - SC - *' | Sort-Object -Desc
        foreach ($file in $charFiles) {
            $fileRules = ([xml](Get-Content $file.FullName)).SelectNodes('//Rule')
            [void]$ruleList.Add($fileRules)
        }

        $highRules = ([xml](Get-Content $baseFilterHighPath)).SelectNodes('//Rule')
        [void]$ruleList.Add($highRules)

        foreach ($ruleSet in $ruleList) {
            foreach ($rule in $ruleSet) {
                $newNode = $xml.ImportNode($rule, $true)
                [void]$xml.SelectSingleNode('//rules').AppendChild($newNode)
            }
        }

        $xml.Save($outPath)
    )"

    Run PowerShell %script%, , "Hide"
}

change_focus() {
    WinActivate, Program Manager
    Sleep, 100
    WinActivate
}

numlock_trick(key) {
    SetNumLockState, On
    Send {%key% Down}
    SetNumLockState, Off
    SetNumLockState, On
}

#IfWinActive, Last Epoch
; !-::merge_lootfilter()
!7::numlock_trick("Numpad1")
!8::numlock_trick("Numpad2")
!9::numlock_trick("Numpad3")
!0::numlock_trick("Numpad4")
!6::numlock_trick("Numpad5")
!Space::change_focus()
#IfWinActive ; End #IfWinActive
