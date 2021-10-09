// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile 
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy

  const Payments = await hre.ethers.getContractFactory("SimplePaymentChannel");

 // console.log('payments: ', Payments);
  const payments = await Payments.deploy("SimplePaymentChannel", {args:['0xdcf95741E632aA0Fe5a4d9cbD97e0CFaFb20B869', 9006],value: "1000000000000000000"});

  //await payments.deployed();

  //console.log("ReceiverPays contract deployed to:", payments.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });

