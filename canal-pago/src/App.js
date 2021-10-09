import './App.css';
import { useState } from 'react';
import { ethers } from 'ethers'
//import Presale from './artifacts/contracts/PaymentChannel.sol/PaymentChannel.json'
const web3 = require('web3');
const ethereumjs = require('ethereumjs-util')
const abi = require('ethereumjs-abi');
require('dotenv').config();




function App() {

  //const { PRIVATE_KEY, PUBLIC_KEY } = process.env;
  const [amount, setAmount] = useState(100000000000000000);
  const [recipient, setRecipient] = useState('0x1D918aD261752d71FFD63EF9Fb217001C5875005');
  const [nonce, setNonce] = useState( Math.floor(new Date().getTime()/1000.0));
  var expectedSigner;

// contrato deployado..
const contractAddress = "0x79353b87D4A0D5d5DF4B2e91A22D353415716913";

  var [signature, setSignature] = useState('');

  console.log('Billetera conectada? ',window.ethereum.isConnected());


  async function requestAccount() {
    return  await  window.ethereum.request({ method: 'eth_requestAccounts' });
    //console.log('mira el request', request );
  }

 //const signer =  ethereum.enable().then(console.log)

 //ethereum.request({method:"personal_sign", params: [account, hash]}).then(console.log)

function constructPaymentMessage(contractAddress, amount) {
    var hash = abi.soliditySHA3(
        ["address", "uint256"],
        [contractAddress, amount]
    );
    document.querySelector('#hash').innerHTML = hash;
}

function signMessage(message, callback) {
    web3.eth.personal.sign(
        "0x" + message.toString("hex"),
        web3.eth.defaultAccount,
        callback
    );
}

// recipient is the address that should be paid.
// amount, in wei, specifies how much ether should be sent.
// nonce can be any unique number to prevent replay attacks
// contractAddress is used to prevent cross-contract replay attacks
// recipient is the address that should be paid.
// amount, in wei, specifies how much ether should be sent.
// nonce can be any unique number to prevent replay attacks
// contractAddress is used to prevent cross-contract replay attacks
function signPayment(recipient, amount, nonce, contractAddress) {
  var hash = "0x" + abi.soliditySHA3(
      ["address", "uint256", "uint256", "address"],
      [recipient, amount, nonce, contractAddress]
  ).toString("hex");
  document.querySelector('#hash').innerHTML = hash;
  setSignature(hash);
  web3.eth.personal.sign(hash, web3.eth.defaultAccount, console.log());
}



// this mimics the prefixing behavior of the eth_sign JSON-RPC method.
function prefixed(hash) {
    return abi.soliditySHA3(
        ["string", "bytes32"],
        ["\x19Ethereum Signed Message:\n32", hash]
    );
}

function recoverSigner(message, signature) {
    var split = ethereumjs.Util.fromRpcSig(signature);
    var publicKey = ethereumjs.Util.ecrecover(message, split.v, split.r, split.s);
    var signer = ethereumjs.Util.pubToAddress(publicKey).toString("hex");
    return signer;
}

function isValidSignature(contractAddress, amount, signature, expectedSigner) {
    var message = prefixed(constructPaymentMessage(contractAddress, amount));
    var signer = recoverSigner(message, signature);
    if (signer.toLowerCase() ==
        ethereumjs.Util.stripHexPrefix(expectedSigner).toLowerCase()) {
          document.querySelector('#ok').innerHTML = 'Es el mismo firmante';
        } else {
          document.querySelector('#ok').innerHTML = 'No es el mismo';
        }
}

  return (
    <div className="App">
      <header className="App-header">
        {/* <button onClick={fetchrate}>Tokens por 1 BNB</button>
        <button onClick={getBalance}>Tokens disponibles</button> */}


              <input className="" onChange={e => setRecipient(e.target.value)} id="" placeholder="Deudor" value={recipient} />
              <input className="" onChange={e => setAmount(e.target.value)} id="" placeholder="Cantidad en BNBs" value={amount} />
              <input className="" onChange={e => setNonce(e.target.value)} id="" placeholder="Nonce" value={nonce} />
              <input className="" id="" placeholder="Contract Address" defaultValue={contractAddress} />
              <button onClick={signPayment}>Firmar</button>

              <h2 id="hash">...</h2>

              <input className="" id="" placeholder="Contract Address" defaultValue={contractAddress} />
              <input className="" onChange={e => setAmount(e.target.value)} id="" placeholder="A pagar" value={amount} />
              <input className="" id="" placeholder="Signature" onChange={e => setSignature(e.target.value)} value={signature} />
              <input className="" id="" placeholder="Direccion pagador" defaultValue={expectedSigner} />
              <button onClick={isValidSignature}>Comprobar</button>
              <h2 id="ok">...</h2>
      </header>
    </div>
  );
  
}

export default App;
