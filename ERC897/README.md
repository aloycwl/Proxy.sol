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
ERC20 e20 = new ERC20("Proxy Token", "PXT");
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

// Even through they did the same thing and can be re-called using a private 
// function, it will cost a little extra gas to therefore all based codes
// are duplicated between the 2 functions.
```

implementation() usage:
```
// To know what is the implementation, simply:
address adr = 0x000...000; // Proxy address
address imp = ERC897(adr).implementation();

// To set a new implementation address
address newContract = address(new ERC20("Another Token", "ANT"));
ERC897(adr).mem(IN2, newContract);
```

mem(bytes32) and mem(bytes32, bytes32) usage:
```
// These are not the default functions in a typical ERC897 contract but they
// are the most useful function as it can access all the storage pointers.
// All storage are determined by bytes32 so meaning each contract would have 
// almost unlimited storage (16^64 positions).

// To store a value
address tmp = msg.sender;
bytes32 ptr = keccak256(abi.encodePacked(tmp));
bytes32 val = bytes32(uint(0x1234));
ERC897(adr).mem(ptr, val);
// This map the caller's address into a bytes32 position and the information
// pertaining to this user is stored in the memory Solidity

// To retrieve a value
address tmp = msg.sender;
bytes32 ptr = keccak256(abi.encodePacked(tmp));
bytes32 val = ERC897(adr).mem(ptr);
// Using the same mapping manner the val can be recovered, to ensure no similar
// mapping, you can add salt in the keccak to better segregate it.
```

By using the mem functions, every storage in your contract and be manipulate
or accessed. Even for arrays and string values, the first position is usually
the data size and the rest of the data are +1 point to the initial bytes32.