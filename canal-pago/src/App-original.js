import './App.css';
import { useState } from 'react';
import { ethers } from 'ethers'
import Presale from './artifacts/contracts/PaymentChannel.sol/PaymentChannel.json'
const web3 = require('web3');
require('dotenv').config();




function App() {

  const { PRIVATE_KEY, PUBLIC_KEY } = process.env;

// contrato deployado..
const contractAddress = "0xaF5E4E9e9fFfEe3799f8cd6dBcf8a4d996816c34";

  const [defaultaddress] = useState(requestAccount());
  //const [amount, check] = useState(0);
  //const [recipient, setRecipient] = useState('0x');
  console.log('Billetera conectada? ',window.ethereum.isConnected());


  async function requestAccount() {
    return  await  window.ethereum.request({ method: 'eth_requestAccounts' });
    //console.log('mira el request', request );
  }

//   let signPayment = async () => {
//    // const accounts = await web3.eth.getAccounts()
//     //const hash = web3.utils.soliditySha3(recipient, ethers.utils.parseEther(amount), nonce, contractAddress)

//     const tx = {

//       to: recipient,
//       value:ethers.utils.parseEther(amount),
//       gas: 2000000,
//       gasPrice: '234567897654321',
//       nonce: nonce
//     }

//     try {
//         const sigObject = await web3.eth.accounts.signTransaction(tx, `0x${PRIVATE_KEY}`)
//         console.log(amount, nonce, sigObject)
//     } catch (error) {
//         console.log(error)
//     }
// } 

  async function SigningCheck() {
  
    const recipient = '0x1D918aD261752d71FFD63EF9Fb217001C5875005';
    const nonce = '10' // recuerda que no se puede repetir.
    const amount = '0.1';

  let provider = new ethers.providers.Web3Provider(window.ethereum)
  let signer = provider.getSigner()
    console.log('signer ', signer);

  let BNBamount = ethers.utils.parseEther(amount)
  console.log(BNBamount);
  let dataHash =  ethers.utils.solidityKeccak256 (['address','uint256','uint256','address'],[recipient, nonce, BNBamount, contractAddress])
  let bytesDataHash = ethers.utils.arrayify(dataHash)
  let signature = await signer.signMessage(bytesDataHash)
  let sigBreakdown = ethers.utils.splitSignature(signature)

  console.log('firma? ',sigBreakdown );

  }

  // async function fetchrate() {
  //   if (typeof window.ethereum !== 'undefined') {
  //     const provider = new ethers.providers.Web3Provider(window.ethereum)
  //    // console.log({ provider })
  //     const contract = new ethers.Contract(contractAddress, Presale.abi, provider)
  //     try {
  //       const data = await contract.rate();
  //       console.log('Tokens por un BNB: ', data.toString());
  //     } catch (err) {
  //       console.log("Error: ", err)
  //     }
  //   }    
  // }

  // async function getBalance() {
  //   if (typeof window.ethereum !== 'undefined') {
  //     const [account] = await window.ethereum.request({ method: 'eth_requestAccounts' });
  //     const provider = new ethers.providers.Web3Provider(window.ethereum);
  //     const contract = new ethers.Contract(contractAddress, Presale.abi, provider);
  //     const balance = await contract.TokenBalance();
  //     const tokens =  balance.toString();
  //     console.log('Tokens disponibles: ', ethers.utils.formatUnits(tokens));
  //     console.log("Solicitud de cuenta : ", account.toString());
  //   }
  // }
  // parsear decimales a weis.
  //ethers.utils.parseEther('1.2');

  // async function buytokens() {
  //   if (typeof window.ethereum !== 'undefined') {
  //     const [account] = await window.ethereum.request({ method: 'eth_requestAccounts' });
  //     console.log('cuenta conectada: ', account);
  //     const provider = new ethers.providers.Web3Provider(window.ethereum);
  //     const signer = provider.getSigner();
  //     const contract = new ethers.Contract(contractAddress, Presale.abi, signer);
  //    // console.log('amount', amount);
  //     //console.log('signer', signer);
  //    const bnbamount =ethers.utils.parseEther(amount);
  //     const transation = await contract.buyTokens(account);
  //     await transation.wait();
  //     console.log(`${bnbamount} Weis  successfully sent from ${account}`);
  //   }
  // }

  return (
    <div className="App">
      <header className="App-header">
        {/* <button onClick={fetchrate}>Tokens por 1 BNB</button>
        <button onClick={getBalance}>Tokens disponibles</button> */}

        <button onClick={SigningCheck}>Firmar</button>
        {/* <input onChange={e => check(e.target.value)} placeholder={amount} value={amount}/>
        <input onChange={e => setRecipient(e.target.value)} placeholder={recipient} value={recipient}/> */}

        {/* <input placeholder={defaultaddress} value={defaultaddress}/> */}
        {/* <input onChange={e => setAmount(e.target.value)} placeholder={amount} value={amount}/>
        <button onClick={buytokens}>Comprar tokens</button> */}
      </header>
    </div>
  );
  
}

export default App;
