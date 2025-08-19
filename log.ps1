
# Default paths
if (-not $env:DWARF_FORTRESS_PATH) {
    $env:DWARF_FORTRESS_PATH = "$env:USERPROFILE\AppData\Roaming\Steam\steamapps\common\Dwarf Fortress"
}
if (-not $env:DF_OUTPUT_FILE) {
    $env:DF_OUTPUT_FILE = ".\lualog.log"
}

# Require valid path
if (-not (Test-Path $env:DWARF_FORTRESS_PATH)) {
    Write-Host "Dwarf Fortress path not found. Please set DWARF_FORTRESS_PATH to the root directory."
    Write-Host "DWARF_FORTRESS_PATH=""$env:DWARF_FORTRESS_PATH"""
    exit 1
}

# Input files
$input_file_1 = Join-Path $env:DWARF_FORTRESS_PATH "gamelog.txt"
$input_file_2 = Join-Path $env:DWARF_FORTRESS_PATH "lualog.txt"
$DF_OUTPUT_FILE = $env:DF_OUTPUT_FILE

# Ensure they exist
New-Item -Force -ItemType File -Path $input_file_1, $input_file_2, $DF_OUTPUT_FILE | Out-Null

# Start log
$startStamp = Get-Date -Format "[yyyy-MM-dd HH:mm:ss]"
"===> Log started at $startStamp <===" | Tee-Object -FilePath $DF_OUTPUT_FILE -Append

# Cleanup handler
$cleanup = {
    $stopStamp = Get-Date -Format "[yyyy-MM-dd HH:mm:ss]"
    "===> Log stopped at $stopStamp <===" | Tee-Object -FilePath $DF_OUTPUT_FILE -Append
    exit
}
# Trap Ctrl+C
Register-EngineEvent ConsoleCancelEventHandler -Action $cleanup | Out-Null

# State tracking
$last_line = ""
$repeat_count = 0

# Tail and merge both files
Get-Content $input_file_1, $input_file_2 -Wait -Tail 0 |
    ForEach-Object {
        $line = $_
        $timestamp = Get-Date -Format "[yyyy-MM-dd HH:mm:ss]"
        if ($line -eq $last_line) {
            $repeat_count++
            $output_line = "$timestamp $line [x$repeat_count]"
            # Clear last line and overwrite (ANSI escape sequences)
            Write-Host "`e[1A`e[2K$output_line"
            $output_line | Tee-Object -FilePath $DF_OUTPUT_FILE -Append
        }
        else {
            if ($last_line -ne "") {
                # Write the last line if it wasn't repeated
                if ($repeat_count -eq 1) {
                    "$timestamp $last_line" | Tee-Object -FilePath $DF_OUTPUT_FILE -Append
                }
            }
            $repeat_count = 1
            $last_line = $line
            "$timestamp $line" | Tee-Object -FilePath $DF_OUTPUT_FILE -Append
        }
    }
