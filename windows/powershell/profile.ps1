fastfetch

$machine = hostname.exe

$prompt1 = get-content $PSHOME/prompt1.txt
$prompt2 = get-content $PSHOME/prompt2.txt
$prompt3 = get-content $PSHOME/prompt3.txt
$prompt4 = get-content $PSHOME/prompt4.txt

$global:mode = "i"

function prompt {

	$location = $(if ($pwd.path.StartsWith($home) -eq $true) {"~"+$pwd.path.substring($home.length)} else {$pwd.path.substring(2)})

	write-host -NoNewLine "$prompt1[$env:username@$machine]$prompt2[$location]`n$prompt3[$global:mode]$prompt4 $"
    " "
}

function OnViModeChange {
    if ($args[0] -eq 'Command') {
        $global:mode = "n"
        Write-Host -NoNewLine "`r$prompt3[$global:mode]$prompt4 $ "
    } else {
        $global:mode = "i"
        Write-Host -NoNewLine "`r$prompt3[$global:mode]$prompt4 $ "
    }
}

Set-PSReadlineOption -EditMode vi
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

Set-PSReadLineKeyHandler -Chord Enter -ScriptBlock {

    $currentInput = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref] $currentInput, [ref] $null)

    $CurrentLine  = $Host.UI.RawUI.CursorPosition.Y
    $ConsoleWidth = $Host.UI.RawUI.BufferSize.Width

    [Console]::SetCursorPosition(0, $CurrentLine)
    [Console]::Write("{0,-$ConsoleWidth}" -f " ")
    [Console]::SetCursorPosition(0, $CurrentLine - 1)
    [Console]::Write("{0,-$ConsoleWidth}" -f " ")
    [Console]::SetCursorPosition(0, $CurrentLine - 1)
    Write-Host -NoNewLine "> $currentInput"

    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    [Console]::SetCursorPosition(0, $Host.UI.RawUI.CursorPosition.Y - 1)
}
