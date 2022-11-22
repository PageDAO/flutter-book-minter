self.window = self // This is required for the jsencrypt library to work within the web worker

// self.importScripts('https://cdnjs.cloudflare.com/ajax/libs/jsencrypt/3.2.1/jsencrypt.min.js');
self.importScripts('web3.min.js'); // Using v1.2.2 https://raw.githubusercontent.com/web3/web3.js/1.x/dist/web3.min.js because of this issue https://github.com/web3/web3.js/issues/3256

async function checkNFT(params) {
  const { address, tokenID, abi} = params;
  var web3 = new Web3("https://polygon-rpc.com");
  const contract = new web3.eth.Contract(abi, tokenID);
  const tokenOwner = await contract.methods.balanceOf(address).call()
  const hasToken = tokenOwner > 0;
  return hasToken;
}