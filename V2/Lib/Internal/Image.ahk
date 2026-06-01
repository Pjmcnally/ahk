; Directives
#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\"
#Include "Mouse.ahk"
#Include "Keyboard.ahk"

class image {
    static Click(x1, y1, x2, y2, imagePath, delay := 100, attemptCount := 1, throwError := false) {
        results := this.Find(x1, y1, x2, y2, imagePath, attemptCount, throwError)
        if (results.success) {
            GlobalLogger.WriteDebug("Clicking image at X: " . results.x . " Y: " . results.y)
            Mouse.ClickWait(results.x, results.y, 1, 100)
        }

        return results
    }

    static Find(x1, y1, x2, y2, imagePath, maxTryCount := 1, mustFind := false) {
        ; Check for valid and existing image path before attempting search
        if (!FileExist(imagePath)) {
            GlobalLogger.WriteFatal("Image path does not exist: " . imagePath)
            throw Error("Image path does not exist: " . imagePath)
        }

        GlobalLogger.WriteDebug("Searching for image by path: " . imagePath)
        GlobalLogger.WriteDebug("Searching area X1: " . x1 . " Y1: " . y1 . " X2: " . x2 . " Y2: " . y2)

        outX := unset
        outY := unset
        success := false

        attemptCount := 1
        errorRetryCount := 0
        while ((attemptCount <= maxTryCount) and !success) {
            GlobalLogger.WriteDebug("Attempt: " . attemptCount)

            try {
                if (ImageSearch(&outX, &outY, x1, y1, x2, y2, "*50 " . imagePath)) {
                    GlobalLogger.WriteDebug("Image found at X: " . outX . " Y: " . outY)
                    success := true
                } else {
                    attemptCount += 1
                    GlobalLogger.WriteDebug("Image not found")
                }
            } catch OSError as e {
                if (errorRetryCount < 3) {
                    errorRetryCount += 1
                    GlobalLogger.WriteDebug("Retrying image search after error. Retry count: " . errorRetryCount)
                    Sleep(1000 * errorRetryCount) ; Wait before retrying in case of transient error
                } else {
                    GlobalLogger.WriteError("Max retry attempts reached for image search. Aborting search for: " . imagePath)
                    GlobalLogger.WriteError("Final error: " . e.Message, e)
                    throw e
                }
            }

            Sleep(250 * attemptCount) ; Wait before next attempt, increasing with each try to allow for any transient issues to resolve
        }

        if (!success and mustFind) {
            GlobalLogger.WriteError("Image not found after [" . attemptCount . "] attempts. " . imagePath)
            throw Error("Image not found after [" . attemptCount . "] attempts. " . imagePath)
        }

        return {success: success, x: outX, y: outY}
    }
}
