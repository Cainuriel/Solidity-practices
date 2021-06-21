const Web3 = require('web3');
const Solc = require('solc');
require('dotenv').config();

const createRawTransaction = require('ethereumjs-tx').Transaction;
const common = require('ethereumjs-common');

 const chain = common.default.forCustomChain(
   'mainnet',{
     name: 'bnb',
     networkId: 97,
     chainId: 97
   },
   'petersburg'
 )


const fs = require('fs'); //modulo node para lectura de archivos.

const { PRIVATE_KEY, PUBLIC_KEY } = process.env;

const web3 = new Web3("https://data-seed-prebsc-1-s1.binance.org:8545");

const myAddress =`${PUBLIC_KEY}`;
const myAddressKey = Buffer.from(`${PRIVATE_KEY}`, 'hex');
//console.log('mira la privada ', myAddressKey);
const content = fs.readFileSync('Greeter.sol').toString();

const objectsolc = {
    language: 'Solidity',
    sources: {
        'greeter': {
            content: content
        }
    },
    settings: {
        outputSelection: {
            '*': {
                '*': ['*']
            }
        }
    }
};

const output = JSON.parse(Solc.compile(JSON.stringify(objectsolc))); // salida del compilador.

const byteCodeContract = output.contracts.greeter.Greeter.evm.bytecode.object;

web3.eth.getTransactionCount(myAddress, (err, txCount) => {
    const txObject = {
        nonce: web3.utils.toHex(txCount),
        to: null,
        gasLimit: web3.utils.toHex(1000000),
        // gasPrice:web3.utils.toHex(web3.utils.toWei('2', 'gwei')),
        // value: web3.utils.toHex(web3.utils.toWei('0', 'ether')),
        data: '0x' + byteCodeContract
    }

    //const tx = new EthereumTx(txObject);


    var rawTx = new createRawTransaction(txObject, {common: chain});

    rawTx.sign(myAddressKey);

    const serial = rawTx.serialize().toString('hex');

     web3.eth.sendSignedTransaction('0x' + serial).on('receipt', console.log)
     console.log('GUA GUA GUA GUA GUA GUA', web3.eth.accounts[0]);
});


