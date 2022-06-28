$endpoint="YOUR_ENDPOINT"
$key="YOUR_KEY"


# Code to call Computer Vision service for image analysis
$img_file = "img1.jpg"
if ($args.count -gt 0 -And $args[0] -in ("img1.jpg", "img2.jpg", "img3.jpg"))
{
    $img_file = $args[0]
}

$img = "https://github.com/qwik-azurelabs/ai900lab7/blob/main/data/$img_file"

$headers = @{}
$headers.Add( "Ocp-Apim-Subscription-Key", $key )
$headers.Add( "Content-Type","application/json" )

$body = "{'url' : '$img'}"

write-host "Analyzing image..."
$result = Invoke-RestMethod -Method Post `
          -Uri "$endpoint/vision/v3.2/analyze?visualFeatures=Categories,Description,Objects" `
          -Headers $headers `
          -Body $body | ConvertTo-Json -Depth 5

$analysis = $result | ConvertFrom-Json
Write-Host("`nDescription:")
foreach ($caption in $analysis.description.captions)
{
    Write-Host ($caption.text)
}

Write-Host("`nObjects in this image:")
foreach ($object in $analysis.objects)
{
    Write-Host (" -", $object.object)
}

Write-Host("`nTags relevant to this image:")
foreach ($tag in $analysis.description.tags)
{
    Write-Host (" -", $tag)
}

Write-Host("`n")