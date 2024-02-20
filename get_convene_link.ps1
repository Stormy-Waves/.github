# Define the path to the JSON file
$jsonFilePath = "$env:APPDATA\KRLauncher\G153\C50004\kr_starter_game.json"

try {
    # Check if the JSON file exists
    if (Test-Path $jsonFilePath) {
        # Read the content of the JSON file
        $jsonContent = Get-Content $jsonFilePath -Raw | ConvertFrom-Json

        # Extract the path key
        $pathKey = $jsonContent.path

        # Construct the full path to the log file
        $logFilePath = "$pathKey\Client\Saved\Logs\Client.log"

        # Check if the log file exists
        if (Test-Path $logFilePath) {
            # Read the content of the log file
            $logContent = Get-Content $logFilePath

            # Search for the specific line in the log content
            $matchingLine = $logContent | Where-Object { $_ -like "*https://web-static.kurogame.net/aki/gacha/index.html#/record?svr_id*" } | Select-Object -First 1

            # Extract the desired substring
            if ($matchingLine) {
                $startIndex = $matchingLine.IndexOf('"url":"') + '"url":"'.Length
                $endIndex = $matchingLine.IndexOf('","transparent"', $startIndex)
                $extractedUrl = $matchingLine.Substring($startIndex, $endIndex - $startIndex)

                Write-Output $extractedUrl
            } else {
                Write-Output "No matching line found in the log file."
            }
        } else {
            Write-Output "Log file does not exist at $logFilePath."
        }
    } else {
        Write-Output "JSON file does not exist at $jsonFilePath."
    }
} catch {
    Write-Output "An error occurred: $_"
}
