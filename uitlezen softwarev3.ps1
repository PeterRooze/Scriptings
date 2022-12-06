# De directories die we doorzoeken op .exe files, het is mogelijk directories toe te voegen.
$directories = "C:\Program Files (x86)\CLB", "C:\Unicare", "C:\UniVOS", "C:\Program Files\2BrightSparks\SyncBackPro\"
$excludeFolders = @("Setup")
$data = @()
$Computername = hostname
$date = Get-Date
$formattedDate = $date.ToString("ddMMyyyy")
$filename = $("Geinstalleerde_Software_" +$Computername + "_" + $formattedDate )

# Wat doen we eigenlijk
Write-Host "Searching for software versions in $directories"

# Hiermee kunnen we de totale executie tijd berekenen
$result = Measure-Command {

# Loop die loop 
foreach ($directory in $directories) {
  # Zoeken!!!
  Write-Host "Searching in directory $directory"
  foreach ($file in (Get-ChildItem -Path $directory -Exclude $excludeFolders -Recurse -Filter "*.exe" -ErrorAction SilentlyContinue | ? {$_ -notmatch $excludeFolders })) {
    # Controlleren of bestanden geen 0 bevatten. In deze .exe bestanden zijn wij niet geïnteresseerd. 
    if ($file.Name -notmatch "0") {
      $version = (get-command $file.FullName).FileVersionInfo.FileVersion
      # Gooi alles in een array
      $data += [PSCustomObject]@{
        FilePath = $file.FullName
        FileVersion = $version
      }
      # Gevonden software 
      Write-Host "Found file $file with version $version"
    }
  }
}

# Data exporteren
# New-item -Path c:\Temp\ -ItemType Directory
$Temppad = "C:\Temp\"
    
If (!(test-path $Temppad))
{
    md $Temppad
}
Write-Host "Excluded folders: $excludeFolders"
Write-Host "Exporting data to c:\Temp\$filename.txt"
Write-Host "Exporting data to c:\Temp\$filename.csv"
$data | Out-File -FilePath "c:\Temp\$filename.txt"
$data | Export-Csv -Path "c:\Temp\$filename.csv" -NoTypeInformation -UseCulture 
}

# Executie tijd
Write-Host "Elapsed time: $($result.TotalSeconds) seconds"

# hit die enter knop dan
Read-Host -Prompt "Press Enter to close the window"
