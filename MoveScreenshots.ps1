# Define the source and destination directories
$standardDesktop = "$env:USERPROFILE\Desktop"
$oneDriveDesktop = "$env:USERPROFILE\OneDrive\Desktop"
$destinationDirectory = "$env:USERPROFILE\Pictures\Hearthstone"

Write-Output "Standard Desktop Directory: $standardDesktop"
Write-Output "OneDrive Desktop Directory: $oneDriveDesktop"
Write-Output "Destination Directory: $destinationDirectory"

# Check if the source directory exists
if (Test-Path -Path $oneDriveDesktop) {
    $sourceDirectory = $oneDriveDesktop
    Write-Output "Using OneDrive Desktop Directory."
} elseif (Test-Path -Path $standardDesktop) {
    $sourceDirectory = $standardDesktop
    Write-Output "Using Standard Desktop Directory."
} else {
    Write-Output "No valid Desktop directory found."
    exit
}

# Check if destination directory exists and create it if it doesn't
if (-Not (Test-Path -Path $destinationDirectory)) {
    Write-Output "Destination directory does not exist. Creating directory: $destinationDirectory"
    New-Item -ItemType Directory -Path $destinationDirectory
} else {
    Write-Output "Destination directory exists: $destinationDirectory"
}

# Get all .png files from the source directory
Write-Output "Retrieving files..."
$files = Get-ChildItem -Path $sourceDirectory -Filter "*.png" -ErrorAction SilentlyContinue

if ($files.Count -eq 0) {
    Write-Output "No .png files found in the source directory."
    exit
}

Write-Output "Files found:"
foreach ($file in $files) {
    Write-Output $file.FullName
}

# Filter files manually to ensure correct matching
$filteredFiles = $files | Where-Object { $_.Name -like "Hearthstone Screenshot*.png" }

if ($filteredFiles.Count -eq 0) {
    Write-Output "No files found matching the pattern 'Hearthstone Screenshot*.png'."
} else {
    Write-Output "$($filteredFiles.Count) file(s) found."

    # Move each file to the destination directory
    foreach ($file in $filteredFiles) {
        Write-Output "Moving file: $($file.FullName) to $destinationDirectory"
        Move-Item -Path $file.FullName -Destination $destinationDirectory
        Write-Output "Moved file: $($file.Name)"
    }
}

Write-Output "Script execution completed."