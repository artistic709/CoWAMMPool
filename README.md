## Pooled CoW AMM demo on Gnosis Chain

CoWSwap <> Safe <> LP contract

### Demo
[Frontend Demo](https://cow-amm-pool-interface.netlify.app)

![cowammpool.jpg](https://github.com/artistic709/CoWAMMPool/assets/6032476/ff5e7c95-1ca5-4b58-a7b7-b3fcabe2304a)

### Contracts address

- WXDAI: [0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d](https://gnosisscan.io/address/0xe91d153e0b41518a2ce8dd3d7944fa863463a97d)
- WETH: [0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1](https://gnosisscan.io/address/0x6a023ccd1ff6f2045c3309768ead9e68f978f6e1)
- SAFE: [0xbc6159Fd429be18206e60b3BB01D7289F905511B](https://gnosisscan.io/address/0xbc6159fd429be18206e60b3bb01d7289f905511b)
- CoWAMMPool: [0x23C167FC9A196B36B15002558f5783648ef47C47](https://gnosisscan.io/address/0x23C167FC9A196B36B15002558f5783648ef47C47)

### Deploy flow
1. create a Safe contract
2. deploy CoWAMMPool contract
3. Safe approve CoWAMMPool to move tokens
4. fund initial liquidity by invoking CoWAMMPool.addLiquidity
5. use CoW AMM Deployer Safe App

### **Disclaimer** ⚠️
- not audited
- currently Safe owner is my EOA

### Feature/TODO
- tokenize LP position in a shared CoW AMM
- work as a standalone contract, not a Safe module
- imbalanced deposit is allowed
- no fee
- still need to rely on Safe owner to configure CoW AMM
- add/remove liquidity via CoW Swap (intent: spend m token0 for n LP)
- auto adjust CoW AMM minimum amount
