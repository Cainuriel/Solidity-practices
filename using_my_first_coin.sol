pragma solidity ^0.5.0;

interface Interface {
    
    function decimals() external view returns(uint8);
    function balanceOf(address _address) external view returns(uint256);
    function transfer(address _to, uint256 _value) external returns (bool success);
}

contract usermyfirstCoin {
    address owner;
    uint256 price;
    Interface MytokenContract;
    uint256 tokensSold;
    
    event Sold(address buyer, uint256 amount);
    
    constructor(uint256 _price, address addressContract) public {
        owner = msg.sender;
        price = _price;
        // direccion del contrato del token
        MytokenContract = Interface(addressContract);
        
        
    }
    
    function mul(uint256 a, uint256 b) internal pure returns(uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
        
    }
    
    function buy(uint256 tokens) public payable {
        require(msg.value == mul(price, tokens));
        uint256 scaledamount = mul(tokens, uint256(10) ** MytokenContract.decimals());
        require(MytokenContract.balanceOf(address(this)) >= scaledamount);
        tokensSold += tokens;
        require(MytokenContract.transfer(msg.sender, scaledamount));
        emit Sold(msg.sender, tokens);
        
    }
    
    function endSold() public {
        require(msg.sender == owner);
        require(MytokenContract.transfer(owner, MytokenContract.balanceOf(address(this))));
        msg.sender.transfer(address(this).balance);
       
    }
    

}