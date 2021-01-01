pragma solidity ^0.5.0;

contract Seminar {
	
	struct Person {
		string name;
		uint age;
		bool active;
	}

	uint256 fee;
	uint loss = 80;

	mapping(address=>Person) public attendants;

	function Register(string memory _name, uint _age) payable public {
		if(msg.value == fee) {
			attendants[msg.sender] = Person({
				name: _name,
				age: _age,
				active: true
			});
		} else {
			revert(); 
		}


	}

	function setRegistrationFee(uint256 _fee) public {
		fee = _fee;
	}

	function cancelRegistration() payable public {
		attendants[msg.sender].active = false;
		uint amount = (fee * loss)/100;
		msg.sender.transfer(amount);
	}
}
