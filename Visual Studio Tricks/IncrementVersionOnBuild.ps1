<# 
	Use by placing this file in the same folder the .csproj file is in and adding

	PowerShell -ExecutionPolicy Bypass -NoProfile -File IncrementVersionOnBild.ps1

	to pre or post build events in VS, whatever suits better.

	This will format the Version as X.X.[Build].[Year][DayOfYear]
	The unorthodox way of getting an exact date [Year][DayOfYear] is used because through testing I found out Versions don't handle numbers past a certain size well.
	Since I wanted a date in my version to make it easy to see when it was last updated, this was an OK compromise.

	Minor and Major still have to be set manually

	Don't forget to replace the name of the project in the $path variable with your own!
	Use and modify to your wishes
#>

$path = "##NAME-OF-PROJECT##.csproj"

$xml = [xml](Get-Content $path)

$currentVersion = [version]($xml.Project.PropertyGroup | Select-Object -First 1).Version
$year = Get-Date -Format "yy"
$dayOfYear = (Get-Date).DayOfYear
$build = [int]$currentVersion.Build
$rev = "{0:d2}{1:d3}" -f [int]$year, [int]$dayOfYear
($xml.Project.PropertyGroup | Select-Object -First 1).Version = "{0}.{1}.{2}.{3}" -f $currentVersion.Major, $currentVersion.Minor, [int]($build+1), $rev

$xml.Save($path)