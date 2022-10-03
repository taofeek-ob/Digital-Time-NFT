// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;


// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "base64-sol/base64.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";



interface DateInterface{
  function getSecond(uint timestamp) external pure returns (uint8);
  function getMinute(uint timestamp) external pure returns (uint8);
  function getHour(uint timestamp) external pure returns (uint8);
}



// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract DigitalTimeNFT is ERC721Enumerable, ERC721URIStorage {
address public constant OTHER_CONTRACT = 0x6524Fe1C9B9f34147596FfdFD5dC87a78eba8E55;
  DateInterface DateContract = DateInterface(OTHER_CONTRACT);

// Magic given to us by OpenZeppelin to help us keep track of tokenIds.
using Counters for Counters.Counter;

Counters.Counter private _tokenIds;

// This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
// So, we make a baseSvg variable here that all our NFTs can use.
string baseSvg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 450"><path d="M0 0h500v450H0z"/><text x="50%" y="50%" fill="#17D4FE" dominant-baseline="middle" text-anchor="middle" style="font-size:50px;font-family:Orbitron;letter-spacing:7px">';

constructor() ERC721 ("DIGITAL TIME", "TIME") {

}




function format() internal view returns (string memory) {
  uint8 h = DateContract.getHour(block.timestamp);
  uint8 m = DateContract.getMinute(block.timestamp);
  uint8 s = DateContract.getSecond(block.timestamp);

 
    string memory session = "AM";
    
    if(h == 0){
        h = 12;
    }
    
    if(h > 12){
        h = h - 12;
        session = "PM";
    }

   h=h+1;
    
    string memory hour = (h < 10) ? string.concat("0",  Strings.toString(h)) : Strings.toString(h);
    string memory minute = (m < 10) ? string.concat("0",  Strings.toString(m)) : Strings.toString(m);
    string memory second = (s < 10) ? string.concat("0",  Strings.toString(s)) : Strings.toString(s);
   
    
    
    return string.concat(hour, ":", minute, ":", second, " ", session);
}


function formatTokenURI(string memory imageURI) internal pure returns (string memory) {
        return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "DIGITAL TIME ", // You can add whatever name here
                                '", "description":"A Digital Clock Dependent NFT based on SVG! Created by Taofeek", "attributes":"", "image":"',imageURI,'"}'
                            )
                        )
                    )
                )
            );
    }
function mintTime() public {
uint256 newItemId = _tokenIds.current();
// string memory time= formatTime(block.timestamp);
string memory finalSvg = string(abi.encodePacked(baseSvg, format(), "</text></svg>"));


 string memory baseURL = "data:image/svg+xml;base64,";
string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(finalSvg))));
string memory imageURI = string(abi.encodePacked(baseURL,svgBase64Encoded));

// Actually mint the NFT to the sender using msg.sender.
_safeMint(msg.sender, newItemId);
// Set the NFTs data.
_setTokenURI(newItemId, formatTokenURI(imageURI));

// Increment the counter for when the next NFT is minted.
_tokenIds.increment();
}

// The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}