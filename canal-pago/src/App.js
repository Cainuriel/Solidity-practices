import './App.css';
import { useState } from 'react';
import { ethers } from 'ethers'
import Presale from './artifacts/contracts/Presale.sol/Presale.json'

// 0xABAD9324a5b54696B57a0043BF5D9a2E0831B3c3 before contract
const presaleaddress = "0x078a934A34b3cae51Fab550847A8d0B08e8eE68a" // in testnet of Binance Smart Chain

function App() {

  const [userAccount, setUserAccount] = useState('');
  const [amount, setAmount] = useState(0);
  console.log('Billetera conectada? ',window.ethereum.isConnected());

  async function requestAccount() {
    return  await  window.ethereum.request({ method: 'eth_requestAccounts' });
    //console.log('mmira el request', request );
  }

  async function fetchrate() {
    if (typeof window.ethereum !== 'undefined') {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
     // console.log({ provider })
      const contract = new ethers.Contract(presaleaddress, Presale.abi, provider)
      try {
        const data = await contract.rate();
        console.log('Tokens por un BNB: ', data.toString());
      } catch (err) {
        console.log("Error: ", err)
      }
    }    
  }

  async function getBalance() {
    if (typeof window.ethereum !== 'undefined') {
      const [account] = await window.ethereum.request({ method: 'eth_requestAccounts' });
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const contract = new ethers.Contract(presaleaddress, Presale.abi, provider);
      const balance = await contract.TokenBalance();
      const tokens =  balance.toString();
      console.log('Tokens disponibles: ', ethers.utils.formatUnits(tokens));
      console.log("Solicitud de cuenta : ", account.toString());
    }
  }
  // parsear decimales a weis.
  //ethers.utils.parseEther('1.2');

  async function buytokens() {
    if (typeof window.ethereum !== 'undefined') {
      const [account] = await window.ethereum.request({ method: 'eth_requestAccounts' });
      console.log('cuenta conectada: ', account);
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(presaleaddress, Presale.abi, signer);
     // console.log('amount', amount);
      //console.log('signer', signer);
     const bnbamount =ethers.utils.parseEther(amount);
      const transation = await contract.buyTokens(account);
      await transation.wait();
      console.log(`${bnbamount} Weis  successfully sent from ${account}`);
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <button onClick={fetchrate}>Tokens por 1 BNB</button>
        <button onClick={getBalance}>Tokens disponibles</button>

        {/* <input onChange={e => setUserAccount(e.target.value)} placeholder={userAccount} value={userAccount}/> */}
        <input onChange={e => setAmount(e.target.value)} placeholder={amount} value={amount}/>
        <button onClick={buytokens}>Comprar tokens</button>
      </header>
    </div>
  );
  
}

export default App;
