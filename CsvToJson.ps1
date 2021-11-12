param($InputCsvFile = ".\ChennaiFloodsVolunteers2021.csv", $OutputJsonFile)

function Get-CsvRecords
{
	param($FileName)
	
	$records = import-csv $FileName

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

		$isLatLngValid = $false
		if (($csv.LatLongToBeVerified -eq 0) -and $csv.LatLong)
		{
			$tmpLatLng = $csv.LatLong.ToString().Trim()
			if ($tmpLatLng -imatch "^\d+")
			{
				$isLatLngValid = $true
			}
		}
		if ($isLatLngValid)
		{
			$p = $tmpLatLng.Split(",").Trim()
			$o.Lat = [double] $p[0]
			$o.Lng = [double] $p[1]

			$o.Email = $csv.Email

			$o.VolunteerType = $csv.VolunteerServiceType
			$o.AreaPreferences = $csv.AreaPreferences 
			$o.AvailableDays = $csv.AvailableShiftPreferencesinDays 
			$o.UnavailableDays = $csv.NotAvailableShiftPreferencesinDays
			$o.AvailableHours = $csv.AvailableShiftPreferencesinHours 
			$o.UnavailableHours = $csv.NotAvailableShiftPreferencesinHours

			$o
		}
		else
		{
			write-host -fore yellow "No LatLong specified or not valid. Skipping #$($o.SerialNumber)"
		}
	}
}

if (!$OutputJsonFile)
{
	if ($InputCsvFile -imatch "(.*)\.(.*)")
	{
		$OutputJsonFile = $matches[1] + ".json"
	}
}

$recs = @(Get-CsvRecords -FileName:$InputCsvFile)
if ($recs.Length -gt 0)
{
	write-host -fore cyan "Converting $($recs.Count) records to $OutputJsonFile"
	$recs | ConvertTo-Json | out-string | out-file -Encoding:Ascii $OutputJsonFile
}

#	}
#	else
#	{
#		$o.Lat = [double] 12.943235472062494
#		$o.Lng = [double] 80.23696092653837
#	}

