// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

pragma experimental ABIEncoderV2;
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
contract CustomSVGText is ERC721Enumerable, ERC721URIStorage {
address public constant OTHER_CONTRACT = 0x6524Fe1C9B9f34147596FfdFD5dC87a78eba8E55;
  DateInterface DateContract = DateInterface(OTHER_CONTRACT);

// Magic given to us by OpenZeppelin to help us keep track of tokenIds.
using Counters for Counters.Counter;

Counters.Counter private _tokenIds;
// This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
// So, we make a baseSvg variable here that all our NFTs can use.
string baseSvg = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 250"><style>@import url(https://fonts.googleapis.com/css2?family=Monoton);@import url(https://fonts.googleapis.com/css?family=Anonymous+Pro:400,400i,700,700i);</style><rect class="rect" width="100%" height="500%" fill="#fff"/><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-family="Cursive" font-weight="800" font-size="18" fill="red">';
string baseSVG2= '</text><text x="50%" id="txt" y="90%" class="small" dominant-baseline="middle" text-anchor="middle"></text>';
string baseSVG3= '<text x="50%" y="95%" dominant-baseline="middle" text-anchor="middle" font-family="Monoton" style="fill:#000;font-size:10px">';
string baseSVG4= '</text>';
string baseSCript= 'PHNjcmlwdCB0eXBlPSJ0ZXh0L2phdmFzY3JpcHQiPiA8IVtDREFUQVsKCiAgIGZ1bmN0aW9uIGNoZWNrVGltZShpKSB7CiAgaWYgKGkgPCAxMCkge2kgPSAiMCIgKyBpfTsgIC8vIGFkZCB6ZXJvIGluIGZyb250IG9mIG51bWJlcnMgPCAxMAogIHJldHVybiBpOwp9CiBmdW5jdGlvbiBzdGFydFRpbWUoKSB7CiAgY29uc3QgdG9kYXkgPSBuZXcgRGF0ZSgpOwogIGxldCBoID0gdG9kYXkuZ2V0SG91cnMoKTsKICBsZXQgbSA9IHRvZGF5LmdldE1pbnV0ZXMoKTsKICBsZXQgcyA9IHRvZGF5LmdldFNlY29uZHMoKTsKICBtID0gY2hlY2tUaW1lKG0pOwogIHMgPSBjaGVja1RpbWUocyk7CiAgZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQoJ3R4dCcpLmlubmVySFRNTCA9ICBoICsgIjoiICsgbSArICI6IiArIHM7CiAgc2V0VGltZW91dChzdGFydFRpbWUsIDEwMDApOwp9CgogICAgIHN0YXJ0VGltZSgpOwogICAgXV0+CiAgICAKICA8L3NjcmlwdD4=';




constructor() ERC721 ("MESSAGE-NFT", "MST") {

}




function formatDate () public view returns (uint8) {
  uint8 h = DateContract.getHour(block.timestamp);

  if(h == 0){
        h = 12;
    }
    
    if(h > 12){
        h = (h - 12);
      
    }
    return h +1;
}

function formatTokenURI(string memory imageURI) internal pure returns (string memory) {
        return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "SVG NFT",
                                '", "description":"An NFT based on SVG! Created by TAOFEEK", "attributes":"", "image":"',imageURI,'"}'
                            )
                        )
                    )
                )
            );
    }
function mintText( string calldata message) public {
uint256 newItemId = _tokenIds.current();

string memory finalSvg = string(abi.encodePacked(baseSvg, message, baseSVG2,baseSVG3, "Sent By: ", Strings.toHexString(uint256(uint160(msg.sender)), 20), "</text>", string(abi.encodePacked(Base64.decode(baseSCript))), "</svg>"));


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