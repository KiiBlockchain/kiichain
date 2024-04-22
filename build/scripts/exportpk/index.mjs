import {ethers} from 'ethers'

// Converts Cosmos mnemonic phrase to private key (to import into wallet providers like metamask)

const MNEMONIC_PHRASE = [
  {
    name: "account_name",
    phrase: "mnemonic phrase",
  },
];

MNEMONIC_PHRASE.map((account) => {
  let mnemonicWallet = ethers.Wallet.fromPhrase(account.phrase);
  console.log(JSON.stringify({ name: account.name, phrase: `${mnemonicWallet.privateKey}` }));
});
