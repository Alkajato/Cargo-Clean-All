$exceptions = "sources"

Get-ChildItem -Directory | ForEach-Object {
    $fullPath = $_.FullName
    $directory = (Split-Path $fullPath -Leaf)

    if ($exceptions -notcontains $directory) {
        Write-Host "Processing: $directory"
        
        Start-Job -ScriptBlock {
            Set-Location $using:fullPath
            cargo clean
        } | Out-Null
    }
}

# Silently wait for jobs to finish then remove them
Get-Job | Wait-Job -Any | Out-Null
Get-Job | Where-Object { $_.State -eq 'Completed' } | Remove-Job
