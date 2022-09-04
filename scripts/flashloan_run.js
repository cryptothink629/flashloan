const { ethers } = require("hardhat");

const flashloan_addr = "0x029018E31007D326D93c5535AA0F8A1F68214160"
const DAI = "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063"

async function main() {
    const [signer] = await ethers.getSigners();
    console.log("Singer account:", signer.address, ", Balance:", (await signer.getBalance()).toString());
    const flashloan_c = await ethers.getContractAt("Flashloan", flashloan_addr, signer)

    const tx = await flashloan_c.flashloan(DAI, ethers.utils.parseEther("1"));
    // const tx = await flashloan_c.flashloan(DAI, 1);  // 使用最小单位可以免手续费，跑通流程
    await tx.wait();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });