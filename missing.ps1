param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $FolderPath
)

# Get all files in the specified folder and select only the CreationTime property
$creationTimes = Get-ChildItem -Path $FolderPath | Select-Object -ExpandProperty CreationTime

# Determine the minimum and maximum creation times
$minTime = $creationTimes | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
$maxTime = $creationTimes | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum

# Generate an array of all minutes between the minimum and maximum creation times
$allMinutes = @()
for ($time = $minTime; $time -le $maxTime; $time = $time.AddMinutes(1)) {
    $allMinutes += $time
}

# Generate an array of minutes for which files exist
$existingMinutes = $creationTimes | ForEach-Object { $_.Date.AddHours($_.Hour).AddMinutes($_.Minute) }

# Identify missing minutes
$missingMinutes = $allMinutes | Where-Object { $_ -notin $existingMinutes }

# Display total files present
$totalFilesPresent = $creationTimes.Count
Write-Host "Total files present: $totalFilesPresent"

# Calculate total expected files based on the pattern of the data
$totalExpectedFiles = $allMinutes.Count
Write-Host "Total expected files based on the pattern of the data: $totalExpectedFiles"

# Calculate time missed
$totalTimeMissed = $missingMinutes.Count
Write-Host "Total time missed: $($totalTimeMissed) minutes"

# Display missing minutes
if ($missingMinutes.Count -eq 0) {
    Write-Host "No missing minutes found."
} else {
    Write-Host "Missing minutes:"
    $missingMinutes | ForEach-Object { Write-Host $_ }
}


