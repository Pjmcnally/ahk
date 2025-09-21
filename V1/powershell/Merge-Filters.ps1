$filterPath = 'C:\Users\Patrick\AppData\LocalLow\Eleventh Hour Games\Last Epoch\Filters'
$baseFilterEmptyPath = 'C:\Users\Patrick\AppData\LocalLow\Eleventh Hour Games\Last Epoch\Filters\Base - Multi - Empty.xml'
$baseFilterHighPath = 'C:\Users\Patrick\AppData\LocalLow\Eleventh Hour Games\Last Epoch\Filters\Base - Multi - High.xml'
$baseFilterLowPath = 'C:\Users\Patrick\AppData\LocalLow\Eleventh Hour Games\Last Epoch\Filters\Base - Multi - Low.xml'
$OutPath = 'C:\Users\Patrick\AppData\LocalLow\Eleventh Hour Games\Last Epoch\Filters\Merged Loot Filter.xml'

$xml = [xml](Get-Content $baseFilterEmptyPath)
$xml.SelectSingleNode('//name').InnerText = 'Merged Loot Filter'
$xml.SelectSingleNode('//description').InnerText = 'Merged Loot filter'

$ruleList = [System.Collections.ArrayList]::new()
$lowRules = ([xml](Get-Content $baseFilterLowPath)).SelectNodes('//Rule')
[void]$ruleList.Add($lowRules)

$charFiles = Get-ChildItem -Path $FilterPath -Filter 'Base - SC - *'
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
