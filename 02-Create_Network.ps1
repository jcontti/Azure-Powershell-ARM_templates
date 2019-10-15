# Variables
$ResourceGroupName = "Stage5_RG"
$Location = "East US"


# Configure network settings
$SubnetName = $ResourceGroupName + "subnet"
$VnetName = $ResourceGroupName + "vnet"
$PipName = $ResourceGroupName + "PubIPname"

# Create a subnet configuration
#$SubnetConfig = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix 192.168.1.0/24
$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix 192.168.1.0/24

# Create a virtual network
#New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location `
New-AzureRmVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location `
   -Name $VnetName -AddressPrefix 192.168.0.0/16 -Subnet $SubnetConfig

# Create a public IP address and specify a DNS name
#New-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Location $Location `
New-AzureRmPublicIpAddress -ResourceGroupName $ResourceGroupName -Location $Location `
   -AllocationMethod Static -IdleTimeoutInMinutes 4 -Name $PipName

# Create an inbound network security group rule for port 22
#$nsgRuleSSH = New-AzNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleSSH  -Protocol Tcp `
$nsgRuleSSH = New-AzureRmNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleSSH  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 22 -Access Allow

# Create a network security group
#New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $location `
New-AzureRmNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $location `
  -Name myNetworkSecurityGroup -SecurityRules $nsgRuleSSH