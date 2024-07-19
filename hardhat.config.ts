import "@nomicfoundation/hardhat-ethers";
import "@yankeguo/hardhat-trezor";
import "@nomicfoundation/hardhat-verify";

import { HardhatUserConfig } from "hardhat/config";
import { task } from "hardhat/config";
import { ethers } from "ethers";

task("liled:deploy", "deploy LiLED contract", async (taskArgs, hre) => {
  const [signer] = await hre.ethers.getSigners();
  const balance = await signer.provider.getBalance(signer.address);
  console.log("address:", signer.address);
  console.log("balance:", ethers.formatEther(balance));
  //console.log("deploying contract...");
  //const LiLED = await hre.ethers.getContractFactory("LiLED", signer);
  //const contract = await LiLED.deploy();
  //console.log("contract deployed at:", await contract.getAddress());
});

module.exports = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    iotex_mainnet: {
      url: "https://babel-api.mainnet.iotex.io",
      trezorDerivationPaths: [[44, 60, 0, 0, 0]],
      trezorInsecureDerivation: true,
    },
    iotex_testnet: {
      url: "https://babel-api.testnet.iotex.io",
      trezorDerivationPaths: [[44, 60, 0, 0, 0]],
      trezorInsecureDerivation: true,
    },
  },
  etherscan: {
    customChains: [
      {
        network: "iotex_mainnet",
        chainId: 4689,
        urls: {
          apiURL: "https://TBD",
          browserURL: "https://TBD",
        },
      },
      {
        network: "iotex_testnet",
        chainId: 4690,
        urls: {
          apiURL: "https://TBD",
          browserURL: "https://TBD",
        },
      },
    ],
    apiKey: {
      iotex_mainnet: "TBD",
      iotex_testnet: "TBD",
    },
  },
} as HardhatUserConfig;
