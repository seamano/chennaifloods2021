param(
	[switch] $UseLink,
	$JsonFile = ".\ChennaiFloodsVolunteers2021.json", 
	$JsonLink = "https://raw.githubusercontent.com/seamano/chennaifloods2021/master/ChennaiFloodsVolunteers2021.json",
	[switch] $NoFormatting)

if ($UseLink)
{
	write-host -fore yellow "Downloading from $JsonLink"
	$req = iwr -Uri $JsonLink
	$content = $req.Content
}
else
{
	write-host -fore yellow "Reading from $JsonFile"
	$content = get-content $JsonFile
}

$s = $content | out-string
$jsonRecords = convertfrom-json $s

if ($NoFormatting)
{
	$jsonRecords
}
else
{
	$jsonRecords | ft
}
