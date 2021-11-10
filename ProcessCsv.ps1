param($CsvFile)

$records = import-csv $CsvFile

foreach($csv in $records)
{
	$headers = "SerialNumber","Name","Address","Phone","Lat","Lng","Email","VolunteerType","AreaPreferences","AvailableDays","UnavailableDays","AvailableHours","UnavailableHours";
	$o = "" | select $headers

	$o.SerialNumber = [int] $csv.No
	$o.Name = $csv.Name
	$o.Address = $csv.RevisedAddress
	if (!$o.Address)
	{
		$o.Address = $csv.Address
	}
	$o.Phone = $csv.MobileNumber

	if ($csv.LatLong)
	{
		$p = $csv.LatLong.Split(",").Trim()
		$o.Lat = [double] $p[0]
		$o.Lng = [double] $p[1]
	}
	else
	{
		$o.Lat = [double] 12.943235472062494
		$o.Lat = [double] 80.23696092653837
	}

	$o.Email = $csv.Email

	$o.VolunteerType = $csv.VolunteerServiceType
	$o.AreaPreferences = $csv.AreaPreferences 
	$o.AvailableDays = $csv.AvailableShiftPreferencesinDays 
	$o.UnavailableDays = $csv.NotAvailableShiftPreferencesinDays
	$o.AvailableHours = $csv.AvailableShiftPreferencesinHours 
	$o.UnavailableHours = $csv.NotAvailableShiftPreferencesinHours

	$o
}
