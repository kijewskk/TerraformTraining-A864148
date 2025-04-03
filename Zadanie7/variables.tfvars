frontend_rules = {
  frontend1 = {
    # 10.0.2.5 A864148VMFND1
    inbound = [
     {
        name = "Allow_RDP_from_Bastion_to_Frontedn02"
        source = "10.0.1.4"
        port = "3389"
        priority = 110
        destination = "10.0.2.5"
     },
     {
        name = "Allow_HTTP_from_LB_to_Frontedn02"
        source = "137.135.248.99"
        port = "80"
        priority = 120
        destination = "10.0.2.5"
     },
  {
    name = "Allow_HTTPS_from_LB_to_Frontedn02"
    source = "137.135.248.99"
    port = "443"
    priority = 130
    destination = "10.0.2.5"
  },
  ]
  }
  frontend2 = {
  # 10.0.2.4 A864148VMFND2
  inbound = [
  {
    name = "Allow_RDP_from_Bastion_to_Frontedn02"
    source = "10.0.1.4"
    port = "3389"
    priority = 110
    destination = "10.0.2.4"
  },
  {
    name = "Allow_HTTP_from_LB_to_Frontedn02"
    source = "137.135.248.99"
    port = "80"
    priority = 120
    destination = "10.0.2.4"
  },
  {
    name = "Allow_HTTPS_from_LB_to_Frontedn02"
    source = "137.135.248.99"
    port = "443"
    priority = 130
    destination = "10.0.2.4"
  },
  ]
}
}

#Bastion
BastionRuleName = "Allow_RDP_Inbound"
BastionPriority = "110"
BastionPort = "3389"
BastionIP = "10.0.1.4"

#DB
DatabaseRuleName = "Allow_SQL_Inbound_From_Frontend"
DatabasePriority = "110"
DatabasePort = "1443"
DatabaseIP = "10.0.3.4"