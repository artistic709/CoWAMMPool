## Pooled CoW AMM demo on Gnosis Chain

CoWSwap <> Safe <> LP contract

### Contracts address

WXDAI 0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d
WETH 0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1
SAFE 0xbc6159Fd429be18206e60b3BB01D7289F905511B
CoWAMMPool 0xf34e100057e982f9Dc3C5dE30e756080C50e9726

### Deploy flow
1. create a Safe contract
2. deploy CoWAMMPool contract
3. Safe approve CoWAMMPool to move tokens
4. fund initial liquidity by invoking CoWAMMPool.addLiquidity
5. use CoW AMM Deployer Safe App

### ⚠️ **Disclaimer**
- not audited
- currently Safe owner is my EOA
