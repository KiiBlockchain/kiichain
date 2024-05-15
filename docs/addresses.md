# Kiichain Addresses

With the transition to the new Kiichain EVM testnet, a fundamental shift in address formatting has occurred. Previously, addresses were structured in Bech32 format with a distinctive "kii" prefix, characteristic of Cosmos-based chains. However, in alignment with the Ethereum Virtual Machine (EVM) compatibility of the new testnet, addresses are now represented in hexadecimal format akin to Ethereum addresses. This alteration reflects a strategic adaptation to streamline interoperability with Ethereum-based tools and infrastructure, facilitating a seamless transition for developers and users alike.

For users who had generated wallet addresses on the previous testnet, continuity is ensured through the retention of their seed phrases. By importing these seed phrases into EVM-compatible wallet providers such as MetaMask, users can effortlessly retrieve their new hexadecimal addresses for engagement with the Kiichain EVM testnet. This streamlined process not only maintains accessibility for existing users but also underscores the commitment to interoperability, empowering users to seamlessly navigate the evolving blockchain landscape with familiar tools and workflows.

```javascript
// old testnet address format
kii123abc...

// new Kiichain testnet address format
0x123abc...
```