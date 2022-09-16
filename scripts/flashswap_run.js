const { ethers } = require("hardhat");

const flashswap_addr = "0x129b639a28aBAe0693C13FaCE56873d25f6Cb0AD"

const _borrowToken = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"
const _borrowNum = ethers.utils.parseEther("1000")  // borrow 1000 BUSD
const _pairAddress = "0x58F876857a02D6762E0101bb5C46A8c1ED44Dc16"
const _router = "0x10ED43C718714eb63d5aA57B78B54704E256024E"

async function main() {
    const [signer] = await ethers.getSigners();
    console.log("Singer account:", signer.address, ", Balance:", (await signer.getBalance()).toString());

    const flashswap_c = await ethers.getContractAt("Flashswap", flashswap_addr, signer)
    const tx = await flashswap_c.flashswap(_borrowToken, _borrowNum, _pairAddress, _router, {value: ethers.utils.parseEther("2")});
    await tx.wait();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });