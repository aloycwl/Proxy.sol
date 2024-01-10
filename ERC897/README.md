# ERC897

Contains:

ERC897.sol - This is by far the most tiny, cost effecient yet secured version available.
All its functions are written in Yul (Solidity Assembly) and therefore able to directly
manipulate the storage pointers easily. Only by using Yul we understand how each the 
redirection of the proxy call take place.

Proxy contracts work in a way where it handles all kinds of commands. If the function
existing in the proxy contract, it will be delegate to the implementation contract.
Therefore, never create the same function as the proxy or never try to overwrite it
as it will not even reach that the other contract.

Usage:
```
// Create a new contract first, let's use a ERC-20 token contract as example
ERC20 e20 = new ERC20("Proxy Coin", "PXC");
Proxy pxy = new Proxy(address(e20));
// As the constructor for Proxy requires an address input,
// the newly created contract will need to be converted
// This will create a new proxy and automatically the implementation address
// is set to the e20 address
```

fallback() and receive() explained:
```
// Basically these functions are the same, they resend the calldata that was sent to
// the proxy contract without the correct function selector.
// fallback() - This function is executed when no ether is sent.
// receive() - This function is executed when ether is sent.

// Get all the data sent and the size of the data to determine end of message
calldatacopy(0x00, 0x00, calldatasize())

// Send the data to the implementation address inside IN2
let res := delegatecall(gas(), sload(IN2), 0x00, calldatasize(), 0x00, 0x00)

// Get the length of the return data to determine the end of message
let sze := returndatasize()

// Get all the data received from the implementation contract
returndatacopy(0x00, 0x00, sze)

// Prompt error if sending fail otherwise send the returned message
switch res
    case 0 { revert(0x00, sze) }
    default { return(0x00, sze) }

```