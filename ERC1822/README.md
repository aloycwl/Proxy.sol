# ERC1822

Contains:

UUPS.sol - This is a universal upgradeable proxy, meaning it can be upgraded upon implementation.
Read more at https://www.linkedin.com/pulse/simplest-way-use-erc-1822-universal-upgradeable-proxy-aloysius-chan/
and https://eips.ethereum.org/EIPS/eip-1822.

This is a fairly easy to use proxy, once any contract attaches "UUPSUpgradeable",
Remix will automatically enable the options to implement or upgrade the proxy.

init() function:
```
// INI is to keep track if this proxy contract has been initiated before
// if it has been initiated before, meaning the UUID is already set,
// it will return error

// OWN is the owner of this contract. The first one to init the contract
// will become the owner and only then he will be able to upgrade it
```

upgradeTo() function:
```
// This function is automatically being called upon the first deployment
// and subsequent upgrade. The UUID is fixed so it should not be change, it should be 
// a Keccak value of some value. However that bytes32 value acts as a memory slot 
// and not an address variable, the address exist inside the memory pointer of the UUID
```

UUPS_Example.sol - This is an example to run the UUPS. There are 2 contracts 
within this file and both have to attached "UUPSUpgradeable" in order for Remix to
recognise it as an upgradeable proxy. To deploy, simply go the deploy tab in Remix where 
you will see the additional proxy options.

>Important: Not every chain support the version above 0.8.17, this proxy will automatically
>include the opcode optimisation which will cause an error to older chains. If this
>issue exist, simply downgrade the compiler version.

NFTExample contract:
```
// This contract mimicks a NFT contract, deploy this contract first and only take
// note of its proxy address (the implementation contract is not important once deployed).
// We can set the totalSupply to be 10 during deployment, so after it is all minted,
// the contract lose its value. This is where we upgrade it.
```

NFTExampleV2 contract:
```
// As the "name" is stored in the proxy contract, it could be changed. Any default
// variables stored in the implementation contract will not be called. This new version
// has an addSupply() function that add 16 new supply everytime it is being called.
// There is no limit to how many versions as it can be upgraded.
```