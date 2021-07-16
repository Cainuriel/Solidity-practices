require("@nomiclabs/hardhat-waffle");
// hardhat.config.js
require("@nomiclabs/hardhat-ethers");
require('@openzeppelin/hardhat-upgrades');
require('dotenv').config();

// hardhat.config.js
const { API_URL, PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.7.3",
  networks: {
    rinkeby: {
      url: `${API_URL}`,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  }
};




