const { ethers } = require("hardhat");
const contract_name = "Flashloan"
const pool_addr_provider = "0xa97684ead0e402dC232d5A977953DF7ECBaB3CDb"

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Contract = await ethers.getContractFactory(contract_name);
    const c = await Contract.deploy(pool_addr_provider);
    await c.deployed();
    console.log("Contract address:", c.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

