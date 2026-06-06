; Directives
#Requires AutoHotkey v2.0

class System {
    static DownloadsPath => RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "{374DE290-123F-4565-9164-39C4925E467B}")

    /**
     * @description `GetRandomFile()`
     * Gets the path to a random file from a specified directory
     * @param {(String)} directoryPath
     * The path to the folder containing files
     * @param {(String)} nameFilter
     * The file name filter use to search for files in the folder (do not include extension or period).
     * Default is "*" (all).
     * @param {(String)} extension
     * The extension of files to include in the search (without the period).
     * Default is "*" (all).
     * @returns {(String)}
     * The path to the selected file
     * @Example
     * GetRandomFile("C:\Users\ahk\Desktop")
     * @Example
     * GetRandomFile("C:\Users\ahk\Desktop", "temp")
     * @Example
     * GetRandomFile("C:\Users\ahk\Desktop", "temp_*", "txt")
     */
    static GetRandomFile(directoryPath, nameFilter := "*", extension := "*") {
        fileList := []
        Loop Files, directoryPath "\" . nameFilter . "." . extension
        {
            fileList.Push(A_LoopFilePath)
        }

        return fileList.GetRandomItem()
    }

        /**
     * @description `GetRandomFiles()`
     * Gets an array of random files from a folder.
     * @param {(String)} directoryPath
     * The path to the folder containing files
     * @param {(String)} nameFilter
     * The file name filter use to search for files in the folder (do not include extension or period).
     * Default is "*" (all).
     * @param {(String)} extension
     * The extension of files to include in the search (without the period).
     * Default is "*" (all).
     * @param {(Integer)} count
     * The max number of files to return. If no files match the provided criteria then an empty array is returned.
     * Default is 1.
     * @returns {(Array)}
     * An array of files.
     * @Example
     * GetRandomFiles("C:\Users\ahk\Desktop")
     * @Example
     * GetRandomFiles("C:\Users\ahk\Desktop", "temp")
     * @Example
     * GetRandomFiles("C:\Users\ahk\Desktop", "temp_*", "txt")
     * @Example
     * GetRandomFiles("C:\Users\ahk\Desktop", "temp_*", "txt", 5)
     */
    static GetRandomFiles(directoryPath, nameFilter := "*", extension := "*", count := 1) {
        fileList := []
        Loop Files, directoryPath "\" . nameFilter . "." . extension
        {
            fileList.Push(A_LoopFilePath)
        }

        resultArray := fileList.GetRandomSample(count)

        return resultArray
    }
}
