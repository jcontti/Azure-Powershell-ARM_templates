# Variables
$resourceGroup = "Stage5_RG"
$location = "centralus"
$vmName = "MyLinuxVM"

$vmUser = "azureuser"
$vmPass = "Password_1234"

$vmSubNetname = "mySubnet"
$vmSubNetAdress = "192.168.1.0/24"
$vmVirtualNetName = "MYvNET"
$vmVirtualNetAdress = "192.168.0.0/16"

# Define user name and password
$SecurePassword = ConvertTo-SecureString $vmPass -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ($vmUser, $SecurePassword); 

# Create a resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create a subnet configuration
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name $vmSubNetname -AddressPrefix $vmSubNetAdress

# Create a virtual network
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $location `
  -Name $vmVirtualNetName -AddressPrefix $vmVirtualNetAdress -Subnet $subnetConfig

# Create a public IP address and specify a DNS name
$pip = New-AzPublicIpAddress -ResourceGroupName $resourceGroup -Location $location `
  -Name "mypublicdns$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4

# Create an inbound network security group rule for port 22
$nsgRuleSSH = New-AzNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleSSH  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 22 -Access Allow

# Create a network security group
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location `
  -Name myNetworkSecurityGroup -SecurityRules $nsgRuleSSH

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzNetworkInterface -Name myNic -ResourceGroupName $resourceGroup -Location $location `
  -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

# Create Storage Account 
New-AzStorageAccount -ResourceGroupName $resourceGroup -Name mylinuxstorageacc -Location $location -SkuName Standard_GRS

# Create a virtual machine configuration
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize Standard_D1 |
Set-AzVMOperatingSystem -Linux -ComputerName $vmName -Credential $cred  |
Set-AzVMSourceImage -PublisherName Canonical -Offer UbuntuServer -Skus 14.04.2-LTS -Version latest |
Add-AzVMNetworkInterface -Id $nic.Id

# Create a virtual machine
New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig