pragma solidity ^0.8.4;
//SPDX-License-Identifier: MIT


import "@openzeppelin/contracts/token/ERC721/ERC721B.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';

import './HexStrings.sol';
import './ToColor.sol';
//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract YourCollectible is ERC721B, Ownable {

  using Strings for uint256;
  using HexStrings for uint160;
  using ToColor for bytes3;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;



  constructor() public ERC721B("ETHERHEARTS", "EHRT") {
    // RELEASE THE LOOGIES!
  }


  mapping (uint256 => bytes3) public color;
 
  mapping (uint256 => uint256) public messages;
  mapping (uint256 => uint256) public chubbiness;
  uint256 mintDeadline = block.timestamp + 24 hours;

  function mintItem(uint256 quantity)
      public      
      returns (uint256)
  { 
      uint256 lastTokenId = super.totalSupply();
      require( block.timestamp < mintDeadline, 'DONE MINTING');  
      require( quantity <=uint256(5), 'leave some for the rest of us!');
      require( lastTokenId + quantity <= uint256(222), 'till next year loves');

      uint256 id; 
      _safeMint(msg.sender, quantity);
      for (uint i=0; i < quantity; i++)   {
      _tokenIds.increment();
      id = _tokenIds.current() - 1;
     
      tokenURI(id);
      
     
      bytes32 predictableRandom = keccak256(abi.encodePacked( blockhash(block.number+quantity), address(this), id, quantity));  
      color[id] = bytes2(predictableRandom[0]) | ( bytes2(predictableRandom[1]) >> 8 ) | ( bytes3(predictableRandom[2]) >> 16 );
  
      messages[id] = (uint8(predictableRandom[4]) % 13 );
      }
    
      return id;
  }



  function tokenURI(uint256 id) public view override returns (string memory) {
      require(_exists(id), "not exist");
      
      string memory name = string(abi.encodePacked('Ether Heart #',id.toString()));
      string memory description = string(abi.encodePacked('this heart beats the color#',color[id].toColor(),' !!!'));
      string memory image = Base64.encode(bytes(generateSVGofTokenById(id)));
      

      return
          string(
              abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                          abi.encodePacked(
                              '{"name":"',
                              name,
                              '", "description":"',
                              description,
                              '", "external_url":"https://burnyboys.com/token/',
                              id.toString(),
                              '", "attributes": [{"trait_type": "color", "value": "#',
                              color[id].toColor(),
                              '"}], "owner":"',
                              (uint160(ownerOf(id))).toHexString(20),
                              '", "image": "',
                              'data:image/svg+xml;base64,',
                              image,
                              '"}'
                          )
                        )
                    )
              )
          );
  }

  function generateSVGofTokenById(uint256 id) internal view returns (string memory) {
    

    string memory svg = string(abi.encodePacked(
      '<svg width="100%" height="100%" viewBox="0 0 900 900" xmlns="http://www.w3.org/2000/svg">',
        renderTokenById(id),
      '</svg>'
    ));

    return svg;

  }

  // Visibility is `public` to enable it being called by other contracts for composition.
  function renderTokenById(uint256 id) public view returns (string memory) {
    string[29] memory messageTxt = [ 'RIGHT-CLICK MY HEART', 'U RUGGED MY HEART', 'BE MINED', 'HODL ME', '0x0x', 'FRONT RUN ME', 'MEV AND CHILL?', 'UR ON MY WHITELIST', 'DECENTRALIZE ME BABY', 'UR MY 1/1', 'BE MY BAYC', 'ARE U EVM COMPATIBLE', 'MAXI 4 U', 'ON-CHAIN HOTTIE', 'U R NONFUNGIBLE TO ME', 'U R MY CRYPTONITE', 'CURATE ME', 'GWEI OUT WITH ME', 'WHATS YOUR SEEDPHRASE', 'UR A FOX', 'ETHERSCAN ME', 'OPEN TO YOUR SEA', 'UR MY FOUNDATION', 'U R SUPERRARE', 'ILY.ETH', '$LOOK-in GOOD', 'JPEG ME', 'NON-FUNGIBLE BABY', 'MY LOVE IS LIQUID'  ] ;
    string memory render = string(abi.encodePacked(
        '<g id="head">',
          '<path id="Bottom" d="M70,279.993C70,279.993 63.297,379.987 70,427.647C85.329,536.631 300.49,820.025 450.016,820.025C599.542,820.025 817.839,533.159 830.014,423.782C835.6,373.594 830.007,280.007 830.007,280.007" style="fill:#', 
          color[id].toColor(), ';stroke:rgb(0,0,0);stroke-width:5px;"/>',
        '<path id="Top" d="M449.75,149.777C426.146,149.777 401.744,80.04 249.999,80.001C139.6,79.972 70,169.594 70,279.993C70,450.051 347.857,689.996 450.004,689.996C552.151,689.996 830.007,449.95 830.007,280.007C830.007,169.801 760.231,80.049 650.026,80.049C486.311,80.049 473.355,149.777 449.75,149.777Z" style="fill:#',
        color[id].toColor(), ';stroke:rgb(0,0,0);stroke-width:5px;"/>',
        '<text x="50%" y="40%" dominant-baseline="middle" text-anchor="middle" stroke="rgb(211, 73, 78)" stroke-width= "5" font-weight="400" font-size="48" font-family="Helvetica" fill="rgb(211, 73, 78)">' , messageTxt[messages[id]], '</text>',
        '</g>'
      ));

    return render;
  }


}