require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.10",
    networks: {
        hardhat: {
            forking: {
                url: "https://polygon-mainnet.g.alchemy.com/v2/***",
            }
        },
      localfork: {
        url: "http://127.0.0.1:10545"
      }
    }
};

