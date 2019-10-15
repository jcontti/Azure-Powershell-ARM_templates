# Variables
 $resourceGroup = "Stage5_RG"
 $location = "centralus"
 $vmName = "MyWinVM"

 $vmUser = "azureuser"
 $vmPass = "Password_1234"

 $vmSubNetname = "mySubnet"
# $vmSubNetAdress = "192.168.1.0/24"
 $vmVirtualNetName = "MYvNET"
# $vmVirtualNetAdress = "192.168.0.0/16"

# Define user name and password
$SecurePassword = ConvertTo-SecureString $vmPass -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ($vmUser, $SecurePassword); 

New-AzVm `
    -ResourceGroupName $resourceGroup `
    -Name $vmName `
    -Location $location `
    -VirtualNetworkName $vmVirtualNetName `
    -SubnetName $vmSubNetname `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress" `
    -OpenPorts 80,3389 `
    -Credential $cred