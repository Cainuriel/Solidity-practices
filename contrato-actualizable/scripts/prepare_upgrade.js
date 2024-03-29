// scripts/prepare_upgrade.js
async function main() {
    const proxyAddress = '0x76E2cFc1F5Fa8F6a5b3fC4c8F4788F0116861F9B';
   
    const BoxV2 = await ethers.getContractFactory("BoxV2");
    console.log("Preparing upgrade...");
    const boxV2Address = await upgrades.prepareUpgrade(proxyAddress, BoxV2);
    console.log("BoxV2 at:", boxV2Address);
  }
   
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });