# Flashloan

AAVE v3, on Polygon mainnet

```
https://docs.aave.com/developers/deployed-contracts/v3-mainnet/polygon
https://github.com/aave/aave-v3-core/tree/master/contracts/flashloan
```

run fork
```
# set up fork network
npx hardhat node --port 10545 --network hardhat

# run script on forked network
npx hardhat run scripts/flashloan_deploy.js --network localfork
npx hardhat run scripts/flashloan_run.js --network localfork
```

