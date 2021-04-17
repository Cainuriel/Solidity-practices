pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./ERC721TokenReceiver.sol";
import "./ERC165.sol";
import "./IERC165.sol";

contract tokenERC721 is ERC165, IERC721 {
    
    // Mapping que devuelve el propietario de un token
    mapping (uint256 => address) private _owners;

    // Mapping cantidad de tokens que posee una address
    mapping (address => uint256) private _balances;

    // Mapping que address gestiona el token introducido
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping de mappings de gestores de sus tokens a los que
    // puede revocar su permiso.
    mapping (address => mapping (address => bool)) private _operatorApprovals;
    
    
   
       function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }
     
    
      function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }
    
     //Funciones de gestion
 
     function approve(address _to, uint256 _tokenId) external virtual override {
         // guardamos la address propietaria del token
        address owner = ownerOf(_tokenId);
        
        // la direccion delegada no puede ser propietaria
        require(_to != owner, "ERC721: approval to current owner");
        
        //quien realiza esta transaccion tiene que ser el propietario O es address gestora
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "ERC721: approve caller is not owner nor approved for all"
        );
        
        // se delega
        _approve(_to, _tokenId);
    }
    
       function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }
    
      function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != msg.sender, "ERC721: approve to caller");

        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }
    
     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }
    
       function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }
    
     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }
         
         
         
         //Fin de funciones de gestion
         
         
         // tranferencias
         
           function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
            }
            
            
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }
    
     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }


    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }
    
    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // quita la gestion si la tuviese el token
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }
    
       // Fin de funciones de tranferencia
    
    
    
     // funciones de creacion de tokens
     
    function _mint(address to, uint256 tokenId) internal virtual {
        // evitamos que sea una direccion vacia para no quemar el token.
        require(to != address(0), "ERC721: mint to the zero address");
        // comprobamos que la id del token no existe.
        require(!_exists(tokenId), "ERC721: token already minted");
        
        
        // funcion para crear logica antes de la creacion de un token.
        _beforeTokenTransfer(address(0), to, tokenId);
        
        // añadimos la id del token al nuevo propietario
        _owners[tokenId] = to;
        
        // subimos la cantidad de tokens a la address propietaria
        _balances[to] += 1;
        
        // lanzamos el evento de la interface.
        // from es cero, porque estamos creando un token. no hay 
        // address de destino.
        emit Transfer(address(0), to, tokenId);
    }
    
    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(address to, uint256 tokenId, bytes memory _data) public {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }
    
        // Fin de lasfunciones de creacion de tokens
    
        /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        private returns (bool)
    {
        if (isContract(to)) {
            try ERC721TokenReceiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
                return retval == ERC721TokenReceiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    // solhint-disable-next-line no-inline-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
    
    function isContract(address _address) private view returns(bool) {
        uint32 size;
        assembly {
            size := extcodesize(_address)
        }
        return (size > 0);
    }
    
     function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0); // todos los mappins devuelven una direccion 0
    }

     // validacion ERC165
        /**
     * @dev See {IERC165-supportsInterface}.
     */
      function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
        return interfaceId == type(IERC721).interfaceId || super.supportsInterface(interfaceId);
    }
    

      function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
      
   

}