pragma solidity ^0.8.0;

        /// @title ERC-721 Non-Fungible Token Standard
        /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
        ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd
        interface IERC721  {

            event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
            event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
            event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

            /// Nos indica cuantos tokens disponemos en una dirección
            function balanceOf(address _owner) external view returns (uint256);

            /// Relaciona un Token con una dirección. 
            function ownerOf(uint256 _tokenId) external view returns (address);

            
            /// guarda la transacción de un token. 
            function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external;

                /// guarda la transacción de un token. 
                /// el selector de una función, que es su firma, se conforma con el nombre y sus parametros.
                /// en éste caso aunque se llamen igual dispone de un parametro de más. creando una
                /// una firma diferente para la maquina virtual. 
            function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;

            /// Realiza la transacción de un token a una dirección. 
            function transferFrom(address _from, address _to, uint256 _tokenId) external;

            /// Delega la gestión de un token a otra dirección sin que sea propietario de el. 
            function approve(address _approved, uint256 _tokenId) external;

            /// Nos permite delegar todos los tokens a una dirección que no es la propietaria. 
            function setApprovalForAll(address _operator, bool _approved) external;

            /// Nos indica quien gestiona el token, que recordamos, no es suyo.
            function getApproved(uint256 _tokenId) external view returns (address);

            /// Nos da la información de si una dirección es la delegada de los tokens de una dirección
            /// propietaria 
            function isApprovedForAll(address _owner, address _operator) external view returns (bool);
        }
