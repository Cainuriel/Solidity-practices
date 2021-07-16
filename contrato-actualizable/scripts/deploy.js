// scripts/deploy.js
async function main() {
  const Box = await ethers.getContractFactory("Box");
  console.log("Deploying Box...");
  const box = await upgrades.deployProxy(Box, [42], { initializer: 'store' });
  console.log("Box deployed to:", box.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });

  // 0x135BfAC32F284ee7cdbd60Bb649cc4Dda40D6E5D in Rinkeby deployed.