# Azure Cloud Project: Home office solution using Microsoft Azure VPN Gateway

## Problem

Staff have transitioned from working in office, to working fully remote for the forseeable future. The org requires a solution which allows staff to access the environment in Microsoft Azure, without exposing the entire environment to the public internet.

## Solution

- Point to site VPN gateway allows us to create a secure connection to our Azure Virtual Network form an individual client computer
- Useful for connecting to Azure VNet from remote locations
- Utilizing Azure Highly Available config

## Implementation

### 1. Create Azure Virtual Network
