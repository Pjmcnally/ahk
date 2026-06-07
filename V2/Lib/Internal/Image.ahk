; Directives
#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\"
#Include "Mouse.ahk"
#Include "Keyboard.ahk"

/**
 * @description
 * A class for searching for images on the screen.
 * This class is static and should not be instantiated. All methods and properties are static and can be accessed directly from the class.
 */
class image {
    /**
     * @description `Click`
     * Clicks on an image on the screen.
     * @param {(Number)} x1
     * The x coordinate of the top left corner area to search for the image.
     * @param {(Number)} y1
     * The y coordinate of the top left corner area to search for the image.
     * @param {(Number)} x2
     * The x coordinate of the bottom right corner area to search for the image.
     * @param {(Number)} y2
     * The y coordinate of the bottom right corner area to search for the image.
     * @param {(String)} imagePath
     * The path to the image to search for.
     * @param {(Number)} delay
     * The delay in milliseconds to wait after clicking the image.
     * @param {(Number)} maxTryCount
     * The number of times to attempt to find the image before giving up.
     * Default = 1
     * @param {(Boolean)} mustFind
     * Whether to throw an error if the image is not found.
     * @return {(Object)}
     * An object containing a boolean success property and the x and y coordinates of the image if found.
     */
    static Click(x1, y1, x2, y2, imagePath, delay := 100, maxTryCount := 1, mustFind := false) {
        results := this.Find(x1, y1, x2, y2, imagePath, maxTryCount, mustFind)
        if (results.success) {
            GlobalLogger.WriteDebug("Clicking image at X: " . results.x . " Y: " . results.y)
            Mouse.ClickWait(results.x, results.y, 1, delay)
        }

        return results
    }

    /**
     * @description `Find`
     * Finds an image on the screen.
     * @param {(Number)} x1
     * The x coordinate of the top left corner area to search for the image.
     * @param {(Number)} y1
     * The y coordinate of the top left corner area to search for the image.
     * @param {(Number)} x2
     * The x coordinate of the bottom right corner area to search for the image.
     * @param {(Number)} y2
     * The y coordinate of the bottom right corner area to search for the image.
     * @param {(String)} imagePath
     * The path to the image to search for.
     * @param {(Number)} maxTryCount
     * The maximum number of times to attempt to find the image before giving up.
     * Default = 1
     * @param {(Boolean)} mustFind
     * Whether to throw an error if the image is not found.
     * @return {(Object)}
     * An object containing a boolean success property and the x and y coordinates of the image if found.
     */
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
