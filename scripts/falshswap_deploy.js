const { ethers } = require("hardhat");
const contract_name = "Flashswap"

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Contract = await ethers.getContractFactory(contract_name);
    const c = await Contract.deploy();
    await c.deployed();
    console.log("Contract address:", c.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

