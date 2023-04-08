$exceptions = "library_reader"

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

# Remove completed jobs
Get-Job | Where-Object { $_.State -eq 'Completed' } | Remove-Job