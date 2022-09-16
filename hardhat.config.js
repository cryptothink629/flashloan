require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: {
        compilers: [
            {
                version: "0.8.10",
            },
            {
                version: "0.6.6",
            }
        ]
    },
    networks: {
        hardhat: {
            forking: {
                url: "http://localhost:9545",
            }
        },
      localhost: {
        url: "http://127.0.0.1:7545"
      }
    }
};

