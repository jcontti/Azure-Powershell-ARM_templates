# Variables
$ResourceGroupName = "Stage5_RG"
$Location = "CentralUs"

#Create RG
#New-AzResourceGroup -Name $ResourceGroupName -Location $Location
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location