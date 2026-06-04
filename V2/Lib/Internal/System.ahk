; Directives
#Requires AutoHotkey v2.0

class System {
    static DownloadsPath => RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "{374DE290-123F-4565-9164-39C4925E467B}")

    static GetRandomFile(directoryPath) {
        GlobalLogger.WriteDebug("Getting random file from: " . directoryPath)
        fileList := []
        Loop Files, directoryPath "\*.*"
        {
            fileList.Push(A_LoopFilePath)
        }

        count := fileList.Length
        GlobalLogger.WriteDebug("Total Files Found: " . count)

        randomIndex := Random(1, count)
        selectedFile := fileList[randomIndex]
        GlobalLogger.WriteDebug("Selected file: " . selectedFile)

        return selectedFile
    }
}
